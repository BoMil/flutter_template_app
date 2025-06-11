class LoginResponse {
  late String refreshToken;
  late String token;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'] ?? '';
    token = json['token'] ?? '';
  }
}
