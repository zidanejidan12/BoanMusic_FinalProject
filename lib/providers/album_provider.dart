import 'package:flutter/material.dart';
import 'package:boanmusic/domain/usecases/fetch_albums.dart';
import 'package:boanmusic/domain/usecases/fetch_albums_by_artist_id.dart'; // Import the new use case

class AlbumProvider extends ChangeNotifier {
  final FetchAlbums _fetchAlbums;
  final FetchAlbumsByArtistId _fetchAlbumsByArtistId; // Add the new use case

  AlbumProvider({
    required FetchAlbums fetchAlbums,
    required FetchAlbumsByArtistId
        fetchAlbumsByArtistId, // Add the new use case to the constructor
  })  : _fetchAlbums = fetchAlbums,
        _fetchAlbumsByArtistId =
            fetchAlbumsByArtistId; // Initialize the new use case

  bool _isLoading = false;
  List<Map<String, dynamic>> _albums = [];
  String _error = '';

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get albums => _albums;
  String get error => _error;

  Future<void> fetchAlbums() async {
    _isLoading = true;
    notifyListeners();

    try {
      _albums = await _fetchAlbums();
    } catch (e) {
      _error = 'Failed to fetch albums: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // New method to fetch albums by artist ID
  Future<void> fetchAlbumsByArtistId(int artistId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _albums = await _fetchAlbumsByArtistId(artistId); // Use the new use case
    } catch (e) {
      _error = 'Failed to fetch albums by artist ID: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
