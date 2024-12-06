import 'package:flutter/material.dart';
import '../services/stats_service.dart';
import '../l10n/app_localizations.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _statsService = StatsService();
  String _selectedRange = 'all';
  Map<String, int>? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _loadStats() async {
    DateTime? startDate;
    final now = DateTime.now();

    switch (_selectedRange) {
      case 'day':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'all':
      default:
        startDate = null;
    }

    final stats = await _statsService.getAggregatedStats(startDate: startDate);
    setState(() {
      _stats = stats;
    });
  }

  Future<void> _showResetConfirmation() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.resetStats),
          content: Text(l10n.resetStatsConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                await _statsService.resetStats();
                if (mounted) {
                  Navigator.of(context).pop();
                  _loadStats(); // Reload stats after reset
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.reset),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showResetConfirmation,
            tooltip: l10n.resetStats,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'day', label: Text(l10n.day)),
                ButtonSegment(value: 'week', label: Text(l10n.week)),
                ButtonSegment(value: 'month', label: Text(l10n.month)),
                ButtonSegment(value: 'all', label: Text(l10n.all)),
              ],
              selected: {_selectedRange},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedRange = newSelection.first;
                  _loadStats();
                });
              },
            ),
          ),
          if (_stats != null)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _StatCard(
                    title: l10n.totalTrainings,
                    value: _stats!['totalTrainings'].toString(),
                    icon: Icons.fitness_center,
                  ),
                  _StatCard(
                    title: l10n.totalTrainingTime,
                    value: _formatTime(_stats!['totalTrainingTime']!),
                    icon: Icons.timer,
                  ),
                  _StatCard(
                    title: l10n.totalTime,
                    value: _formatTime(_stats!['totalTrainingTime']! + _stats!['totalBreakTime']!),
                    icon: Icons.schedule,
                  ),
                  _StatCard(
                    title: l10n.combinationsThrown,
                    value: _stats!['totalCombinations'].toString(),
                    icon: Icons.repeat,
                  ),
                  _StatCard(
                    title: l10n.punchesThrown,
                    value: _stats!['totalPunches'].toString(),
                    icon: Icons.sports_mma,
                  ),
                  _StatCard(
                    title: l10n.roundsCompleted,
                    value: _stats!['totalRounds'].toString(),
                    icon: Icons.loop,
                  ),
                  if (_stats!['totalTrainings']! > 0)
                    _StatCard(
                      title: 'Average Punches per Training',
                      value: (_stats!['totalPunches']! / _stats!['totalTrainings']!).round().toString(),
                      icon: Icons.analytics,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
} 