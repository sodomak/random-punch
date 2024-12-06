import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/training_stats.dart';

class StatsService {
  static const String _statsKey = 'training_stats';

  Future<void> saveTrainingStats(TrainingStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final existingStatsJson = prefs.getString(_statsKey);
    final List<TrainingStats> allStats = [];
    
    if (existingStatsJson != null) {
      final List<dynamic> decoded = jsonDecode(existingStatsJson);
      allStats.addAll(decoded.map((e) => TrainingStats.fromJson(e)));
    }
    
    allStats.add(stats);
    await prefs.setString(_statsKey, jsonEncode(allStats.map((e) => e.toJson()).toList()));
  }

  Future<List<TrainingStats>> getStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    
    if (statsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(statsJson);
    final allStats = decoded.map((e) => TrainingStats.fromJson(e)).toList();
    
    if (startDate == null && endDate == null) return allStats;
    
    return allStats.where((stat) {
      if (startDate != null && stat.startTime.isBefore(startDate)) return false;
      if (endDate != null && stat.endTime.isAfter(endDate)) return false;
      return true;
    }).toList();
  }

  Future<Map<String, int>> getAggregatedStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final stats = await getStats(startDate: startDate, endDate: endDate);
    
    return {
      'totalTrainings': stats.length,
      'totalTrainingTime': stats.fold(0, (sum, stat) => sum + stat.trainingTimeSeconds),
      'totalBreakTime': stats.fold(0, (sum, stat) => sum + stat.breakTimeSeconds),
      'totalCombinations': stats.fold(0, (sum, stat) => sum + stat.combinationsThrown),
      'totalPunches': stats.fold(0, (sum, stat) => sum + stat.punchesThrown),
      'totalRounds': stats.fold(0, (sum, stat) => sum + stat.roundsCompleted),
    };
  }

  Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
  }
} 