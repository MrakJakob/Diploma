import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path/path.dart';
import 'package:snowscape_tracker/data/areas/area.dart';
import 'package:snowscape_tracker/data/areas/areas.dart';
import 'package:snowscape_tracker/data/bulletin/avalanche_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/problem_bulletin.dart';
import 'package:snowscape_tracker/data/rules/danger_rule.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import 'package:snowscape_tracker/data/rules/pattern_rule.dart';
import 'package:snowscape_tracker/data/rules/problem_rule.dart';
import 'package:snowscape_tracker/data/rules/rule.dart';
import 'package:snowscape_tracker/data/rules/rule_with_lists.dart';
import 'package:snowscape_tracker/data/rules/weather_description.dart';
import 'package:snowscape_tracker/data/weather/weather_hour.dart';
import 'package:snowscape_tracker/helpers/geo_properties_calculator.dart';
import 'package:snowscape_tracker/services/arcGIS_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

var areaId = -1;

Future<bool> isInsideArea(LatLng point) async {
  final String response = await rootBundle.loadString('assets/areas.json');

  if (response.contains('error')) {
    throw Exception('Failed to load rules');
  }

  final data = await json.decode(response);

  Areas areas = Areas.fromJson(data);

  bool isInside = false;

  for (Area area in areas.areas!) {
    List<mp.LatLng> polygon = [];

    for (List<String> pointJs in area.geometry) {
      polygon
          .add(mp.LatLng(double.parse(pointJs[1]), double.parse(pointJs[0])));
    }

    if (mp.PolygonUtil.containsLocation(
            mp.LatLng(point.latitude, point.longitude), polygon, false) &&
        area.avAreaId != 5) {
      isInside = true;
      areaId = area.avAreaId;
      break;
    }
  }
  return isInside;
}

Future<List<ContextPoint>> getApproximateRoute(List<ContextPoint> route) async {
  List<ContextPoint> approximateRoute = [];
  var previousPoint;

  for (ContextPoint point in route) {
    bool insideArea = await isInsideArea(point.point);
    if (point == route.first || !insideArea) {
      // we skip the first point because it doesn't have slope and aspect with current implementation TODO: check in future
      // or if the point is not inside one of the supported areas we skip it
      continue;
    } else if (approximateRoute.isEmpty) {
      previousPoint = point;
      approximateRoute.add(point);
    } else {
      var lastPoint = approximateRoute.last;
      var distance = GeoPropertiesCalculator()
              .calculateDistanceHaversine(lastPoint.point, point.point) *
          1000; // distance in meters

      // we check if the distance between two points is more than 250 meters and less than 350 meters
      if (distance > 250 && distance < 350) {
        // if it is we add the point to the approximate route
        approximateRoute.add(point);
      } else if (distance > 350) {
        // if the distance is more than 100 meters we add the previous point to the approximate route if that point is not already in the approximate route
        if (previousPoint != lastPoint) {
          approximateRoute.add(previousPoint);
        } else {
          // if the previous point is already in the approximate route we add the point to the approximate route even if the distance is more than 350 meters
          approximateRoute.add(point);
        }
      } else {
        // if the distance is less than 250 meters we skip the point
      }
    }
    previousPoint = point;
  }

  return approximateRoute;
}

