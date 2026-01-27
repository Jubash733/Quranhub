import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:ai_assistant/presentation/cubit/ai_assistant_cubit.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _surahController = TextEditingController();
  final TextEditingController _ayahController = TextEditingController();

  @override
  void dispose() {
    _surahController.dispose();
    _ayahController.dispose();
    super.dispose();
  }

  void _generate(BuildContext context, String languageCode) {
    final surah = int.tryParse(_surahController.text.trim());
    final ayah = int.tryParse(_ayahController.text.trim());
    if (surah == null || ayah == null || surah <= 0 || ayah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unexpectedError)),
      );
      return;
    }
    context.read<AiAssistantCubit>().generate(
          AyahRef(surah: surah, ayah: ayah),
          languageCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        final isDarkTheme = prefSetProvider.isDarkTheme;
        final languageCode = prefSetProvider.locale.languageCode;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkTheme ? kDarkTheme : Colors.white,
            foregroundColor: isDarkTheme ? Colors.white : kDarkPurple,
            elevation: 0,
            title: Text(
              context.l10n.aiAssistant,
              style: kHeading6.copyWith(fontSize: 18),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: kMikadoYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: kMikadoYellow),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          context.l10n.aiDisclaimer,
                          style: kSubtitle.copyWith(
                            color: isDarkTheme ? kGreyLight : kDarkPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _surahController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.l10n.surah,
                          filled: true,
                          fillColor: isDarkTheme
                              ? kDarkPurple.withValues(alpha: 0.6)
                              : kGrey92,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: TextField(
                        controller: _ayahController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.l10n.ayah,
                          filled: true,
                          fillColor: isDarkTheme
                              ? kDarkPurple.withValues(alpha: 0.6)
                              : kGrey92,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _generate(context, languageCode),
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(context.l10n.aiGenerate),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: BlocBuilder<AiAssistantCubit, AiAssistantState>(
                    builder: (context, state) {
                      final status = state.status.status;
                      if (status.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (status.isError) {
                        return Center(
                          child: Text(
                            state.status.message.isNotEmpty
                                ? state.status.message
                                : context.l10n.unexpectedError,
                          ),
                        );
                      }
                      if (status.isHasData) {
                        final data = state.status.data!;
                        return SingleChildScrollView(
                          child: SelectableText(
                            data.response,
                            style: kHeading6.copyWith(
                              fontSize: 14.0,
                              height: 1.6,
                              color: isDarkTheme ? Colors.white : kDarkPurple,
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          context.l10n.aiPromptTitle,
                          style: kSubtitle.copyWith(
                            color: kGrey.withValues(alpha: 0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
