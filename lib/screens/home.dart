import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/controllers/weather_contronller.dart';

class Home extends StatefulWidget {
  final ValueChanged<bool> onFontChange;

  const Home({super.key, required this.onFontChange});

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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.denied) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "App sẽ tiếp tục theo dõi vị trí của bạn",
          notificationTitle: "Đang chạy nền",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
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

    position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    dataWeather = await weatherContronller.getWeathData(
      position?.latitude ?? 21.028511,
      position?.longitude ?? 105.804817,
    );

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
    if (iconCode.startsWith("01")) return "assets/lotties/Sun.json";
    if (iconCode.startsWith("02") || iconCode.startsWith("03")) {
      return "assets/lotties/Sunny.json";
    }
    if (iconCode.startsWith("04")) return "assets/lotties/cloud.json";
    if (iconCode.startsWith("09") || iconCode.startsWith("10")) {
      return "assets/lotties/Rain Fall.json";
    }
    if (iconCode.startsWith("11")) return "assets/lotties/storm.png";
    if (iconCode.startsWith("13")) return "assets/lotties/snow.png";
    if (iconCode.startsWith("50")) return "assets/lotties/fog.png";
    return "assets/lotties/404.json";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        centerTitle: true,
      ),
      drawer: Drawer(
          child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () async {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final Offset offset = button.localToGlobal(Offset.zero);

                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromLTWH(
                      overlay.size.width - 200,
                      offset.dy,
                      0,
                      0,
                    ),
                    Offset.zero & overlay.size,
                  );

                  await showMenu(
                    context: context,
                    position: position,
                    items: [
                      PopupMenuItem(
                        child: const Text("Font mới"),
                        onTap: () {
                          widget.onFontChange(true);
                        },
                      ),
                      PopupMenuItem(
                        child: const Text("Font mặc định"),
                        onTap: () {
                          widget.onFontChange(false);
                        },
                      ),
                    ],
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/lotties/font.json",
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Đổi phông chữ"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () async {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final Offset offset = button.localToGlobal(Offset.zero);

                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromLTWH(
                      overlay.size.width - 200,
                      offset.dy,
                      0,
                      0,
                    ),
                    Offset.zero & overlay.size,
                  );

                  await showMenu(
                    context: context,
                    position: position,
                    items: [
                      PopupMenuItem(
                        child: const Text("Vietnamese"),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: const Text("English"),
                        onTap: () {},
                      ),
                    ],
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/lotties/lang.json",
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Đổi ngôn ngữ"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () async {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final Offset offset = button.localToGlobal(Offset.zero);

                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromLTWH(
                      overlay.size.width - 200,
                      offset.dy,
                      0,
                      0,
                    ),
                    Offset.zero & overlay.size,
                  );

                  await showMenu(
                    context: context,
                    position: position,
                    items: [
                      PopupMenuItem(
                        child: const Text("Sáng"),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: const Text("Tối"),
                        onTap: () {},
                      ),
                    ],
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/lotties/Light Mode.json",
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Đổi giao diện"),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
      body: SafeArea(
        child: Column(
          children: [
            dataWeather != null
                ? Center(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(dataWeather!['name'].toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            LottieBuilder.asset(
                              "assets/lotties/location.json",
                            ),
                          ],
                        ),
                        Text("${dataWeather!['main']['temp'].round()} °C"),
                        Text(
                            "${getWeatherCondition()}, độ ẩm ${dataWeather!['main']['humidity']}%"),
                        LottieBuilder.asset(
                          getCustomWeatherIcon(
                              dataWeather!['weather'][0]['icon']),
                          height: 200,
                          width: 200,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        Shimmer(
                          gradient: LinearGradient(colors: [
                            Colors.grey.shade300,
                            Colors.grey.shade600
                          ]),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/lotties/fb.json",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 10),
                LottieBuilder.asset(
                  "assets/lotties/instagram.json",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 10),
                LottieBuilder.asset(
                  "assets/lotties/linkedin.json",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
