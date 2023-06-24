class Danger {
  String aspects;
  int avAreaId;
  int elevationFrom;
  int elevationTo;
  bool treeline;
  bool treelineAbove;
  String validEnd;
  String validStart;
  int value;

  Danger({
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

  factory Danger.fromJson(Map<String, dynamic> json) {
    return Danger(
      aspects: json['aspects'],
      avAreaId: json['av_area_id'],
      elevationFrom: json['elevation_from'],
      elevationTo: json['elevation_to'],
      treeline: json['treeline'],
      treelineAbove: json['treeline_above'],
      validEnd: json['valid_end'],
      validStart: json['valid_start'],
      value: json['value'],
    );
  }
}
