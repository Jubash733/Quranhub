import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/models/ayah_translation_dto.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class FakeTranslationRemoteDataSource implements TranslationRemoteDataSource {
  FakeTranslationRemoteDataSource(this.data);

  final Map<AyahRef, AyahTranslationDTO> data;

  @override
  Future<AyahTranslationDTO> getAyahTranslation(AyahRef ref) async {
    final result = data[ref];
    if (result == null) {
      throw Exception('Not found');
    }
    return result;
  }
}

void main() {
  test('returns translation for matching AyahRef', () async {
    const ref = AyahRef(surah: 1, ayah: 2);
    final dataSource = FakeTranslationRemoteDataSource({
      ref: AyahTranslationDTO(
        surahNumber: 1,
        ayahNumber: 2,
        translation: TranslationDTO(
          en: 'All praise is due to Allah',
          id: 'Segala puji',
        ),
      ),
    });
    final repository =
        TranslationRepositoryImpl(remoteDataSource: dataSource);

    final result = await repository.getAyahTranslation(ref);

    result.fold(
      (failure) => fail('Expected Right, got Left: ${failure.message}'),
      (data) {
        expect(data.ref, ref);
        expect(data.text, 'Segala puji');
        expect(data.languageCode, 'id');
      },
    );
  });

  test('returns failure when data source throws', () async {
    const ref = AyahRef(surah: 1, ayah: 999);
    final repository = TranslationRepositoryImpl(
        remoteDataSource: FakeTranslationRemoteDataSource({}));

    final result = await repository.getAyahTranslation(ref);

    result.fold(
      (failure) => expect(failure.message, contains('Exception')),
      (_) => fail('Expected Left'),
    );
  });

  test('returns failure when AyahRef mismatch occurs', () async {
    const ref = AyahRef(surah: 1, ayah: 1);
    final dataSource = FakeTranslationRemoteDataSource({
      ref: AyahTranslationDTO(
        surahNumber: 2,
        ayahNumber: 1,
        translation: TranslationDTO(en: 'en', id: 'id'),
      ),
    });
    final repository =
        TranslationRepositoryImpl(remoteDataSource: dataSource);

    final result = await repository.getAyahTranslation(ref);

    result.fold(
      (failure) => expect(failure.message, contains('AyahRef mismatch')),
      (_) => fail('Expected Left'),
    );
  });
}
