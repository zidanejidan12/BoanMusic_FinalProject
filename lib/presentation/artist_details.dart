import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/domain/usecases/fetch_songs_by_artist_id.dart';
import 'package:boanmusic/domain/usecases/fetch_albums_by_artist_id.dart';
import 'package:boanmusic/presentation/album_details.dart';
import 'package:boanmusic/presentation/song_details.dart';

/// Screen to display details of an artist, including their songs and albums.
class ArtistDetailsScreen extends StatelessWidget {
  final int artistId;

  /// Constructs an [ArtistDetailsScreen] with the given [artistId].
  const ArtistDetailsScreen({Key? key, required this.artistId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildArtistHeader(context),
            const SizedBox(height: 20),
            _buildSongSection(context),
            const SizedBox(height: 20),
            _buildAlbumSection(context),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with artist details.
  Widget _buildArtistHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<FetchSongsByArtistId>(context).call(artistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final songs = snapshot.data!;
            final artistImageUrl = songs.isNotEmpty
                ? songs.first['album']['artist']['imageURL']
                : '';
            final artistName =
                songs.isNotEmpty ? songs.first['album']['artist']['fName'] : '';
            return GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(artistImageUrl),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      artistName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds the section displaying songs by the artist.
  Widget _buildSongSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Songs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<FetchSongsByArtistId>(
            builder: (context, fetchSongsByArtistId, _) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchSongsByArtistId.call(artistId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final songs = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: songs
                            .map((song) => _buildSongCard(context, song))
                            .toList(),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds a card widget for a song.
  Widget _buildSongCard(BuildContext context, Map<String, dynamic> song) {
    return GestureDetector(
      onTap: () {
        // Navigate to song details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongDetailsScreen(songId: song['id']),
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

  /// Builds the section displaying albums by the artist.
  Widget _buildAlbumSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Albums',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<FetchAlbumsByArtistId>(
            builder: (context, fetchAlbumsByArtistId, _) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAlbumsByArtistId.call(artistId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final albums = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: albums
                            .map((album) => _buildAlbumCard(context, album))
                            .toList(),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds a card widget for an album.
  Widget _buildAlbumCard(BuildContext context, Map<String, dynamic> album) {
    return GestureDetector(
      onTap: () {
        // Navigate to album details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(albumId: album['id']),
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
