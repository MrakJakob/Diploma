class Comment {
  int avAreaId;
  String contents;
  String headingCode;
  List<dynamic> subareas;

  Comment({
    required this.avAreaId,
    required this.contents,
    required this.headingCode,
    required this.subareas,
  });

  Map<String, dynamic> toMap() {
    return {
      'avAreaId': avAreaId,
      'contents': contents,
      'headingCode': headingCode,
      'subareas': subareas,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      avAreaId: json['av_area_id'],
      contents: json['contents'],
      headingCode: json['heading_code'],
      subareas: json['subareas'],
    );
  }
}
