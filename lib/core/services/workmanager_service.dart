import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final notificationService = NotificationService();
    await notificationService.init();
    
    // Simulate checking if the user read their daily portion today via Hive.
    // If not, send the notification.
    await notificationService.showDailyReminder(
      'الورد اليومي',
      'حان وقت قراءة الورد اليومي من القران الكريم. لا تترك وردك!',
    );
    
    return Future.value(true);
  });
}

class WorkmanagerService {
  static final WorkmanagerService _instance = WorkmanagerService._internal();
  factory WorkmanagerService() => _instance;
  WorkmanagerService._internal();

  Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    final initialDelay = scheduledDate.difference(now);

    await Workmanager().cancelByUniqueName('daily_reminder_task');
    await Workmanager().registerPeriodicTask(
      'daily_reminder_task',
      'daily_reminder_task',
      frequency: const Duration(days: 1),
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
  }

  Future<void> cancelDailyReminder() async {
    await Workmanager().cancelByUniqueName('daily_reminder_task');
  }
}
