import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:developer' as developer;

class SoundService {
  bool _isMuted = false;
  bool _isInitialized = false;

  bool get isMuted => _isMuted;

  Future<void> initialize() async {
    developer.log('Initializing SoundService');
    if (_isInitialized) return;

    _isInitialized = true;
    developer.log('SoundService initialized');
  }

  Future<AudioPlayer> _createPlayer(String assetPath) async {
    final player = AudioPlayer();
    await player.setLoopMode(LoopMode.off);
    await player.setAsset(assetPath);
    return player;
  }

  Future<void> playCountdown() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/countdown.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing countdown sound: $e', error: e);
    }
  }

  Future<void> playStart() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/start.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing start sound: $e', error: e);
    }
  }

  Future<void> playEnd() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/end.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing end sound: $e', error: e);
    }
  }

  Future<void> playFinish() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/finish.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing finish sound: $e', error: e);
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    developer.log('SoundService mute toggled: $_isMuted');
  }

  void dispose() {
    developer.log('Disposing SoundService');
  }
} 