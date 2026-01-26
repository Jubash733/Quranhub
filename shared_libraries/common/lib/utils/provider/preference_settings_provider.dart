import 'package:common/utils/helper/preference_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:resources/styles/theme.dart';

class PreferenceSettingsProvider extends ChangeNotifier {
  late PreferenceSettingsHelper preferenceSettingsHelper;

  PreferenceSettingsProvider({required this.preferenceSettingsHelper}) {
    _getTheme();
    _getLocale();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  void _getTheme() async {
    _isDarkTheme = await preferenceSettingsHelper.isDarkTheme;
    notifyListeners();
  }

  void _getLocale() async {
    final code = await preferenceSettingsHelper.localeCode;
    _locale = Locale(code ?? 'ar');
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferenceSettingsHelper.setDarkTheme(value);
    _getTheme();
  }

  void setLocale(Locale locale) {
    preferenceSettingsHelper.setLocaleCode(locale.languageCode);
    _getLocale();
  }
}
