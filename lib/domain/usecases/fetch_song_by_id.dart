import 'package:boanmusic/data/repository/song_repository.dart';

class FetchSongById {
  final SongRepository _repository;

  FetchSongById({required SongRepository repository})
      : _repository = repository;

  Future<Map<String, dynamic>> call(int id) async {
    try {
      return await _repository.fetchSongById(id);
    } catch (e) {
      throw Exception('Failed to fetch song: $e');
    }
  }
}
