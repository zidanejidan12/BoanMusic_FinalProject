import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum PlayerState { stopped, playing, paused }

class AudioPlayerState extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _currentPosition = Duration.zero;
  late String _currentSongUrl = '';

  AudioPlayerState() {
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (state == PlayerState.playing) {
        _playerState = PlayerState.playing;
        notifyListeners();
      } else if (state == PlayerState.paused) {
        _playerState = PlayerState.paused;
        notifyListeners();
      } else if (state == PlayerState.stopped) {
        _playerState = PlayerState.stopped;
        notifyListeners();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  PlayerState get playerState => _playerState;

  Duration get currentPosition => _currentPosition;

  Future<void> playUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      _currentSongUrl = url;
    } catch (e) {
      print('Error playing URL: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _playerState = PlayerState.paused;
    notifyListeners();
  }

  Future<void> stop(String currentSongUrl) async {
    if (currentSongUrl.isNotEmpty && _audioPlayer.playing) {
      await _audioPlayer.stop();
      _playerState = PlayerState.stopped;
      notifyListeners();
    }
  }

  Future<void> seekForward(Duration duration) async {
    final newPosition = _currentPosition + duration;
    await _audioPlayer.seek(newPosition);
  }

  Future<void> seekBackward(Duration duration) async {
    final newPosition = _currentPosition - duration;
    await _audioPlayer.seek(newPosition);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    if (_audioPlayer.playing) {
      _audioPlayer.stop();
    }
    _audioPlayer.dispose();
    super.dispose();
  }
}