Future<List<RuleWithLists>> rules(Database db) async {
  // Get a reference to the database.

  // We get the rules from the database
  List<Map<String, dynamic>> rules =
      (await db.query('rules', where: 'userHiking'));

  // Weather descriptions
  List<Map<String, dynamic>> dbWeatherDescriptions =
      (await db.query('weather_description_rule'));

  List<WeatherDescription> weatherDescriptions =
      List.generate(dbWeatherDescriptions.length, (i) {
    return WeatherDescription.fromJson(dbWeatherDescriptions[i]);
  });

  // Pattern rules
  List<Map<String, dynamic>> dbPatternRules = (await db.query('pattern_rule'));

  List<PatternRule> patternRules = List.generate(dbPatternRules.length, (i) {
    return PatternRule.fromJson(dbPatternRules[i]);
  });

  // Problem rules
  List<Map<String, dynamic>> dbProblemRules = (await db.query('problem_rule'));

  List<ProblemRule> problemRules = List.generate(dbProblemRules.length, (i) {
    return ProblemRule.fromJson(dbProblemRules[i]);
  });

  // Danger rules
  List<Map<String, dynamic>> dbDangerRules = (await db.query('danger_rule'));

  List<DangerRule> dangerRules = List.generate(dbDangerRules.length, (i) {
    return DangerRule.fromJson(dbDangerRules[i]);
  });

  // Convert the List<Map<String, dynamic> into a List<RuleWithLists>.
  return List.generate(rules.length, (i) {
    // here we probably have to filter weather descriptions, pattern rules, problem rules and danger rules by rule id
    return RuleWithLists(
        rule: Rule.fromJson(rules[i]),
        weatherDescriptions: weatherDescriptions.where((element) {
          return element.ruleId == rules[i]['ruleId'];
        }).toList(),
        patternRules: patternRules,
        problemRules: problemRules
            .where((element) => element.ruleId == rules[i]['ruleId'])
            .toList(),
        dangerRules: dangerRules);
  });
}

