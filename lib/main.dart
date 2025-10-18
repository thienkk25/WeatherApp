import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/home.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _fontFamily = true;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('vi');

  void _changeFont(bool newFont) {
    setState(() {
      _fontFamily = newFont;
    });
  }

  void _changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)?.appTitle ?? 'Weather',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        fontFamily: _fontFamily ? 'Borel' : '',
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue, brightness: Brightness.light),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Borel',
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F5FA),
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Borel',
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: _fontFamily ? 'Borel' : '',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF22253A),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Borel',
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF151827),
        cardColor: const Color(0xFF23284A),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3048EA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Borel',
            ),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: Home(
        onFontChange: _changeFont,
        onThemeModeChange: _changeThemeMode,
        currentThemeMode: _themeMode,
        onLocaleChange: _changeLocale,
        currentLocale: _locale,
      ),
    );
  }
}
