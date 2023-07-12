class PlannedTourDb {
  String? id;
  String tourName;
  double distance;
  double totalElevationGain;
  double duration;
  DateTime plannedTourTime;

  PlannedTourDb({
    this.id,
    required this.tourName,
    required this.distance,
    required this.totalElevationGain,
    required this.duration,
    required this.plannedTourTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tourName': tourName,
      'distance': distance,
      'totalElevationGain': totalElevationGain,
      'duration': duration,
      'plannedTourTime': plannedTourTime.millisecondsSinceEpoch,
    };
  }

  PlannedTourDb.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        tourName = map['tourName'],
        distance = map['distance'],
        totalElevationGain = map['totalElevationGain'],
        duration = map['duration'],
        plannedTourTime =
            DateTime.fromMillisecondsSinceEpoch(map['plannedTourTime']);

  static createTable() {
    return '''
      CREATE TABLE planned_tours (
        id TEXT PRIMARY KEY,
        tourName TEXT,
        distance REAL,
        totalElevationGain REAL,
        duration REAL,
        plannedTourTime INTEGER
      )
    ''';
  }
}
