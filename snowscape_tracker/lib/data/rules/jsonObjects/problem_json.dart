class ProblemFromJson {
  final bool? checkElevation;
  final int? dayDelay;
  final int? hourMax;
  final int? hourMin;
  final int? problemId;

  ProblemFromJson({
    this.checkElevation,
    this.dayDelay,
    this.hourMax,
    this.hourMin,
    this.problemId,
  });

  Map<String, dynamic> toMap() {
    return {
      'checkElevation': checkElevation,
      'dayDelay': dayDelay,
      'hourMax': hourMax,
      'hourMin': hourMin,
      'problemId': problemId,
    };
  }

  factory ProblemFromJson.fromJson(Map<String, dynamic> json) {
    return ProblemFromJson(
      checkElevation: json['check_elevation'],
      dayDelay: json['day_delay'],
      hourMax: json['hour_max'],
      hourMin: json['hour_min'],
      problemId: json['problem_id'],
    );
  }
}
