class PlannedTourDb {
  String? id;
  String userId;
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
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'tourName': tourName,
      'distance': distance,
      'totalElevationGain': totalElevationGain,
      'duration': duration,
      'plannedTourTime': plannedTourTime.millisecondsSinceEpoch,
    };
  }

  PlannedTourDb.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['userId'],
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
        userId TEXT,
        tourName TEXT,
        distance REAL,
        totalElevationGain REAL,
        duration REAL,
        plannedTourTime INTEGER
      )
    ''';
  }
}
