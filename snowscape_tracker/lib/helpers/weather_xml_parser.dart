import 'dart:async';
import 'package:intl/intl.dart';
import 'package:snowscape_tracker/data/weather/weather_hour.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

Future<List<WeatherHour>> weatherXmlParser(String input, Database db) async {
  final document = XmlDocument.parse(input);

  // List<WeatherHour> weatherHourList = [];
  DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  // String datum = "11.06.2023 8:00 CEST";
  // // DateTime date = dateFormat.parse(datum.replaceAll(" CEST", ""));
  // final brut = document.findAllElements('metData').length;

  // var completer = Completer<List<WeatherHour>>();
  int i = 0;
  List<WeatherHour> w = document.findAllElements('metData').map((element) {
    //
    WeatherHour weatherHour = WeatherHour(
      id: i,
      date: dateFormat.parse(element.findElements('valid').single.innerText),
      oblacnost: element.findElements('nn_icon').single.innerText.toString(),
      vremenskiPojav:
          element.findElements('wwsyn_icon').single.innerText.toString(),
      intenzivnost:
          element.findElements('rr_decodeText').single.innerText.toString(),
      t3000: int.parse(
          element.findElements('t_level_3000_m').single.innerText.toString()),
      t2500: int.parse(
          element.findElements('t_level_2500_m').single.innerText.toString()),
      t2000: int.parse(
          element.findElements('t_level_2000_m').single.innerText.toString()),
      t1500: int.parse(
          element.findElements('t_level_1500_m').single.innerText.toString()),
      t1000: int.parse(
          element.findElements('t_level_1000_m').single.innerText.toString()),
      t500: int.parse(
          element.findElements('t_level_500_m').single.innerText.toString()),
      w3000: double.parse(element
          .findElements('ffVal_level_3000_m')
          .single
          .innerText
          .toString()),
      w2500: double.parse(element
          .findElements('ffVal_level_2500_m')
          .single
          .innerText
          .toString()),
      w2000: double.parse(element
          .findElements('ffVal_level_2000_m')
          .single
          .innerText
          .toString()),
      w1500: double.parse(element
          .findElements('ffVal_level_1500_m')
          .single
          .innerText
          .toString()),
      w1000: double.parse(element
          .findElements('ffVal_level_1000_m')
          .single
          .innerText
          .toString()),
      w500: double.parse(element
          .findElements('ffVal_level_500_m')
          .single
          .innerText
          .toString()),
      snowLimit:
          int.parse(element.findElements('sl_alt').single.innerText.toString()),
      area:
          element.findElements('domain_meteosiId').single.innerText.toString(),
    );
    i++;
    return weatherHour;
  }).toList();
  return w;
}
