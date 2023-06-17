import 'package:snowscape_tracker/data/rules/jsonObjects/danger_json.dart';
import 'package:snowscape_tracker/data/rules/jsonObjects/pattern_json.dart';
import 'package:snowscape_tracker/data/rules/jsonObjects/problem_json.dart';
import 'package:snowscape_tracker/data/rules/jsonObjects/weather_description_json.dart';

class RuleFromJson {
  final int? avAreaId;
  final String? aspect;
  final double? minSlope;
  final double? maxSlope;
  final int? elevationMin;
  final int? elevationMax;
  final int? hourMin;
  final int? hourMax;
  final bool? userHiking;
  final String? notificationName;
  final String? notificationText;
  final List<WeatherDescriptionFromJson?>? weatherDescriptions;
  final List<PatternFromJson?>? patterns;
  final List<ProblemFromJson?>? problems;
  final List<DangerFromJson?>? dangers;

  RuleFromJson({
    this.avAreaId,
    this.aspect,
    this.minSlope,
    this.maxSlope,
    this.elevationMin,
    this.elevationMax,
    this.hourMin,
    this.hourMax,
    this.userHiking,
    this.notificationName,
    this.notificationText,
    this.weatherDescriptions,
    this.patterns,
    this.problems,
    this.dangers,
  });

  factory RuleFromJson.fromJson(Map<String, dynamic> json) {
    return RuleFromJson(
      avAreaId: json['avAreaId'],
      aspect: json['aspect'],
      minSlope: json['min_slope'],
      maxSlope: json['max_slope'],
      elevationMin: json['elevation_min'],
      elevationMax: json['elevation_max'],
      hourMin: json['hour_min'],
      hourMax: json['hour_max'],
      userHiking: json['user_hiking'],
      notificationName: json['notification_name'],
      notificationText: json['notification_text'],
      weatherDescriptions: json['weather_descriptions'] != null
          ? (json['weather_descriptions'] as List)
              .map((i) => WeatherDescriptionFromJson.fromJson(i))
              .toList()
          : null,
      patterns: json['patterns'] != null
          ? (json['patterns'] as List)
              .map((i) => PatternFromJson.fromJson(i))
              .toList()
          : null,
      problems: json['problems'] != null
          ? (json['problems'] as List)
              .map((i) => ProblemFromJson.fromJson(i))
              .toList()
          : null,
      dangers: json['dangers'] != null
          ? (json['dangers'] as List)
              .map((i) => DangerFromJson.fromJson(i))
              .toList()
          : null,
    );
  }
}
