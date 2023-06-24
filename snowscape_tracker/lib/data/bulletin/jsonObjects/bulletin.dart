import 'package:snowscape_tracker/data/bulletin/jsonObjects/av_pattern.dart';
import 'package:snowscape_tracker/data/bulletin/jsonObjects/bulletin_text.dart';
import 'package:snowscape_tracker/data/bulletin/jsonObjects/comment.dart';
import 'package:snowscape_tracker/data/bulletin/jsonObjects/danger.dart';
import 'package:snowscape_tracker/data/bulletin/jsonObjects/problem.dart';
import 'package:snowscape_tracker/data/bulletin/jsonObjects/snow_area.dart';

class Bulletin {
  int avBulletinId;
  int avUser;
  List<Comment> comments;
  List<Danger> dangers;
  String dateCreated;
  String dateModified;
  String dateNextBulletin;
  List<AvPattern> patterns;
  List<Problem> problems;
  List<SnowArea> snowareas;
  List<dynamic> snowfeatures;
  int status;
  List<BulletinText> texts;
  String validStart;

  Bulletin({
    required this.avBulletinId,
    required this.avUser,
    required this.comments,
    required this.dangers,
    required this.dateCreated,
    required this.dateModified,
    required this.dateNextBulletin,
    required this.patterns,
    required this.problems,
    required this.snowareas,
    required this.snowfeatures,
    required this.status,
    required this.texts,
    required this.validStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'avBulletinId': avBulletinId,
      'avUser': avUser,
      'comments': comments,
      'dangers': dangers,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'dateNextBulletin': dateNextBulletin,
      'patterns': patterns,
      'problems': problems,
      'snowareas': snowareas,
      'snowfeatures': snowfeatures,
      'status': status,
      'texts': texts,
      'validStart': validStart,
    };
  }

  factory Bulletin.fromJson(Map<String, dynamic> json) {
    return Bulletin(
      avBulletinId: json['av_bulletin_id'],
      avUser: json['av_user'],
      comments:
          List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x))),
      dangers:
          List<Danger>.from(json['dangers'].map((x) => Danger.fromJson(x))),
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      dateNextBulletin: json['date_next_bulletin'],
      patterns: List<AvPattern>.from(
          json['patterns'].map((x) => AvPattern.fromJson(x))),
      problems:
          List<Problem>.from(json['problems'].map((x) => Problem.fromJson(x))),
      snowareas: List<SnowArea>.from(
          json['snowareas'].map((x) => SnowArea.fromJson(x))),
      snowfeatures: List<dynamic>.from(json['snowfeatures'].map((x) => x)),
      status: json['status'],
      texts: List<BulletinText>.from(
          json['texts'].map((x) => BulletinText.fromJson(x))),
      validStart: json['valid_start'],
    );
  }
}
