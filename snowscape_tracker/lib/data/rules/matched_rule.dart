class MatchedRule {
  // @PrimaryKey(autoGenerate = true)
  final int matchedRuleId;
  final int ruleId;
  final DateTime date;
  final bool read;
  final String name;
  final String text;
  final bool hiking;
  final int areaId;
  final double latitude;
  final double longitude;

  MatchedRule({
    required this.matchedRuleId,
    required this.ruleId,
    required this.date,
    required this.read,
    required this.name,
    required this.text,
    required this.hiking,
    required this.areaId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'matchedRuleId': matchedRuleId,
      'ruleId': ruleId,
      'date': date.toIso8601String(),
      'read': read,
      'name': name,
      'text': text,
      'hiking': hiking,
      'areaId': areaId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS matched_rule (
      matchedRuleId INTEGER PRIMARY KEY AUTOINCREMENT,
      ruleId INTEGER,
      date TEXT,
      read INTEGER,
      name TEXT,
      text TEXT,
      hiking INTEGER,
      areaId INTEGER,
      latitude REAL,
      longitude REAL
    )''';
  }
}
