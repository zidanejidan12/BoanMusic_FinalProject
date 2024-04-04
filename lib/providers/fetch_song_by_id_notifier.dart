import 'package:flutter/material.dart';
import 'package:boanmusic/data/repository/song_repository.dart';

class FetchSongById with ChangeNotifier {
  final SongRepository _repository;

  FetchSongById({required SongRepository repository})
      : _repository = repository;

  Future<Map<String, dynamic>> call(int id) async {
    try {
      final song = await _repository.fetchSongById(id);
      notifyListeners();
      return song;
    } catch (e) {
      throw Exception('Failed to fetch song: $e');
    }
  }
}
