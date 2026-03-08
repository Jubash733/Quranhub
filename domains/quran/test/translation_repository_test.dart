import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_pack_data_source.dart';
import 'package:quran/data/data_sources/translation_cache_data_source.dart';
import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/models/translation_cache_entry.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';

class FakePackDataSource implements QuranPackDataSource {
  FakePackDataSource(this.translationPacks);

  final Map<String, Map<String, String>> translationPacks;

  @override
  Future<List<PackManifestItem>> getManifest() async {
    return [];
  }

  @override
  Future<bool> isPackAvailable(String editionId) async {
    return translationPacks.containsKey(editionId);
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String editionId) async {
    return translationPacks[editionId]?['${ref.surah}:${ref.ayah}'];
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String editionId) async {
    return null;
  }
}

class FakeTranslationCacheDataSource implements TranslationCacheDataSource {
  FakeTranslationCacheDataSource();

  final Map<String, TranslationCacheEntry> cache = {};

  @override
  Future<TranslationCacheEntry?> getCachedTranslation(
    AyahRef ref, {
    required String languageCode,
    required String edition,
  }) async {
    return cache['$edition:$languageCode:${ref.surah}:${ref.ayah}'];
  }

  @override
  Future<void> cacheTranslation(
    AyahRef ref, {
    required String languageCode,
    required String edition,
    required String text,
  }) async {
    cache['$edition:$languageCode:${ref.surah}:${ref.ayah}'] =
        TranslationCacheEntry(
      text: text,
      edition: edition,
      updatedAtMillis: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> clearTranslations(String languageCode) async {
    cache.removeWhere((key, _) => key.contains(':$languageCode:'));
  }

  @override
  DatabaseHelper get databaseHelper => throw UnimplementedError();
}

class FakeAppSettingsRepository implements AppSettingsRepository {
  FakeAppSettingsRepository();

  AppSettingsEntity _settings = AppSettingsEntity(
    translationEdition: 'en.sahih',
    translationLanguage: 'en',
    tafsirEdition: 'ar.muyassar',
    tafsirLanguage: 'ar',
    audioEdition: 'ar.alafasy',
    updatedAt: DateTime(2025, 1, 1),
  );

  @override
  Future<AppSettingsEntity> getSettings() async => _settings;

  @override
  Stream<AppSettingsEntity> watchSettings() async* {
    yield _settings;
  }

  @override
  Future<void> updateAudioEdition(String edition) async {
    _settings = AppSettingsEntity(
      translationEdition: _settings.translationEdition,
      translationLanguage: _settings.translationLanguage,
      tafsirEdition: _settings.tafsirEdition,
      tafsirLanguage: _settings.tafsirLanguage,
      audioEdition: edition,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> updateTafsirEdition(String edition, String languageCode) async {
    _settings = AppSettingsEntity(
      translationEdition: _settings.translationEdition,
      translationLanguage: _settings.translationLanguage,
      tafsirEdition: edition,
      tafsirLanguage: languageCode,
      audioEdition: _settings.audioEdition,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> updateTranslationEdition(
    String edition,
    String languageCode,
  ) async {
    _settings = AppSettingsEntity(
      translationEdition: edition,
      translationLanguage: languageCode,
      tafsirEdition: _settings.tafsirEdition,
      tafsirLanguage: _settings.tafsirLanguage,
      audioEdition: _settings.audioEdition,
      updatedAt: DateTime.now(),
    );
  }
}

void main() {
  test('returns translation from offline pack when cache empty', () async {
    const ref = AyahRef(surah: 1, ayah: 2);
    final packDataSource = FakePackDataSource({
      'en.sahih': {'1:2': 'All praise is due to Allah'},
    });
    final repository = TranslationRepositoryImpl(
      cacheDataSource: FakeTranslationCacheDataSource(),
      packDataSource: packDataSource,
      settingsRepository: FakeAppSettingsRepository(),
    );

    final result = await repository.getAyahTranslation(ref, languageCode: 'ar');

    result.fold(
      (failure) => fail('Expected Right, got Left: ${failure.message}'),
      (data) {
        expect(data.ref, ref);
        expect(data.text, 'All praise is due to Allah');
        expect(data.languageCode, 'ar');
      },
    );
  });

  test('returns failure when pack missing', () async {
    const ref = AyahRef(surah: 1, ayah: 999);
    final repository = TranslationRepositoryImpl(
      cacheDataSource: FakeTranslationCacheDataSource(),
      packDataSource: FakePackDataSource({}),
      settingsRepository: FakeAppSettingsRepository(),
    );

    final result = await repository.getAyahTranslation(ref, languageCode: 'ar');

    result.fold(
      (failure) => expect(failure.message, 'PACK_UNAVAILABLE'),
      (_) => fail('Expected Left'),
    );
  });
}
