import 'dart:developer' as developer;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  bool _isMuted = false;
  bool _isInitialized = false;
  static const String _muteKey = 'isMuted';

  SoundService() {
    _loadMuteState();
  }

  Future<void> _loadMuteState() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool(_muteKey) ?? false;
  }

  Future<void> _saveMuteState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_muteKey, _isMuted);
  }

  Future<void> initialize() async {
    _isInitialized = true;
    await _loadMuteState();
  }

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    _saveMuteState();
    developer.log('SoundService mute toggled: $_isMuted');
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

  void dispose() {
    developer.log('Disposing SoundService');
  }
} 