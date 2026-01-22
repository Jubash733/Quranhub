import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class FakeTranslationRemoteDataSource implements TranslationRemoteDataSource {
  FakeTranslationRemoteDataSource(this.data);

  final Map<AyahRef, TranslationDTO> data;

  @override
  Future<TranslationDTO> getAyahTranslation(AyahRef ref) async {
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
      ref: TranslationDTO(en: 'All praise is due to Allah', id: 'Segala puji'),
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
    const ref = AyahRef(surah: 99, ayah: 1);
    final repository = TranslationRepositoryImpl(
        remoteDataSource: FakeTranslationRemoteDataSource({}));

    final result = await repository.getAyahTranslation(ref);

    result.fold(
      (failure) => expect(failure.message, contains('Exception')),
      (_) => fail('Expected Left'),
    );
  });
}
