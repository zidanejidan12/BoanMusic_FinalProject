import 'package:boanmusic/data/datasource/user_api.dart';

class UserRepository {
  final UserApi _userApi;

  UserRepository({required UserApi userApi}) : _userApi = userApi;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      return await _userApi.login(username, password);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
