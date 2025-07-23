import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/controllers/weather_contronller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final weatherContronller = WeatherContronller();
  Map? dataWeather;
  Position? position;
  late LocationSettings locationSettings;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      locationSettings = WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        maximumAge: const Duration(minutes: 5),
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    dataWeather = await weatherContronller.getWeathData(
        position!.latitude, position!.longitude);
    setState(() {});
  }

  String getWeatherCondition() {
    final main = dataWeather?['weather'][0]['main'];
    final description = dataWeather?['weather'][0]['description'];

    if (main == 'Clear') return 'Nắng';
    if (main == 'Clouds') return 'Nhiều mây';
    if (main == 'Rain') return 'Mưa';
    if (main == 'Thunderstorm') return 'Dông';
    if (main == 'Drizzle') return 'Mưa phùn';
    if (main == 'Snow') return 'Tuyết';
    if (main == 'Mist' || main == 'Fog' || main == 'Haze') return 'Sương mù';

    return description;
  }

  String getCustomWeatherIcon(String iconCode) {
    if (iconCode.startsWith("01")) return "assets/sun.png";
    if (iconCode.startsWith("02") || iconCode.startsWith("03")) {
      return "assets/cloud_sun.png";
    }
    if (iconCode.startsWith("04")) return "assets/cloud.png";
    if (iconCode.startsWith("09") || iconCode.startsWith("10")) {
      return "assets/rain.png";
    }
    if (iconCode.startsWith("11")) return "assets/storm.png";
    if (iconCode.startsWith("13")) return "assets/snow.png";
    if (iconCode.startsWith("50")) return "assets/fog.png";
    return "assets/unknown.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),
      body: dataWeather != null
          ? Center(
              child: Column(
                children: [
                  Text(dataWeather!['name'].toString()),
                  Text("${dataWeather!['main']['temp'].round()} °C"),
                  Text(
                      "${getWeatherCondition()}, độ ẩm ${dataWeather!['main']['humidity']}%"),
                  Image.network(
                      "https://openweathermap.org/img/wn/${dataWeather!['weather'][0]['icon']}@4x.png"),
                ],
              ),
            )
          : Center(
              child: Column(
                children: [
                  Shimmer(
                    gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade600]),
                    child: const Text("Loading..."),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 14,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 14,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
