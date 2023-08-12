class Rule {
  int ruleId;
  final String? aspect;
  final double? minSlope;
  final double? maxSlope;
  final int? elevationMin;
  final int? elevationMax;
  final int? hourMin;
  final int? hourMax;
  final bool? userHiking;
  final int? avAreaId;
  final String? notificationName;
  final String? notificationText;

  Rule({
    required this.ruleId,
    required this.aspect,
    required this.minSlope,
    required this.maxSlope,
    required this.elevationMin,
    required this.elevationMax,
    required this.hourMin,
    required this.hourMax,
    required this.userHiking,
    required this.avAreaId,
    required this.notificationName,
    required this.notificationText,
  });

  Map<String, dynamic> toMap() {
    return {
      'ruleId': ruleId,
      'aspect': aspect,
      'minSlope': minSlope,
      'maxSlope': maxSlope,
      'elevationMin': elevationMin,
      'elevationMax': elevationMax,
      'hourMin': hourMin,
      'hourMax': hourMax,
      'userHiking': userHiking,
      'avAreaId': avAreaId,
      'notificationName': notificationName,
      'notificationText': notificationText,
    };
  }

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      ruleId: json['ruleId'],
      aspect: json['aspect'],
      minSlope: json['minSlope'],
      maxSlope: json['maxSlope'],
      elevationMin: json['elevationMin'],
      elevationMax: json['elevationMax'],
      hourMin: json['hourMin'],
      hourMax: json['hourMax'],
      userHiking: json['userHiking'] == 1 ? true : false,
      avAreaId: json['avAreaId'],
      notificationName: json['notificationName'],
      notificationText: json['notificationText'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS rule (
      ruleId INTEGER PRIMARY KEY,
      aspect TEXT,
      minSlope REAL,
      maxSlope REAL,
      elevationMin INTEGER,
      elevationMax INTEGER,
      hourMin INTEGER,
      hourMax INTEGER,
      userHiking INTEGER,
      avAreaId INTEGER,
      notificationName TEXT,
      notificationText TEXT
    )''';
  }
}
