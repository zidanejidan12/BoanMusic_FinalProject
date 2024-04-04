import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  final String baseUrl;

  UserApi({required this.baseUrl});

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final Uri url = Uri.parse('$baseUrl/api/v1/users/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
