import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/audio_reciter_entity.dart';
import 'package:quran/domain/entities/surah_entity.dart';
import 'package:quran/domain/usecases/get_audio_cache_size_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_by_reciter_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_by_surah_usecase.dart';
import 'package:quran/domain/usecases/get_audio_reciters_usecase.dart';
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
  bool _recitersLoading = false;
  List<AudioReciterEntity> _reciters =
      List<AudioReciterEntity>.of(_fallbackReciters);
  String _selectedReciterEdition = _fallbackReciters.first.identifier;
  SurahEntity? _selectedSurah;
  List<SurahEntity> _surahOptions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadReciters();
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
        .call(_selectedReciterEdition);
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

  Future<AudioReciterEntity?> _pickReciter(bool isDarkTheme) {
    return _showPickerSheet<AudioReciterEntity>(
      title: context.l10n.audioReciter,
      items: _reciters,
      isDarkTheme: isDarkTheme,
      labelBuilder: (item) => _reciterLabel(item, context),
      isSelected: (item) => item.identifier == _selectedReciterEdition,
    );
  }

  Future<SurahEntity?> _pickSurah(bool isDarkTheme) {
    final items = _surahOptions;
    if (items.isEmpty) {
      return Future.value(null);
    }
    return _showPickerSheet<SurahEntity>(
      title: context.l10n.surah,
      items: items,
      isDarkTheme: isDarkTheme,
      labelBuilder: (item) {
        final name = context.l10n.isArabic
            ? item.name.short
            : item.name.transliteration.en;
        return '${item.number}. $name';
      },
      isSelected: (item) => item.number == _selectedSurah?.number,
    );
  }

  Future<T?> _showPickerSheet<T>({
    required String title,
    required List<T> items,
    required bool isDarkTheme,
    required String Function(T item) labelBuilder,
    required bool Function(T item) isSelected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkTheme ? kDarkTheme : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        final maxHeight =
            MediaQuery.of(sheetContext).size.height * 0.7;
        return SafeArea(
          child: SizedBox(
            height: maxHeight,
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kGrey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: kHeading6.copyWith(
                        fontSize: 16.0,
                        color: isDarkTheme ? Colors.white : kDarkPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: isDarkTheme
                          ? Colors.white.withValues(alpha: 0.08)
                          : kGrey.withValues(alpha: 0.2),
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = isSelected(item);
                      return ListTile(
                        title: Text(
                          labelBuilder(item),
                          style: kSubtitle.copyWith(
                            color:
                                isDarkTheme ? kGreyLight : kDarkPurple,
                            fontWeight:
                                selected ? FontWeight.w600 : null,
                          ),
                        ),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle,
                                color: kPurplePrimary,
                              )
                            : null,
                        onTap: () => Navigator.pop(sheetContext, item),
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

  Future<void> _loadReciters() async {
    if (_recitersLoading) {
      return;
    }
    _recitersLoading = true;
    final result = await _sl<GetAudioRecitersUsecase>().call();
    if (!mounted) {
      return;
    }
    result.fold(
      (_) => null,
      (items) {
        final mapped = _mapReciters(items);
        if (mapped.isNotEmpty) {
          setState(() {
            _reciters = mapped;
            if (!_reciters.any(
              (reciter) => reciter.identifier == _selectedReciterEdition,
            )) {
              _selectedReciterEdition = _reciters.first.identifier;
            }
          });
        }
      },
    );
    _recitersLoading = false;
  }

  List<AudioReciterEntity> _mapReciters(List<AudioReciterEntity> items) {
    final unique = <String, AudioReciterEntity>{};
    for (final item in items) {
      if (item.identifier.isEmpty) {
        continue;
      }
      unique[item.identifier] = item;
    }
    final list = unique.values.toList();
    list.sort((a, b) => _reciterSortKey(a).compareTo(_reciterSortKey(b)));
    return list;
  }

  String _reciterSortKey(AudioReciterEntity reciter) {
    if (reciter.englishName.trim().isNotEmpty) {
      return reciter.englishName.trim();
    }
    return reciter.name.trim();
  }

  String _reciterLabel(AudioReciterEntity reciter, BuildContext context) {
    final isArabic = context.l10n.isArabic;
    if (isArabic && reciter.name.trim().isNotEmpty) {
      return reciter.name;
    }
    if (!isArabic && reciter.englishName.trim().isNotEmpty) {
      return reciter.englishName;
    }
    return reciter.name.isNotEmpty ? reciter.name : reciter.englishName;
  }

  AudioReciterEntity _currentReciter() {
    if (_reciters.isEmpty) {
      return _fallbackReciters.first;
    }
    return _reciters.firstWhere(
      (reciter) => reciter.identifier == _selectedReciterEdition,
      orElse: () => _reciters.first,
    );
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
                  _reciterSection(
                    title: context.l10n.clearByReciter,
                    valueLabel: _reciterLabel(
                      _currentReciter(),
                      context,
                    ),
                    onPick: () async {
                      final selected = await _pickReciter(isDarkTheme);
                      if (selected != null) {
                        setState(() =>
                            _selectedReciterEdition = selected.identifier);
                      }
                    },
                    onPressed: _clearByReciter,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 18.0),
                  _surahSection(
                    title: context.l10n.clearBySurah,
                    surah: _selectedSurah,
                    onPick: () async {
                      final selected = await _pickSurah(isDarkTheme);
                      if (selected != null) {
                        setState(() => _selectedSurah = selected);
                      }
                    },
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

  Widget _reciterSection({
    required String title,
    required String valueLabel,
    required VoidCallback onPick,
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
          _pickerField(
            label: valueLabel,
            isDarkTheme: isDarkTheme,
            onTap: onPick,
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
    required VoidCallback onPick,
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
            _pickerField(
              label: surah == null
                  ? context.l10n.noData
                  : (context.l10n.isArabic
                      ? surah.name.short
                      : surah.name.transliteration.en),
              isDarkTheme: isDarkTheme,
              onTap: onPick,
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

  Widget _pickerField({
    required String label,
    required bool isDarkTheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isDarkTheme ? kDarkTheme : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isDarkTheme
                ? Colors.white.withValues(alpha: 0.12)
                : kGrey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: kSubtitle.copyWith(
                  color: isDarkTheme ? kGreyLight : kDarkPurple,
                ),
              ),
            ),
            Icon(
              Icons.expand_more,
              color: isDarkTheme ? kGreyLight : kGrey,
            ),
          ],
        ),
      ),
    );
  }
}

const List<AudioReciterEntity> _fallbackReciters = [
  AudioReciterEntity(
    identifier: 'ar.alafasy',
    name: '\u0645\u0634\u0627\u0631\u064a \u0627\u0644\u0639\u0641\u0627\u0633\u064a',
    englishName: 'Mishary Alafasy',
    language: 'ar',
    format: 'audio',
    type: 'versebyverse',
    allowDownload: false,
  ),
  AudioReciterEntity(
    identifier: 'ar.abdurrahmaansudais',
    name: '\u0627\u0644\u0633\u062f\u064a\u0633',
    englishName: 'Abdurrahman Al-Sudais',
    language: 'ar',
    format: 'audio',
    type: 'versebyverse',
    allowDownload: false,
  ),
];
