import 'package:flutter_test/flutter_test.dart';

import 'package:quran_pkg/quran_pkg.dart';

void main() {
  test('quran package asset path is stable', () {
    expect(quranPkgIconAsset, 'assets/icon_quran.png');
  });
}
