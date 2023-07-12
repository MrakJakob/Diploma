class WeatherDescription {
  // @PrimaryKey(autoGenerate = true)
  final String weatherDescriptionId;
  final int ruleId;
  final int dayDelay;
  final int? tempAvgMin;
  final int? tempAvgMax;
  final int? hourMin;
  final int? hourMax;
  // TODO: translate these
  final String? oblacnost;
  final String? vremenskiPojav;
  final String? intenzivnost;
  final String? elevation;

  WeatherDescription({
    required this.weatherDescriptionId,
    required this.ruleId,
    required this.dayDelay,
    required this.tempAvgMin,
    required this.tempAvgMax,
    required this.hourMin,
    required this.hourMax,
    required this.oblacnost,
    required this.vremenskiPojav,
    required this.intenzivnost,
    required this.elevation,
  });

  Map<String, dynamic> toMap() {
    return {
      'weatherDescriptionId': weatherDescriptionId,
      'ruleId': ruleId,
      'dayDelay': dayDelay,
      'tempAvgMin': tempAvgMin,
      'tempAvgMax': tempAvgMax,
      'hourMin': hourMin,
      'hourMax': hourMax,
      'oblacnost': oblacnost,
      'vremenskiPojav': vremenskiPojav,
      'intenzivnost': intenzivnost,
      'elevation': elevation,
    };
  }

  factory WeatherDescription.fromJson(Map<String, dynamic> json) {
    return WeatherDescription(
      weatherDescriptionId: json['weatherDescriptionId'],
      ruleId: json['ruleId'],
      dayDelay: json['dayDelay'],
      tempAvgMin: json['tempAvgMin'],
      tempAvgMax: json['tempAvgMax'],
      hourMin: json['hourMin'],
      hourMax: json['hourMax'],
      oblacnost: json['oblacnost'],
      vremenskiPojav: json['vremenskiPojav'],
      intenzivnost: json['intenzivnost'],
      elevation: json['elevation'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS weather_description_rule (
      weatherDescriptionId TEXT PRIMARY KEY,
      ruleId INTEGER NOT NULL,
      dayDelay INTEGER NOT NULL,
      tempAvgMin INTEGER,
      tempAvgMax INTEGER,
      hourMin INTEGER,
      hourMax INTEGER,
      oblacnost TEXT,
      vremenskiPojav TEXT,
      intenzivnost TEXT,
      elevation TEXT,
      FOREIGN KEY (ruleId) REFERENCES rule (ruleId)
    )''';
  }
}
