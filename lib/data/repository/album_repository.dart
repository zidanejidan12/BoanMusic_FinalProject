import 'package:boanmusic/data/datasource/album_api.dart';

class AlbumRepository {
  final AlbumApi _albumApi;

  AlbumRepository({required AlbumApi albumApi}) : _albumApi = albumApi;

  Future<List<Map<String, dynamic>>> fetchAlbums() async {
    try {
      return await _albumApi.fetchAlbums();
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAlbumsbyArtistId(int artistId) async {
    try {
      return await _albumApi.fetchAlbumsbyArtistId(artistId);
    } catch (e) {
      throw Exception('Failed to fetch albums by artist id: $e');
    }
  }
}
