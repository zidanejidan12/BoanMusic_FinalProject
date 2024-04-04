import 'package:boanmusic/presentation/user_login_screen.dart';
import 'package:boanmusic/providers/login_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:boanmusic/domain/usecases/fetch_albums.dart';
import 'package:boanmusic/domain/usecases/fetch_songs.dart';
import 'package:boanmusic/domain/usecases/fetch_artist.dart';
import 'package:boanmusic/presentation/song_details.dart';
import 'package:boanmusic/presentation/album_details.dart';
import 'package:boanmusic/presentation/artist_details.dart';
import 'package:provider/provider.dart';

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
    _futureArtists = widget.fetchArtists(); // Fetch top artists data

    // Access the LoginUserProvider instance
    _loginUserProvider = Provider.of<LoginUserProvider>(context, listen: false);
  }

  void _logout() async {
    try {
      // Call logoutUser method from LoginUserProvider
      await _loginUserProvider.logoutUser();

      // Navigate back to the login screen
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
      // Handle logout error
      print('Logout error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(79, 85, 89, 1), // Spotify green color
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BoanMusic'),
          actions: [
            IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          // Wrap the entire Column with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Top Songs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), // Text color
                  ),
                ),
              ),
              FutureBuilder(
                future: _futureSongs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final songs = snapshot.data as List<Map<String, dynamic>>;
                    return SingleChildScrollView(
                      // Wrap the SingleChildScrollView with SingleChildScrollView to allow horizontal scrolling
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            songs.map((song) => SongItem(song: song)).toList(),
                      ),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Top Albums',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), // Text color
                  ),
                ),
              ),
              FutureBuilder(
                future: _futureAlbums,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final albums = snapshot.data as List<Map<String, dynamic>>;
                    return SingleChildScrollView(
                      // Wrap the SingleChildScrollView with SingleChildScrollView to allow horizontal scrolling
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: albums
                            .map((album) => AlbumItem(album: album))
                            .toList(),
                      ),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Top Artists',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), // Text color
                  ),
                ),
              ),
              FutureBuilder(
                future: _futureArtists,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final artists = snapshot.data as List<Map<String, dynamic>>;
                    return SingleChildScrollView(
                      // Wrap the SingleChildScrollView with SingleChildScrollView to allow horizontal scrolling
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: artists
                            .map((artist) => ArtistItem(artist: artist))
                            .toList(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        width: 200, // Width of each song item
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image or Album Artwork
            Image.network(
              song['imageSongURL'], // Assuming this key holds the image URL
              width: 150, // Adjust image width as needed
              height: 150, // Adjust image height as needed
            ),
            const SizedBox(height: 8.0),
            // Title
            Text(
              song['title'], // Assuming this key holds the title of the song
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            // Artist Name
            Text(song['album']['artist']
                ['fName']), // Assuming this key holds the artist's first name
          ],
        ),
      ),
    );
  }
}

class ArtistItem extends StatelessWidget {
  final Map<String, dynamic> artist;

  const ArtistItem({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle artist item tap
        int artistId = artist['id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailsScreen(artistId: artistId),
          ),
        );
      },
      child: Container(
        width: 200, // Width of each artist item
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image or Artist Photo
            Image.network(
              artist['imageURL'], // Assuming this key holds the image URL
              width: 150, // Adjust image width as needed
              height: 150, // Adjust image height as needed
            ),
            const SizedBox(height: 8.0),
            // Artist Name
            Text(
              '${artist['fName']} ${artist['lName'] ?? ''}', // Assuming this key holds the artist's full name
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}

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
        width: 200, // Width of each album item
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image or Album Artwork
            Image.network(
              album['imageCoverURL'], // Assuming this key holds the image URL
              width: 150, // Adjust image width as needed
              height: 150, // Adjust image height as needed
            ),
            const SizedBox(height: 8.0),
            // Title
            Text(
              album['title'], // Assuming this key holds the title of the album
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            // Artist Name
            Text(album['artist']
                ['fName']), // Assuming this key holds the artist's first name
          ],
        ),
      ),
    );
  }
}
