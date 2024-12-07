import 'dart:developer' as developer;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class SoundService {
  bool _isMuted = false;
  bool _isInitialized = false;
  String? _currentLanguage;
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

  Future<void> initialize([String? languageCode]) async {
    if (_isInitialized && languageCode == _currentLanguage) return;
    
    try {
      debugPrint('[SoundService] Starting initialization');
      
      // Create cache directory if it doesn't exist
      final cacheDir = Directory('/data/user/0/com.sodomak.randompunch/cache/just_audio_cache/');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      
      await AudioPlayer.clearAssetCache();
      final testPlayer = AudioPlayer();
      final testPath = languageCode != null ? 
        'assets/sounds/$languageCode/1.mp3' : 
        'assets/sounds/countdown.mp3';
        
      debugPrint('[SoundService] Testing with path: $testPath');
      await testPlayer.setAsset(testPath);
      debugPrint('[SoundService] Asset set successfully');
      
      await testPlayer.seek(Duration.zero);
      await testPlayer.setVolume(0);
      
      if (kIsWeb) {
        _isInitialized = true;
        debugPrint('[SoundService] Web audio context initialized');
      } else {
        debugPrint('[SoundService] Starting mobile playback test');
        await testPlayer.play();
        await Future.delayed(const Duration(milliseconds: 100));
        await testPlayer.stop();
        _isInitialized = true;
        debugPrint('[SoundService] Mobile audio initialized successfully');
      }
      
      await testPlayer.dispose();
      _currentLanguage = languageCode;
      
    } catch (e, stackTrace) {
      debugPrint('[SoundService] Initialization error: $e');
      debugPrint('[SoundService] Stack trace: $stackTrace');
      _isInitialized = false;
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
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/start.mp3');
      await player.seek(Duration.zero);
      await player.play();
      await player.dispose();
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

  void dispose() {
    _isInitialized = false;
    developer.log('Disposing SoundService');
  }
} 