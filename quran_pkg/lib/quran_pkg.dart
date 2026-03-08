import 'package:flutter/services.dart';

const String quranPkgIconAsset = 'assets/icon_quran.png';

Future<ByteData> loadQuranPkgIcon() {
  return rootBundle.load('packages/quran_pkg/$quranPkgIconAsset');
}
