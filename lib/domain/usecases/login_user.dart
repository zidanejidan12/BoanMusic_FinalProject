import 'package:boanmusic/data/repository/user_repository.dart';

class LoginUser {
  final UserRepository _repository;

  LoginUser({required UserRepository repository}) : _repository = repository;

  Future<Map<String, dynamic>?> call(String username, String password) async {
    try {
      return await _repository.login(username, password);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
