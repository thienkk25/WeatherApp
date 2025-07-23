import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/home.dart';

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

  void _changeFont(bool newFont) {
    setState(() {
      _fontFamily = newFont;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather",
      debugShowCheckedModeBanner: false,
      theme: _fontFamily
          ? ThemeData(fontFamily: 'Borel')
          : ThemeData(fontFamily: ''),
      themeMode: ThemeMode.system,
      home: Home(
        onFontChange: _changeFont,
      ),
    );
  }
}
