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
  bool isDarkMode;

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
    this.isDarkMode = false,
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
    bool? isDarkMode,
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
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  static TrainingSettings getDefault() {
    return TrainingSettings(
      roundLength: const Duration(minutes: 3),
      breakLength: const Duration(minutes: 1),
      countdownLength: const Duration(seconds: 10),
      selectedNumbers: const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      isFixedNumberCount: true,
      fixedNumberCount: 1,
      minNumberCount: 1,
      maxNumberCount: 4,
      minInterval: const Duration(seconds: 3),
      maxInterval: const Duration(seconds: 10),
      name: 'Default',
      numberOfRounds: 3,
      isDarkMode: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'roundLength': roundLength.inSeconds,
    'breakLength': breakLength.inSeconds,
    'countdownLength': countdownLength.inSeconds,
    'selectedNumbers': selectedNumbers,
    'isFixedNumberCount': isFixedNumberCount,
    'fixedNumberCount': fixedNumberCount,
    'minNumberCount': minNumberCount,
    'maxNumberCount': maxNumberCount,
    'minInterval': minInterval.inSeconds,
    'maxInterval': maxInterval.inSeconds,
    'name': name,
    'numberOfRounds': numberOfRounds,
    'isDarkMode': isDarkMode,
  };

  factory TrainingSettings.fromJson(Map<String, dynamic> json) {
    return TrainingSettings(
      roundLength: Duration(seconds: json['roundLength'] ?? 0),
      breakLength: Duration(seconds: json['breakLength'] ?? 0),
      countdownLength: Duration(seconds: json['countdownLength'] ?? 0),
      selectedNumbers: json['selectedNumbers'] ?? [],
      isFixedNumberCount: json['isFixedNumberCount'] ?? true,
      fixedNumberCount: json['fixedNumberCount'] ?? 1,
      minNumberCount: json['minNumberCount'] ?? 1,
      maxNumberCount: json['maxNumberCount'] ?? 4,
      minInterval: Duration(seconds: json['minInterval'] ?? 0),
      maxInterval: Duration(seconds: json['maxInterval'] ?? 0),
      name: json['name'] ?? 'Default',
      numberOfRounds: json['numberOfRounds'] ?? 3,
      isDarkMode: json['isDarkMode'] ?? false,
    );
  }
} 