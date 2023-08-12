class AvalancheBulletin {
  int avBulletinId;
  String dangerDescription;
  String snowConditionsTendency;
  String weatherEvolution;
  String snowConditions;

  AvalancheBulletin({
    required this.avBulletinId,
    required this.dangerDescription,
    required this.snowConditionsTendency,
    required this.weatherEvolution,
    required this.snowConditions,
  });

  Map<String, dynamic> toMap() {
    return {
      'avBulletinId': avBulletinId,
      'dangerDescription': dangerDescription,
      'snowConditionsTendency': snowConditionsTendency,
      'weatherEvolution': weatherEvolution,
      'snowConditions': snowConditions,
    };
  }

  factory AvalancheBulletin.fromJson(Map<String, dynamic> json) {
    return AvalancheBulletin(
      avBulletinId: json['avBulletinId'],
      dangerDescription: json['dangerDescription'],
      snowConditionsTendency: json['snowConditionsTendency'],
      weatherEvolution: json['weatherEvolution'],
      snowConditions: json['snowConditions'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS avalanche_bulletin (
      avBulletinId INTEGER PRIMARY KEY,
      dangerDescription TEXT,
      snowConditionsTendency TEXT,
      weatherEvolution TEXT,
      snowConditions TEXT
    )''';
  }
}
