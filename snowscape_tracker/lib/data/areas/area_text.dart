class AreaText {
  String name;
  int sLanguageId;
  String shortName;

  AreaText({
    required this.name,
    required this.sLanguageId,
    required this.shortName,
  });

  factory AreaText.fromJson(Map<String, dynamic> json) {
    return AreaText(
      name: json['name'],
      sLanguageId: json['s_language_id'],
      shortName: json['short_name'],
    );
  }
}
