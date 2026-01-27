import 'dart:convert';

import 'package:dependencies/sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quran/data/models/bookmark_verses_dto.dart';
import 'package:quran/data/models/last_read_surah_dto.dart';
import 'package:quran/data/utils/quran_text_normalizer.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  static const int _dbVersion = 2;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblLastReadSurah = 'lastReadSurah';
  static const String _tblBookmarkVerses = 'bookmarkVerses';
  static const String _tblQuranSurah = 'quranSurah';
  static const String _tblQuranAyah = 'quranAyah';
  static const String _tblQuranTranslation = 'quranTranslation';
  static const String _tblQuranFts = 'quranFts';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = '$path/quran.db';

    var db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblLastReadSurah (
        id INTEGER PRIMARY KEY,
        number INTEGER,
        surah TEXT,
        numberOfVerses INTEGER,
        revelation TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblBookmarkVerses (
        id INTEGER PRIMARY KEY,
        inSurah INTEGER,
        surah TEXT,
        audioUri TEXT,
        textArab TEXT,
        transliteration TEXT,
        translation TEXT
      );
    ''');

    await _createCoreTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createCoreTables(db);
    }
  }

  Future<void> _createCoreTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblQuranSurah (
        surah INTEGER PRIMARY KEY,
        nameAr TEXT,
        nameEn TEXT,
        ayahCount INTEGER,
        revelation TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblQuranAyah (
        surah INTEGER NOT NULL,
        ayah INTEGER NOT NULL,
        text TEXT NOT NULL,
        textNorm TEXT NOT NULL,
        PRIMARY KEY (surah, ayah)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblQuranTranslation (
        surah INTEGER NOT NULL,
        ayah INTEGER NOT NULL,
        languageCode TEXT NOT NULL,
        text TEXT NOT NULL,
        textNorm TEXT NOT NULL,
        PRIMARY KEY (surah, ayah, languageCode)
      );
    ''');
    await db.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS $_tblQuranFts
      USING fts5(
        textNorm,
        surah UNINDEXED,
        ayah UNINDEXED,
        tokenize = 'unicode61 remove_diacritics 2'
      );
    ''');
  }

  bool get _isLocalDbSupported {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows;
  }

  bool get isSupported => _isLocalDbSupported;

  Future<void> ensureQuranCoreData() async {
    if (!_isLocalDbSupported) {
      return;
    }
    final db = await database;
    if (db == null) {
      return;
    }
    await _createCoreTables(db);
    final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $_tblQuranAyah'),
        ) ??
        0;
    if (count >= 6236) {
      return;
    }
    await _seedQuranCore(db);
  }

  Future<void> _seedQuranCore(Database db) async {
    final textRaw = await rootBundle.loadString('assets/data/quran_text.json');
    final textPayload = jsonDecode(textRaw) as List<dynamic>;

    final surahRaw = await rootBundle.loadString('assets/data/surah_meta.json');
    final surahPayload = jsonDecode(surahRaw) as List<dynamic>;

    await db.delete(_tblQuranAyah);
    await db.delete(_tblQuranSurah);
    await db.delete(_tblQuranTranslation);
    await db.execute('DELETE FROM $_tblQuranFts');

    final surahBatch = db.batch();
    for (final item in surahPayload) {
      surahBatch.insert(_tblQuranSurah, {
        'surah': item['surah'],
        'nameAr': item['name_ar'],
        'nameEn': item['name_en'],
        'ayahCount': item['ayah_count'],
        'revelation': item['revelation'],
      });
    }
    await surahBatch.commit(noResult: true);

    final ayahBatch = db.batch();
    for (final item in textPayload) {
      final surah = item['surah'] as int;
      final ayah = item['ayah'] as int;
      final text = item['text'] as String;
      final normalized = QuranTextNormalizer.normalizeArabic(text);
      ayahBatch.insert(
        _tblQuranAyah,
        {
          'surah': surah,
          'ayah': ayah,
          'text': text,
          'textNorm': normalized,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      ayahBatch.insert(
        _tblQuranFts,
        {
          'textNorm': normalized,
          'surah': surah,
          'ayah': ayah,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await ayahBatch.commit(noResult: true);

    await _seedTranslations(db, 'en');
    await _seedTranslations(db, 'ar');
  }

  Future<void> _seedTranslations(Database db, String languageCode) async {
    try {
      final raw = await rootBundle
          .loadString('assets/data/translations/$languageCode.json');
      final payload = jsonDecode(raw) as List<dynamic>;
      final batch = db.batch();
      for (final item in payload) {
        final surah = item['surah'] as int;
        final ayah = item['ayah'] as int;
        final text = item['text'] as String;
        final normalized = QuranTextNormalizer.normalizeArabic(text);
        batch.insert(
          _tblQuranTranslation,
          {
            'surah': surah,
            'ayah': ayah,
            'languageCode': languageCode,
            'text': text,
            'textNorm': normalized,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (_) {
      // Ignore missing translation assets.
    }
  }

  Future<List<Map<String, dynamic>>> searchAyah(
    String ftsQuery, {
    int limit = 50,
    String languageCode = 'ar',
  }) async {
    final db = await database;
    if (db == null) {
      return [];
    }
    return db.rawQuery('''
      SELECT q.surah, q.ayah, q.text,
             s.nameAr AS surahNameAr, s.nameEn AS surahNameEn,
             t.text AS translation
      FROM $_tblQuranFts f
      JOIN $_tblQuranAyah q
        ON q.surah = f.surah AND q.ayah = f.ayah
      JOIN $_tblQuranSurah s
        ON s.surah = q.surah
      LEFT JOIN $_tblQuranTranslation t
        ON t.surah = q.surah AND t.ayah = q.ayah AND t.languageCode = ?
      WHERE f.textNorm MATCH ?
      LIMIT $limit;
    ''', [languageCode, ftsQuery]);
  }

  // LAST READ QURAN
  Future<int> insertLastReadQuran(LastReadSurahDTO lastRead) async {
    final db = await database;
    return await db!.insert(_tblLastReadSurah, lastRead.toJson());
  }

  Future<int> updateLastReadQuran(LastReadSurahDTO lastRead) async {
    final db = await database;
    return await db!
        .update(_tblLastReadSurah, lastRead.toJson(), where: 'id = 1');
  }

  Future<List<Map<String, dynamic>>> getLastReadQuran() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db!.query(_tblLastReadSurah, where: 'id = 1');

    return result;
  }

  // BOOKMARK VERSES
  Future<int> insertBookmarkVerses(BookmarkVersesDTO bookmark) async {
    final db = await database;
    return await db!.insert(_tblBookmarkVerses, bookmark.toJson());
  }

  Future<int> removeBookmarkVerses(BookmarkVersesDTO bookmark) async {
    final db = await database;
    return await db!.delete(
      _tblBookmarkVerses,
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }

  Future<List<Map<String, dynamic>>> getBookmarkVerses() async {
    final db = await database;
    return await db!.query(_tblBookmarkVerses);
  }

  Future<Map<String, dynamic>?> getBookmarkVerseById(int id) async {
    final db = await database;
    final result = await db!.query(
      _tblBookmarkVerses,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }
}
