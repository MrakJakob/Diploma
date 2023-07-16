import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snowscape_tracker/data/bulletin/avalanche_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/danger_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/jsonObjects/bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/pattern_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/problem_bulletin.dart';
import 'package:snowscape_tracker/data/weather/weather_hour.dart';
import 'package:snowscape_tracker/helpers/weather_xml_parser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ArsoWeatherService {
  final dio = Dio();
  var uuid = const Uuid();

  Future<bool> getWeatherForecast(Database db) async {
    String url =
        "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/forecast_si-upperAir-new_latest.xml";

    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200 && response.data != null) {
        debugPrint("Response: ${response.data}");
        List<WeatherHour> weatherHours =
            await weatherXmlParser(response.data, db);

        // add to database
        weatherHours.forEach((weatherHour) async {
          var id = await db.insert(
            'weather_hour',
            weatherHour.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          debugPrint("Weather hour id: $id");
        });
        return true;
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return false;
    }
    return false;
  }

  Future<bool?> getAvalancheBulletin(Database db) async {
    String url = "https://vreme.arso.gov.si/api/1.0/avalanche_bulletin/";

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          "format": "json",
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        debugPrint("Response: ${response.data}");
        Bulletin bulletin = Bulletin.fromJson(response.data);
        debugPrint("Bulletin: ${bulletin}");

        AvalancheBulletin avalancheBulletin = AvalancheBulletin(
          avBulletinId: bulletin.avBulletinId,
          dangerDescription: bulletin.texts[0].dangerDescription,
          snowConditionsTendency: bulletin.texts[0].snowConditionsTendency,
          weatherEvolution: bulletin.texts[0].weatherEvolution,
          snowConditions: bulletin.texts[0].snowConditions,
        );

        // add to database
        var avId = await db.insert(
          'avalanche_bulletin',
          avalancheBulletin.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        if (avId != -1) {
          bulletin.dangers.forEach((danger) async {
            DangerBulletin dangerObj = DangerBulletin(
              dangId: uuid.v4(),
              avBulletinId: avId,
              aspects: danger.aspects,
              avAreaId: danger.avAreaId,
              elevationFrom: danger.elevationFrom,
              elevationTo: danger.elevationTo,
              treeline: danger.treeline,
              treelineAbove: danger.treelineAbove,
              validEnd: DateTime.parse(danger.validEnd)
                  .millisecondsSinceEpoch, // we need to convert to milliseconds since epoch because sqlite doesn't support datetime
              validStart:
                  DateTime.parse(danger.validStart).millisecondsSinceEpoch,
              value: danger.value,
            );
            await db.insert(
              'danger_bulletin',
              dangerObj.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          });

          bulletin.patterns.forEach((pattern) async {
            PatternBulletin patternObj = PatternBulletin(
              pattId: uuid.v4(),
              avBulletinId: avId,
              pattern: pattern.pattern,
              avAreaId: pattern.avAreaId,
              validEnd: DateTime.parse(pattern.validEnd).millisecondsSinceEpoch,
              validStart:
                  DateTime.parse(pattern.validStart).millisecondsSinceEpoch,
            );
            await db.insert(
              'pattern_bulletin',
              patternObj.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          });

          bulletin.problems.forEach((problem) async {
            ProblemBulletin problemObj = ProblemBulletin(
              probId: uuid.v4(),
              avBulletinId: avId,
              problem: problem.problemId,
              avAreaId: problem.avAreaId,
              elevationFrom: problem.elevationFrom,
              elevationTo: problem.elevationTo,
              validEnd: DateTime.parse(problem.validEnd).millisecondsSinceEpoch,
              validStart:
                  DateTime.parse(problem.validStart).millisecondsSinceEpoch,
            );
            await db.insert(
              'problem_bulletin',
              problemObj.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          });
        }
        return true;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
    return null;
  }
}
