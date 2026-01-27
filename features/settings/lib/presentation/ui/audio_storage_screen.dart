import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/surah_entity.dart';
import 'package:quran/domain/usecases/get_audio_cache_size_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_by_reciter_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_by_surah_usecase.dart';
import 'package:quran/domain/usecases/get_surah_usecase.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class AudioStorageScreen extends StatefulWidget {
  const AudioStorageScreen({super.key});

  @override
  State<AudioStorageScreen> createState() => _AudioStorageScreenState();
}

class _AudioStorageScreenState extends State<AudioStorageScreen> {
  final _sl = GetIt.instance;
  int _cacheSizeBytes = 0;
  bool _loading = true;
  _SettingsOption _selectedReciter = _reciterOptions.first;
  SurahEntity? _selectedSurah;
  List<SurahEntity> _surahOptions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    await _loadCacheSize();
    await _loadSurahList();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadCacheSize() async {
    final result = await _sl<GetAudioCacheSizeUsecase>().call();
    result.fold(
      (_) => _cacheSizeBytes = 0,
      (size) => _cacheSizeBytes = size,
    );
  }

  Future<void> _loadSurahList() async {
    if (_surahOptions.isNotEmpty) {
      return;
    }
    final result = await _sl<GetSurahUsecase>().call();
    result.fold(
      (_) => _selectedSurah = null,
      (list) {
        if (list.isNotEmpty) {
          _surahOptions = list;
          _selectedSurah = list.first;
        }
      },
    );
  }

  Future<void> _clearAll() async {
    final result = await _sl<ClearAudioCacheUsecase>().call();
    _showResult(result.isRight());
    await _loadData();
  }

  Future<void> _clearByReciter() async {
    final result = await _sl<ClearAudioCacheByReciterUsecase>()
        .call(_selectedReciter.value);
    _showResult(result.isRight());
    await _loadData();
  }

  Future<void> _clearBySurah() async {
    final surah = _selectedSurah;
    if (surah == null) {
      return;
    }
    final result =
        await _sl<ClearAudioCacheBySurahUsecase>().call(surah.number);
    _showResult(result.isRight());
    await _loadData();
  }

  void _showResult(bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? context.l10n.cacheCleared : context.l10n.unexpectedError,
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    final mb = bytes / (1024 * 1024);
    if (mb < 1) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        final isDarkTheme = prefSetProvider.isDarkTheme;
        final cardColor = isDarkTheme
            ? kDarkPurple.withValues(alpha: 0.6)
            : kGrey92;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.l10n.audioStorage,
              style: kHeading6.copyWith(
                fontSize: 18.0,
                color: isDarkTheme ? Colors.white : kDarkPurple,
              ),
            ),
            backgroundColor: isDarkTheme ? kDarkTheme : Colors.white,
            foregroundColor: isDarkTheme ? Colors.white : kDarkPurple,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.cacheSize,
                        style: kHeading6.copyWith(
                          fontSize: 14.0,
                          color: isDarkTheme ? Colors.white : kDarkPurple,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        _formatBytes(_cacheSizeBytes),
                        style: kHeading5.copyWith(
                          fontSize: 22.0,
                          color: isDarkTheme ? Colors.white : kDarkPurple,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        context.l10n.storageLimit,
                        style: kSubtitle.copyWith(
                          color: isDarkTheme ? kGreyLight : kDarkPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),
                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  _actionSection(
                    title: context.l10n.clearAudioCache,
                    subtitle: context.l10n.clearAll,
                    onPressed: _clearAll,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 18.0),
                  _dropdownSection(
                    title: context.l10n.clearByReciter,
                    value: _selectedReciter,
                    items: _reciterOptions,
                    onChanged: (option) {
                      if (option == null) return;
                      setState(() => _selectedReciter = option);
                    },
                    onPressed: _clearByReciter,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 18.0),
                  _surahSection(
                    title: context.l10n.clearBySurah,
                    surah: _selectedSurah,
                    onChanged: (value) => setState(() {
                      _selectedSurah = value;
                    }),
                    onPressed: _clearBySurah,
                    isDarkTheme: isDarkTheme,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionSection({
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    required bool isDarkTheme,
  }) {
    return _sectionCard(
      isDarkTheme: isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kHeading6.copyWith(
              fontSize: 14.0,
              color: isDarkTheme ? Colors.white : kDarkPurple,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            subtitle,
            style: kSubtitle.copyWith(
              color: isDarkTheme ? kGreyLight : kDarkPurple,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.delete_forever),
              label: Text(context.l10n.clearAll),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownSection({
    required String title,
    required _SettingsOption value,
    required List<_SettingsOption> items,
    required ValueChanged<_SettingsOption?> onChanged,
    required VoidCallback onPressed,
    required bool isDarkTheme,
  }) {
    return _sectionCard(
      isDarkTheme: isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kHeading6.copyWith(
              fontSize: 14.0,
              color: isDarkTheme ? Colors.white : kDarkPurple,
            ),
          ),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<_SettingsOption>(
            key: ValueKey(value.value),
            initialValue: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDarkTheme ? kDarkTheme : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            items: items
                .map(
                  (option) => DropdownMenuItem<_SettingsOption>(
                    value: option,
                    child: Text(option.label),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.delete),
              label: Text(context.l10n.clearByReciter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _surahSection({
    required String title,
    required SurahEntity? surah,
    required ValueChanged<SurahEntity?> onChanged,
    required VoidCallback onPressed,
    required bool isDarkTheme,
  }) {
    final items = _surahOptions;
    return _sectionCard(
      isDarkTheme: isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kHeading6.copyWith(
              fontSize: 14.0,
              color: isDarkTheme ? Colors.white : kDarkPurple,
            ),
          ),
          const SizedBox(height: 8.0),
          if (items.isEmpty)
            Text(
              context.l10n.noData,
              style: kSubtitle.copyWith(
                color: isDarkTheme ? kGreyLight : kGrey,
              ),
            )
          else
            DropdownButtonFormField<SurahEntity>(
              key: ValueKey(surah?.number ?? items.first.number),
              initialValue: surah ?? items.first,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDarkTheme ? kDarkTheme : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              items: items
                  .map(
                    (option) => DropdownMenuItem<SurahEntity>(
                      value: option,
                      child: Text(
                        context.l10n.isArabic
                            ? option.name.short
                            : option.name.transliteration.en,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: items.isEmpty ? null : onPressed,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: Text(context.l10n.clearBySurah),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required Widget child,
    required bool isDarkTheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? kDarkPurple.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDarkTheme
              ? Colors.white.withValues(alpha: 0.08)
              : kGrey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          if (!isDarkTheme)
            BoxShadow(
              color: kGrey.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: child,
    );
  }
}

class _SettingsOption {
  const _SettingsOption({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

const List<_SettingsOption> _reciterOptions = [
  _SettingsOption(
    value: 'ar.alafasy',
    label: 'مشاري العفاسي',
  ),
  _SettingsOption(
    value: 'ar.abdurrahmaansudais',
    label: 'السديس',
  ),
];
