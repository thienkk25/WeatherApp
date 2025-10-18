import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/controllers/weather_contronller.dart';
import '../l10n/app_localizations.dart';

class Home extends StatefulWidget {
  final ValueChanged<bool> onFontChange;
  final ValueChanged<ThemeMode> onThemeModeChange;
  final ThemeMode currentThemeMode;
  final ValueChanged<Locale> onLocaleChange;
  final Locale currentLocale;

  const Home({
    super.key,
    required this.onFontChange,
    required this.onThemeModeChange,
    required this.currentThemeMode,
    required this.onLocaleChange,
    required this.currentLocale,
  });

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
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'Weather'),
        centerTitle: true,
      ),
      drawer: Drawer(
          child: SafeArea(
        child: Column(
          spacing: 10,
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
                    Text(AppLocalizations.of(context)?.changeFont ??
                        "Đổi phông chữ"),
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
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)?.vietnamese ??
                                "Vietnamese"),
                            if (widget.currentLocale.languageCode == 'vi')
                              const Icon(Icons.check,
                                  color: Colors.blue, size: 18),
                          ],
                        ),
                        onTap: () {
                          widget.onLocaleChange(const Locale('vi'));
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)?.english ??
                                "English"),
                            if (widget.currentLocale.languageCode == 'en')
                              const Icon(Icons.check,
                                  color: Colors.blue, size: 18),
                          ],
                        ),
                        onTap: () {
                          widget.onLocaleChange(const Locale('en'));
                        },
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
                    Text(AppLocalizations.of(context)?.changeLanguage ??
                        "Đổi ngôn ngữ"),
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
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)?.light ?? "Sáng"),
                            if (widget.currentThemeMode == ThemeMode.light)
                              const Icon(Icons.check,
                                  color: Colors.blue, size: 18),
                          ],
                        ),
                        onTap: () {
                          widget.onThemeModeChange(ThemeMode.light);
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)?.dark ?? "Tối"),
                            if (widget.currentThemeMode == ThemeMode.dark)
                              const Icon(Icons.check,
                                  color: Colors.blue, size: 18),
                          ],
                        ),
                        onTap: () {
                          widget.onThemeModeChange(ThemeMode.dark);
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)?.system ??
                                "Tự động"),
                            if (widget.currentThemeMode == ThemeMode.system)
                              const Icon(Icons.check,
                                  color: Colors.blue, size: 18),
                          ],
                        ),
                        onTap: () {
                          widget.onThemeModeChange(ThemeMode.system);
                        },
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
                    Text(AppLocalizations.of(context)?.changeTheme ??
                        "Đổi giao diện"),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dataWeather != null
                      ? Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 10,
                          shadowColor: Colors.blue.withValues(alpha: .17),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                        color: Colors.blue.shade600, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      dataWeather!["name"].toString(),
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Lottie.asset(
                                  getCustomWeatherIcon(
                                      dataWeather!["weather"][0]["icon"]),
                                  height: 200,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)?.temperature(
                                          dataWeather!["main"]["temp"]
                                              .toStringAsFixed(0)) ??
                                      "${dataWeather!["main"]["temp"].toStringAsFixed(0)}°C",
                                  style: TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                    fontFamily: 'Borel',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  getWeatherCondition(),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)?.humidity(
                                          dataWeather!["main"]["humidity"]) ??
                                      "Độ ẩm ${dataWeather!["main"]["humidity"]}%",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                          shadowColor: Colors.blue.withValues(alpha: .13),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Shimmer(
                                  gradient: LinearGradient(colors: [
                                    Colors.blue.shade100,
                                    Colors.blue.shade200
                                  ]),
                                  child: Container(
                                    height: 36,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Shimmer.fromColors(
                                  baseColor: Colors.blue.shade100,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue.shade50,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Shimmer.fromColors(
                                  baseColor: Colors.blue.shade100,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 28,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Shimmer.fromColors(
                                  baseColor: Colors.blue.shade100,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 18,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Lottie.asset("assets/lotties/fb.json",
                              height: 36, width: 36),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Lottie.asset("assets/lotties/instagram.json",
                              height: 36, width: 36),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Lottie.asset("assets/lotties/linkedin.json",
                              height: 36, width: 36),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
