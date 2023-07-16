class MatchedRule {
  // @PrimaryKey(autoGenerate = true)
  String id;
  String? plannedTourId;
  int ruleId;
  DateTime date;
  bool read;
  String name;
  String text;
  bool hiking;
  int areaId;
  double latitude;
  double longitude;
  double distanceFromStart;
  String symbolId = "";
  int? validEnd; // validEnd in milisecondsSinceEpoch

  MatchedRule({
    required this.id,
    this.plannedTourId,
    required this.ruleId,
    required this.date,
    required this.read,
    required this.name,
    required this.text,
    required this.hiking,
    required this.areaId,
    required this.latitude,
    required this.longitude,
    required this.distanceFromStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plannedTourId': plannedTourId,
      'ruleId': ruleId,
      'date': date.millisecondsSinceEpoch,
      'read': read,
      'name': name,
      'text': text,
      'hiking': hiking,
      'areaId': areaId,
      'latitude': latitude,
      'longitude': longitude,
      'distanceFromStart': distanceFromStart,
      'symbol': symbolId,
      'validEnd': validEnd,
    };
  }

  MatchedRule.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        plannedTourId = map['plannedTourId'],
        ruleId = map['ruleId'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']),
        read = map['read'] == 1,
        name = map['name'],
        text = map['text'],
        hiking = map['hiking'] == 1,
        areaId = map['areaId'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        distanceFromStart = map['distanceFromStart'],
        symbolId = map['symbol'],
        validEnd = map['validEnd'];

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS matched_rules (
      id TEXT PRIMARY KEY,
      plannedTourId TEXT,
      ruleId INTEGER,
      date INTEGER,
      read INTEGER,
      name TEXT,
      text TEXT,
      hiking INTEGER,
      areaId INTEGER,
      latitude REAL,
      longitude REAL,
      distanceFromStart REAL,
      symbol TEXT,
      validEnd INTEGER,
      FOREIGN KEY (plannedTourId) REFERENCES planned_tours(id) ON DELETE CASCADE
    )''';
  }
}
