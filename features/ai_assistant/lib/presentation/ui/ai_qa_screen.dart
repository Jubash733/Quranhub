import 'package:flutter/material.dart';
import 'package:core/network/ai_api.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class AiQaScreen extends StatefulWidget {
  const AiQaScreen({super.key});

  @override
  State<AiQaScreen> createState() => _AiQaScreenState();
}

class _AiQaScreenState extends State<AiQaScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _ask() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': question});
      _isLoading = true;
      _controller.clear();
    });

    final answer = await AiService().askQuran(question);

    setState(() {
      _messages.add({'role': 'ai', 'text': answer});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اسأل القرآن'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? (isDark ? kPurplePrimary : kGreyLight)
                          : (isDark ? kSecondarySeed : kMikadoYellow.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text']!,
                      style: kSubtitle.copyWith(
                        color: isDark ? Colors.white : kBlackPurple,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'مثلاً: ما هي صفات المؤمنين؟',
                      filled: true,
                      fillColor: isDark ? kDarkPurple : kGrey92,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : _ask,
                  icon: const Icon(Icons.send, color: kPurplePrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
