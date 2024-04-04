import 'package:boanmusic/data/repository/artist_repository.dart';

class FetchArtists {
  final ArtistRepository _repository;

  FetchArtists({required ArtistRepository repository})
      : _repository = repository;

  Future<List<Map<String, dynamic>>> call() async {
    try {
      return await _repository.fetchArtists();
    } catch (e) {
      throw Exception('Failed to fetch artists: $e');
    }
  }
}
