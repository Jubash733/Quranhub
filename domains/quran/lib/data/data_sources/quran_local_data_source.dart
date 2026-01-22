import 'package:flutter/foundation.dart';
import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/models/bookmark_verses_dto.dart';
import 'package:quran/data/models/last_read_surah_dto.dart';

abstract class QuranLocalDataSource {
  // LAST READ QURAN
  Future<String> insertLastRead(LastReadSurahDTO lastRead);
  Future<String> updateLastRead(LastReadSurahDTO lastRead);
  Future<List<LastReadSurahDTO>> getLastRead();
  // BOOKMARK VERSES
  Future<String> insertBookmarkVerses(BookmarkVersesDTO bookmark);
  Future<String> removeBookmarkVerses(BookmarkVersesDTO bookmark);
  Future<List<BookmarkVersesDTO>> getBookmarkVerses();
  Future<BookmarkVersesDTO?> getBookmarkVerseById(int id);
}

class QuranLocalDataSourceImpl extends QuranLocalDataSource {
  final DatabaseHelper databaseHelper;

  QuranLocalDataSourceImpl({required this.databaseHelper});

  bool get _isLocalDbSupported {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  Future<List<LastReadSurahDTO>> getLastRead() async {
    if (!_isLocalDbSupported) {
      return [];
    }
    final result = await databaseHelper.getLastReadQuran();
    return result.map((data) => LastReadSurahDTO.fromMap(data)).toList();
  }

  @override
  Future<String> insertLastRead(LastReadSurahDTO lastRead) async {
    if (!_isLocalDbSupported) {
      return 'Local storage unsupported';
    }
    try {
      await databaseHelper.insertLastReadQuran(lastRead);
      return 'Insert Last Read Quran';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateLastRead(LastReadSurahDTO lastRead) async {
    if (!_isLocalDbSupported) {
      return 'Local storage unsupported';
    }
    try {
      await databaseHelper.updateLastReadQuran(lastRead);
      return 'Update Last Read Quran';
    } catch (e) {
      rethrow;
    }
  }

  // BOOKMARK VERSES
  @override
  Future<List<BookmarkVersesDTO>> getBookmarkVerses() async {
    if (!_isLocalDbSupported) {
      return [];
    }
    final result = await databaseHelper.getBookmarkVerses();
    return result.map((data) => BookmarkVersesDTO.fromMap(data)).toList();
  }

  @override
  Future<String> insertBookmarkVerses(BookmarkVersesDTO bookmark) async {
    if (!_isLocalDbSupported) {
      return 'Local storage unsupported';
    }
    try {
      await databaseHelper.insertBookmarkVerses(bookmark);
      return 'Insert Bookmark Verses';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> removeBookmarkVerses(BookmarkVersesDTO bookmark) async {
    if (!_isLocalDbSupported) {
      return 'Local storage unsupported';
    }
    try {
      await databaseHelper.removeBookmarkVerses(bookmark);
      return 'Remove Bookmark Verses';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookmarkVersesDTO?> getBookmarkVerseById(int id) async {
    if (!_isLocalDbSupported) {
      return null;
    }
    try {
      final result = await databaseHelper.getBookmarkVerseById(id);

      if (result != null) {
        return BookmarkVersesDTO.fromMap(result);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
