class SnowHeight {
  int altitude;
  var orientation;
  bool recent;
  var value_max;
  var value_min;

  SnowHeight({
    required this.altitude,
    required this.orientation,
    required this.recent,
    required this.value_max,
    required this.value_min,
  });

  Map<String, dynamic> toMap() {
    return {
      'altitude': altitude,
      'orientation': orientation,
      'recent': recent,
      'value_max': value_max,
      'value_min': value_min,
    };
  }

  factory SnowHeight.fromJson(Map<String, dynamic> json) {
    return SnowHeight(
      altitude: json['altitude'],
      orientation: json['orientation'],
      recent: json['recent'],
      value_max: json['value_max'],
      value_min: json['value_min'],
    );
  }
}
