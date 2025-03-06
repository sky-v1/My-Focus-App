import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/services/auth_service.dart';
import '../../models/auth_state_model.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class AuthNotifier extends StateNotifier<AuthStateModel> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthStateModel.initial()) {
    // Initialize by checking if user is already authenticated
    checkAuthStatus();
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    debugPrint('Checking auth status');
    try {
      final isValid = await _authService.validateSession();
      if (isValid) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          state = state.copyWith(
            isAuthenticated: true,
            isInitializing: false,
            user: user,
            errorMessage: null,
          );
          debugPrint('User authenticated: ${user.username}');
        } else {
          await logout();
        }
      } else {
        await logout();
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      await logout();
    }
  }

  // Login with username/email and password
  Future<String?> logInWithEmailPassword(String emailOrUsername, String password) async {
    debugPrint('Login attempt with email/username: $emailOrUsername');
    try {
      state = state.copyWith( errorMessage: null);
      
      final user = await _authService.logInWithEmailPassword(emailOrUsername, password);
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          isInitializing: false,
          user: user,
          errorMessage: null,
        );
        debugPrint('Login successful for: ${user.username}');
        return null;
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isInitializing: false,
          errorMessage: 'Invalid username/email or password',
        );
        debugPrint('Login failed: Invalid credentials');
        return 'Invalid username/email or password';
      }
    } catch (e) {
      final errorMessage = 'Login failed: $e';
      debugPrint(errorMessage);
      state = state.copyWith(
        isAuthenticated: false,
        isInitializing: false,
        errorMessage: errorMessage,
      );
      return errorMessage;
    }
  }

  // Sign in with Google
  Future<String?> signInWithGoogle() async {
    debugPrint('Starting Google sign-in');
    try {
      state = state.copyWith( errorMessage: null);
      
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          isInitializing: false,
          user: user,
          errorMessage: null,
          isPendingGoogleAuth: false,
        );
        debugPrint('Google sign-in successful for: ${user.username}');
        return null;
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isInitializing: false,
          errorMessage: 'Google sign-in failed',
          isPendingGoogleAuth: false,
        );
        debugPrint('Google sign-in failed');
        return 'Google sign-in failed';
      }
    } catch (e) {
      final errorMessage = 'Google sign-in error: $e';
      debugPrint(errorMessage);
      state = state.copyWith(
        isAuthenticated: false,
        isInitializing: false,
        errorMessage: errorMessage,
        isPendingGoogleAuth: false,
      );
      return errorMessage;
    }
  }

  // Initialize email signup (first step)
  Future<String?> initializeEmailSignup(String username, String email, String password) async {
    debugPrint('Initializing email signup for username: $username');
    try {
      state = state.copyWith( errorMessage: null);
      
      final success = await _authService.initializeEmailSignup(username, email, password);
      if (success) {
        state = state.copyWith(
          isInitializing: false,
          errorMessage: null,
          isPendingGoogleAuth: true, // Mark that we're waiting for Google auth
        );
        debugPrint('Email signup initialized, awaiting Google authentication');
        return null;
      } else {
        state = state.copyWith(
          isInitializing: false,
          errorMessage: 'Failed to initialize signup. Username may already exist.',
          isPendingGoogleAuth: false,
        );
        debugPrint('Failed to initialize email signup');
        return 'Failed to initialize signup. Username may already exist.';
      }
    } catch (e) {
      final errorMessage = 'Error initializing signup: $e';
      debugPrint(errorMessage);
      state = state.copyWith(
        isInitializing: false,
        errorMessage: errorMessage,
        isPendingGoogleAuth: false,
      );
      return errorMessage;
    }
  }

  // Complete email signup with Google
  Future<String?> completeEmailSignupWithGoogle() async {
    debugPrint('Completing email signup with Google authentication');
    try {
      state = state.copyWith( errorMessage: null);
      
      final user = await _authService.completeEmailSignupWithGoogle();
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          isInitializing: false,
          user: user,
          errorMessage: null,
          isPendingGoogleAuth: false,
        );
        debugPrint('Email signup completed successfully for: ${user.username}');
        return null;
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isInitializing: false,
          errorMessage: 'Failed to complete signup with Google',
          isPendingGoogleAuth: false,
        );
        debugPrint('Failed to complete email signup with Google');
        return 'Failed to complete signup with Google';
      }
    } catch (e) {
      final errorMessage = 'Error completing signup: $e';
      debugPrint(errorMessage);
      state = state.copyWith(
        isAuthenticated: false,
        isInitializing: false,
        errorMessage: errorMessage,
        isPendingGoogleAuth: false,
      );
      return errorMessage;
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _authService.getAccessToken();
  }

  // Reset password
  Future<String> resetPassword(String email) async {
    return _authService.resetPassword(email);
  }

  // Logout
  Future<void> logout() async {
    debugPrint('Logging out user');
    await _authService.logout();
    state = state.copyWith(
      isAuthenticated: false,
      isInitializing: false,
      user: null,
      errorMessage: null,
      isPendingGoogleAuth: false,
    );
    debugPrint('Logout completed');
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthStateModel>((ref) {
  return AuthNotifier(AuthService());
});