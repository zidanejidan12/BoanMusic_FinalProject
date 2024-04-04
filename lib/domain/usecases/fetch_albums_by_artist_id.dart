import 'package:boanmusic/data/repository/album_repository.dart';

class FetchAlbumsByArtistId {
  final AlbumRepository _repository;

  FetchAlbumsByArtistId({required AlbumRepository repository})
      : _repository = repository;

  Future<List<Map<String, dynamic>>> call(int artistId) async {
    try {
      return await _repository.fetchAlbumsbyArtistId(artistId);
    } catch (e) {
      throw Exception('Failed to fetch albums by artist ID: $e');
    }
  }
}
