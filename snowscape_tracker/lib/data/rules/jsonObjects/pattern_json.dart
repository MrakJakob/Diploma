class PatternFromJson {
  final int? dayDelay;
  final int? hourMax;
  final int? hourMin;
  final int? patternId;

  PatternFromJson({
    this.dayDelay,
    this.hourMax,
    this.hourMin,
    this.patternId,
  });

  Map<String, dynamic> toMap() {
    return {
      'dayDelay': dayDelay,
      'hourMax': hourMax,
      'hourMin': hourMin,
      'patternId': patternId,
    };
  }

  factory PatternFromJson.fromJson(Map<String, dynamic> json) {
    return PatternFromJson(
      dayDelay: json['day_delay'],
      hourMax: json['hour_max'],
      hourMin: json['hour_min'],
      patternId: json['pattern_id'],
    );
  }
}
