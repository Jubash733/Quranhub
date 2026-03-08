import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/local/quran_local_database.dart';
import '../../core/services/workmanager_service.dart';

class DailyReminderSettings {
  final bool isEnabled;
  final TimeOfDay reminderTime;
  final int partsGoal; // 1, 2, or 5 juz'

  DailyReminderSettings({
    required this.isEnabled,
    required this.reminderTime,
    required this.partsGoal,
  });

  DailyReminderSettings copyWith({
    bool? isEnabled,
    TimeOfDay? reminderTime,
    int? partsGoal,
  }) {
    return DailyReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      partsGoal: partsGoal ?? this.partsGoal,
    );
  }
}

class DailyReminderNotifier extends StateNotifier<DailyReminderSettings> {
  final WorkmanagerService _workmanagerService = WorkmanagerService();

  DailyReminderNotifier()
      : super(DailyReminderSettings(
          isEnabled: false,
          reminderTime: const TimeOfDay(hour: 8, minute: 0),
          partsGoal: 1,
        )) {
    _loadSettings();
  }

  void _loadSettings() {
    final box = Hive.box(QuranLocalDatabase.settingsBox);
    final isEnabled = box.get('daily_reminder_enabled', defaultValue: false);
    final hour = box.get('daily_reminder_hour', defaultValue: 8);
    final minute = box.get('daily_reminder_minute', defaultValue: 0);
    final partsGoal = box.get('daily_reminder_parts_goal', defaultValue: 1);

    state = DailyReminderSettings(
      isEnabled: isEnabled,
      reminderTime: TimeOfDay(hour: hour, minute: minute),
      partsGoal: partsGoal,
    );
  }

  Future<void> toggleEnabled(bool value) async {
    final box = Hive.box(QuranLocalDatabase.settingsBox);
    await box.put('daily_reminder_enabled', value);
    state = state.copyWith(isEnabled: value);
    
    if (value) {
      await _workmanagerService.scheduleDailyReminder(state.reminderTime);
    } else {
      await _workmanagerService.cancelDailyReminder();
    }
  }

  Future<void> updateTime(TimeOfDay time) async {
    final box = Hive.box(QuranLocalDatabase.settingsBox);
    await box.put('daily_reminder_hour', time.hour);
    await box.put('daily_reminder_minute', time.minute);
    state = state.copyWith(reminderTime: time);
    
    if (state.isEnabled) {
      await _workmanagerService.scheduleDailyReminder(time);
    }
  }

  Future<void> updatePartsGoal(int goal) async {
    final box = Hive.box(QuranLocalDatabase.settingsBox);
    await box.put('daily_reminder_parts_goal', goal);
    state = state.copyWith(partsGoal: goal);
  }
}

final dailyReminderProvider =
    StateNotifierProvider<DailyReminderNotifier, DailyReminderSettings>((ref) {
  return DailyReminderNotifier();
});
