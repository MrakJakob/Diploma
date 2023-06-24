class BulletinText {
  String dangerDescription;
  int sLanguageId;
  String snowConditions;
  String snowConditionsTendency;
  String weatherEvolution;

  BulletinText({
    required this.dangerDescription,
    required this.sLanguageId,
    required this.snowConditions,
    required this.snowConditionsTendency,
    required this.weatherEvolution,
  });

  Map<String, dynamic> toMap() {
    return {
      'dangerDescription': dangerDescription,
      'sLanguageId': sLanguageId,
      'snowConditions': snowConditions,
      'snowConditionsTendency': snowConditionsTendency,
      'weatherEvolution': weatherEvolution,
    };
  }

  factory BulletinText.fromJson(Map<String, dynamic> json) {
    return BulletinText(
      dangerDescription: json['danger_description'],
      sLanguageId: json['s_language_id'],
      snowConditions: json['snow_conditions'],
      snowConditionsTendency: json['snow_conditions_tendency'],
      weatherEvolution: json['weather_evolution'],
    );
  }
}
