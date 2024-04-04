import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/domain/usecases/fetch_songs_by_album_id.dart';
import 'song_details.dart';

class AlbumDetailsScreen extends StatelessWidget {
  final int albumId;

  const AlbumDetailsScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<FetchSongsByAlbumId>(context).call(albumId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If data is still loading, display loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display the error message
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // If data is available, display the album image and name
            final songs = snapshot.data!;
            final albumImageUrl =
                songs.isNotEmpty ? songs.first['album']['imageCoverURL'] : '';
            final albumName =
                songs.isNotEmpty ? songs.first['album']['title'] : '';

            return Stack(
              children: [
                // Background image with blur effect
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(albumImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                // Album details positioned in the upper part of the screen
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.1, // Position adjusted to 1/4 of the screen height
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Album image
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(albumImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Album name
                      Text(
                        albumName,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                          height:
                              16), // Added space between album name and song list
                    ],
                  ),
                ),
                // List of songs
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.5, // Adjusted position
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return InkWell(
                        onTap: () {
                          // Navigate to SongDetailsScreen when song is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SongDetailsScreen(songId: song['id']),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              title: Text(
                                song['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                  '${song['album']['artist']['fName']}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 223, 216, 216),
                                  ),
                                ),
                              ),
                              // You can add more details if needed
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
