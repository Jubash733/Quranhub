import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/ai_assistant_local_data_source.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AI cache uses promptVersion in key', () async {
    SharedPreferences.setMockInitialValues({});
    final dataSource = AiAssistantLocalDataSource();
    const ref = AyahRef(surah: 1, ayah: 1);
    final entity = AiTadabburEntity(
      ref: ref,
      response: 'test',
      languageCode: 'ar',
      createdAt: DateTime(2024, 1, 1),
      promptVersion: 'v1',
    );

    await dataSource.cache(entity);

    final cachedSame = await dataSource.getCached(ref, 'ar', 'v1');
    final cachedDifferent = await dataSource.getCached(ref, 'ar', 'v2');

    expect(cachedSame, isNotNull);
    expect(cachedSame!.response, 'test');
    expect(cachedDifferent, isNull);
  });
}
