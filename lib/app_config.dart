class AppConfig {
  static const String baseUrl = "http://10.10.7.47:5002/api/v1";
  static const String createUserEndpoint = "$baseUrl/users";
  static const String verifyOtpEndpoint = "$baseUrl/auth/verify-otp";
  static const String loginEndpoint = "$baseUrl/auth/login";
  static const String refreshTokenEndpoint = "$baseUrl/auth/refresh-token";
  static const String getProfileEndpoint = "$baseUrl/users/me";
  static const String getProfilesEndpoint = "$baseUrl/users/profiles";
  static const String connectionRequestEndpoint = "$baseUrl/connections/request";
  static const String cancelConnectionEndpoint = "$baseUrl/connections/{id}/request";
  static const String pendingConnectionsEndpoint = "$baseUrl/connections/pending";
  static const String updateConnectionEndpoint = "$baseUrl/connections";
  static const String learningContentsEndpoint = "$baseUrl/learning-contents";
  static const String likeLearningContentEndpoint = "$baseUrl/learning-contents/{id}/like";
  static const String learningCommentsEndpoint = "$baseUrl/learning-contents/{id}/comments";
  static const String deleteLearningCommentEndpoint = "$baseUrl/learning-contents/comments/{id}";
}
