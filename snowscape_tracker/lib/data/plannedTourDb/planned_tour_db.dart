class PlannedTourDb {
  String? id;
  String tourName;
  double distance;
  int totalElevationGain;
  double duration;

  PlannedTourDb({
    this.id,
    required this.tourName,
    required this.distance,
    required this.totalElevationGain,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tourName': tourName,
      'distance': distance,
      'totalElevationGain': totalElevationGain,
      'duration': duration,
    };
  }

  PlannedTourDb.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        tourName = map['tourName'],
        distance = map['distance'],
        totalElevationGain = map['totalElevationGain'],
        duration = map['duration'];

  static createTable() {
    return '''
      CREATE TABLE planned_tours (
        id TEXT PRIMARY KEY,
        tourName TEXT,
        distance REAL,
        totalElevationGain INTEGER,
        duration REAL
      )
    ''';
  }
}
