import 'user_model.dart';

class AuthResponseModel {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final Map<String, dynamic>? errors;

  AuthResponseModel({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.errors,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      accessToken: json['access_token'] ?? json['token'],
      refreshToken: json['refresh_token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
      'errors': errors,
    };
  }

  factory AuthResponseModel.error(String message, {Map<String, dynamic>? errors}) {
    return AuthResponseModel(
      success: false,
      message: message,
      errors: errors,
    );
  }

  factory AuthResponseModel.success({
    required String accessToken,
    String? refreshToken,
    UserModel? user,
    String? message,
  }) {
    return AuthResponseModel(
      success: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
      message: message,
    );
  }
}
