import 'package:snowscape_tracker/data/areas/area.dart';

class Areas {
  List<Area>? areas;

  Areas({this.areas});

  factory Areas.fromJson(List<dynamic> json) {
    return Areas(
      areas: List<Area>.from(json.map((x) => Area.fromJson(x))),
    );
  }
}
