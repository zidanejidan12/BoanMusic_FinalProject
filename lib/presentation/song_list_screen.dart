import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/domain/usecases/fetch_albums.dart';
import 'package:boanmusic/domain/usecases/fetch_songs.dart';
import 'package:boanmusic/domain/usecases/fetch_artist.dart';
import 'package:boanmusic/presentation/song_details.dart';
import 'package:boanmusic/presentation/album_details.dart';
import 'package:boanmusic/presentation/artist_details.dart';
import 'package:boanmusic/providers/login_user_provider.dart';
import 'package:boanmusic/presentation/user_login_screen.dart';

/// Screen to display a list of songs, albums, and artists.
class SongListScreen extends StatefulWidget {
  final FetchSongs fetchSongs;
  final FetchAlbums fetchAlbums;
  final FetchArtists fetchArtists;

  const SongListScreen({
    Key? key,
    required this.fetchSongs,
    required this.fetchAlbums,
    required this.fetchArtists,
  }) : super(key: key);

  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late Future<List<Map<String, dynamic>>> _futureSongs;
  late Future<List<Map<String, dynamic>>> _futureAlbums;
  late Future<List<Map<String, dynamic>>> _futureArtists;
  late LoginUserProvider _loginUserProvider;

  @override
  void initState() {
    super.initState();
    _futureSongs = widget.fetchSongs();
    _futureAlbums = widget.fetchAlbums();
    _futureArtists = widget.fetchArtists();

    _loginUserProvider = Provider.of<LoginUserProvider>(context, listen: false);
  }

  /// Logs the user out and navigates to the login screen.
  void _logout() async {
    try {
      await _loginUserProvider.logoutUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserLoginScreen(
            fetchSongs: Provider.of<FetchSongs>(context, listen: false),
            fetchAlbums: Provider.of<FetchAlbums>(context, listen: false),
            fetchArtists: Provider.of<FetchArtists>(context, listen: false),
          ),
        ),
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(79, 85, 89, 1),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BoanMusic'),
          actions: [
            IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Top Songs'),
              _buildSongList(_futureSongs),
              _buildSectionTitle('Top Albums'),
              _buildAlbumList(_futureAlbums),
              _buildSectionTitle('Top Artists'),
              _buildArtistList(_futureArtists),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a section title widget.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  /// Builds a list of songs.
  Widget _buildSongList(Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final songs = snapshot.data as List<Map<String, dynamic>>;
          return _buildItemList(
            songs,
            (song) => SongItem(song: song),
          );
        }
      },
    );
  }

  /// Builds a list of albums.
  Widget _buildAlbumList(Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final albums = snapshot.data as List<Map<String, dynamic>>;
          return _buildItemList(
            albums,
            (album) => AlbumItem(album: album),
          );
        }
      },
    );
  }

  /// Builds a list of artists.
  Widget _buildArtistList(Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final artists = snapshot.data as List<Map<String, dynamic>>;
          return _buildItemList(
            artists,
            (artist) => ArtistItem(artist: artist),
          );
        }
      },
    );
  }

  /// Builds a list of items based on the data and item builder function.
  Widget _buildItemList<T>(
    List<T> items,
    Widget Function(T item) itemBuilder,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) => itemBuilder(item)).toList(),
      ),
    );
  }
}

/// Widget to display a song item.
class SongItem extends StatelessWidget {
  final Map<String, dynamic> song;

  const SongItem({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int songId = song['id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongDetailsScreen(songId: songId),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              song['imageSongURL'],
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 8.0),
            Text(
              song['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(song['album']['artist']['fName']),
          ],
        ),
      ),
    );
  }
}

/// Widget to display an artist item.
class ArtistItem extends StatelessWidget {
  final Map<String, dynamic> artist;

  const ArtistItem({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int artistId = artist['id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailsScreen(artistId: artistId),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              artist['imageURL'],
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 8.0),
            Text(
              '${artist['fName']} ${artist['lName'] ?? ''}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}

/// Widget to display an album item.
class AlbumItem extends StatelessWidget {
  final Map<String, dynamic> album;

  const AlbumItem({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int albumId = album['id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(albumId: albumId),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              album['imageCoverURL'],
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 8.0),
            Text(
              album['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(album['artist']['fName']),
          ],
        ),
      ),
    );
  }
}
