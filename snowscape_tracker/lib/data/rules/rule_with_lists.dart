import 'package:snowscape_tracker/data/rules/danger_rule.dart';
import 'package:snowscape_tracker/data/rules/pattern_rule.dart';
import 'package:snowscape_tracker/data/rules/problem_rule.dart';
import 'package:snowscape_tracker/data/rules/rule.dart';
import 'package:snowscape_tracker/data/rules/weather_description.dart';

class RuleWithLists {
  Rule rule;
  List<WeatherDescription> weatherDescriptions;
  List<PatternRule> patternRules;
  List<ProblemRule> problemRules;
  List<DangerRule> dangerRules;

  RuleWithLists({
    required this.rule,
    required this.weatherDescriptions,
    required this.patternRules,
    required this.problemRules,
    required this.dangerRules,
  });
}