Future<List<MatchedRule>> matchRules(
    List<ContextPoint> path, String text) async {
  List<MatchedRule> matchedRules = [];

  if (path.length < 2) {
    return matchedRules;
  }

  final database = await openDatabase(
    join(await getDatabasesPath(), 'rules_database.db'),
    version: 1,
  );

  // We get an approximate route from the path, so that we don't have to check every point in the path
  List<ContextPoint> approximateRoute = await getApproximateRoute(path);
  if (approximateRoute.isEmpty) {
    return matchedRules;
  }

  List<RuleWithLists> rulesList = await rules(database);

  debugPrint('rules: $rulesList');

  //

  for (int i = 0; i < approximateRoute.length; i++) {
    for (RuleWithLists rule in rulesList) {
      bool isMatched = true;

      String? aspect = rule.rule.aspect;

      if (aspect != null) {
        switch (aspect) {
          case 'N':
            if (approximateRoute[i].aspect >= 0 &&
                    approximateRoute[i].aspect <= 90 ||
                approximateRoute[i].aspect >= 270 &&
                    approximateRoute[i].aspect <= 360) {
            } else {
              isMatched = false;
            }
            break;
          case 'S':
            if (approximateRoute[i].aspect >= 90 &&
                approximateRoute[i].aspect <= 270) {
            } else {
              isMatched = false;
            }
            break;
          case 'W':
            if (approximateRoute[i].aspect >= 180 &&
                approximateRoute[i].aspect <= 360) {
            } else {
              isMatched = false;
            }
            break;
          case 'E':
            if (approximateRoute[i].aspect >= 0 &&
                approximateRoute[i].aspect <= 180) {
            } else {
              isMatched = false;
            }
            break;
        }
      }

      // We check if the slope of the point is in the range of the rule
      double? minSlope = rule.rule.minSlope;
      if (minSlope != null && approximateRoute[i].slope < minSlope) {
        isMatched = false;
      }

      double? maxSlope = rule.rule.maxSlope;
      if (maxSlope != null && approximateRoute[i].slope > maxSlope) {
        isMatched = false;
      }

      // We check if the elevation of the point is in the range of the rule
      int? elevationMin = rule.rule.elevationMin;
      if (elevationMin != null &&
          approximateRoute[i].elevation < elevationMin) {
        isMatched = false;
      }

      int? elevationMax = rule.rule.elevationMax;
      if (elevationMax != null &&
          approximateRoute[i].elevation > elevationMax) {
        isMatched = false;
      }

      // Check the weather rules
      for (WeatherDescription weatherDescription in rule.weatherDescriptions) {
        DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        var time = DateTime.now();
        // DateTime date1 = DateTime(
        //     time.year,
        //     time.month,
        //     time.day + weatherDescription.dayDelay,
        //     weatherDescription.hourMin ?? 0,
        //     0,
        //     0,
        //     0,
        //     0);

        // DateTime date2 = DateTime(
        //     time.year,
        //     time.month,
        //     time.day + weatherDescription.dayDelay,
        //     weatherDescription.hourMax ?? 0,
        //     0,
        //     0,
        //     0,
        //     0);
        DateTime date1 =
            DateTime(2023, 6, 16, weatherDescription.hourMin ?? 0, 0, 0, 0, 0);

        DateTime date2 =
            DateTime(2023, 6, 16, weatherDescription.hourMax ?? 0, 0, 0, 0, 0);

        List<WeatherHour> weatherHours = await weatherHoursForAvalancheArea(
            areaId,
            database,
            date1.millisecondsSinceEpoch,
            date2.millisecondsSinceEpoch);
        debugPrint('weatherHours: $weatherHours');

        if (weatherHours.isEmpty) {
          isMatched = false;
        }

        bool weatherOccurance = false;
        bool cloudOccurance = false;
        double temperature = 0;
        for (WeatherHour weatherHour in weatherHours) {
          switch (weatherDescription.elevation) {
            case '1000':
              temperature += weatherHour.t1000;
              break;
            case '1500':
              temperature += weatherHour.t1500;
              break;
            case '2000':
              temperature += weatherHour.t2000;
              break;
            case '2500':
              temperature += weatherHour.t2500;
              break;
            case '3000':
              temperature += weatherHour.t3000;
              break;
          }
          if (weatherDescription.vremenskiPojav != null &&
              weatherDescription.vremenskiPojav == weatherHour.vremenskiPojav) {
            if (weatherDescription.intenzivnost != null &&
                weatherDescription.intenzivnost == weatherHour.intenzivnost) {
              weatherOccurance = true;
            }
          }
          if (weatherDescription.oblacnost != null &&
              weatherDescription.oblacnost == weatherHour.oblacnost) {
            cloudOccurance = true;
          }
        }

        if (weatherDescription.vremenskiPojav != null && !weatherOccurance) {
          isMatched = false;
        }

        if (weatherDescription.oblacnost != null && !cloudOccurance) {
          isMatched = false;
        }

        if (weatherHours.isNotEmpty) {
          temperature = temperature / weatherHours.length;
        }

        if (weatherDescription.tempAvgMin != null &&
            weatherDescription.tempAvgMin != null &&
            temperature <= weatherDescription.tempAvgMin!.toDouble()) {
          isMatched = false;
        }

        if (weatherDescription.tempAvgMax != null &&
            weatherDescription.tempAvgMax != null &&
            temperature >= weatherDescription.tempAvgMax!.toDouble()) {
          isMatched = false;
        }
      }
      // check the avalanche pattern rules
      for (PatternRule patternRule in rule.patternRules) {
        // Not in use yet
        // we currently have no pattern rules in the database
        DateTime date1 =
            DateTime(2023, 6, 16, patternRule.hourMin ?? 0, 0, 0, 0, 0);

        DateTime date2 =
            DateTime(2023, 6, 16, patternRule.hourMax ?? 0, 0, 0, 0, 0);

        // get bulletin from database
        // AvalancheBulletin bulletin = await getAvalancheBulletin(
        //   database,
        // );
        // debugPrint('bulletin: $bulletin');
        // List<Pattern> patternsForAvalancheArea =
        //     await patternsForAvalancheArea(bul, database,
        //         date1.millisecondsSinceEpoch, date2.millisecondsSinceEpoch);
      }

      // check for danger rules
      // we currently have no danger rules in the database

      // check for problem rules
      for (ProblemRule problemRule in rule.problemRules) {
        DateTime date1 =
            DateTime(2023, 6, 16, problemRule.hourMin ?? 0, 0, 0, 0, 0);

        DateTime date2 =
            DateTime(2023, 6, 16, problemRule.hourMax ?? 0, 0, 0, 0, 0);

        AvalancheBulletin? bulletin = await getAvalancheBulletin(
          database,
        );

        if (bulletin != null) {
          List<ProblemBulletin> problemsForAvalancheArea =
              await getProblemsForAvalancheArea(
            bulletin.avBulletinId,
            areaId,
            problemRule.problemType,
            approximateRoute[i],
            database,
          );
          debugPrint('problemsForAvalancheArea: $problemsForAvalancheArea');
          for (ProblemBulletin problemBulletin in problemsForAvalancheArea) {
            debugPrint('problemBulletin: ${problemBulletin}');
          }

          if (problemsForAvalancheArea.isEmpty) {
            isMatched = false;
          } else {
            debugPrint("problemRule.problemType: ${problemRule.problemType}");
          }
        }
      }

      if (isMatched) {
        MatchedRule matchedRule = MatchedRule(
          ruleId: rule.rule.ruleId,
          id: i.toString(),
          date: DateTime.now(),
          read: false,
          name: rule.rule.notificationName ?? '',
          text: rule.rule.notificationText ?? '',
          hiking: true, // change if implementing other functionalities
          areaId: areaId,
          latitude: approximateRoute[i].point.latitude,
          longitude: approximateRoute[i].point.longitude,
        );

        matchedRules.add(matchedRule);
      }
    }
  }

  return matchedRules;
}

