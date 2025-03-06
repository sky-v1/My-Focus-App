import 'package:my_focus/models/user_model.dart';

class AuthStateModel {
  final bool isAuthenticated;
  final bool isInitializing;
  final UserModel? user;
  final String? errorMessage;
  final bool isPendingGoogleAuth; // To track when email signup is awaiting Google auth

  AuthStateModel({
    required this.isAuthenticated,
    required this.isInitializing,
    this.user,
    this.errorMessage,
    this.isPendingGoogleAuth = false,
  });

  factory AuthStateModel.initial() {
    return AuthStateModel(
      isAuthenticated: false,
      isInitializing: true,
      user: null,
      errorMessage: null,
      isPendingGoogleAuth: false,
    );
  }

  AuthStateModel copyWith({
    bool? isAuthenticated,
    bool? isInitializing,
    UserModel? user,
    String? errorMessage,
    bool? isPendingGoogleAuth,
  }) {
    return AuthStateModel(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitializing: isInitializing ?? this.isInitializing,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isPendingGoogleAuth: isPendingGoogleAuth ?? this.isPendingGoogleAuth,
    );
  }
}