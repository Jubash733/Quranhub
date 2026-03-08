import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/daily_reminder_provider.dart';
import 'package:resources/localization/app_localizations.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class DailyReminderScreen extends ConsumerWidget {
  const DailyReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(dailyReminderProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الورد اليومي'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(
            context,
            isDark,
            child: SwitchListTile(
              title: Text(
                'تفعيل التنبيهات',
                style: kHeading6.copyWith(
                  color: isDark ? Colors.white : kBlackPurple,
                ),
              ),
              subtitle: const Text('تلقي تنبيه يومي للقراءة'),
              value: settings.isEnabled,
              onChanged: (value) =>
                  ref.read(dailyReminderProvider.notifier).toggleEnabled(value),
              activeColor: kPurplePrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            isDark,
            child: ListTile(
              title: Text(
                'وقت التنبيه',
                style: kHeading6.copyWith(
                  color: isDark ? Colors.white : kBlackPurple,
                ),
              ),
              trailing: Text(
                settings.reminderTime.format(context),
                style: kSubtitle.copyWith(color: kPurplePrimary, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: settings.reminderTime,
                );
                if (time != null) {
                  ref.read(dailyReminderProvider.notifier).updateTime(time);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'الهدف اليومي (عدد الأجزاء)',
                    style: kHeading6.copyWith(
                      color: isDark ? Colors.white : kBlackPurple,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [1, 2, 5].map((parts) {
                      final isSelected = settings.partsGoal == parts;
                      return ChoiceChip(
                        label: Text('$parts أجزاء'),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(dailyReminderProvider.notifier).updatePartsGoal(parts);
                          }
                        },
                        selectedColor: kPurplePrimary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : kBlackPurple,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? kDarkPurple.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
