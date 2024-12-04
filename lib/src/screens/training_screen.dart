import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../models/training_settings.dart';
import '../services/sound_service.dart';

class TrainingScreen extends StatefulWidget {
  final TrainingSettings settings;

  const TrainingScreen({
    super.key,
    required this.settings,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int _countdown = 0;
  bool _isCountingDown = true;
  bool _isBreak = false;
  List<int> _currentNumbers = [];
  final Random _random = Random();
  late Duration _remainingTime;
  int _currentRound = 1;
  bool _isFinished = false;
  final SoundService _soundService = SoundService();
  Timer? _countdownTimer;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = Duration.zero;
    _initializeSoundService();
  }

  Future<void> _initializeSoundService() async {
    await _soundService.initialize();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _timer?.cancel();
    _soundService.dispose();
    super.dispose();
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
    _timer?.cancel();
    _soundService.playStart();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isBreak = false;
          _remainingTime = widget.settings.roundLength;
          _isPaused = false;
        });
        _startTraining();
        _startTimer();
      }
    });
  }

  void _startBreak() {
    _timer?.cancel();

    if (_currentRound + 1 > widget.settings.numberOfRounds) {
      _soundService.playFinish();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isFinished = true;
            _currentNumbers = [];
            _isPaused = false;
          });
        }
      });
      return;
    }

    _soundService.playEnd();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isBreak = true;
          _currentRound++;
          _remainingTime = widget.settings.breakLength;
          _currentNumbers = [];
          _isPaused = false;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    final startTime = DateTime.now();
    final initialRemainingTime = _remainingTime.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void _startTraining() {
    _generateNumbers();
    _scheduleNextNumbers();
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
        _timer?.cancel();
      } else {
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.training),
        actions: [
          if (!_isCountingDown && !_isFinished)
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: _togglePause,
              tooltip: _isPaused ? l10n.resume : l10n.pause,
            ),
          IconButton(
            icon: Icon(
              _soundService.isMuted ? Icons.volume_off : Icons.volume_up,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _soundService.toggleMute();
              });
            },
            tooltip: _soundService.isMuted ? l10n.unmute : l10n.mute,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isFinished) ...[
              Text(
                l10n.trainingFinished,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _restartTraining,
                    child: Text(l10n.repeat),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.backToHome),
                  ),
                ],
              ),
            ] else if (_isCountingDown) ...[
              Text(
                l10n.getReady,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                _countdown.toString(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ] else ...[
              Text(
                'Round $_currentRound',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _isBreak ? 'Break' : 'Training',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _isBreak ? Colors.orange : Colors.green,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatDuration(_remainingTime),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              if (!_isBreak)
                Text(
                  _currentNumbers.join(' '),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
            ],
          ],
        ),
      ),
    );
  }
} 