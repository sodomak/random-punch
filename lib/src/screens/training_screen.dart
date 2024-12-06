import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../models/training_settings.dart';
import '../services/sound_service.dart';
import 'package:flutter/services.dart';

class TrainingScreen extends StatefulWidget {
  final TrainingSettings settings;
  final SoundService soundService;

  const TrainingScreen({
    super.key,
    required this.settings,
    required this.soundService,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with WidgetsBindingObserver {
  int _countdown = 0;
  bool _isCountingDown = true;
  bool _isBreak = false;
  List<int> _currentNumbers = [];
  final Random _random = Random();
  late Duration _remainingTime;
  int _currentRound = 1;
  bool _isFinished = false;
  Timer? _countdownTimer;
  Timer? _timer;
  bool _isPaused = false;
  DateTime? _pauseTime;
  Duration? _remainingAtPause;

  SoundService get _soundService => widget.soundService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingTime = Duration.zero;
    _keepScreenOn();
    _startCountdown();
  }

  Future<void> _keepScreenOn() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } catch (e) {
      debugPrint('Error setting screen orientation: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _timer?.cancel();
    _soundService.dispose();
    SystemChannels.platform.invokeMethod('SystemChrome.setKeepScreenOn', false);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _keepScreenOn();
    }
  }

  void _startCountdown() {
    setState(() {
      _countdown = widget.settings.countdownLength.inSeconds;
      _isCountingDown = true;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _soundService.playStart();
        setState(() {
          _isCountingDown = false;
        });
        _startRound();
      }
    });
  }

  void _startRound() {
    setState(() {
      _isBreak = false;
      _remainingTime = widget.settings.roundLength;
    });
    _soundService.playStart();
    _startTimer();
    _scheduleNextNumbers();
  }

  void _startBreak() {
    if (_currentRound >= widget.settings.numberOfRounds) {
      _finishTraining();
      return;
    }

    setState(() {
      _isBreak = true;
      _remainingTime = widget.settings.breakLength;
      _currentRound++;
    });
    _soundService.playEnd();
    _startTimer();
  }

  void _finishTraining() {
    _soundService.playFinish();
    _timer?.cancel();
    setState(() {
      _isFinished = true;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    final startTime = DateTime.now();
    final initialRemainingTime = _remainingTime.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) {
        timer.cancel();
        return;
      }

      final elapsedTime = DateTime.now().difference(startTime).inSeconds;
      final newRemainingTime = initialRemainingTime - elapsedTime;

      if (newRemainingTime > 0) {
        setState(() {
          _remainingTime = Duration(seconds: newRemainingTime);
        });
      } else {
        timer.cancel();
        if (_isBreak) {
          _startRound();
        } else {
          _startBreak();
        }
      }
    });
  }

  void _scheduleNextNumbers() {
    final intervalSeconds = _random.nextInt(
          widget.settings.maxInterval.inSeconds - 
          widget.settings.minInterval.inSeconds + 1,
        ) + widget.settings.minInterval.inSeconds;
    
    _timer = Timer(
      Duration(seconds: intervalSeconds),
      () {
        _generateNumbers();
        if (!_isBreak && mounted) {
          _scheduleNextNumbers();
        }
      },
    );
  }

  void _generateNumbers() {
    setState(() {
      final numbers = widget.settings.selectedNumbers;
      if (widget.settings.isFixedNumberCount) {
        _currentNumbers = List.generate(
          widget.settings.fixedNumberCount,
          (_) => numbers[_random.nextInt(numbers.length)],
        );
      } else {
        final count = _random.nextInt(
              widget.settings.maxNumberCount - widget.settings.minNumberCount + 1,
            ) +
            widget.settings.minNumberCount;
        _currentNumbers = List.generate(
          count,
          (_) => numbers[_random.nextInt(numbers.length)],
        );
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _restartTraining() {
    setState(() {
      _isFinished = false;
      _isCountingDown = true;
      _isBreak = false;
      _currentRound = 1;
      _currentNumbers = [];
      _isPaused = false;
    });
    _startCountdown();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        // Pause
        _pauseTime = DateTime.now();
        _remainingAtPause = _remainingTime;
        _timer?.cancel();
        _timer = null;
      } else {
        // Resume
        if (_pauseTime != null && _remainingAtPause != null) {
          _remainingTime = _remainingAtPause!;
          _startTimer();
          if (!_isBreak) {
            _scheduleNextNumbers();
          }
        }
      }
    });
  }

  void _pauseTimer() {
    _togglePause();
  }

  void _resumeTimer() {
    _togglePause();
  }

  void _stopTraining() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_isCountingDown) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.training),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _soundService.toggleMute();
                });
              },
              icon: Icon(
                _soundService.isMuted ? Icons.volume_off : Icons.volume_up,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.getReady,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text(
                _countdown.toString(),
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    if (_isFinished) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.training),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.trainingFinished,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _restartTraining,
                    icon: const Icon(Icons.repeat),
                    label: Text(l10n.repeat),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.home),
                    label: Text(l10n.backToHome),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.training),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _soundService.toggleMute();
              });
            },
            icon: Icon(
              _soundService.isMuted ? Icons.volume_off : Icons.volume_up,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Round Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${l10n.training} ${_currentRound}/${widget.settings.numberOfRounds}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Timer with Circular Progress
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _isBreak 
                          ? _remainingTime.inSeconds / widget.settings.breakLength.inSeconds
                          : _remainingTime.inSeconds / widget.settings.roundLength.inSeconds,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      color: _isBreak ? Colors.orange : Colors.green,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDuration(_remainingTime),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isBreak ? l10n.break_ : l10n.training,
                        style: TextStyle(
                          fontSize: 20,
                          color: _isBreak ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Numbers Display
            Expanded(
              flex: 3,
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: _currentNumbers.map((number) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          number.toString(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    onPressed: _togglePause,
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    iconSize: 32,
                  ),
                  IconButton.filled(
                    onPressed: _stopTraining,
                    icon: const Icon(Icons.stop),
                    iconSize: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 