Future<List<ProblemBulletin>> getProblemsForAvalancheArea(
  int avBulletionId,
  int areaId,
  int? problemType,
  ContextPoint point,
  Database db,
) async {
  List<ProblemBulletin> problems = [];

  List<Map<String, Object?>> problemsBulletins = await db.query(
    'problem_bulletin',
  );
  // where:
  //     'avBulletinId = ? and avAreaId = ?', // and problem = ? and ? between elevationFrom and elevationTo
  // whereArgs: [avBulletionId, areaId]);

  debugPrint('problemsBulletins: $problemsBulletins');
  problems = problemsBulletins
      .map((problemBulletin) => ProblemBulletin.fromJson(problemBulletin))
      .toList();
  return problems;
}

Future<AvalancheBulletin?> getAvalancheBulletin(Database db) async {
  List<Map<String, Object?>> bulletinMaps = await db.query("avalanche_bulletin",
      orderBy: 'avBulletinId ASC', limit: 1);
  if (bulletinMaps.isEmpty) {
    return null;
  }
  AvalancheBulletin bulletin = AvalancheBulletin.fromJson(bulletinMaps[0]);
  return bulletin;
}

Future<List<WeatherHour>> weatherHoursForAvalancheArea(
    int avAreaId, Database db, int date1, int date2) async {
  List<WeatherHour> weatherHours = [];

  switch (avAreaId) {
    case 2:
      // List<Map<String, Object?>> weather = await db.rawQuery(
      //     'SELECT * FROM weather_hour WHERE date >= $date1 and date <= $date2');
      List<Map<String, Object?>> weather = await db.query("weather_hour",
          where: 'date between ? and ? and area="SI_JULIAN-ALPS_"',
          whereArgs: [date1, date2]);

      weatherHours.addAll(List.generate(weather.length, (i) {
        return WeatherHour.fromJson(weather[i]);
      }));
      break;
    case 3:
      List<Map<String, Object?>> weather = await db.query("weather_hour",
          where: 'date between ? and ? and area="SI_JULIAN-ALPS_"',
          whereArgs: [date1, date2]);

      weatherHours.addAll(List.generate(weather.length, (i) {
        return WeatherHour.fromJson(weather[i]);
      }));

      List<Map<String, Object?>> weather2 = await db.query("weather_hour",
          where: 'date between ? and ? and area="SI_KARAVANKE-ALPS_"',
          whereArgs: [date1, date2]);

      weatherHours.addAll(List.generate(weather2.length, (i) {
        return WeatherHour.fromJson(weather2[i]);
      }));
      break;
    case 4:
      List<Map<String, Object?>> weather = await db.query("weather_hour",
          where: 'date between ? and ? and area="SI_KAMNIK-SAVINJA-ALPS_"',
          whereArgs: [date1, date2]);

      weatherHours.addAll(List.generate(weather.length, (i) {
        return WeatherHour.fromJson(weather[i]);
      }));

      List<Map<String, Object?>> weather2 = await db.query("weather_hour",
          where: 'date between ? and ? and area="SI_KARAVANKE-ALPS_"',
          whereArgs: [date1, date2]);

      weatherHours.addAll(List.generate(weather2.length, (i) {
        return WeatherHour.fromJson(weather2[i]);
      }));
      break;
  }

  return weatherHours;
}
