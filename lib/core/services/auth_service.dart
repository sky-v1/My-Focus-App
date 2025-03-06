import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:my_focus/core/services/hive_service.dart';
import '../../models/user_model.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final hiveService = HiveService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/youtube.readonly',
      'https://www.googleapis.com/auth/youtube',
      'https://www.googleapis.com/auth/youtube.force-ssl',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  // Default profile picture (asset path)
  final String _defaultProfilePic = 'assets/images/default_profile.png';

//Save user to firestore database
  Future<void> saveUserToFirestore(
      String uid, String username, String email) async {
    final userRef = _firestore.collection('users').doc(uid);
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      // User does not exist, create a new entry
      await userRef.set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('New user added to Firestore: $username');
    } else {
      debugPrint('User already exists in Firestore, skipping creation.');
    }
  }

  // Generate a random username based on display name
  String _generateUsername(String displayName) {
    final random = Random();
    final sanitizedName =
        displayName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '').trim();

    if (sanitizedName.isEmpty) {
      // Fallback for empty displayName
      return 'user${random.nextInt(10000)}';
    }

    // Add random numbers to make username unique
    return '$sanitizedName${random.nextInt(10000)}';
  }

  // Check if username is unique
  Future<bool> isUsernameUnique(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty; // If empty, username is unique
    } catch (e) {
      debugPrint('Error checking username uniqueness: $e');
      return false;
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    debugPrint('Starting Google sign-in process');
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google sign-in cancelled by user');
        return null;
      }

      debugPrint('Google sign-in successful for ${googleUser.email}');
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        debugPrint('Firebase user is null after Google sign-in');
        return null;
      }

      // Generate username from display name
      final username = _generateUsername(googleUser.displayName ?? 'user');

      await saveUserToFirestore(firebaseUser.uid, username, googleUser.email);

      final userModel = UserModel(
        id: firebaseUser.uid,
        username: username,
        displayName: googleUser.displayName ?? username,
        email: googleUser.email,
        profilePicUrl: googleUser.photoUrl,
        accessToken: googleAuth.accessToken,
      );

      await _saveUserData(userModel);

      debugPrint(
          'Google sign-in completed successfully for username: $username');
      return userModel;
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      return null;
    }
  }

  // Login with username/email and password
  Future<UserModel?> logInWithEmailPassword(
      String emailOrUsername, String password) async {
    debugPrint('Attempting to login with email/username: $emailOrUsername');
    try {
      // Determine if input is email or username
      final bool isEmail = emailOrUsername.contains('@');
      String email = emailOrUsername;

      if (!isEmail) {
        // If username is provided, we need to get the associated email
        email = (await _getEmailFromUsername(emailOrUsername))!;
        if (email.isEmpty) {
          debugPrint('Username not found: $emailOrUsername');
          return null;
        }
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        debugPrint('Firebase user is null after email login');
        return null;
      }

      // Get stored user data
      return await getCurrentUser();
    } catch (e) {
      debugPrint('Error during email/password login: $e');
      return null;
    }
  }

  // Helper to get email from username
  Future<String?> _getEmailFromUsername(String username) async {
    try {
      // Query Firestore to find the email by username
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['email']; // Retrieve email
      } else {
        return null; // Username not found
      }
    } catch (e) {
      debugPrint('Error retrieving email from username: $e');
      return null;
    }
  }

  // Initialize email/password signup (first step)
  Future<bool> initializeEmailSignup(
      String username, String email, String password) async {
    debugPrint(
        'Initializing email signup for username: $username, email: $email');
    try {
      // Check if username is unique
      final isUnique = await isUsernameUnique(username);
      if (!isUnique) {
        debugPrint('Username already exists: $username');
        return false;
      }

      // Store temporary signup data
      await _secureStorage.write(key: 'temp_username', value: username);
      await _secureStorage.write(key: 'temp_email', value: email);
      await _secureStorage.write(key: 'temp_password', value: password);

      debugPrint('Email signup initialized successfully');
      return true;
    } catch (e) {
      debugPrint('Error initializing email signup: $e');
      return false;
    }
  }

  // Complete email signup with Google authentication
  Future<UserModel?> completeEmailSignupWithGoogle() async {
    debugPrint('Completing email signup with Google authentication');
    try {
      // Get temporary data
      final tempUsername = await _secureStorage.read(key: 'temp_username');
      final tempEmail = await _secureStorage.read(key: 'temp_email');
      final tempPassword = await _secureStorage.read(key: 'temp_password');

      if (tempUsername == null || tempEmail == null || tempPassword == null) {
        debugPrint('Temporary signup data is missing');
        return null;
      }

      // Perform Google sign-in
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint(
            'Google sign-in cancelled by user during email signup completion');
        return null;
      }

      final googleAuth = await googleUser.authentication;

      // Create Firebase user with email/password
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: tempEmail,
        password: tempPassword,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        debugPrint('Firebase user is null after account creation');
        await _cleanupTempData();
        return null;
      }

      // Link Google credential to the account
      await firebaseUser.linkWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ));

      await saveUserToFirestore(firebaseUser.uid, tempUsername, tempEmail);

      // Create user model
      final userModel = UserModel(
        id: firebaseUser.uid,
        username: tempUsername,
        displayName: tempUsername, // Use provided username as display name
        email: tempEmail,
        profilePicUrl: _defaultProfilePic, // Use default profile picture
        accessToken: googleAuth.accessToken,
      );

      await _saveUserData(userModel);
      await _cleanupTempData();

      debugPrint(
          'Email signup with Google completed successfully for username: $tempUsername');
      return userModel;
    } catch (e) {
      debugPrint('Error completing email signup with Google: $e');
      await _cleanupTempData();
      return null;
    }
  }

  // Clean up temporary signup data
  Future<void> _cleanupTempData() async {
    await _secureStorage.delete(key: 'temp_username');
    await _secureStorage.delete(key: 'temp_email');
    await _secureStorage.delete(key: 'temp_password');
  }

  // Save user data to secure storage
  Future<void> _saveUserData(UserModel user) async {
    await _secureStorage.write(key: 'user_id', value: user.id);
    await _secureStorage.write(key: 'user_username', value: user.username);
    await _secureStorage.write(
        key: 'user_display_name', value: user.displayName);
    await _secureStorage.write(key: 'user_email', value: user.email);

    if (user.profilePicUrl != null) {
      await _secureStorage.write(
          key: 'user_profile_pic', value: user.profilePicUrl);
    }

    if (user.accessToken != null) {
      await _secureStorage.write(key: 'access_token', value: user.accessToken);
    }
  }

  // Validate session
  Future<bool> validateSession() async {
    try {
      final userId = await _secureStorage.read(key: 'user_id');
      final accessToken = await _secureStorage.read(key: 'access_token');
      return userId != null &&
          accessToken != null &&
          _firebaseAuth.currentUser != null;
    } catch (e) {
      debugPrint('Error validating session: $e');
      return false;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final id = await _secureStorage.read(key: 'user_id');
      final username = await _secureStorage.read(key: 'user_username');
      final displayName = await _secureStorage.read(key: 'user_display_name');
      final email = await _secureStorage.read(key: 'user_email');
      final profilePicUrl = await _secureStorage.read(key: 'user_profile_pic');
      final accessToken = await _secureStorage.read(key: 'access_token');

      if (id == null ||
          username == null ||
          displayName == null ||
          email == null) {
        return null;
      }

      return UserModel(
        id: id,
        username: username,
        displayName: displayName,
        email: email,
        profilePicUrl: profilePicUrl,
        accessToken: accessToken,
      );
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Logout
  Future<void> logout() async {
    debugPrint('Logging out user');
    try {
      // Sign out from Firebase and Google
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _secureStorage.deleteAll();

      // List all user-related boxes that should be cleared on logout.
      final List<String> userBoxes = [
        'subscribedChannels',
        // Add more box names here as your app grows
        // 'userPreferences',
        // 'recentActivity',
      ];

      // Iterate through each box and clear its data
      for (final boxName in userBoxes) {
        if (await Hive.boxExists(boxName)) {
          try {
            final box = Hive.isBoxOpen(boxName)
                ? Hive.box(boxName) // Use the already open box
                : await hiveService
                    .openBox(boxName); // Open if not already open

            await box.clear();
            debugPrint('Cleared box: $boxName');
          } catch (e) {
            debugPrint('Error clearing box $boxName: $e');
          }
        }
      }

      debugPrint('Logout completed successfully');
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  // Reset password
  Future<String> resetPassword(String email) async {
    debugPrint('Sending password reset email to: $email');
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email sent!";
    } on FirebaseAuthException catch (e) {
      final errorMessage = e.code == "user-not-found"
          ? "No account found with this email."
          : e.code == "invalid-email"
              ? "Invalid email address."
              : "An error occurred: ${e.message}";

      debugPrint('Password reset error: $errorMessage');
      return errorMessage;
    }
  }
}
