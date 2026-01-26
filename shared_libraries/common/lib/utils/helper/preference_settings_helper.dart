import 'package:dependencies/shared_preferences/shared_preferences.dart';

class PreferenceSettingsHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferenceSettingsHelper({required this.sharedPreferences});

  static const darkTheme = 'dark_theme';
  static const appLocale = 'app_locale';

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(darkTheme) ?? false;
  }

  Future<String?> get localeCode async {
    final prefs = await sharedPreferences;
    return prefs.getString(appLocale);
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(darkTheme, value);
  }

  void setLocaleCode(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(appLocale, value);
  }
}
