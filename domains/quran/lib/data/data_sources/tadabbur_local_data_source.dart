import 'dart:convert';

import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';

class TadabburLocalDataSource {
  static const String _prefix = 'tadabbur_note';
  static const String _indexPrefix = 'tadabbur_index';

  Future<TadabburNoteEntity?> getNote(
    AyahRef ref,
    String languageCode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(ref, languageCode));
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final payload = jsonDecode(raw);
      if (payload is! Map<String, dynamic>) {
        return null;
      }
      final text = payload['text'] as String? ?? '';
      final updatedAtMillis = payload['updatedAt'] as int? ?? 0;
      final createdAtMillis = payload['createdAt'] as int? ?? updatedAtMillis;
      final tags = _readTags(payload['tags']);
      if (text.trim().isEmpty) {
        return null;
      }
      return TadabburNoteEntity(
        ref: ref,
        text: text,
        languageCode: languageCode,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMillis),
        tags: tags,
      );
    } catch (_) {
      return null;
    }
  }

  Future<TadabburNoteEntity> saveNote(
    AyahRef ref,
    String languageCode,
    String text, {
    List<String> tags = const [],
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = text.trim();
    final existingPayload = _readPayload(prefs.getString(_key(ref, languageCode)));
    final existingCreatedAt = existingPayload?['createdAt'] as int?;
    final existingTags = _readTags(existingPayload?['tags']);
    final now = DateTime.now();
    final createdAtMillis = existingCreatedAt ?? now.millisecondsSinceEpoch;
    final resolvedTags = tags.isNotEmpty ? tags : existingTags;
    final payload = {
      'text': trimmed,
      'createdAt': createdAtMillis,
      'updatedAt': now.millisecondsSinceEpoch,
      'tags': resolvedTags,
      'surah': ref.surah,
      'ayah': ref.ayah,
    };
    await prefs.setString(_key(ref, languageCode), jsonEncode(payload));
    await _ensureIndex(prefs, ref, languageCode);
    return TadabburNoteEntity(
      ref: ref,
      text: trimmed,
      languageCode: languageCode,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      updatedAt: now,
      tags: resolvedTags,
    );
  }

  Future<void> deleteNote(AyahRef ref, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(ref, languageCode));
    await _removeFromIndex(prefs, ref, languageCode);
  }

  Future<List<TadabburNoteEntity>> listNotes(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    final indexKey = _indexKey(languageCode);
    var keys = prefs.getStringList(indexKey) ?? <String>[];
    if (keys.isEmpty) {
      keys = prefs
          .getKeys()
          .where((key) => key.startsWith('$_prefix:$languageCode:'))
          .toList();
      if (keys.isNotEmpty) {
        await prefs.setStringList(indexKey, keys);
      }
    }
    final notes = <TadabburNoteEntity>[];
    for (final key in keys) {
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) {
        continue;
      }
      final payload = _readPayload(raw);
      if (payload == null) {
        continue;
      }
      final text = payload['text'] as String? ?? '';
      if (text.trim().isEmpty) {
        continue;
      }
      final ref = _parseRef(key, payload);
      if (ref == null) {
        continue;
      }
      final updatedAtMillis = payload['updatedAt'] as int? ?? 0;
      final createdAtMillis = payload['createdAt'] as int? ?? updatedAtMillis;
      notes.add(
        TadabburNoteEntity(
          ref: ref,
          text: text,
          languageCode: languageCode,
          createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMillis),
          tags: _readTags(payload['tags']),
        ),
      );
    }
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  String _key(AyahRef ref, String languageCode) {
    final resolvedLanguage = languageCode.isEmpty ? 'ar' : languageCode;
    return '$_prefix:$resolvedLanguage:${ref.surah}:${ref.ayah}';
  }

  String _indexKey(String languageCode) {
    final resolvedLanguage = languageCode.isEmpty ? 'ar' : languageCode;
    return '$_indexPrefix:$resolvedLanguage';
  }

  Map<String, dynamic>? _readPayload(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final payload = jsonDecode(raw);
      if (payload is Map<String, dynamic>) {
        return payload;
      }
    } catch (_) {}
    return null;
  }

  List<String> _readTags(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return raw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  AyahRef? _parseRef(String key, Map<String, dynamic> payload) {
    final surah = payload['surah'];
    final ayah = payload['ayah'];
    if (surah is int && ayah is int) {
      return AyahRef(surah: surah, ayah: ayah);
    }
    final segments = key.split(':');
    if (segments.length >= 4) {
      final surahParsed = int.tryParse(segments[2]);
      final ayahParsed = int.tryParse(segments[3]);
      if (surahParsed != null && ayahParsed != null) {
        return AyahRef(surah: surahParsed, ayah: ayahParsed);
      }
    }
    return null;
  }

  Future<void> _ensureIndex(
    SharedPreferences prefs,
    AyahRef ref,
    String languageCode,
  ) async {
    final indexKey = _indexKey(languageCode);
    final key = _key(ref, languageCode);
    final keys = prefs.getStringList(indexKey) ?? <String>[];
    if (!keys.contains(key)) {
      final updated = [...keys, key];
      await prefs.setStringList(indexKey, updated);
    }
  }

  Future<void> _removeFromIndex(
    SharedPreferences prefs,
    AyahRef ref,
    String languageCode,
  ) async {
    final indexKey = _indexKey(languageCode);
    final key = _key(ref, languageCode);
    final keys = prefs.getStringList(indexKey) ?? <String>[];
    if (keys.contains(key)) {
      final updated = [...keys]..remove(key);
      await prefs.setStringList(indexKey, updated);
    }
  }
}
