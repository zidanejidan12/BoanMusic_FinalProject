import 'package:boanmusic/presentation/album_details.dart';
import 'package:boanmusic/presentation/song_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/domain/usecases/fetch_songs_by_artist_id.dart';
import 'package:boanmusic/domain/usecases/fetch_albums_by_artist_id.dart';

class ArtistDetailsScreen extends StatelessWidget {
  final int artistId;

  const ArtistDetailsScreen({Key? key, required this.artistId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future:
                    Provider.of<FetchSongsByArtistId>(context).call(artistId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final songs = snapshot.data!;
                    final artistImageUrl = songs.isNotEmpty
                        ? songs.first['album']['artist']['imageURL']
                        : '';
                    final artistName = songs.isNotEmpty
                        ? songs.first['album']['artist']['fName']
                        : '';
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
            ),
            Column(
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
                  child: GestureDetector(
                    onTap: () {},
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: Provider.of<FetchSongsByArtistId>(context)
                          .call(artistId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final songs = snapshot.data!;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(songs.length, (index) {
                                final song = songs[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to song details screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongDetailsScreen(
                                            songId: song['id']),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200, // Adjust as needed
                                    margin: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Image or Album Artwork
                                        Image.network(
                                          song[
                                              'imageSongURL'], // Adjust as needed
                                          width: 150, // Adjust as needed
                                          height: 150, // Adjust as needed
                                        ),
                                        const SizedBox(height: 8.0),
                                        // Title
                                        Text(
                                          song['title'], // Adjust as needed
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4.0),
                                        // Artist Name
                                        Text(song['album']['artist']
                                            ['fName']), // Adjust as needed
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
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
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: Provider.of<FetchAlbumsByArtistId>(context)
                            .call(artistId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            final albums = snapshot.data!;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(albums.length, (index) {
                                  final album = albums[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to album details screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AlbumDetailsScreen(
                                                  albumId: album['id']),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 200, // Adjust as needed
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Image or Album Artwork
                                          Image.network(
                                            album[
                                                'imageCoverURL'], // Adjust as needed
                                            width: 150, // Adjust as needed
                                            height: 150, // Adjust as needed
                                          ),
                                          const SizedBox(height: 8.0),
                                          // Title
                                          Text(
                                            album['title'], // Adjust as needed
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4.0),
                                          // Artist Name
                                          Text(album['artist']
                                              ['fName']), // Adjust as needed
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ));
  }
}
