class TrainingSettings {
  final Duration roundLength;
  final Duration breakLength;
  final Duration countdownLength;
  final List<int> selectedNumbers;
  final bool isFixedNumberCount;
  final int fixedNumberCount;
  final int minNumberCount;
  final int maxNumberCount;
  final Duration minInterval;
  final Duration maxInterval;
  final String name;
  final int numberOfRounds;

  TrainingSettings({
    this.roundLength = const Duration(minutes: 3),
    this.breakLength = const Duration(minutes: 1),
    this.countdownLength = const Duration(seconds: 10),
    this.selectedNumbers = const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    this.isFixedNumberCount = true,
    this.fixedNumberCount = 1,
    this.minNumberCount = 1,
    this.maxNumberCount = 4,
    this.minInterval = const Duration(seconds: 3),
    this.maxInterval = const Duration(seconds: 10),
    this.name = 'Default',
    this.numberOfRounds = 3,
  });

  TrainingSettings copyWith({
    Duration? roundLength,
    Duration? breakLength,
    Duration? countdownLength,
    List<int>? selectedNumbers,
    bool? isFixedNumberCount,
    int? fixedNumberCount,
    int? minNumberCount,
    int? maxNumberCount,
    Duration? minInterval,
    Duration? maxInterval,
    String? name,
    int? numberOfRounds,
  }) {
    return TrainingSettings(
      roundLength: roundLength ?? this.roundLength,
      breakLength: breakLength ?? this.breakLength,
      countdownLength: countdownLength ?? this.countdownLength,
      selectedNumbers: selectedNumbers ?? this.selectedNumbers,
      isFixedNumberCount: isFixedNumberCount ?? this.isFixedNumberCount,
      fixedNumberCount: fixedNumberCount ?? this.fixedNumberCount,
      minNumberCount: minNumberCount ?? this.minNumberCount,
      maxNumberCount: maxNumberCount ?? this.maxNumberCount,
      minInterval: minInterval ?? this.minInterval,
      maxInterval: maxInterval ?? this.maxInterval,
      name: name ?? this.name,
      numberOfRounds: numberOfRounds ?? this.numberOfRounds,
    );
  }
} 