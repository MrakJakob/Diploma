import 'package:snowscape_tracker/data/areas/area_text.dart';

class Area {
  int avAreaId;
  List<String> dangeranchor;
  bool forecast;
  List<List<String>> geometry;
  String snow;
  List<String> snowanchor;
  List<AreaText> texts;

  Area({
    required this.avAreaId,
    required this.dangeranchor,
    required this.forecast,
    required this.geometry,
    required this.snow,
    required this.snowanchor,
    required this.texts,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      avAreaId: json['av_area_id'],
      dangeranchor: List<String>.from(json['dangeranchor']),
      forecast: json['forecast'],
      geometry: (json['geometry'] as List)
          .map((e) => (e as List).map((e) => e.toString()).toList())
          .toList(),
      snow: json['snow'],
      snowanchor: List<String>.from(json['snowanchor']),
      texts:
          List<AreaText>.from(json['texts'].map((x) => AreaText.fromJson(x))),
    );
  }
}
