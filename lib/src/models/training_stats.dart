class TrainingStats {
  final DateTime startTime;
  final DateTime endTime;
  final int trainingTimeSeconds;
  final int breakTimeSeconds;
  final int combinationsThrown;
  final int punchesThrown;
  final int roundsCompleted;

  TrainingStats({
    required this.startTime,
    required this.endTime,
    required this.trainingTimeSeconds,
    required this.breakTimeSeconds,
    required this.combinationsThrown,
    required this.punchesThrown,
    required this.roundsCompleted,
  });

  int get totalTimeSeconds => trainingTimeSeconds + breakTimeSeconds;

  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'trainingTimeSeconds': trainingTimeSeconds,
    'breakTimeSeconds': breakTimeSeconds,
    'combinationsThrown': combinationsThrown,
    'punchesThrown': punchesThrown,
    'roundsCompleted': roundsCompleted,
  };

  factory TrainingStats.fromJson(Map<String, dynamic> json) => TrainingStats(
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    trainingTimeSeconds: json['trainingTimeSeconds'],
    breakTimeSeconds: json['breakTimeSeconds'],
    combinationsThrown: json['combinationsThrown'],
    punchesThrown: json['punchesThrown'],
    roundsCompleted: json['roundsCompleted'],
  );
} 