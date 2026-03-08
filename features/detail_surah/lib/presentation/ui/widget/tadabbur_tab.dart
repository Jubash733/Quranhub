import 'package:ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

import 'package:detail_surah/presentation/cubits/tadabbur/tadabbur_cubit.dart';

class TadabburTab extends StatefulWidget {
  const TadabburTab({
    super.key,
    required this.ref,
    required this.languageCode,
    required this.prefSetProvider,
  });

  final AyahRef ref;
  final String languageCode;
  final PreferenceSettingsProvider prefSetProvider;

  @override
  State<TadabburTab> createState() => _TadabburTabState();
}

class _TadabburTabState extends State<TadabburTab> {
  late final TextEditingController _controller;
  String _loadedKey = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController(TadabburState state) {
    final key =
        '${widget.languageCode}:${widget.ref.surah}:${widget.ref.ayah}';
    if (_loadedKey == key) return;
    if (state.status.status.isHasData) {
      _controller.text = state.status.data?.text ?? '';
      _loadedKey = key;
    }
  }

  Future<void> _saveNote() async {
    final error = await context.read<TadabburCubit>().saveNote(
          widget.ref,
          widget.languageCode,
          _controller.text,
        );
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.tadabburSaved)),
    );
  }

  Future<void> _deleteNote() async {
    final error = await context
        .read<TadabburCubit>()
        .deleteNote(widget.ref, widget.languageCode);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.tadabburDeleted)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = widget.prefSetProvider.isDarkTheme;
    return BlocBuilder<TadabburCubit, TadabburState>(
      builder: (context, state) {
        _syncController(state);
        final noteText = state.status.data?.text ?? '';
        final isBusy = state.isSaving || state.isDeleting;
        final surfaceColor = isDarkTheme
            ? kDarkPurple.withValues(alpha: 0.4)
            : kGrey92;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.myTadabbur,
                style: kHeading6.copyWith(
                  fontSize: 14.0,
                  color: isDarkTheme ? Colors.white : kDarkPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: context.l10n.tadabburHint,
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isBusy ? null : _saveNote,
                      icon: state.isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(context.l10n.save),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  if (noteText.trim().isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: isBusy ? null : _deleteNote,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(context.l10n.delete),
                    ),
                ],
              ),
              const SizedBox(height: 18.0),
              Text(
                context.l10n.aiTadabbur,
                style: kHeading6.copyWith(
                  fontSize: 14.0,
                  color: isDarkTheme ? Colors.white : kDarkPurple,
                ),
              ),
              const SizedBox(height: 8.0),
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
              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context
                      .read<AiAssistantCubit>()
                      .generate(widget.ref, widget.languageCode),
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(context.l10n.aiGenerate),
                ),
              ),
              const SizedBox(height: 12.0),
              BlocBuilder<AiAssistantCubit, AiAssistantState>(
                builder: (context, aiState) {
                  final status = aiState.status.status;
                  if (status.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (status.isError) {
                    final isNotConfigured =
                        aiState.status.message == 'AI_NOT_CONFIGURED';
                    if (isNotConfigured) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.aiNotConfigured,
                            style: kSubtitle.copyWith(
                              color: isDarkTheme ? kGreyLight : kDarkPurple,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          OutlinedButton.icon(
                            onPressed: () => _showAiEnableHelp(context),
                            icon: const Icon(Icons.info_outline),
                            label: Text(context.l10n.aiHowToEnable),
                          ),
                        ],
                      );
                    }
                    return Text(
                      aiState.status.message.isNotEmpty
                          ? aiState.status.message
                          : context.l10n.unexpectedError,
                      style: kSubtitle.copyWith(
                        color: isDarkTheme ? kGreyLight : kDarkPurple,
                      ),
                    );
                  }
                  if (status.isHasData) {
                    final response = aiState.status.data?.response ?? '';
                    if (response.trim().isEmpty) {
                      return Text(
                        context.l10n.aiPromptTitle,
                        style: kSubtitle.copyWith(
                          color: kGrey.withValues(alpha: 0.7),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          response,
                          style: kHeading6.copyWith(
                            fontSize: 14.0,
                            height: 1.6,
                            color: isDarkTheme ? Colors.white : kDarkPurple,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () {
                                  _controller.text = response;
                                },
                          icon: const Icon(Icons.note_add_outlined),
                          label: Text(context.l10n.useAiResponse),
                        ),
                      ],
                    );
                  }
                  return Text(
                    context.l10n.aiPromptTitle,
                    style: kSubtitle.copyWith(
                      color: kGrey.withValues(alpha: 0.7),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAiEnableHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        final isDarkTheme =
            Theme.of(sheetContext).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.0,
            20.0,
            20.0,
            28.0 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetContext.l10n.aiEnableTitle,
                style: kHeading6.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: isDarkTheme ? Colors.white : kDarkPurple,
                ),
              ),
              const SizedBox(height: 10.0),
              SelectableText(
                sheetContext.l10n.aiEnableInstructions,
                style: kSubtitle.copyWith(
                  height: 1.5,
                  color: isDarkTheme ? kGreyLight : kDarkPurple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
