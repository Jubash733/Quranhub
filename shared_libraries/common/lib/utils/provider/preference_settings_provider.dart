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
}
