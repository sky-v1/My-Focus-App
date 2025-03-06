class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? profilePicUrl;
  final String? accessToken;
  // Reserved fields for future expansion
  final Map<String, dynamic>? additionalData;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.profilePicUrl,
    this.accessToken,
    this.additionalData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
      profilePicUrl: json['profilePicUrl'],
      accessToken: json['accessToken'],
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'accessToken': accessToken,
      'additionalData': additionalData,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    String? profilePicUrl,
    String? accessToken,
    Map<String, dynamic>? additionalData,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      accessToken: accessToken ?? this.accessToken,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}