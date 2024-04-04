import 'package:boanmusic/data/repository/song_repository.dart';

class FetchSongs {
  final SongRepository _repository;

  FetchSongs({required SongRepository repository}) : _repository = repository;

  Future<List<Map<String, dynamic>>> call() async {
    try {
      return await _repository.fetchSongs();
    } catch (e) {
      throw Exception('Failed to fetch songs: $e');
    }
  }
}
