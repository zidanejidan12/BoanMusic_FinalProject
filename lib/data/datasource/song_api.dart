// song_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class SongApi {
  final String baseUrl;

  SongApi({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchSongs() async {
    final Uri url = Uri.parse('$baseUrl/api/v1/songs');

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

  Future<Map<String, dynamic>> fetchSongById(int id) async {
    final Uri url = Uri.parse('$baseUrl/api/v1/songs/$id');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load song');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongsByAlbumId(int albumId) async {
    final Uri url = Uri.parse('$baseUrl/api/v1/songs');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> allSongs =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        final List<Map<String, dynamic>> songsFilteredByAlbumId =
            allSongs.where((song) => song['albumId'] == albumId).toList();
        return songsFilteredByAlbumId;
      } else {
        throw Exception('Failed to load songs by album ID');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongsByArtistId(int artistId) async {
    final Uri url = Uri.parse('$baseUrl/api/v1/songs');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> allSongs =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        final List<Map<String, dynamic>> songsFilteredByArtistId = allSongs
            .where((song) => song['album']['artist']['id'] == artistId)
            .toList();
        return songsFilteredByArtistId;
      } else {
        throw Exception('Failed to load songs by artist ID');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
