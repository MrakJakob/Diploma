class PatternBulletin {
  String pattId;
  int avBulletinId;
  int pattern;
  int avAreaId;
  int validEnd;
  int validStart;

  PatternBulletin({
    required this.pattId,
    required this.avBulletinId,
    required this.pattern,
    required this.avAreaId,
    required this.validEnd,
    required this.validStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'pattId': pattId,
      'avBulletinId': avBulletinId,
      'pattern': pattern,
      'avAreaId': avAreaId,
      'validEnd': validEnd,
      'validStart': validStart,
    };
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS pattern_bulletin (
      pattId TEXT PRIMARY KEY,
      avBulletinId INTEGER NOT NULL,
      pattern INTEGER NOT NULL,
      avAreaId INTEGER NOT NULL,
      validEnd TEXT NOT NULL,
      validStart TEXT NOT NULL,
      FOREIGN KEY (avBulletinId) REFERENCES avalanche_bulletin (avBulletinId),
      FOREIGN KEY (avAreaId) REFERENCES av_area (avAreaId)
    )''';
  } // TODO: check if foreign key is needed
}
