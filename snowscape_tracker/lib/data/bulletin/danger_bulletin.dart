class DangerBulletin {
  int dangId;
  int avBulletinId;
  String aspects;
  int avAreaId;
  int elevationFrom;
  int elevationTo;
  bool treeline;
  bool treelineAbove;
  int validEnd;
  int validStart;
  int value;

  DangerBulletin({
    required this.dangId,
    required this.avBulletinId,
    required this.aspects,
    required this.avAreaId,
    required this.elevationFrom,
    required this.elevationTo,
    required this.treeline,
    required this.treelineAbove,
    required this.validEnd,
    required this.validStart,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'dangId': dangId,
      'avBulletinId': avBulletinId,
      'aspects': aspects,
      'avAreaId': avAreaId,
      'elevationFrom': elevationFrom,
      'elevationTo': elevationTo,
      'treeline': treeline,
      'treelineAbove': treelineAbove,
      'validEnd': validEnd,
      'validStart': validStart,
      'value': value,
    };
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS danger_bulletin (
      dangId INTEGER PRIMARY KEY AUTOINCREMENT,
      avBulletinId INTEGER NOT NULL,
      aspects TEXT,
      avAreaId INTEGER NOT NULL,
      elevationFrom INTEGER NOT NULL,
      elevationTo INTEGER NOT NULL,
      treeline INTEGER NOT NULL,
      treelineAbove INTEGER NOT NULL,
      validEnd TEXT NOT NULL,
      validStart TEXT NOT NULL,
      value INTEGER NOT NULL,
      FOREIGN KEY (avBulletinId) REFERENCES avalanche_bulletin (avBulletinId),
      FOREIGN KEY (avAreaId) REFERENCES av_area (avAreaId)
    )''';
  }
}
