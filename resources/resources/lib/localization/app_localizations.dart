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
      'aiTadabbur': 'AI reflection',
      'aiRequestHint': 'What would you like to reflect on?',
      'aiNotConfigured': 'AI is not enabled. Add an API key to enable.',
      'aiHowToEnable': 'How to enable',
      'aiEnableTitle': 'Enable AI',
      'aiEnableInstructions':
          'To enable AI, pass dart defines when running/building:\n'
          'flutter run --dart-define=AI_BASE_URL=https://YOUR_PROVIDER --dart-define=AI_API_KEY=YOUR_KEY\n'
          'flutter build apk --debug --dart-define=AI_BASE_URL=https://YOUR_PROVIDER --dart-define=AI_API_KEY=YOUR_KEY\n'
          '\nYou can also set them in assets/config/app_config.json for local testing.',
      'myNotes': 'My notes',
      'tags': 'Tags',
      'tagsHint': 'Comma-separated tags',
      'tadabbur': 'Tadabbur',
      'myTadabbur': 'My reflection',
      'tadabburHint': 'Write your reflection here...',
      'save': 'Save',
      'tadabburSaved': 'Reflection saved',
      'tadabburDeleted': 'Reflection deleted',
      'useAiResponse': 'Use AI response',
      'surahInfo': 'Surah info',
      'mushafOrder': 'Mushaf order:',
      'revelationOrder': 'Revelation order:',
      'ayahCount': 'Ayah count:',
      'surahSummary': 'Summary',
      'surahSummaryUnavailable': 'No summary available yet',
      'meccan': 'Meccan',
      'medinan': 'Medinan',
      'audioConnectionError':
          'Audio connection failed. Check your internet or try another reciter.',
      'sourcesAndLicenses': 'Sources & licenses',
      'viewSources': 'View sources',
      'license': 'License',
      'sourceUrl': 'Source URL',
      'sourceDate': 'Date',
      'downloadPack': 'Download pack',
      'openLibrary': 'Open Library',
      'packNotInstalled': 'Pack not installed',
      'streamingOnly': 'Streaming only',
      'downloadNotAllowed': 'Download not allowed for this reciter',
      'packStorageLimit': 'Offline packs limit',
      'packStorageLimitHint': 'Limit for downloaded translations/tafsir',
      'packStorageLimitReached':
          'Storage limit reached. Increase it in settings.',
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
      'onlineContentSettings': 'Online content',
      'translationEdition': 'Translation edition',
      'tafsirEdition': 'Tafsir edition',
      'audioReciter': 'Reciter',
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
      'manageStorage': 'Storage',
      'audioStorage': 'Audio storage',
      'cacheSize': 'Cached audio size',
      'storageLimit': 'Cache limit: 500 MB',
      'clearAudioCache': 'Clear audio cache',
      'clearByReciter': 'Clear by reciter',
      'clearBySurah': 'Clear by surah',
      'cacheCleared': 'Cache cleared',
      'play': 'Play',
      'playSurah': 'Play surah from start',
      'audioPlaying': 'Now playing',
      'audioSettings': 'Audio settings',
      'reciterSearchHint': 'Search reciter...',
      'downloadRecitation': 'Download surah recitation',
      'downloadInProgress': 'Downloading...',
      'downloadCompleted': 'Download completed',
      'downloadFailed': 'Download failed',
      'playbackSpeed': 'Playback speed',
      'repeatCount': 'Repeat count',
      'sleepTimer': 'Sleep timer',
      'minutes': 'min',
      'off': 'Off',
      'fontUthmani': 'Uthmani',
      'farsiLanguage': 'Farsi',
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
      'aiTadabbur': 'تدبر بالذكاء الاصطناعي',
      'aiRequestHint': '\u0627\u0643\u062a\u0628 \u0637\u0644\u0628\u0643 \u0644\u0644\u062a\u0623\u0645\u0644...?',
      'aiNotConfigured': '\u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u063a\u064a\u0631 \u0645\u0641\u0639\u0644. \u0623\u0636\u0641 \u0645\u0641\u062a\u0627\u062d API \u0644\u0644\u062a\u0641\u0639\u064a\u0644.',
      'aiHowToEnable': '\u0643\u064a\u0641\u064a\u0629 \u0627\u0644\u062a\u0641\u0639\u064a\u0644',
      'aiEnableTitle': '\u062a\u0641\u0639\u064a\u0644 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a',
      'aiEnableInstructions':
          '\u0644\u062a\u0641\u0639\u064a\u0644 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0623\u0636\u0641 dart-define \u0639\u0646\u062f \u0627\u0644\u062a\u0634\u063a\u064a\u0644/\u0627\u0644\u0628\u0646\u0627\u0621:\n'
          'flutter run --dart-define=AI_BASE_URL=https://YOUR_PROVIDER --dart-define=AI_API_KEY=YOUR_KEY\n'
          'flutter build apk --debug --dart-define=AI_BASE_URL=https://YOUR_PROVIDER --dart-define=AI_API_KEY=YOUR_KEY\n'
          '\n\u064a\u0645\u0643\u0646\u0643 \u0623\u064a\u0636\u064b\u0627 \u0636\u0628\u0637\u0647\u0627 \u0641\u064a assets/config/app_config.json \u0644\u0644\u0627\u062e\u062a\u0628\u0627\u0631 \u0627\u0644\u0645\u062d\u0644\u064a.',
      'myNotes': '\u0645\u0644\u0627\u062d\u0638\u0627\u062a\u064a',
      'tags': '\u0627\u0644\u0648\u0633\u0648\u0645',
      'tagsHint': '\u0627\u0643\u062a\u0628 \u0627\u0644\u0648\u0633\u0648\u0645 \u0645\u0641\u0635\u0648\u0644\u0629 \u0628\u0641\u0648\u0627\u0635\u0644',
      'tadabbur': 'التدبر',
      'myTadabbur': 'تدبري الشخصي',
      'tadabburHint': 'اكتب تدبرك هنا...',
      'save': 'حفظ',
      'tadabburSaved': 'تم حفظ التدبر',
      'tadabburDeleted': 'تم حذف التدبر',
      'useAiResponse': 'استخدم رد الذكاء',
      'surahInfo': 'معلومات السورة',
      'mushafOrder': 'ترتيب المصحف:',
      'revelationOrder': '\u062a\u0631\u062a\u064a\u0628 \u0627\u0644\u0646\u0632\u0648\u0644:',
      'ayahCount': 'عدد الآيات:',
      'surahSummary': 'نبذة',
      'surahSummaryUnavailable': 'لا توجد نبذة متاحة حالياً',
      'meccan': 'مكية',
      'medinan': 'مدنية',
      'audioConnectionError':
          'تعذر الاتصال بالصوت. تحقق من الإنترنت أو جرّب قارئًا آخر.',
      'sourcesAndLicenses': 'المصادر والتراخيص',
      'viewSources': 'عرض المصادر',
      'license': 'الترخيص',
      'sourceUrl': 'رابط المصدر',
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
      'onlineContentSettings': 'المحتوى عبر الانترنت',
      'translationEdition': 'نسخة الترجمة',
      'tafsirEdition': 'نسخة التفسير',
      'audioReciter': 'القارئ',
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
      'manageStorage': 'التخزين',
      'audioStorage': 'تخزين الصوت',
      'cacheSize': 'حجم كاش الصوت',
      'storageLimit': 'الحد الأقصى للكاش: ٥٠٠ م.ب',
      'clearAudioCache': 'مسح كاش الصوت',
      'clearByReciter': 'حذف حسب القارئ',
      'clearBySurah': 'حذف حسب السورة',
      'cacheCleared': 'تم مسح الكاش',
      'play': 'تشغيل',
      'playSurah': 'تشغيل السورة من البداية',
      'audioPlaying': 'يتم التشغيل',
      'audioSettings': 'إعدادات الصوت',
      'reciterSearchHint': '\u0627\u0628\u062d\u062b \u0639\u0646 \u0627\u0644\u0642\u0627\u0631\u0626...',
      'downloadRecitation': '\u062a\u0646\u0632\u064a\u0644 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u0633\u0648\u0631\u0629',
      'downloadInProgress': '\u062c\u0627\u0631\u064a \u0627\u0644\u062a\u0646\u0632\u064a\u0644...',
      'downloadCompleted': '\u0627\u0643\u062a\u0645\u0644 \u0627\u0644\u062a\u0646\u0632\u064a\u0644',
      'downloadFailed': '\u0641\u0634\u0644 \u0627\u0644\u062a\u0646\u0632\u064a\u0644',
      'playbackSpeed': 'سرعة التشغيل',
      'repeatCount': 'عدد التكرار',
      'sleepTimer': 'مؤقت النوم',
      'minutes': 'دق',
      'off': 'إيقاف',
      'fontUthmani': 'عثماني',
      'farsiLanguage': 'فارسي',
    },
    'fa': {
      'appTitle': 'برنامه قرآن',
      'greetingAssalam': 'سلام علیکم',
      'greetingWelcome': 'خوش آمدید',
      'lastRead': 'آخرین خوانده شده',
      'surah': 'سوره',
      'ayah': 'آیه',
      'startNow': 'شروع کنید',
      'onboardingSubtitle': 'قرآن را بیاموزید و روزانه بخوانید',
      'noData': 'داده‌ای موجود نیست',
      'loading': 'در حال بارگذاری...',
      'unexpectedError': 'خطای غیرمنتظره',
      'bookmarksTitle': 'آیات نشان‌دار شده',
      'bookmarksEmpty': 'هنوز نشانی وجود ندارد',
      'translation': 'ترجمه',
      'tafsir': 'تفسیر',
      'noTranslation': 'ترجمه‌ای وجود ندارد',
      'noTafsir': 'تفسیری وجود ندارد',
      'translationErrorTitle': 'بارگذاری ترجمه ممکن نیست',
      'tafsirErrorTitle': 'بارگذاری تفسیر ممکن نیست',
      'retry': 'تلاش مجدد',
      'copy': 'کپی کردن',
      'share': 'اشتراک‌گذاری',
      'showTafsir': 'نمایش تفسیر',
      'copied': 'کپی شد',
      'search': 'جستجو',
      'searchHint': 'جستجو در قرآن...',
      'searchResults': 'نتایج جستجو',
      'noResults': 'نتیجه‌ای یافت نشد',
      'searchPreparingTitle': 'آماده‌سازی جستجو',
      'searchPreparingMessage': 'ایجاد نمایه جستجو.',
      'aiAssistant': 'تدبر هوش مصنوعی',
      'aiDisclaimer': 'خروجی هوش مصنوعی صرفاً راهنماست نه فتوا.',
      'aiGenerate': 'تولید',
      'aiPromptTitle': 'دستورالعمل هوش مصنوعی',
      'aiTadabbur': 'تأمل هوش مصنوعی',
      'aiRequestHint': 'مایل هستید در چه موردی تأمل کنید؟',
      'aiNotConfigured': 'هوش مصنوعی فعال نیست و به کلید API نیاز دارد.',
      'aiHowToEnable': 'نحوه فعال‌سازی',
      'aiEnableTitle': 'فعال‌سازی هوش مصنوعی',
      'aiEnableInstructions': 'راهنما...',
      'myNotes': 'یادداشت‌های من',
      'tags': 'برچسب‌ها',
      'tagsHint': 'برچسب‌های جدا شده با کاما',
      'tadabbur': 'تدبر',
      'myTadabbur': 'تأمل من',
      'tadabburHint': 'تأمل خود را اینجا بنویسید...',
      'save': 'ذخیره',
      'tadabburSaved': 'تأمل ذخیره شد',
      'tadabburDeleted': 'تأمل حذف شد',
      'useAiResponse': 'پاسخ هوش مصنوعی',
      'surahInfo': 'اطلاعات سوره',
      'mushafOrder': 'ترتیب مصحف:',
      'revelationOrder': 'ترتیب نزول:',
      'ayahCount': 'تعداد آیات:',
      'surahSummary': 'خلاصه',
      'surahSummaryUnavailable': 'هنوز خلاصه‌ای موجود نیست',
      'meccan': 'مکيه',
      'medinan': 'مدنیه',
      'audioConnectionError': 'خطای اتصال صوتی.',
      'sourcesAndLicenses': 'منابع و مجوزها',
      'viewSources': 'منابع',
      'license': 'مجوز',
      'sourceUrl': 'آدرس منبع',
      'sourceDate': 'تاریخ',
      'downloadPack': 'دانلود بسته',
      'openLibrary': 'کتابخانه',
      'packNotInstalled': 'بسته نصب نشده است',
      'streamingOnly': 'فقط پخش زنده',
      'downloadNotAllowed': 'مجاز نیست',
      'packStorageLimit': 'محدودیت بسته‌ها',
      'packStorageLimitHint': 'محدودیت',
      'packStorageLimitReached': 'محدودیت تکمیل شده است.',
      'close': 'بستن',
      'comingSoonTitle': 'به زودی',
      'comingSoonMessage': 'وقتی آماده شد به شما اطلاع خواهیم داد.',
      'bookmarkAddedTitle': 'نشان افزوده شد',
      'bookmarkRemovedTitle': 'نشان حذف شد',
      'languageToggleShort': 'FA',
      'verseDetails': 'جزئیات آیه',
      'settings': 'تنظیمات',
      'savedTitle': 'ذخیره شده',
      'fontSize': 'اندازه قلم',
      'fontFamily': 'نوع قلم',
      'fontAmiri': 'امیری',
      'fontCairo': 'کایرو',
      'fontUthmani': 'عثمانی',
      'translationToggle': 'نمایش ترجمه',
      'tafsirToggle': 'نمایش تفسیر',
      'appearance': 'ظاهر',
      'darkMode': 'حالت تاریک',
      'contentDisabled': 'غیرفعال شده‌اند.',
      'onlineContentSettings': 'محتوای آنلاین',
      'translationEdition': 'ویرایش ترجمه',
      'tafsirEdition': 'ویرایش تفسیر',
      'audioReciter': 'قاری',
      'lastReadEmptyTitle': 'هنوز خوانده نشده است',
      'lastReadEmptyMessage': 'خواندن را شروع کنید...',
      'language': 'زبان',
      'arabicLanguage': 'عربی',
      'englishLanguage': 'انگلیسی',
      'farsiLanguage': 'فارسی',
      'library': 'کتابخانه',
      'libraryManage': 'مدیریت کتابخانه',
      'librarySearchHint': 'جستجوی کتاب‌ها...',
      'libraryEmpty': 'این قسمت خالی است.',
      'usedSpace': 'فضای استفاده شده',
      'clearAll': 'حذف همه',
      'download': 'دانلود',
      'open': 'باز کردن',
      'delete': 'حذف',
      'pause': 'توقف',
      'resume': 'ادامه',
      'cancel': 'لغو',
      'timeRemaining': 'زمان باقیمانده',
      'speed': 'سرعت',
      'onlineOnly': 'فقط آنلاین',
      'unavailable': 'ناموجود',
      'libraryTabTafsir': 'تفاسیر',
      'libraryTabTranslations': 'ترجمه‌ها',
      'libraryTabAsbab': 'اسباب النزول',
      'libraryTabIrab': 'اعراب',
      'libraryTabTopics': 'موضوعات',
      'libraryTabQiraat': 'قرائت‌ها',
      'manageStorage': 'ذخیره‌سازی',
      'audioStorage': 'ذخیره صوت',
      'cacheSize': 'حجم کش صوت',
      'storageLimit': 'محدودیت: 500 مگابایت',
      'clearAudioCache': 'حذف کش صوتی',
      'clearByReciter': 'بر اساس قاری',
      'clearBySurah': 'بر اساس سوره',
      'cacheCleared': 'کش حذف شد',
      'play': 'پخش',
      'playSurah': 'پخش از ابتدا',
      'audioPlaying': 'در حال پخش',
      'audioSettings': 'تنظیمات صوتی',
      'reciterSearchHint': 'جستجوی قاری...',
      'downloadRecitation': 'دانلود تلاوت سوره',
      'downloadInProgress': 'در حال دانلود...',
      'downloadCompleted': 'دانلود موفق شد',
      'downloadFailed': 'دانلود با شکست مواجه شد',
      'playbackSpeed': 'سرعت پخش',
      'repeatCount': 'تعداد تکرار',
      'sleepTimer': 'تایمر خواب',
      'minutes': 'دقیقه',
      'off': 'خاموش',
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
  String get aiTadabbur => _t('aiTadabbur');
  String get aiRequestHint => _t('aiRequestHint');
  String get aiNotConfigured => _t('aiNotConfigured');
  String get aiHowToEnable => _t('aiHowToEnable');
  String get aiEnableTitle => _t('aiEnableTitle');
  String get aiEnableInstructions => _t('aiEnableInstructions');
  String get myNotes => _t('myNotes');
  String get tags => _t('tags');
  String get tagsHint => _t('tagsHint');
  String get tadabbur => _t('tadabbur');
  String get myTadabbur => _t('myTadabbur');
  String get tadabburHint => _t('tadabburHint');
  String get save => _t('save');
  String get tadabburSaved => _t('tadabburSaved');
  String get tadabburDeleted => _t('tadabburDeleted');
  String get useAiResponse => _t('useAiResponse');
  String get surahInfo => _t('surahInfo');
  String get mushafOrder => _t('mushafOrder');
  String get revelationOrder => _t('revelationOrder');
  String get ayahCount => _t('ayahCount');
  String get surahSummary => _t('surahSummary');
  String get surahSummaryUnavailable => _t('surahSummaryUnavailable');
  String get meccan => _t('meccan');
  String get medinan => _t('medinan');
  String get audioConnectionError => _t('audioConnectionError');
  String get sourcesAndLicenses => _t('sourcesAndLicenses');
  String get viewSources => _t('viewSources');
  String get license => _t('license');
  String get sourceUrl => _t('sourceUrl');
  String get sourceDate => _t('sourceDate');
  String get downloadPack => _t('downloadPack');
  String get openLibrary => _t('openLibrary');
  String get packNotInstalled => _t('packNotInstalled');
  String get streamingOnly => _t('streamingOnly');
  String get downloadNotAllowed => _t('downloadNotAllowed');
  String get packStorageLimit => _t('packStorageLimit');
  String get packStorageLimitHint => _t('packStorageLimitHint');
  String get packStorageLimitReached => _t('packStorageLimitReached');
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
  String get onlineContentSettings => _t('onlineContentSettings');
  String get translationEdition => _t('translationEdition');
  String get tafsirEdition => _t('tafsirEdition');
  String get audioReciter => _t('audioReciter');
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
  String get manageStorage => _t('manageStorage');
  String get audioStorage => _t('audioStorage');
  String get cacheSize => _t('cacheSize');
  String get storageLimit => _t('storageLimit');
  String get clearAudioCache => _t('clearAudioCache');
  String get clearByReciter => _t('clearByReciter');
  String get clearBySurah => _t('clearBySurah');
  String get cacheCleared => _t('cacheCleared');
  String get play => _t('play');
  String get playSurah => _t('playSurah');
  String get audioPlaying => _t('audioPlaying');
  String get audioSettings => _t('audioSettings');
  String get reciterSearchHint => _t('reciterSearchHint');
  String get downloadRecitation => _t('downloadRecitation');
  String get downloadInProgress => _t('downloadInProgress');
  String get downloadCompleted => _t('downloadCompleted');
  String get downloadFailed => _t('downloadFailed');
  String get playbackSpeed => _t('playbackSpeed');
  String get repeatCount => _t('repeatCount');
  String get sleepTimer => _t('sleepTimer');
  String get minutes => _t('minutes');
  String get off => _t('off');

  String get farsiLanguage => _t('farsiLanguage');
  String get fontUthmani => _t('fontUthmani');

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
      locale.languageCode == 'ar' || locale.languageCode == 'en' || locale.languageCode == 'fa';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}










