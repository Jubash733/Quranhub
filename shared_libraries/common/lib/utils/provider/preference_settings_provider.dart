import 'package:common/utils/helper/preference_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:resources/styles/theme.dart';

class PreferenceSettingsProvider extends ChangeNotifier {
  late PreferenceSettingsHelper preferenceSettingsHelper;

  PreferenceSettingsProvider({required this.preferenceSettingsHelper}) {
    _getTheme();
    _getLocale();
    _getArabicFontScale();
    _getArabicFontFamily();
    _getTranslationPreference();
    _getTafsirPreference();
    _getAudioSpeed();
    _getAudioRepeatCount();
    _getAudioSleepMinutes();
    _getPackStorageLimitBytes();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  double _arabicFontScale = 1.0;
  double get arabicFontScale => _arabicFontScale;

  ArabicFontFamily _arabicFontFamily = ArabicFontFamily.amiri;
  ArabicFontFamily get arabicFontFamily => _arabicFontFamily;

  bool _showTranslation = true;
  bool get showTranslation => _showTranslation;

  bool _showTafsir = true;
  bool get showTafsir => _showTafsir;

  double _audioSpeed = 1.0;
  double get audioSpeed => _audioSpeed;

  int _audioRepeatCount = 1;
  int get audioRepeatCount => _audioRepeatCount;

  int _audioSleepMinutes = 0;
  int get audioSleepMinutes => _audioSleepMinutes;

  int _packStorageLimitBytes = 1024 * 1024 * 1024;
  int get packStorageLimitBytes => _packStorageLimitBytes;

  void _getTheme() async {
    _isDarkTheme = await preferenceSettingsHelper.isDarkTheme;
    notifyListeners();
  }

  void _getLocale() async {
    final code = await preferenceSettingsHelper.localeCode;
    _locale = Locale(code ?? 'ar');
    notifyListeners();
  }

  void _getArabicFontScale() async {
    final value = await preferenceSettingsHelper.storedArabicFontScale;
    _arabicFontScale = value ?? 1.0;
    notifyListeners();
  }

  void _getArabicFontFamily() async {
    final value = await preferenceSettingsHelper.storedArabicFontFamily;
    _arabicFontFamily = arabicFontFamilyFromString(value);
    notifyListeners();
  }

  void _getTranslationPreference() async {
    _showTranslation = await preferenceSettingsHelper.isTranslationEnabled;
    notifyListeners();
  }

  void _getTafsirPreference() async {
    _showTafsir = await preferenceSettingsHelper.isTafsirEnabled;
    notifyListeners();
  }

  void _getAudioSpeed() async {
    _audioSpeed = await preferenceSettingsHelper.storedAudioSpeed;
    notifyListeners();
  }

  void _getAudioRepeatCount() async {
    _audioRepeatCount = await preferenceSettingsHelper.storedAudioRepeatCount;
    notifyListeners();
  }

  void _getAudioSleepMinutes() async {
    _audioSleepMinutes = await preferenceSettingsHelper.storedAudioSleepMinutes;
    notifyListeners();
  }

  void _getPackStorageLimitBytes() async {
    _packStorageLimitBytes =
        await preferenceSettingsHelper.storedPackStorageLimitBytes;
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

  void setArabicFontScale(double value) {
    preferenceSettingsHelper.setArabicFontScale(value);
    _arabicFontScale = value;
    notifyListeners();
  }

  void setArabicFontFamily(ArabicFontFamily value) {
    preferenceSettingsHelper.setArabicFontFamily(arabicFontFamilyKey(value));
    _arabicFontFamily = value;
    notifyListeners();
  }

  void setTranslationEnabled(bool value) {
    preferenceSettingsHelper.setTranslationEnabled(value);
    _showTranslation = value;
    notifyListeners();
  }

  void setTafsirEnabled(bool value) {
    preferenceSettingsHelper.setTafsirEnabled(value);
    _showTafsir = value;
    notifyListeners();
  }

  void setAudioSpeed(double value) {
    preferenceSettingsHelper.setAudioSpeed(value);
    _audioSpeed = value;
    notifyListeners();
  }

  void setAudioRepeatCount(int value) {
    preferenceSettingsHelper.setAudioRepeatCount(value);
    _audioRepeatCount = value;
    notifyListeners();
  }

  void setAudioSleepMinutes(int value) {
    preferenceSettingsHelper.setAudioSleepMinutes(value);
    _audioSleepMinutes = value;
    notifyListeners();
  }

  void setPackStorageLimitBytes(int value) {
    preferenceSettingsHelper.setPackStorageLimitBytes(value);
    _packStorageLimitBytes = value;
    notifyListeners();
  }
}
