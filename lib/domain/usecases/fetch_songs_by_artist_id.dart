import 'package:boanmusic/data/repository/song_repository.dart';

class FetchSongsByArtistId {
  final SongRepository _repository;

  FetchSongsByArtistId({required SongRepository repository})
      : _repository = repository;

  Future<List<Map<String, dynamic>>> call(int artistId) async {
    try {
      return await _repository.fetchSongsByArtistId(artistId);
    } catch (e) {
      throw Exception('Failed to fetch songs by album ID: $e');
    }
  }
}
