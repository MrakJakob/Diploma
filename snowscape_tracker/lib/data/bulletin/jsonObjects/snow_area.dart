import 'package:snowscape_tracker/data/bulletin/jsonObjects/snow_height.dart';

class SnowArea {
  int avAreaId;
  List<SnowHeight> snowheights;
  int? snowlevelN;
  int? snowlevelS;

  SnowArea({
    required this.avAreaId,
    required this.snowheights,
    this.snowlevelN,
    this.snowlevelS,
  });

  Map<String, dynamic> toMap() {
    return {
      'avAreaId': avAreaId,
      'snowheights': snowheights,
      'snowlevelN': snowlevelN,
      'snowlevelS': snowlevelS,
    };
  }

  factory SnowArea.fromJson(Map<String, dynamic> json) {
    return SnowArea(
      avAreaId: json['av_area_id'],
      snowheights: List<SnowHeight>.from(
          json['snowheights'].map((x) => SnowHeight.fromJson(x))),
      snowlevelN: json['snowlevel_n'],
      snowlevelS: json['snowlevel_s'],
    );
  }
}
