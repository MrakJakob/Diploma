class DangerFromJson {
  final bool? checkElevation;
  final int? dayDelay;
  final bool? am;
  final int? value;

  DangerFromJson({
    this.checkElevation,
    this.dayDelay,
    this.am,
    this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'checkElevation': checkElevation,
      'dayDelay': dayDelay,
      'am': am,
      'value': value,
    };
  }

  factory DangerFromJson.fromJson(Map<String, dynamic> json) {
    return DangerFromJson(
      checkElevation: json['check_elevation'],
      dayDelay: json['day_delay'],
      am: json['am'],
      value: json['value'],
    );
  }
}
