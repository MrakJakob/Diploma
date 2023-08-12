import 'package:snowscape_tracker/data/rules/jsonObjects/rule_json.dart';

class RulesJson {
  List<RuleFromJson>? rules;

  RulesJson({this.rules});

  factory RulesJson.fromJson(Map<String, dynamic> json) {
    // possible error because of table rules renamed to rule
    return RulesJson(
      rules: json['rules'] != null
          ? (json['rules'] as List)
              .map((i) => RuleFromJson.fromJson(i))
              .toList()
          : null,
    );
  }
}
