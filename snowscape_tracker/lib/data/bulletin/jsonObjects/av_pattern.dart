class AvPattern {
  int avAreaId;
  int pattern;
  String validEnd;
  String validStart;

  AvPattern({
    required this.avAreaId,
    required this.pattern,
    required this.validEnd,
    required this.validStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'avAreaId': avAreaId,
      'pattern': pattern,
      'validEnd': validEnd,
      'validStart': validStart,
    };
  }

  factory AvPattern.fromJson(Map<String, dynamic> json) {
    return AvPattern(
      avAreaId: json['av_area_id'],
      pattern: json['pattern'],
      validEnd: json['valid_end'],
      validStart: json['valid_start'],
    );
  }
}
