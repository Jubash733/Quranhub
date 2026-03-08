import 'dart:convert';

import 'package:dependencies/sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:common/utils/helper/asset_warning_helper.dart';
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

  // Dev note: bump this when changing DB/FTS schema to force rebuild on device.
  static const int _dbVersion = 3;

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
  static const String _tblMeta = 'quranMeta';
  static const String _metaFtsAvailable = 'fts_available';
  static const List<String> _ftsRequiredColumns = [
    'arabicNorm',
    'translationArNorm',
    'translationEnNorm',
    'surah',
    'ayah',
  ];

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
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS $_tblQuranTranslation');
      await db.execute('DROP TABLE IF EXISTS $_tblQuranFts');
      await db.execute('DROP TABLE IF EXISTS $_tblMeta');
      await _createCoreTables(db);
    }
  }

  Future<void> _createCoreTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblMeta (
        key TEXT PRIMARY KEY,
        value TEXT
      );
    ''');
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
        edition TEXT NOT NULL,
        text TEXT NOT NULL,
        textNorm TEXT NOT NULL,
        updatedAt INTEGER NOT NULL,
        PRIMARY KEY (surah, ayah, languageCode)
      );
    ''');
    var ftsAvailable = true;
    try {
      await db.execute('''
        CREATE VIRTUAL TABLE IF NOT EXISTS $_tblQuranFts
        USING fts5(
          arabicNorm,
          translationArNorm,
          translationEnNorm,
          surah UNINDEXED,
          ayah UNINDEXED,
          tokenize = 'unicode61 remove_diacritics 2'
        );
      ''');
    } catch (_) {
      ftsAvailable = false;
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_tblQuranFts (
          surah INTEGER NOT NULL,
          ayah INTEGER NOT NULL,
          arabicNorm TEXT,
          translationArNorm TEXT,
          translationEnNorm TEXT,
          PRIMARY KEY (surah, ayah)
        );
      ''');
    }
    await _setMeta(
      db,
      _metaFtsAvailable,
      ftsAvailable ? '1' : '0',
    );
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
    await _ensureFtsSchema(db);
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
    final textPayload = await _loadJsonList('assets/data/quran_text.json');
    final surahPayload = await _loadJsonList('assets/data/surah_meta.json');
    if (textPayload == null || surahPayload == null) {
      return;
    }

    await db.delete(_tblQuranAyah);
    await db.delete(_tblQuranSurah);
    await db.delete(_tblQuranTranslation);
    await db.execute('DELETE FROM $_tblQuranFts');
    await _setMeta(db, 'fts_version', '0');

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
    }
    await ayahBatch.commit(noResult: true);
  }

  Future<List<dynamic>?> _loadJsonList(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final payload = jsonDecode(raw);
      if (payload is! List) {
        AssetWarningHelper.reportInvalidAsset(assetPath);
        return null;
      }
      return payload;
    } catch (e) {
      if (AssetWarningHelper.isMissingAssetError(e)) {
        AssetWarningHelper.reportMissingAsset(assetPath);
      } else {
        AssetWarningHelper.reportInvalidAsset(assetPath);
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchAyah(
    String ftsQuery, {
    required List<String> tokens,
    int limit = 50,
    String languageCode = 'ar',
    String? edition,
  }) async {
    final db = await database;
    if (db == null) {
      return [];
    }
    final ftsAvailable = await _isFtsAvailable(db);
    if (!ftsAvailable) {
      if (tokens.isEmpty) {
        return [];
      }
      final clauses = <String>[];
      final args = <Object?>[languageCode, edition, edition];
      for (final token in tokens) {
        clauses.add('(q.textNorm LIKE ? OR t.textNorm LIKE ?)');
        args.add('%$token%');
        args.add('%$token%');
      }
      final where = clauses.join(' AND ');
      return db.rawQuery('''
        SELECT q.surah, q.ayah, q.text,
               s.nameAr AS surahNameAr, s.nameEn AS surahNameEn,
               t.text AS translation
        FROM $_tblQuranAyah q
        JOIN $_tblQuranSurah s
          ON s.surah = q.surah
        LEFT JOIN $_tblQuranTranslation t
          ON t.surah = q.surah AND t.ayah = q.ayah AND t.languageCode = ?
          AND (? IS NULL OR t.edition = ?)
        WHERE $where
        LIMIT $limit;
      ''', args);
    }
    return db.rawQuery('''
      SELECT q.surah, q.ayah, q.text,
             s.nameAr AS surahNameAr, s.nameEn AS surahNameEn,
             t.text AS translation
      FROM $_tblQuranFts
      JOIN $_tblQuranAyah q
        ON q.surah = $_tblQuranFts.surah AND q.ayah = $_tblQuranFts.ayah
      JOIN $_tblQuranSurah s
        ON s.surah = q.surah
      LEFT JOIN $_tblQuranTranslation t
        ON t.surah = q.surah AND t.ayah = q.ayah AND t.languageCode = ?
        AND (? IS NULL OR t.edition = ?)
      WHERE $_tblQuranFts MATCH ?
      LIMIT $limit;
    ''', [languageCode, edition, edition, ftsQuery]);
  }

  Future<bool> isSearchIndexReady() async {
    final db = await database;
    if (db == null) return false;
    final row = await _getMeta(db, 'fts_version');
    return row == _dbVersion.toString();
  }

  Stream<double> buildSearchIndex() async* {
    final db = await database;
    if (db == null) {
      yield 1;
      return;
    }
    await db.execute('DELETE FROM $_tblQuranFts');
    final total = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $_tblQuranAyah'),
        ) ??
        0;
    if (total == 0) {
      await _setMeta(db, 'fts_version', _dbVersion.toString());
      yield 1;
      return;
    }
    const batchSize = 250;
    var offset = 0;
    while (offset < total) {
      final rows = await db.query(
        _tblQuranAyah,
        columns: ['surah', 'ayah', 'textNorm'],
        limit: batchSize,
        offset: offset,
      );
      final batch = db.batch();
      for (final row in rows) {
        final payload = {
          'arabicNorm': row['textNorm'],
          'translationArNorm': '',
          'translationEnNorm': '',
          'surah': row['surah'],
          'ayah': row['ayah'],
        };
        batch.insert(
          _tblQuranFts,
          payload,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
      offset += rows.length;
      yield offset / total;
    }
    await _setMeta(db, 'fts_version', _dbVersion.toString());
    yield 1;
  }

  Future<Map<String, dynamic>?> getCachedTranslation({
    required int surah,
    required int ayah,
    required String languageCode,
    required String edition,
  }) async {
    final db = await database;
    if (db == null) return null;
    final rows = await db.query(
      _tblQuranTranslation,
      where: 'surah = ? AND ayah = ? AND languageCode = ? AND edition = ?',
      whereArgs: [surah, ayah, languageCode, edition],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<void> upsertTranslationCache({
    required int surah,
    required int ayah,
    required String languageCode,
    required String edition,
    required String text,
  }) async {
    final db = await database;
    if (db == null) return;
    final normalized = QuranTextNormalizer.normalizeForSearch(text);
    await db.insert(
      _tblQuranTranslation,
      {
        'surah': surah,
        'ayah': ayah,
        'languageCode': languageCode,
        'edition': edition,
        'text': text,
        'textNorm': normalized,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final column =
        languageCode == 'ar' ? 'translationArNorm' : 'translationEnNorm';
    await db.update(
      _tblQuranFts,
      {column: normalized},
      where: 'surah = ? AND ayah = ?',
      whereArgs: [surah, ayah],
    );
  }

  Future<void> clearTranslations(String languageCode) async {
    final db = await database;
    if (db == null) return;
    await db.delete(
      _tblQuranTranslation,
      where: 'languageCode = ?',
      whereArgs: [languageCode],
    );
    final column =
        languageCode == 'ar' ? 'translationArNorm' : 'translationEnNorm';
    await db.execute("UPDATE $_tblQuranFts SET $column = ''");
  }

  Future<bool> _isFtsAvailable(Database db) async {
    final actualIsFts = await _isFtsVirtualTable(db);
    final row = await _getMeta(db, _metaFtsAvailable);
    if (row == null) {
      await _setMeta(db, _metaFtsAvailable, actualIsFts ? '1' : '0');
      return actualIsFts;
    }
    if (row == '1' && !actualIsFts) {
      await _setMeta(db, _metaFtsAvailable, '0');
      return false;
    }
    if (row == '0' && actualIsFts) {
      await _setMeta(db, _metaFtsAvailable, '1');
      return true;
    }
    return row == '1';
  }

  Future<bool> _isFtsVirtualTable(Database db) async {
    final rows = await db.rawQuery(
      'SELECT sql FROM sqlite_master WHERE name = ?',
      [_tblQuranFts],
    );
    if (rows.isEmpty) {
      return false;
    }
    final sql = (rows.first['sql'] as String?)?.toLowerCase() ?? '';
    return sql.contains('virtual table') && sql.contains('fts');
  }

  Future<String?> _getMeta(Database db, String key) async {
    final rows = await db.query(
      _tblMeta,
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first['value'] as String? : null;
  }

  Future<void> _setMeta(Database db, String key, String value) async {
    await db.insert(
      _tblMeta,
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _ensureFtsSchema(Database db) async {
    final required = _ftsRequiredColumns.toSet();
    var hasAll = false;
    try {
      final columns = await db.rawQuery('PRAGMA table_info($_tblQuranFts)');
      if (columns.isNotEmpty) {
        final names = columns
            .map((row) => row['name'] as String?)
            .whereType<String>()
            .toSet();
        hasAll = required.every(names.contains);
      } else {
        final rows = await db.rawQuery(
          'SELECT sql FROM sqlite_master WHERE name = ?',
          [_tblQuranFts],
        );
        final sql = (rows.isNotEmpty ? rows.first['sql'] : '')?.toString() ?? '';
        final normalized = sql.toLowerCase();
        hasAll = required.every(
          (column) => normalized.contains(column.toLowerCase()),
        );
      }
    } catch (_) {
      hasAll = false;
    }
    if (hasAll) {
      return;
    }
    await db.execute('DROP TABLE IF EXISTS $_tblQuranFts');
    await _createCoreTables(db);
    await _setMeta(db, 'fts_version', '0');
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
