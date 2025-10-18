// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Thời tiết';

  @override
  String get loading => 'Đang tải...';

  @override
  String get changeFont => 'Đổi phông chữ';

  @override
  String get defaultFont => 'Font mặc định';

  @override
  String get changeLanguage => 'Đổi ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get changeTheme => 'Đổi giao diện';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get system => 'Tự động';

  @override
  String humidity(Object value) {
    return 'Độ ẩm $value%';
  }

  @override
  String get weatherConditionClear => 'Nắng';

  @override
  String get weatherConditionClouds => 'Nhiều mây';

  @override
  String get weatherConditionRain => 'Mưa';

  @override
  String get weatherConditionThunderstorm => 'Dông';

  @override
  String get weatherConditionDrizzle => 'Mưa phùn';

  @override
  String get weatherConditionSnow => 'Tuyết';

  @override
  String get weatherConditionMist => 'Sương mù';

  @override
  String temperature(Object value) {
    return '$value°C';
  }
}
