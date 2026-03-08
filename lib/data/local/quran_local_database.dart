import 'package:hive_flutter/hive_flutter.dart';

class QuranLocalDatabase {
  static const String bookmarksBox = 'bookmarks_box';
  static const String notesBox = 'notes_box';
  static const String lastReadBox = 'last_read_box';
  static const String settingsBox = 'settings_box';
  static const String dailyProgressBox = 'daily_progress_box';

  Future<void> initDatabase() async {
    await Hive.initFlutter();
    
    // فتح الصناديق المختلفة الخاصة بالتطبيق
    await Hive.openBox(bookmarksBox);
    await Hive.openBox(notesBox);
    await Hive.openBox(lastReadBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(dailyProgressBox);
  }

  // عمليات الإشارات المرجعية
  Future<void> addBookmark(String ayahId) async {
    final box = Hive.box(bookmarksBox);
    await box.put(ayahId, true);
  }

  // عمليات الملاحظات
  Future<void> saveNote(String ayahId, String note) async {
    final box = Hive.box(notesBox);
    await box.put(ayahId, note);
  }

  // عملية حفظ آخر آية مقروءة
  Future<void> saveLastRead(String surahAndAyah) async {
    final box = Hive.box(lastReadBox);
    await box.put('last', surahAndAyah);
  }

  // إعدادات المستخدم (الخط، القارئ، إلخ)
  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBox);
    await box.put(key, value);
  }
}
