import 'package:flutter/material.dart';
import 'package:boanmusic/data/repository/artist_repository.dart';
import 'package:boanmusic/domain/usecases/fetch_artist.dart';

class ArtistProvider extends ChangeNotifier {
  final FetchArtists _fetchArtists;

  ArtistProvider({required ArtistRepository repository})
      : _fetchArtists = FetchArtists(repository: repository);

  List<Map<String, dynamic>> _artists = [];
  List<Map<String, dynamic>> get artists => _artists;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchArtists() async {
    try {
      _isLoading = true;
      notifyListeners();
      _artists = await _fetchArtists();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
