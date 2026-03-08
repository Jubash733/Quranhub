import 'package:dependencies/shared_preferences/shared_preferences.dart';

class PreferenceSettingsHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferenceSettingsHelper({required this.sharedPreferences});

  static const darkTheme = 'dark_theme';
  static const appLocale = 'app_locale';
  static const arabicFontScale = 'arabic_font_scale';
  static const arabicFontFamily = 'arabic_font_family';
  static const showTranslation = 'show_translation';
  static const showTafsir = 'show_tafsir';
  static const audioSpeed = 'audio_speed';
  static const audioRepeatCount = 'audio_repeat_count';
  static const audioSleepMinutes = 'audio_sleep_minutes';
  static const packStorageLimitBytes = 'pack_storage_limit_bytes';

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(darkTheme) ?? false;
  }

  Future<String?> get localeCode async {
    final prefs = await sharedPreferences;
    return prefs.getString(appLocale);
  }

  Future<double?> get storedArabicFontScale async {
    final prefs = await sharedPreferences;
    return prefs.getDouble(arabicFontScale);
  }

  Future<String?> get storedArabicFontFamily async {
    final prefs = await sharedPreferences;
    return prefs.getString(arabicFontFamily);
  }

  Future<bool> get isTranslationEnabled async {
    final prefs = await sharedPreferences;
    return prefs.getBool(showTranslation) ?? true;
  }

  Future<bool> get isTafsirEnabled async {
    final prefs = await sharedPreferences;
    return prefs.getBool(showTafsir) ?? true;
  }

  Future<double> get storedAudioSpeed async {
    final prefs = await sharedPreferences;
    return prefs.getDouble(audioSpeed) ?? 1.0;
  }

  Future<int> get storedAudioRepeatCount async {
    final prefs = await sharedPreferences;
    return prefs.getInt(audioRepeatCount) ?? 1;
  }

  Future<int> get storedAudioSleepMinutes async {
    final prefs = await sharedPreferences;
    return prefs.getInt(audioSleepMinutes) ?? 0;
  }

  Future<int> get storedPackStorageLimitBytes async {
    final prefs = await sharedPreferences;
    return prefs.getInt(packStorageLimitBytes) ?? (1024 * 1024 * 1024);
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(darkTheme, value);
  }

  void setLocaleCode(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(appLocale, value);
  }

  void setArabicFontScale(double value) async {
    final prefs = await sharedPreferences;
    prefs.setDouble(arabicFontScale, value);
  }

  void setArabicFontFamily(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(arabicFontFamily, value);
  }

  void setTranslationEnabled(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(showTranslation, value);
  }

  void setTafsirEnabled(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(showTafsir, value);
  }

  void setAudioSpeed(double value) async {
    final prefs = await sharedPreferences;
    prefs.setDouble(audioSpeed, value);
  }

  void setAudioRepeatCount(int value) async {
    final prefs = await sharedPreferences;
    prefs.setInt(audioRepeatCount, value);
  }

  void setAudioSleepMinutes(int value) async {
    final prefs = await sharedPreferences;
    prefs.setInt(audioSleepMinutes, value);
  }

  void setPackStorageLimitBytes(int value) async {
    final prefs = await sharedPreferences;
    prefs.setInt(packStorageLimitBytes, value);
  }
}
