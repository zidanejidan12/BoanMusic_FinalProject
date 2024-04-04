import 'package:boanmusic/data/datasource/artist_api.dart';

class ArtistRepository {
  final ArtistApi _artistApi;

  ArtistRepository({required ArtistApi artistApi}) : _artistApi = artistApi;

  Future<List<Map<String, dynamic>>> fetchArtists() async {
    try {
      return await _artistApi.fetchArtists();
    } catch (e) {
      throw Exception('Failed to fetch artists: $e');
    }
  }
}
