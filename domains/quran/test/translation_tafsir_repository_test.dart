import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_pack_data_source.dart';
import 'package:quran/data/data_sources/tafsir_cache_data_source.dart';
import 'package:quran/data/data_sources/translation_cache_data_source.dart';
import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/models/tafsir_cache_model.dart';
import 'package:quran/data/models/translation_cache_entry.dart';
import 'package:quran/data/repositories/tafsir_repository_impl.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/data/storage/quran_cache_isar_service.dart';
import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';

class FakePackDataSource implements QuranPackDataSource {
  FakePackDataSource({
    required this.translationPacks,
    required this.tafsirPacks,
  });

  final Map<String, Map<String, String>> translationPacks;
  final Map<String, Map<String, String>> tafsirPacks;

  @override
  Future<List<PackManifestItem>> getManifest() async {
    return [];
  }

  @override
  Future<bool> isPackAvailable(String editionId) async {
    return translationPacks.containsKey(editionId) ||
        tafsirPacks.containsKey(editionId);
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String editionId) async {
    return translationPacks[editionId]?['${ref.surah}:${ref.ayah}'];
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String editionId) async {
    return tafsirPacks[editionId]?['${ref.surah}:${ref.ayah}'];
  }
}

class FakeTranslationCacheDataSource implements TranslationCacheDataSource {
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

class FakeTafsirCacheDataSource implements TafsirCacheDataSource {
  final Map<String, TafsirCacheModel> cache = {};

  @override
  Future<TafsirCacheModel?> getCachedTafsir(
    AyahRef ref, {
    required String languageCode,
    required String edition,
  }) async {
    return cache['$edition:$languageCode:${ref.surah}:${ref.ayah}'];
  }

  @override
  Future<void> cacheTafsir(
    AyahRef ref, {
    required String languageCode,
    required String edition,
    required String text,
  }) async {
    final model = TafsirCacheModel()
      ..key = '$edition:$languageCode:${ref.surah}:${ref.ayah}'
      ..surah = ref.surah
      ..ayah = ref.ayah
      ..languageCode = languageCode
      ..edition = edition
      ..text = text
      ..updatedAt = DateTime.now();
    cache[model.key] = model;
  }

  @override
  Future<void> clearAll() async {
    cache.clear();
  }

  @override
  QuranCacheIsarService get isarService => throw UnimplementedError();
}

class FakeAppSettingsRepository implements AppSettingsRepository {
  FakeAppSettingsRepository({
    required this.translationEdition,
    required this.translationLanguage,
    required this.tafsirEdition,
    required this.tafsirLanguage,
    required this.audioEdition,
  });

  final String translationEdition;
  final String translationLanguage;
  final String tafsirEdition;
  final String tafsirLanguage;
  final String audioEdition;

  @override
  Future<AppSettingsEntity> getSettings() async => AppSettingsEntity(
        translationEdition: translationEdition,
        translationLanguage: translationLanguage,
        tafsirEdition: tafsirEdition,
        tafsirLanguage: tafsirLanguage,
        audioEdition: audioEdition,
        updatedAt: DateTime(2025, 1, 1),
      );

  @override
  Stream<AppSettingsEntity> watchSettings() async* {
    yield await getSettings();
  }

  @override
  Future<void> updateAudioEdition(String edition) async {}

  @override
  Future<void> updateTafsirEdition(String edition, String languageCode) async {}

  @override
  Future<void> updateTranslationEdition(
    String edition,
    String languageCode,
  ) async {}
}

void main() {
  test('translation and tafsir repositories return different text', () async {
    const ref = AyahRef(surah: 1, ayah: 2);
    final packDataSource = FakePackDataSource(
      translationPacks: {
        'en.sahih': {'1:2': 'Translation text'},
      },
      tafsirPacks: {
        'ar.muyassar': {'1:2': 'Tafsir text'},
      },
    );
    final settingsRepository = FakeAppSettingsRepository(
      translationEdition: 'en.sahih',
      translationLanguage: 'en',
      tafsirEdition: 'ar.muyassar',
      tafsirLanguage: 'ar',
      audioEdition: 'ar.alafasy',
    );
    final translationRepository = TranslationRepositoryImpl(
      cacheDataSource: FakeTranslationCacheDataSource(),
      packDataSource: packDataSource,
      settingsRepository: settingsRepository,
    );
    final tafsirRepository = TafsirRepositoryImpl(
      cacheDataSource: FakeTafsirCacheDataSource(),
      packDataSource: packDataSource,
      settingsRepository: settingsRepository,
    );

    final translationResult =
        await translationRepository.getAyahTranslation(ref, languageCode: 'en');
    final tafsirResult =
        await tafsirRepository.getAyahTafsir(ref, languageCode: 'ar');

    String? translationText;
    String? tafsirText;

    translationResult.fold(
      (failure) => fail('Expected translation, got ${failure.message}'),
      (data) => translationText = data.text,
    );
    tafsirResult.fold(
      (failure) => fail('Expected tafsir, got ${failure.message}'),
      (data) => tafsirText = data.text,
    );

    expect(translationText, 'Translation text');
    expect(tafsirText, 'Tafsir text');
    expect(translationText, isNot(equals(tafsirText)));
  });
}
