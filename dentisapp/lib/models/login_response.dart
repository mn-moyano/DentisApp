class LoginResponse {
  final bool success;
  final String message;
  final String token;
  final String refreshToken;

  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}