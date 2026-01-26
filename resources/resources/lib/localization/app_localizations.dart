import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return localizations ?? const AppLocalizations(Locale('en'));
  }

  bool get isArabic => locale.languageCode == 'ar';

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'appTitle': 'Quran App',
      'greetingAssalam': "Assalamu'alaikum",
      'greetingWelcome': 'Ahlan wa Sahlan',
      'lastRead': 'Last Read',
      'surah': 'Surah',
      'ayah': 'Ayah',
      'startNow': 'Start Now',
      'onboardingSubtitle': 'Learn Quran and read it daily',
      'noData': 'No data available',
      'loading': 'Loading...',
      'unexpectedError': 'Something went wrong',
      'bookmarksTitle': 'Bookmarked Verses',
      'bookmarksEmpty': 'No bookmarks yet',
      'translation': 'Translation',
      'tafsir': 'Tafsir',
      'noTranslation': 'No translation available',
      'noTafsir': 'No tafsir available',
      'translationErrorTitle': "Couldn't load translation",
      'tafsirErrorTitle': "Couldn't load tafsir",
      'retry': 'Retry',
      'copy': 'Copy',
      'share': 'Share',
      'showTafsir': 'Show Tafsir',
      'copied': 'Copied',
      'search': 'Search',
      'searchHint': 'Search the Quran...',
      'searchResults': 'Search Results',
      'noResults': 'No results found',
      'aiAssistant': 'AI Tadabbur',
      'aiDisclaimer': 'AI output is assistant only, not a fatwa.',
      'aiGenerate': 'Generate',
      'aiPromptTitle': 'AI Prompt',
      'close': 'Close',
      'comingSoonTitle': 'Coming soon',
      'comingSoonMessage': 'We will notify you once this feature is ready.',
      'bookmarkAddedTitle': 'Bookmark added',
      'bookmarkRemovedTitle': 'Bookmark removed',
      'languageToggleShort': 'AR',
      'verseDetails': 'Verse Details',
    },
    'ar': {
      'appTitle': 'تطبيق القرآن',
      'greetingAssalam': 'السلام عليكم',
      'greetingWelcome': 'أهلًا وسهلًا',
      'lastRead': 'آخر قراءة',
      'surah': 'السور',
      'ayah': 'آية',
      'startNow': 'ابدأ الآن',
      'onboardingSubtitle': 'تعلّم القرآن وداوم على قراءته يوميًا',
      'noData': 'لا توجد بيانات',
      'loading': 'جارٍ التحميل',
      'unexpectedError': 'حدث خطأ غير متوقع',
      'bookmarksTitle': 'الآيات المحفوظة',
      'bookmarksEmpty': 'لا توجد علامات محفوظة',
      'translation': 'الترجمة',
      'tafsir': 'التفسير',
      'noTranslation': 'لا توجد ترجمة',
      'noTafsir': 'لا يوجد تفسير',
      'translationErrorTitle': 'تعذر تحميل الترجمة',
      'tafsirErrorTitle': 'تعذر تحميل التفسير',
      'retry': 'إعادة المحاولة',
      'copy': 'نسخ',
      'share': 'مشاركة',
      'showTafsir': 'عرض التفسير',
      'copied': 'تم النسخ',
      'search': 'بحث',
      'searchHint': 'ابحث في القرآن...',
      'searchResults': 'نتائج البحث',
      'noResults': 'لا توجد نتائج',
      'aiAssistant': 'مساعد التدبر الذكي',
      'aiDisclaimer': 'مخرجات الذكاء الاصطناعي مساعدة فقط وليست فتوى.',
      'aiGenerate': 'إنشاء',
      'aiPromptTitle': 'صيغة الطلب',
      'close': 'إغلاق',
      'comingSoonTitle': 'قريبًا',
      'comingSoonMessage': 'سنُخطرك فور جاهزية هذه الميزة.',
      'bookmarkAddedTitle': 'إضافة علامة الآية',
      'bookmarkRemovedTitle': 'حذف علامة الآية',
      'languageToggleShort': 'EN',
      'verseDetails': 'تفاصيل الآية',
    },
  };

  String _t(String key) =>
      _strings[locale.languageCode]?[key] ?? _strings['en']![key] ?? key;

  String get appTitle => _t('appTitle');
  String get greetingAssalam => _t('greetingAssalam');
  String get greetingWelcome => _t('greetingWelcome');
  String get lastRead => _t('lastRead');
  String get surah => _t('surah');
  String get ayah => _t('ayah');
  String get startNow => _t('startNow');
  String get onboardingSubtitle => _t('onboardingSubtitle');
  String get noData => _t('noData');
  String get loading => _t('loading');
  String get unexpectedError => _t('unexpectedError');
  String get bookmarksTitle => _t('bookmarksTitle');
  String get bookmarksEmpty => _t('bookmarksEmpty');
  String get translation => _t('translation');
  String get tafsir => _t('tafsir');
  String get noTranslation => _t('noTranslation');
  String get noTafsir => _t('noTafsir');
  String get translationErrorTitle => _t('translationErrorTitle');
  String get tafsirErrorTitle => _t('tafsirErrorTitle');
  String get retry => _t('retry');
  String get copy => _t('copy');
  String get share => _t('share');
  String get showTafsir => _t('showTafsir');
  String get copied => _t('copied');
  String get search => _t('search');
  String get searchHint => _t('searchHint');
  String get searchResults => _t('searchResults');
  String get noResults => _t('noResults');
  String get aiAssistant => _t('aiAssistant');
  String get aiDisclaimer => _t('aiDisclaimer');
  String get aiGenerate => _t('aiGenerate');
  String get aiPromptTitle => _t('aiPromptTitle');
  String get close => _t('close');
  String get comingSoonTitle => _t('comingSoonTitle');
  String get comingSoonMessage => _t('comingSoonMessage');
  String get bookmarkAddedTitle => _t('bookmarkAddedTitle');
  String get bookmarkRemovedTitle => _t('bookmarkRemovedTitle');
  String get languageToggleShort => _t('languageToggleShort');
  String get verseDetails => _t('verseDetails');

  String formatSurahAyah(String surahName, int ayahNumber) {
    if (isArabic) {
      return 'سورة $surahName · آية $ayahNumber';
    }
    return 'Surah $surahName · Ayah $ayahNumber';
  }

  String formatAyahNumber(int ayahNumber) {
    return isArabic ? 'آية $ayahNumber' : 'Ayah $ayahNumber';
  }

  String bookmarkAddedMessage(String surahName, int ayahNumber) {
    if (isArabic) {
      return 'تمت إضافة علامة الآية إلى سورة $surahName آية $ayahNumber.';
    }
    return 'Added bookmark for Surah $surahName, Ayah $ayahNumber.';
  }

  String bookmarkRemovedMessage(String surahName, int ayahNumber) {
    if (isArabic) {
      return 'تم حذف علامة الآية من سورة $surahName آية $ayahNumber.';
    }
    return 'Removed bookmark for Surah $surahName, Ayah $ayahNumber.';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ar' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
