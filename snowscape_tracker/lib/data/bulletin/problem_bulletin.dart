class ProblemBulletin {
  int probId;
  int avBulletinId;
  int problem;
  int avAreaId;
  int elevationFrom;
  int elevationTo;
  int validEnd;
  int validStart;

  ProblemBulletin({
    required this.probId,
    required this.avBulletinId,
    required this.problem,
    required this.avAreaId,
    required this.elevationFrom,
    required this.elevationTo,
    required this.validEnd,
    required this.validStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'probId': probId,
      'avBulletinId': avBulletinId,
      'problem': problem,
      'avAreaId': avAreaId,
      'elevationFrom': elevationFrom,
      'elevationTo': elevationTo,
      'validEnd': validEnd,
      'validStart': validStart,
    };
  }

  factory ProblemBulletin.fromJson(Map<String, dynamic> json) {
    return ProblemBulletin(
      probId: json['probId'],
      avBulletinId: json['avBulletinId'],
      problem: json['problem'],
      avAreaId: json['avAreaId'],
      elevationFrom: json['elevationFrom'].round(),
      elevationTo: json['elevationTo'].round(),
      validEnd: json['validEnd'],
      validStart: json['validStart'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS problem_bulletin (
      probId INTEGER PRIMARY KEY AUTOINCREMENT,
      avBulletinId INTEGER NOT NULL,
      problem INTEGER NOT NULL,
      avAreaId INTEGER NOT NULL,
      elevationFrom REAL NOT NULL,
      elevationTo REAL NOT NULL,
      validEnd INTEGER NOT NULL,
      validStart INTEGER NOT NULL,
      FOREIGN KEY (avBulletinId) REFERENCES avalanche_bulletin (avBulletinId),
      FOREIGN KEY (avAreaId) REFERENCES av_area (avAreaId)
    )''';
  } // TODO: check if foreign key is needed
}
