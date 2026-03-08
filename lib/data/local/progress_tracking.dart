import 'package:hive_flutter/hive_flutter.dart';
import 'quran_local_database.dart';

class ProgressTracking {
  static final ProgressTracking _instance = ProgressTracking._internal();
  factory ProgressTracking() => _instance;
  ProgressTracking._internal();

  String _getDateKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> markAyahAsRead(int surahId, int ayahNumber) async {
    final box = Hive.box(QuranLocalDatabase.dailyProgressBox);
    final key = _getDateKey();
    
    List<String> readAyahs = box.get(key, defaultValue: <String>[])?.cast<String>() ?? <String>[];
    final ayahKey = '$surahId:$ayahNumber';
    
    if (!readAyahs.contains(ayahKey)) {
      readAyahs.add(ayahKey);
      await box.put(key, readAyahs);
    }
  }

  Future<int> getReadAyahsCountToday() async {
    final box = Hive.box(QuranLocalDatabase.dailyProgressBox);
    final key = _getDateKey();
    List<String> readAyahs = box.get(key, defaultValue: <String>[])?.cast<String>() ?? <String>[];
    return readAyahs.length;
  }

  Future<double> getProgressPercentage(int goalAyahs) async {
    if (goalAyahs <= 0) return 0.0;
    final count = await getReadAyahsCountToday();
    return (count / goalAyahs).clamp(0.0, 1.0);
  }
}
