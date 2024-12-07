import 'dart:developer' as developer;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class SoundService {
  static const String defaultLanguage = 'en';
  
  AudioPlayer? _player;
  bool _isMuted = false;
  bool _isInitialized = false;
  String _currentLanguage = defaultLanguage;
  static const String _muteKey = 'isMuted';
  bool _isSettingsChanged = false;

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

  bool needsReinitialization(String? languageCode) {
    if (!_isInitialized) return true;
    if (languageCode != null && languageCode != _currentLanguage) return true;
    return false;
  }

  Future<void> initialize({required String languageCode}) async {
    _currentLanguage = languageCode;
    _isInitialized = true;
    _isSettingsChanged = false;
  }

  Future<void> dispose() async {
    if (_player != null) {
      try {
        await _player?.dispose();
      } catch (e) {
        debugPrint('[SoundService] Error disposing player: $e');
      }
      _player = null;
    }
    _isInitialized = false;
  }

  Future<void> _playSound(String assetPath, {bool testMode = false}) async {
    if (_isMuted || !_isInitialized) return;
    
    try {
      final player = await _createPlayer(assetPath);
      await player.seek(Duration.zero);
      await player.play();
      
      // Wait for completion
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      await player.dispose();
      
    } catch (e) {
      debugPrint('[SoundService] Playback error: $e');
      rethrow;
    }
  }

  // Add this method to handle first user interaction
  Future<void> handleUserInteraction() async {
    if (!kIsWeb) return;
    
    try {
      final testPlayer = AudioPlayer();
      await testPlayer.setAsset('assets/sounds/countdown.mp3');
      await testPlayer.setVolume(0);
      await testPlayer.play();
      await Future.delayed(const Duration(milliseconds: 100));
      await testPlayer.stop();
      await testPlayer.dispose();
      debugPrint('Web audio context activated after user interaction');
    } catch (e) {
      debugPrint('Error activating web audio context: $e');
    }
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
    AudioPlayer? player;
    try {
      player = await _createPlayer('assets/sounds/countdown.mp3');
      await player.seek(Duration.zero);
      await player.play();
      // Wait for completion before disposing
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      await player.dispose();
    } catch (e) {
      await player?.dispose();
      developer.log('Error playing countdown sound: $e', error: e);
    }
  }

  Future<void> playStart() async {
    if (_isMuted) return;
    
    try {
      // Force initialization check for start sound
      if (!_isInitialized) {
        await initialize(languageCode: _currentLanguage);
      }
      await _playSound('assets/sounds/start.mp3');
    } catch (e) {
      debugPrint('[SoundService] Error playing start sound: $e');
    }
  }

  Future<void> playEnd() async {
    if (_isMuted || !_isInitialized || _isSettingsChanged) return;
    try {
      final player = await _createPlayer('assets/sounds/end.mp3');
      await player.seek(Duration.zero);
      await player.play();
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      await player.dispose();
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
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      await player.dispose();
    } catch (e) {
      developer.log('Error playing finish sound: $e', error: e);
    }
  }

  Future<AudioPlayer?> playNumber(int number, String languageCode) async {
    if (_isMuted || !_isInitialized) {
      debugPrint('[SoundService] Sound skipped: muted=$_isMuted, initialized=$_isInitialized');
      return null;
    }
    
    try {
      String assetPath = 'assets/sounds/$languageCode/$number.mp3';
      debugPrint('[SoundService] Attempting to play sound: $assetPath');
      
      final player = await _createPlayer(assetPath);
      debugPrint('[SoundService] Player created successfully');
      
      await player.seek(Duration.zero);
      debugPrint('[SoundService] Starting playback');
      await player.play();
      
      debugPrint('[SoundService] Waiting for completion');
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      await player.dispose();
      debugPrint('[SoundService] Successfully completed playback: $assetPath');
      return null;
      
    } catch (e, stackTrace) {
      debugPrint('[SoundService] Primary language sound failed ($languageCode): $e');
      debugPrint('[SoundService] Stack trace: $stackTrace');
      if (languageCode != 'en') {
        try {
          String fallbackPath = 'assets/sounds/en/$number.mp3';
          debugPrint('Attempting fallback sound: $fallbackPath');
          
          final player = await _createPlayer(fallbackPath);
          await player.seek(Duration.zero);
          await player.play();
          
          // Wait for completion
          await player.playerStateStream.firstWhere(
            (state) => state.processingState == ProcessingState.completed
          );
          await player.dispose();
          debugPrint('Successfully played and disposed fallback: $fallbackPath');
          return null;
        } catch (e) {
          debugPrint('Fallback sound failed: $e');
          return null;
        }
      }
      debugPrint('Error playing any sound: $e');
      return null;
    }
  }

  Future<void> _disposePlayer() async {
    if (_player != null) {
      try {
        await _player?.dispose();
      } catch (e) {
        debugPrint('[SoundService] Error disposing player: $e');
      }
      _player = null;
    }
  }

  void onSettingsChanged() {
    _isInitialized = false;
    _isSettingsChanged = true;
  }
} 