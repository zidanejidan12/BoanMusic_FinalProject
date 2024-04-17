import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/domain/usecases/fetch_song_by_id.dart';
import 'package:boanmusic/providers/audio_player_provider.dart';

/// Screen to display details of a song.
class SongDetailsScreen extends StatelessWidget {
  final int songId;

  /// Constructs a [SongDetailsScreen] with the given [songId].
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
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final songDetails = snapshot.data!;
                  final runtimeInSeconds = songDetails['runtimeInSeconds'] ?? 0;
                  final mp3Url = 'https://localhost:44300/api/v1/songs/';
                  final songMp3 = Uri.encodeComponent(songDetails['songMP3']);
                  final filePath = mp3Url + songMp3;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildSongImage(songDetails['imageSongURL']),
                        const SizedBox(height: 20),
                        _buildSongTitle(songDetails['title']),
                        const SizedBox(height: 10),
                        _buildArtistName(
                            songDetails['album']['artist']['fName']),
                        const SizedBox(height: 20),
                        _buildAudioControls(runtimeInSeconds, filePath),
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

  /// Builds the widget for displaying the song image.
  Widget _buildSongImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 200,
      height: 200,
    );
  }

  /// Builds the widget for displaying the song title.
  Widget _buildSongTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Builds the widget for displaying the artist name.
  Widget _buildArtistName(String artistName) {
    return Text(
      artistName,
      style: const TextStyle(fontSize: 18),
    );
  }

  /// Builds the widget for audio playback controls.
  Widget _buildAudioControls(int runtimeInSeconds, String filePath) {
    return Consumer<AudioPlayerState>(
      builder: (context, audioPlayerState, _) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    _toggleAudioPlayback(audioPlayerState, filePath);
                  },
                  icon: Icon(
                    audioPlayerState.playerState == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
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
              value: audioPlayerState.currentPosition.inSeconds.toDouble(),
              min: 0.0,
              max: runtimeInSeconds.toDouble(),
              onChanged: (double value) {
                // No action needed while dragging
              },
              onChangeEnd: (double value) {
                final position = Duration(seconds: value.toInt());
                audioPlayerState.seek(position);
              },
            ),
          ],
        );
      },
    );
  }

  /// Toggles audio playback.
  void _toggleAudioPlayback(
      AudioPlayerState audioPlayerState, String filePath) {
    if (audioPlayerState.playerState == PlayerState.playing) {
      audioPlayerState.pause();
    } else {
      audioPlayerState.playUrl(filePath);
    }
  }
}
