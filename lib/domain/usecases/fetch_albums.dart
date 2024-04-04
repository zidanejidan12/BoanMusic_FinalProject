import 'package:boanmusic/data/repository/album_repository.dart';

class FetchAlbums {
  final AlbumRepository _repository;

  FetchAlbums({required AlbumRepository repository}) : _repository = repository;

  Future<List<Map<String, dynamic>>> call() async {
    try {
      return await _repository.fetchAlbums();
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }
}
