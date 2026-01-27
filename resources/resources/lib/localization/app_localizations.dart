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
      'searchPreparingTitle': 'Preparing search',
      'searchPreparingMessage': 'Building the search index. This runs once.',
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
      'settings': 'Settings',
      'savedTitle': 'Saved',
      'fontSize': 'Font size',
      'fontFamily': 'Font family',
      'fontAmiri': 'Amiri',
      'fontCairo': 'Cairo',
      'translationToggle': 'Show translation',
      'tafsirToggle': 'Show tafsir',
      'appearance': 'Appearance',
      'darkMode': 'Dark mode',
      'contentDisabled': 'Translation and tafsir are disabled in settings.',
      'lastReadEmptyTitle': 'No last read yet',
      'lastReadEmptyMessage': 'Start reading to see your progress here.',
      'language': 'Language',
      'arabicLanguage': 'Arabic',
      'englishLanguage': 'English',
      'library': 'Library',
      'libraryManage': 'Manage Library',
      'librarySearchHint': 'Search books...',
      'libraryEmpty': 'No items in this category yet.',
      'usedSpace': 'Used space',
      'clearAll': 'Clear all',
      'download': 'Download',
      'open': 'Open',
      'delete': 'Delete',
      'pause': 'Pause',
      'resume': 'Resume',
      'cancel': 'Cancel',
      'timeRemaining': 'Time remaining',
      'speed': 'Speed',
      'onlineOnly': 'Available online only',
      'unavailable': 'Unavailable',
      'libraryTabTafsir': 'Tafsir',
      'libraryTabTranslations': 'Translations',
      'libraryTabAsbab': 'Asbab',
      'libraryTabIrab': 'I‘rab',
      'libraryTabTopics': 'Topics',
      'libraryTabQiraat': 'Qiraat',
    },
    'ar': {
      'appTitle': 'تطبيق القرآن',
      'greetingAssalam': 'السلام عليكم',
      'greetingWelcome': 'أهلًا وسهلًا',
      'lastRead': 'آخر قراءة',
      'surah': 'سورة',
      'ayah': 'آية',
      'startNow': 'ابدأ الآن',
      'onboardingSubtitle': 'تعلّم القرآن وداوم على قراءته يوميًا',
      'noData': 'لا توجد بيانات',
      'loading': 'جارٍ التحميل',
      'unexpectedError': 'حدث خطأ غير متوقع',
      'bookmarksTitle': 'الآيات المحفوظة',
      'bookmarksEmpty': 'لا توجد إشارات بعد',
      'translation': 'الترجمة',
      'tafsir': 'التفسير',
      'noTranslation': 'لا توجد ترجمة',
      'noTafsir': 'لا يوجد تفسير',
      'translationErrorTitle': 'تعذّر تحميل الترجمة',
      'tafsirErrorTitle': 'تعذّر تحميل التفسير',
      'retry': 'إعادة المحاولة',
      'copy': 'نسخ',
      'share': 'مشاركة',
      'showTafsir': 'عرض التفسير',
      'copied': 'تم النسخ',
      'search': 'بحث',
      'searchHint': 'ابحث في القرآن...',
      'searchResults': 'نتائج البحث',
      'noResults': 'لا توجد نتائج',
      'searchPreparingTitle': 'جاري إعداد البحث',
      'searchPreparingMessage': 'يتم الآن بناء فهرس البحث لمرة واحدة.',
      'aiAssistant': 'مساعد التدبّر',
      'aiDisclaimer': 'مخرجات مساعدة وليست فتوى.',
      'aiGenerate': 'إنشاء',
      'aiPromptTitle': 'نص الطلب',
      'close': 'إغلاق',
      'comingSoonTitle': 'قريبًا',
      'comingSoonMessage': 'سنبلغك فور جاهزية هذه الميزة.',
      'bookmarkAddedTitle': 'تمت إضافة العلامة',
      'bookmarkRemovedTitle': 'تمت إزالة العلامة',
      'languageToggleShort': 'EN',
      'verseDetails': 'تفاصيل الآية',
      'settings': 'الإعدادات',
      'savedTitle': 'المحفوظات',
      'fontSize': 'حجم الخط',
      'fontFamily': 'نوع الخط',
      'fontAmiri': 'أميري',
      'fontCairo': 'كايرو',
      'translationToggle': 'إظهار الترجمة',
      'tafsirToggle': 'إظهار التفسير',
      'appearance': 'المظهر',
      'darkMode': 'الوضع الداكن',
      'contentDisabled': 'الترجمة والتفسير معطّلان في الإعدادات.',
      'lastReadEmptyTitle': 'لا توجد قراءة سابقة',
      'lastReadEmptyMessage': 'ابدأ القراءة لتظهر هنا.',
      'language': 'اللغة',
      'arabicLanguage': 'العربية',
      'englishLanguage': 'الإنجليزية',
      'library': 'المكتبة',
      'libraryManage': 'إدارة المكتبة',
      'librarySearchHint': 'ابحث في الكتب...',
      'libraryEmpty': 'لا توجد عناصر في هذا القسم بعد.',
      'usedSpace': 'المساحة المستخدمة',
      'clearAll': 'حذف الكل',
      'download': 'تنزيل',
      'open': 'فتح',
      'delete': 'حذف',
      'pause': 'إيقاف مؤقت',
      'resume': 'استئناف',
      'cancel': 'إلغاء',
      'timeRemaining': 'الوقت المتبقي',
      'speed': 'السرعة',
      'onlineOnly': 'متاح عبر الإنترنت فقط',
      'unavailable': 'غير متاح',
      'libraryTabTafsir': 'تفاسير',
      'libraryTabTranslations': 'تراجم',
      'libraryTabAsbab': 'أسباب النزول',
      'libraryTabIrab': 'إعراب',
      'libraryTabTopics': 'موضوعات',
      'libraryTabQiraat': 'قراءات',
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
  String get searchPreparingTitle => _t('searchPreparingTitle');
  String get searchPreparingMessage => _t('searchPreparingMessage');
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
  String get settings => _t('settings');
  String get savedTitle => _t('savedTitle');
  String get fontSize => _t('fontSize');
  String get fontFamily => _t('fontFamily');
  String get fontAmiri => _t('fontAmiri');
  String get fontCairo => _t('fontCairo');
  String get translationToggle => _t('translationToggle');
  String get tafsirToggle => _t('tafsirToggle');
  String get appearance => _t('appearance');
  String get darkMode => _t('darkMode');
  String get contentDisabled => _t('contentDisabled');
  String get lastReadEmptyTitle => _t('lastReadEmptyTitle');
  String get lastReadEmptyMessage => _t('lastReadEmptyMessage');
  String get language => _t('language');
  String get arabicLanguage => _t('arabicLanguage');
  String get englishLanguage => _t('englishLanguage');
  String get library => _t('library');
  String get libraryManage => _t('libraryManage');
  String get librarySearchHint => _t('librarySearchHint');
  String get libraryEmpty => _t('libraryEmpty');
  String get usedSpace => _t('usedSpace');
  String get clearAll => _t('clearAll');
  String get download => _t('download');
  String get open => _t('open');
  String get delete => _t('delete');
  String get pause => _t('pause');
  String get resume => _t('resume');
  String get cancel => _t('cancel');
  String get timeRemaining => _t('timeRemaining');
  String get speed => _t('speed');
  String get onlineOnly => _t('onlineOnly');
  String get unavailable => _t('unavailable');
  String get libraryTabTafsir => _t('libraryTabTafsir');
  String get libraryTabTranslations => _t('libraryTabTranslations');
  String get libraryTabAsbab => _t('libraryTabAsbab');
  String get libraryTabIrab => _t('libraryTabIrab');
  String get libraryTabTopics => _t('libraryTabTopics');
  String get libraryTabQiraat => _t('libraryTabQiraat');

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
