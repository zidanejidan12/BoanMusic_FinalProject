class user_model {
  int userId;
  String username;
  String email;
  DateTime dateOfBirth;
  String userType;
  String password;

  user_model({
    required this.userId,
    required this.username,
    required this.email,
    required this.dateOfBirth,
    this.userType = 'regular',
    required this.password,
  });

  factory user_model.fromJson(Map<String, dynamic> json) {
    return user_model(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : DateTime.now(), // Provide a default value if dateOfBirth is null
      userType: json['userType'] ?? 'regular',
      password: json['password'],
    );
  }
}
