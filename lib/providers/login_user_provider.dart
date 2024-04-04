import 'package:flutter/material.dart';
import 'package:boanmusic/domain/usecases/login_user.dart';
import 'package:boanmusic/data/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUserProvider extends ChangeNotifier {
  final LoginUser _loginUser;
  final UserRepository _userRepository;

  LoginUserProvider({
    required LoginUser loginUser,
    required UserRepository userRepository,
  })  : _loginUser = loginUser,
        _userRepository = userRepository;

  Future<void> loginUser(String username, String password) async {
    try {
      // Perform login operation using the LoginUser use case
      final userInformation = await _loginUser(username, password);

      // Extract token from user information
      final token = userInformation?['token'];

      if (token == null) {
        throw Exception('Token not found in user information');
      }

      // Save token to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Notify listeners that the login operation was successful
      notifyListeners();
    } catch (e) {
      // Handle any errors during the login operation
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logoutUser() async {
    // Remove token from shared preferences on logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Notify listeners that the user has logged out
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    // Check if a token exists in shared preferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
