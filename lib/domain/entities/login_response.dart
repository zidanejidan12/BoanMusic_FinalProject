class LoginResponseModel {
  final String token;
  final String username;
  final String userType;

  LoginResponseModel({
    required this.token,
    required this.username,
    required this.userType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      username: json['username'],
      userType: json['userType'],
    );
  }
}
