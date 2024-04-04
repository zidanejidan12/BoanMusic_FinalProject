import 'dart:convert';
import 'package:http/http.dart' as http;

class ArtistApi {
  final String baseUrl;

  ArtistApi({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchArtists() async {
    final Uri url = Uri.parse('$baseUrl/api/v1/artists');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'text/plain'},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
