import 'package:weather_app/services/weather_service.dart';

class WeatherContronller {
  Future<Map?> getWeathData(double lat, double lon) async {
    final data =
        await WeatherService().getWeathData(lat.toString(), lon.toString());
    return data;
  }
}
