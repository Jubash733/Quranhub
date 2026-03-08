import 'package:ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:ai_assistant/presentation/cubit/tadabbur_notes_cubit.dart';
import 'package:ai_assistant/presentation/ui/ai_qa_screen.dart';
import 'package:ai_assistant/presentation/ui/ai_mood_screen.dart';
import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/surah_entity.dart';
import 'package:quran/domain/usecases/get_surah_usecase.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:detail_surah/presentation/cubits/tadabbur/tadabbur_cubit.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen>
    with SingleTickerProviderStateMixin {
  final _sl = GetIt.instance;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  List<SurahEntity> _surahs = const [];
  SurahEntity? _selectedSurah;
  int? _selectedAyah;
  bool _loadingSurah = true;
  String _loadedNoteKey = '';
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSurahs();
    final languageCode = context
        .read<PreferenceSettingsProvider>()
        .locale
        .languageCode;
    context.read<TadabburNotesCubit>().loadNotes(languageCode: languageCode);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _tagsController.dispose();
    _promptController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    if (!_loadingSurah) return;
    final result = await _sl<GetSurahUsecase>().call();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _surahs = const [];
        _loadingSurah = false;
      }),
      (data) {
        setState(() {
          _surahs = data;
          _selectedSurah = data.isNotEmpty ? data.first : null;
          _selectedAyah = _selectedSurah?.numberOfVerses == 0 ? null : 1;
          _loadingSurah = false;
        });
        _loadNoteForSelection();
      },
    );
  }

  void _loadNoteForSelection() {
    final surah = _selectedSurah;
    final ayah = _selectedAyah;
    if (surah == null || ayah == null) return;
    final languageCode = context
        .read<PreferenceSettingsProvider>()
        .locale
        .languageCode;
    context.read<TadabburCubit>().loadNote(
          AyahRef(surah: surah.number, ayah: ayah),
          languageCode,
        );
  }

  void _onSurahChanged(SurahEntity? surah) {
    if (surah == null) return;
    setState(() {
      _selectedSurah = surah;
      _selectedAyah = 1;
      _loadedNoteKey = '';
    });
    context.read<AiAssistantCubit>().reset();
    _loadNoteForSelection();
  }

  void _onAyahChanged(int? ayah) {
    if (ayah == null) return;
    setState(() {
      _selectedAyah = ayah;
      _loadedNoteKey = '';
    });
    context.read<AiAssistantCubit>().reset();
    _loadNoteForSelection();
  }

  List<int> _ayahOptions() {
    final count = _selectedSurah?.numberOfVerses ?? 0;
    if (count <= 0) return const [];
    return List<int>.generate(count, (index) => index + 1);
  }

  AyahRef? _currentRef() {
    final surah = _selectedSurah;
    final ayah = _selectedAyah;
    if (surah == null || ayah == null) return null;
    return AyahRef(surah: surah.number, ayah: ayah);
  }

  Future<void> _saveNote() async {
    final ref = _currentRef();
    if (ref == null) return;
    final languageCode = context
        .read<PreferenceSettingsProvider>()
        .locale
        .languageCode;
    final tags = _parseTags(_tagsController.text);
    final error = await context.read<TadabburCubit>().saveNote(
          ref,
          languageCode,
          _noteController.text,
          tags: tags,
        );
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    context.read<TadabburNotesCubit>().loadNotes(languageCode: languageCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.tadabburSaved)),
    );
  }

  Future<void> _deleteNote() async {
    final ref = _currentRef();
    if (ref == null) return;
    final languageCode = context
        .read<PreferenceSettingsProvider>()
        .locale
        .languageCode;
    final error = await context
        .read<TadabburCubit>()
        .deleteNote(ref, languageCode);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    _noteController.clear();
    _tagsController.clear();
    context.read<TadabburNotesCubit>().loadNotes(languageCode: languageCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.tadabburDeleted)),
    );
  }

  void _generateAi(BuildContext context) {
    final ref = _currentRef();
    if (ref == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unexpectedError)),
      );
      return;
    }
    final languageCode = context
        .read<PreferenceSettingsProvider>()
        .locale
        .languageCode;
    context.read<AiAssistantCubit>().generate(
          ref,
          languageCode,
          userPrompt: _promptController.text,
        );
  }

  void _syncNoteControllers(TadabburState state) {
    final ref = _currentRef();
    if (ref == null) return;
    final key = '${ref.surah}:${ref.ayah}';
    if (_loadedNoteKey == key) return;
    if (!state.status.status.isHasData) return;
    final note = state.status.data;
    _noteController.text = note?.text ?? '';
    _tagsController.text = (note?.tags ?? const []).join(', ');
    _loadedNoteKey = key;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        final isDarkTheme = prefSetProvider.isDarkTheme;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkTheme ? kDarkTheme : Colors.white,
            foregroundColor: isDarkTheme ? Colors.white : kDarkPurple,
            elevation: 0,
            title: Text(
              context.l10n.aiAssistant,
              style: kHeading6.copyWith(fontSize: 18),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: isDarkTheme ? Colors.white : kDarkPurple,
              tabs: [
                Tab(text: context.l10n.aiTadabbur),
                Tab(text: context.l10n.myNotes),
              ],
            ),
          ),
          body: SafeArea(
            top: false,
            child: _loadingSurah
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildSelectionHeader(context, isDarkTheme),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAiTab(context, isDarkTheme),
                            _buildNotesTab(context, isDarkTheme),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionHeader(BuildContext context, bool isDarkTheme) {
    final surahItems = _surahs
        .map((surah) => DropdownMenuItem<SurahEntity>(
              value: surah,
              child: Text('${surah.number}. ${surah.name.short}'),
            ))
        .toList();
    final ayahItems = _ayahOptions()
        .map((ayah) => DropdownMenuItem<int>(
              value: ayah,
              child: Text(ayah.toString()),
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<SurahEntity>(
              initialValue: _selectedSurah,
              items: surahItems,
              onChanged: _onSurahChanged,
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
            child: DropdownButtonFormField<int>(
              initialValue: _selectedAyah,
              items: ayahItems,
              onChanged: _onAyahChanged,
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
    );
  }

  Widget _buildAiTab(BuildContext context, bool isDarkTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
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
          const SizedBox(height: 12.0),
          TextField(
            controller: _promptController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: context.l10n.aiRequestHint,
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
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAi(context),
              icon: const Icon(Icons.auto_awesome),
              label: Text(context.l10n.aiGenerate),
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiQaScreen()),
                  ),
                  icon: const Icon(Icons.question_answer_outlined),
                  label: const Text('اسأل القرآن'),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiMoodScreen()),
                  ),
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  label: const Text('آيات لمزاجك'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<AiAssistantCubit, AiAssistantState>(
            builder: (context, state) {
              final status = state.status.status;
              if (status.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (status.isError) {
                final isNotConfigured =
                    state.status.message == 'AI_NOT_CONFIGURED';
                if (isNotConfigured) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.aiNotConfigured,
                          textAlign: TextAlign.center,
                          style: kSubtitle.copyWith(
                            color: isDarkTheme ? kGreyLight : kDarkPurple,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        OutlinedButton.icon(
                          onPressed: () => _showAiEnableHelp(context),
                          icon: const Icon(Icons.info_outline),
                          label: Text(context.l10n.aiHowToEnable),
                        ),
                      ],
                    ),
                  );
                }
                final message = state.status.message.isNotEmpty
                    ? state.status.message
                    : context.l10n.unexpectedError;
                return Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: kSubtitle.copyWith(
                      color: isDarkTheme ? kGreyLight : kDarkPurple,
                    ),
                  ),
                );
              }
              if (status.isHasData) {
                final data = state.status.data!;
                return SelectableText(
                  data.response,
                  style: kHeading6.copyWith(
                    fontSize: 14.0,
                    height: 1.6,
                    color: isDarkTheme ? Colors.white : kDarkPurple,
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
        ],
      ),
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
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: isDarkTheme ? Colors.white : kDarkPurple,
                ),
              ),
              const SizedBox(height: 12.0),
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

  Widget _buildNotesTab(BuildContext context, bool isDarkTheme) {
    final surfaceColor =
        isDarkTheme ? kDarkPurple.withValues(alpha: 0.4) : kGrey92;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BlocListener<TadabburCubit, TadabburState>(
        listener: (context, state) => _syncNoteControllers(state),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.myNotes,
              style: kHeading6.copyWith(
                fontSize: 14.0,
                color: isDarkTheme ? Colors.white : kDarkPurple,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _noteController,
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
            const SizedBox(height: 8.0),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: context.l10n.tagsHint,
                labelText: context.l10n.tags,
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
                    onPressed: _saveNote,
                    icon: const Icon(Icons.save),
                    label: Text(context.l10n.save),
                  ),
                ),
                const SizedBox(width: 8.0),
                OutlinedButton.icon(
                  onPressed: _deleteNote,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(context.l10n.delete),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<TadabburNotesCubit, TadabburNotesState>(
              builder: (context, state) {
                final status = state.status.status;
                if (status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (status.isError) {
                  return Text(
                    state.status.message.isNotEmpty
                        ? state.status.message
                        : context.l10n.unexpectedError,
                    style: kSubtitle.copyWith(
                      color: isDarkTheme ? kGreyLight : kDarkPurple,
                    ),
                  );
                }
                final notes = state.status.data ?? const [];
                if (notes.isEmpty) {
                  return Text(
                    context.l10n.noData,
                    style: kSubtitle.copyWith(
                      color: kGrey.withValues(alpha: 0.7),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${note.ref.surah}:${note.ref.ayah}',
                          style: kSubtitle.copyWith(
                            color: isDarkTheme ? Colors.white : kDarkPurple,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              note.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (note.tags.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: note.tags
                                      .map((tag) => Chip(
                                            label: Text(tag),
                                            visualDensity: VisualDensity.compact,
                                          ))
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _selectedSurah = _surahs.firstWhere(
                              (s) => s.number == note.ref.surah,
                              orElse: () => _selectedSurah ?? _surahs.first,
                            );
                            _selectedAyah = note.ref.ayah;
                            _loadedNoteKey = '';
                          });
                          _loadNoteForSelection();
                          _tabController.animateTo(1);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }
}
