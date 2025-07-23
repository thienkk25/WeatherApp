import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map?> getWeathData(String lat, String lon) async {
    try {
      final appid = dotenv.env['WEATHER_APIKEY'];
      final response = await http.post(Uri(
        scheme: "https",
        host: "api.openweathermap.org",
        path: "data/2.5/weather",
        queryParameters: {
          "lat": lat,
          "lon": lon,
          "appid": appid,
          "lang": "vi",
          "units": "metric"
        },
      ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
