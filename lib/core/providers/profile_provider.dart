// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_focus/core/services/profile_service.dart';
// import 'package:my_focus/models/user_model.dart';

// // Profile state to hold user data and loading state
// class ProfileState {
//   final UserModel? user;
//   final bool isLoading;
//   final String? error;

//   const ProfileState({
//     this.user,
//     this.isLoading = false,
//     this.error,
//   });

//   // Create a copy of this state with updated properties
//   ProfileState copyWith({
//     UserModel? user,
//     bool? isLoading,
//     String? error,
//   }) {
//     return ProfileState(
//       user: user ?? this.user,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }

//   // Check if user is empty
//   bool get isEmpty => user == null;
// }

// // Provider class to handle profile logic
// class ProfileNotifier extends StateNotifier<ProfileState> {
//   final ProfileService _profileService;

//   ProfileNotifier(this._profileService) : super(const ProfileState());

//   // Load profile data from service
//   Future<void> loadProfile() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       if (!_profileService.isAuthenticated) {
//         state = state.copyWith(
//           isLoading: false,
//           user: null,
//           error: 'Not authenticated',
//         );
//         return;
//       }

//       final user = await _profileService.getUserProfile();
//       state = state.copyWith(
//         user: user,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Update profile
//   Future<void> updateProfile(Map<String, dynamic> updates) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       final updatedUser = await _profileService.updateProfile(updates);

//       state = state.copyWith(
//         user: updatedUser,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Sign in with Google
//   Future<void> signInWithGoogle() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       final user = await _profileService.signInWithGoogle();

//       state = state.copyWith(
//         user: user,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       await _profileService.signOut();

//       state = const ProfileState();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Check if user is authenticated
//   bool get isAuthenticated => _profileService.isAuthenticated;
// }

// // Provider instances

// // Profile service provider
// final profileServiceProvider = Provider<ProfileService>((ref) {
//   return ProfileService();
// });

// // Profile state provider
// final profileProvider =
//     StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
//   final profileService = ref.watch(profileServiceProvider);
//   return ProfileNotifier(profileService);
// });

// // Profile loading state provider (convenient for UI)
// final profileLoadingProvider = Provider<bool>((ref) {
//   return ref.watch(profileProvider).isLoading;
// });

// // Profile error provider (convenient for UI)
// final profileErrorProvider = Provider<String?>((ref) {
//   return ref.watch(profileProvider).error;
// });

// // Authentication state provider
// final isAuthenticatedProvider = Provider<bool>((ref) {
//   return ref.watch(profileProvider.notifier).isAuthenticated;
// });
