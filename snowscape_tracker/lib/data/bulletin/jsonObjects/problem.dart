import 'package:snowscape_tracker/data/bulletin/jsonObjects/avalanche_type.dart';

class Problem {
  int additionalLoad;
  String aspects;
  int avAreaId;
  List<AvalancheType> avalanchetypes;
  int elevationFrom;
  int elevationTo;
  String primaryDays;
  int problemId;
  int sReasonId;
  bool treeline;
  bool treelineAbove;
  String trends;
  String validEnd;
  String validStart;

  Problem({
    required this.additionalLoad,
    required this.aspects,
    required this.avAreaId,
    required this.avalanchetypes,
    required this.elevationFrom,
    required this.elevationTo,
    required this.primaryDays,
    required this.problemId,
    required this.sReasonId,
    required this.treeline,
    required this.treelineAbove,
    required this.trends,
    required this.validEnd,
    required this.validStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'additionalLoad': additionalLoad,
      'aspects': aspects,
      'avAreaId': avAreaId,
      'avalanchetypes': avalanchetypes,
      'elevationFrom': elevationFrom,
      'elevationTo': elevationTo,
      'primaryDays': primaryDays,
      'problemId': problemId,
      'sReasonId': sReasonId,
      'treeline': treeline,
      'treelineAbove': treelineAbove,
      'trends': trends,
      'validEnd': validEnd,
      'validStart': validStart,
    };
  }

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      additionalLoad: json['additional_load'],
      aspects: json['aspects'],
      avAreaId: json['av_area_id'],
      avalanchetypes: List<AvalancheType>.from(
          json['avalanchetypes'].map((x) => AvalancheType.fromJson(x))),
      elevationFrom: json['elevation_from'],
      elevationTo: json['elevation_to'],
      primaryDays: json['primary_days'],
      problemId: json['problem_id'],
      sReasonId: json['s_reason_id'],
      treeline: json['treeline'],
      treelineAbove: json['treeline_above'],
      trends: json['trends'],
      validEnd: json['valid_end'],
      validStart: json['valid_start'],
    );
  }
}
