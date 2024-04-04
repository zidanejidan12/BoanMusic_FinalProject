import 'package:boanmusic/data/datasource/song_api.dart';

class SongRepository {
  final SongApi _songApi;

  SongRepository({required SongApi songApi}) : _songApi = songApi;

  Future<List<Map<String, dynamic>>> fetchSongs() async {
    try {
      return await _songApi.fetchSongs();
    } catch (e) {
      throw Exception('Failed to fetch songs: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSongById(int id) async {
    try {
      return await _songApi.fetchSongById(id);
    } catch (e) {
      throw Exception('Failed to fetch song: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongsByAlbumId(int albumId) async {
    try {
      return await _songApi.fetchSongsByAlbumId(albumId);
    } catch (e) {
      throw Exception('Failed to fetch songs by album ID: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongsByArtistId(int artistId) async {
    try {
      return await _songApi.fetchSongsByArtistId(artistId);
    } catch (e) {
      throw Exception('Failed to fetch songs by artist ID: $e');
    }
  }
}
