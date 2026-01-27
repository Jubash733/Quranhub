import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/ai_assistant_local_data_source.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AI cache uses promptType and promptVersion in key', () async {
    final memoryCache = <String, AiTadabburEntity>{};
    final dataSource = AiAssistantLocalDataSource(inMemoryCache: memoryCache);
    const ref = AyahRef(surah: 1, ayah: 1);
    final entity = AiTadabburEntity(
      ref: ref,
      response: 'test',
      languageCode: 'ar',
      createdAt: DateTime.now(),
      promptType: 'tadabbur',
      promptVersion: 'v1',
    );

    await dataSource.cache(entity);

    final cachedSame =
        await dataSource.getCached(ref, 'ar', 'v1', 'tadabbur');
    final cachedDifferentVersion =
        await dataSource.getCached(ref, 'ar', 'v2', 'tadabbur');
    final cachedDifferentType =
        await dataSource.getCached(ref, 'ar', 'v1', 'summary');

    expect(cachedSame, isNotNull);
    expect(cachedSame!.response, 'test');
    expect(cachedDifferentVersion, isNull);
    expect(cachedDifferentType, isNull);
  });
}
