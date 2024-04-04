import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/domain/usecases/fetch_song_by_id.dart';
import 'package:boanmusic/providers/audio_player_provider.dart';

class SongDetailsScreen extends StatelessWidget {
  final int songId;

  const SongDetailsScreen({Key? key, required this.songId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<FetchSongById>(
          builder: (context, fetchSongById, _) {
            return FutureBuilder<Map<String, dynamic>>(
              future: fetchSongById.call(songId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final songDetails = snapshot.data!;
                  final runtimeInSeconds = songDetails['runtimeInSeconds'] ?? 0;
                  final String mp3Url = 'https://localhost:44300/api/v1/songs/';
                  final songMp3 = Uri.encodeComponent(songDetails['songMP3']);
                  final filePath = mp3Url + songMp3;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          songDetails['imageSongURL'],
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          songDetails['title'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${songDetails['album']['artist']['fName']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Consumer<AudioPlayerState>(
                          builder: (context, audioPlayerState, _) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 20),
                                    IconButton(
                                      onPressed: () {
                                        if (audioPlayerState.playerState ==
                                            PlayerState.playing) {
                                          audioPlayerState.pause();
                                        } else {
                                          audioPlayerState.playUrl(filePath);
                                        }
                                      },
                                      icon: Icon(audioPlayerState.playerState ==
                                              PlayerState.playing
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      onPressed: () {
                                        audioPlayerState.stop(filePath);
                                      },
                                      icon: const Icon(Icons.stop),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                ),
                                Slider(
                                  value: audioPlayerState
                                      .currentPosition.inSeconds
                                      .toDouble(),
                                  min: 0.0,
                                  max: runtimeInSeconds.toDouble(),
                                  onChanged: (value) {
                                    audioPlayerState
                                        .seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
