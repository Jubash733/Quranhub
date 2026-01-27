import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('offline lookup by AyahRef returns text only', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      final file = File(key);
      if (!file.existsSync()) {
        return null;
      }
      final bytes = await file.readAsBytes();
      return ByteData.view(Uint8List.fromList(bytes).buffer);
    });

    final dataSource = QuranAssetDataSourceImpl();
    const refs = [
      AyahRef(surah: 1, ayah: 1),
      AyahRef(surah: 2, ayah: 255),
      AyahRef(surah: 3, ayah: 1),
    ];

    for (final ref in refs) {
      final ayah = await dataSource.getAyah(ref);
      expect(ayah, isNotNull);
      expect(ayah!.textArabic.isNotEmpty, true);

      final translation = await dataSource.getTranslation(ref, 'en');
      expect(translation == null || translation.isEmpty, true);
    }
  });
}
