import 'package:boanmusic/data/repository/song_repository.dart';

class FetchSongsByAlbumId {
  final SongRepository _repository;

  FetchSongsByAlbumId({required SongRepository repository})
      : _repository = repository;

  Future<List<Map<String, dynamic>>> call(int albumId) async {
    try {
      return await _repository.fetchSongsByAlbumId(albumId);
    } catch (e) {
      throw Exception('Failed to fetch songs by album ID: $e');
    }
  }
}
