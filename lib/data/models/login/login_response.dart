class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String message;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      message: json['message'],
    );
  }
}
