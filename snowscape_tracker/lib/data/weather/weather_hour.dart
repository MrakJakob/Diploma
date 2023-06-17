class WeatherHour {
  int id;
  DateTime date; // miliseconds since epoch
  String oblacnost;
  String? vremenskiPojav;
  String? intenzivnost;
  int t500;
  int t1000;
  int t1500;
  int t2000;
  int t2500;
  int t3000;
  int snowLimit;
  int w500;
  int w1000;
  int w1500;
  int w2000;
  int w2500;
  int w3000;
  String area;

  WeatherHour({
    required this.id,
    required this.date,
    required this.oblacnost,
    required this.vremenskiPojav,
    required this.intenzivnost,
    required this.t500,
    required this.t1000,
    required this.t1500,
    required this.t2000,
    required this.t2500,
    required this.t3000,
    required this.snowLimit,
    required this.w500,
    required this.w1000,
    required this.w1500,
    required this.w2000,
    required this.w2500,
    required this.w3000,
    required this.area,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'oblacnost': oblacnost,
      'vremenskiPojav': vremenskiPojav,
      'intenzivnost': intenzivnost,
      't500': t500,
      't1000': t1000,
      't1500': t1500,
      't2000': t2000,
      't2500': t2500,
      't3000': t3000,
      'snowLimit': snowLimit,
      'w500': w500,
      'w1000': w1000,
      'w1500': w1500,
      'w2000': w2000,
      'w2500': w2500,
      'w3000': w3000,
      'area': area,
    };
  }

  factory WeatherHour.fromJson(Map<String, dynamic> json) {
    return WeatherHour(
      id: json['id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      oblacnost: json['oblacnost'],
      vremenskiPojav: json['vremenskiPojav'],
      intenzivnost: json['intenzivnost'],
      t500: json['t500'],
      t1000: json['t1000'],
      t1500: json['t1500'],
      t2000: json['t2000'],
      t2500: json['t2500'],
      t3000: json['t3000'],
      snowLimit: json['snowLimit'],
      w500: json['w500'],
      w1000: json['w1000'],
      w1500: json['w1500'],
      w2000: json['w2000'],
      w2500: json['w2500'],
      w3000: json['w3000'],
      area: json['area'],
    );
  }

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS weather_hour (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER NOT NULL,
      oblacnost TEXT NOT NULL,
      vremenskiPojav TEXT,
      intenzivnost TEXT,
      t500 INTEGER NOT NULL,
      t1000 INTEGER NOT NULL,
      t1500 INTEGER NOT NULL,
      t2000 INTEGER NOT NULL,
      t2500 INTEGER NOT NULL,
      t3000 INTEGER NOT NULL,
      snowLimit INTEGER NOT NULL,
      w500 INTEGER NOT NULL,
      w1000 INTEGER NOT NULL,
      w1500 INTEGER NOT NULL,
      w2000 INTEGER NOT NULL,
      w2500 INTEGER NOT NULL,
      w3000 INTEGER NOT NULL,
      area TEXT NOT NULL
    )''';
  }
}
