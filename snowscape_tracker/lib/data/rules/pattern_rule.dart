class PatternRule {
  // @PrimaryKey(autoGenerate = true)
  final int patternId;
  final int ruleId;
  final int? dayDelay;
  final int? hourMax;
  final int? hourMin;
  final int? patternType;

  PatternRule({
    required this.patternId,
    required this.ruleId,
    required this.dayDelay,
    required this.hourMax,
    required this.hourMin,
    required this.patternType,
  });

  Map<String, dynamic> toMap() {
    return {
      'patternId': patternId,
      'ruleId': ruleId,
      'dayDelay': dayDelay,
      'hourMax': hourMax,
      'hourMin': hourMin,
      'patternType': patternType,
    };
  }

  factory PatternRule.fromJson(Map<String, dynamic> json) {
    return PatternRule(
      patternId: json['patternId'],
      ruleId: json['ruleId'],
      dayDelay: json['dayDelay'],
      hourMax: json['hourMax'],
      hourMin: json['hourMin'],
      patternType: json['patternType'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS pattern_rule (
      patternId INTEGER PRIMARY KEY AUTOINCREMENT,
      ruleId INTEGER NOT NULL,
      dayDelay INTEGER,
      hourMax INTEGER,
      hourMin INTEGER,
      patternType INTEGER,
      FOREIGN KEY (ruleId) REFERENCES rule (ruleId)
    )''';
  }
}
