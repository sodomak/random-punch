import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../models/training_settings.dart';

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
  late Timer _timer;
  int _countdown = 0;
  bool _isCountingDown = true;
  bool _isBreak = false;
  List<int> _currentNumbers = [];
  final Random _random = Random();
  late Duration _remainingTime;
  int _currentRound = 1;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = widget.settings.countdownLength.inSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _isCountingDown = false;
          timer.cancel();
          _startRound();
        }
      });
    });
  }

  void _startRound() {
    setState(() {
      _isBreak = false;
      _remainingTime = widget.settings.roundLength;
    });
    _startTraining();
    _startTimer();
  }

  void _startBreak() {
    setState(() {
      _isBreak = true;
      _currentRound++;
      
      if (_currentRound > widget.settings.numberOfRounds) {
        _isFinished = true;
        _timer.cancel();
        return;
      }
      
      _remainingTime = widget.settings.breakLength;
      _currentNumbers = [];
    });
    _timer.cancel();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 1) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          timer.cancel();
          if (_isBreak) {
            _startRound();
          } else {
            _startBreak();
          }
        }
      });
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
    });
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.training),
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