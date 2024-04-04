import 'dart:convert';
import 'package:http/http.dart' as http;

class AlbumApi {
  final String baseUrl;

  AlbumApi({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchAlbums() async {
    final Uri url = Uri.parse('$baseUrl/api/v1/albums');

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

  Future<List<Map<String, dynamic>>> fetchAlbumsbyArtistId(int artistId) async {
    final Uri url = Uri.parse('$baseUrl/api/v1/albums');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> allAlbums =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        final List<Map<String, dynamic>> albumsFilteredByArtistId =
            allAlbums.where((album) => album['artistId'] == artistId).toList();
        return albumsFilteredByArtistId;
      } else {
        throw Exception('Failed to load albums by artist ID');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
