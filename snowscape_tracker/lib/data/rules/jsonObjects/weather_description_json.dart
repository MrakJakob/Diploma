class WeatherDescriptionFromJson {
  final int dayDelay; // -1 -> prejsni dan, 0 -> danes, 1 -> jutri
  final int? tempAvgMin; // min povprečna temperatura
  final int? tempAvgMax; // max povprečna temperatura
  final int
      hourMin; // med hourMin in hourMax mora veljati povprečna temperatura,
  final int hourMax;
  // TODO: translate to english
  final String?
      oblacnost; // clear, mostClear, slightCloudy, partCloudy, modCloudy, prevCloudy, overcast, FG
  final String?
      vremenskiPojav; //FG, DZ, FZDZ, RA, FZRA, RASN, SN, SHRA, SHRASN, SHSN, SHGR, TS, TSRA, TSRASN, TSSN, TSGR
  final String? intenzivnost; // light, mod, heavy
  final String
      elevation; // 1000m, 1500m, 2000m, 2500m, 3000m -> temperatura na nadmorski višini

  WeatherDescriptionFromJson({
    required this.dayDelay,
    required this.tempAvgMin,
    required this.tempAvgMax,
    required this.hourMin,
    required this.hourMax,
    required this.oblacnost,
    required this.vremenskiPojav,
    required this.intenzivnost,
    required this.elevation,
  });

  factory WeatherDescriptionFromJson.fromJson(Map<String, dynamic> json) {
    return WeatherDescriptionFromJson(
      dayDelay: json['day_delay'],
      tempAvgMin: json['temp_avg_min'],
      tempAvgMax: json['temp_avg_max'],
      hourMin: json['hour_min'],
      hourMax: json['hour_max'],
      oblacnost: json['oblacnost'],
      vremenskiPojav: json['vremenski_pojav'],
      intenzivnost: json['intenzivnost'],
      elevation: json['elevation'],
    );
  }
}
