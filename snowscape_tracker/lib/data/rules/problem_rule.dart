class ProblemRule {
  // @PrimaryKey(autoGenerate = true)
  final int problemId;
  final int ruleId;
  final bool? checkElevation;
  final int? dayDelay;
  final int? hourMax;
  final int? hourMin;
  final int? problemType;

  ProblemRule({
    required this.problemId,
    required this.ruleId,
    required this.checkElevation,
    required this.dayDelay,
    required this.hourMax,
    required this.hourMin,
    required this.problemType,
  });

  Map<String, dynamic> toMap() {
    return {
      'problemId': problemId,
      'ruleId': ruleId,
      'checkElevation': checkElevation,
      'dayDelay': dayDelay,
      'hourMax': hourMax,
      'hourMin': hourMin,
      'problemType': problemType,
    };
  }

  factory ProblemRule.fromJson(Map<String, dynamic> json) {
    return ProblemRule(
      problemId: json['problemId'],
      ruleId: json['ruleId'],
      checkElevation: json['checkElevation'] == 1 ? true : false,
      dayDelay: json['dayDelay'],
      hourMax: json['hourMax'],
      hourMin: json['hourMin'],
      problemType: json['problemType'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS problem_rule (
      problemId INTEGER PRIMARY KEY AUTOINCREMENT,
      ruleId INTEGER NOT NULL,
      checkElevation INTEGER,
      dayDelay INTEGER,
      hourMax INTEGER,
      hourMin INTEGER,
      problemType INTEGER,
      FOREIGN KEY (ruleId) REFERENCES rule (ruleId)
    )''';
  }
}
