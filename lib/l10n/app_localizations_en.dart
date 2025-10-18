// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather';

  @override
  String get loading => 'Loading...';

  @override
  String get changeFont => 'Change font';

  @override
  String get defaultFont => 'Default font';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get changeTheme => 'Change theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String humidity(Object value) {
    return 'Humidity $value%';
  }

  @override
  String get weatherConditionClear => 'Sunny';

  @override
  String get weatherConditionClouds => 'Cloudy';

  @override
  String get weatherConditionRain => 'Rain';

  @override
  String get weatherConditionThunderstorm => 'Thunderstorm';

  @override
  String get weatherConditionDrizzle => 'Drizzle';

  @override
  String get weatherConditionSnow => 'Snow';

  @override
  String get weatherConditionMist => 'Mist / Fog / Haze';

  @override
  String temperature(Object value) {
    return '$value°C';
  }
}
