import 'package:flutter/material.dart';
import 'package:core/network/ai_api.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class AiMoodScreen extends StatefulWidget {
  const AiMoodScreen({super.key});

  @override
  State<AiMoodScreen> createState() => _AiMoodScreenState();
}

class _AiMoodScreenState extends State<AiMoodScreen> {
  String? _mood;
  String? _response;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _moods = [
    {'name': 'حزين', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.blue},
    {'name': 'خائف', 'icon': Icons.warning_amber_rounded, 'color': Colors.orange},
    {'name': 'فرحان', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.green},
    {'name': 'قلق', 'icon': Icons.query_builder, 'color': Colors.purple},
    {'name': 'وحيد', 'icon': Icons.person_outline, 'color': Colors.indigo},
  ];

  Future<void> _getVerses(String mood) async {
    setState(() {
      _mood = mood;
      _isLoading = true;
      _response = null;
    });

    final verses = await AiService().getMoodVerses(mood);

    setState(() {
      _response = verses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('آيات حسب مزاجك'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _moods.map((moodData) {
                final isSelected = _mood == moodData['name'];
                return InkWell(
                  onTap: () => _getVerses(moodData['name']),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? moodData['color'].withValues(alpha: 0.2) : (isDark ? kDarkPurple : kGrey92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? moodData['color'] : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(moodData['icon'], color: isSelected ? moodData['color'] : kGrey),
                        const SizedBox(height: 4),
                        Text(moodData['name'], style: kSubtitle.copyWith(color: isDark ? Colors.white : kBlackPurple)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _response == null
                    ? Center(
                        child: Text(
                          'اختر شعورك لنقترح لك آيات من القرآن',
                          style: kSubtitle.copyWith(color: kGrey),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? kDarkPurple.withValues(alpha: 0.4) : kMikadoYellow.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SelectableText(
                                _response!,
                                style: kSubtitle.copyWith(
                                  color: isDark ? Colors.white : kBlackPurple,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'مخرجات مساعدة وليست فتوى',
                              style: kSubtitle.copyWith(color: Colors.red, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
