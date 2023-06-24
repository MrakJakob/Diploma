class DangerRule {
  // @PrimaryKey(autoGenerate = true)
  final int dangerId;
  final int ruleId;
  final bool? checkElevation;
  final int? dayDelay;
  final bool? am;
  final int? value;

  DangerRule({
    required this.dangerId,
    required this.ruleId,
    required this.checkElevation,
    required this.dayDelay,
    required this.am,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'dangerId': dangerId,
      'ruleId': ruleId,
      'checkElevation': checkElevation,
      'dayDelay': dayDelay,
      'am': am,
      'value': value,
    };
  }

  factory DangerRule.fromJson(Map<String, dynamic> json) {
    return DangerRule(
      dangerId: json['dangerId'],
      ruleId: json['ruleId'],
      checkElevation: json['checkElevation'],
      dayDelay: json['dayDelay'],
      am: json['am'],
      value: json['value'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS danger_rule (
      dangerId INTEGER PRIMARY KEY AUTOINCREMENT,
      ruleId INTEGER NOT NULL,
      checkElevation INTEGER,
      dayDelay INTEGER,
      am INTEGER,
      value INTEGER,
      FOREIGN KEY (ruleId) REFERENCES rule (ruleId)
    )''';
  }
}
