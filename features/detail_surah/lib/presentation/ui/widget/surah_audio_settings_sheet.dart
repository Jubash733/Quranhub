import 'package:flutter/material.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class SurahAudioSettings {
  const SurahAudioSettings({
    required this.speed,
    required this.repeatCount,
    required this.sleepMinutes,
    required this.edition,
  });

  final double speed;
  final int repeatCount;
  final int sleepMinutes;
  final String edition;
}

class AudioReciterOption {
  const AudioReciterOption({
    required this.edition,
    required this.labelAr,
    required this.labelEn,
    this.allowDownload = false,
    this.downloadNote,
  });

  final String edition;
  final String labelAr;
  final String labelEn;
  final bool allowDownload;
  final String? downloadNote;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;
}

class SurahAudioSettingsSheet extends StatefulWidget {
  const SurahAudioSettingsSheet({
    super.key,
    required this.initial,
    required this.reciters,
    required this.isDarkTheme,
    this.onDownloadSurah,
  });

  final SurahAudioSettings initial;
  final List<AudioReciterOption> reciters;
  final bool isDarkTheme;
  final Future<void> Function()? onDownloadSurah;

  @override
  State<SurahAudioSettingsSheet> createState() =>
      _SurahAudioSettingsSheetState();
}

class _SurahAudioSettingsSheetState extends State<SurahAudioSettingsSheet> {
  late double _speed;
  late int _repeat;
  late int _sleepMinutes;
  late String _edition;
  late List<AudioReciterOption> _reciters;
  late List<AudioReciterOption> _filteredReciters;
  final TextEditingController _searchController = TextEditingController();
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _speed = widget.initial.speed.clamp(0.75, 1.5).toDouble();
    _repeat = widget.initial.repeatCount < 1 ? 1 : widget.initial.repeatCount;
    _sleepMinutes =
        widget.initial.sleepMinutes < 0 ? 0 : widget.initial.sleepMinutes;
    _edition = widget.initial.edition;
    _reciters = widget.reciters.isNotEmpty
        ? List<AudioReciterOption>.of(widget.reciters)
        : [
            AudioReciterOption(
              edition: _edition,
              labelAr: _edition,
              labelEn: _edition,
            ),
          ];
    if (_edition.isEmpty && _reciters.isNotEmpty) {
      _edition = _reciters.first.edition;
    }
    if (!_reciters.any((reciter) => reciter.edition == _edition)) {
      _reciters.add(
        AudioReciterOption(
          edition: _edition,
          labelAr: _edition,
          labelEn: _edition,
        ),
      );
    }
    _filteredReciters = List<AudioReciterOption>.of(_reciters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.l10n.isArabic;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = colorScheme.surfaceContainerHighest;
    final repeatOptions = _withCurrentOption(
      const [1, 2, 3, 5, 10],
      _repeat,
    );
    final sleepOptions = _withCurrentOption(
      const [0, 5, 10, 20, 30],
      _sleepMinutes,
    );
    final reciterItems = _filteredReciters
        .map(
          (reciter) => DropdownMenuItem(
            value: reciter.edition,
            child: Text(reciter.label(isArabic)),
          ),
        )
        .toList();
    final selectedReciter = _reciters.firstWhere(
      (reciter) => reciter.edition == _edition,
      orElse: () => _reciters.first,
    );
    final canDownload = selectedReciter.allowDownload;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: widget.isDarkTheme
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.audioSettings,
              style: kHeading6.copyWith(
                fontSize: 16,
                color: widget.isDarkTheme ? Colors.white : kDarkPurple,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.audioReciter,
                    style: kSubtitle.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    onChanged: _filterReciters,
                    decoration: InputDecoration(
                      hintText: context.l10n.reciterSearchHint,
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _edition,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: reciterItems,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _edition = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.playbackSpeed,
                        style: kSubtitle.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text('${_speed.toStringAsFixed(2)}x'),
                    ],
                  ),
                  Slider(
                    value: _speed,
                    min: 0.75,
                    max: 1.5,
                    divisions: 15,
                    onChanged: (value) => setState(() => _speed = value),
                    activeColor:
                        colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    context.l10n.repeatCount,
                    style: kSubtitle.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: _repeat,
                    underline: const SizedBox.shrink(),
                    items: repeatOptions
                        .map(
                          (count) => DropdownMenuItem(
                            value: count,
                            child: Text('$count'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _repeat = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    context.l10n.sleepTimer,
                    style: kSubtitle.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: _sleepMinutes,
                    underline: const SizedBox.shrink(),
                    items: sleepOptions
                        .map(
                          (minutes) => DropdownMenuItem(
                            value: minutes,
                            child: Text(
                              minutes == 0
                                  ? context.l10n.off
                                  : '$minutes ${context.l10n.minutes}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sleepMinutes = value);
                    },
                  ),
                ],
              ),
            ),
            if (widget.onDownloadSurah != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _isDownloading || !canDownload ? null : _downloadSurah,
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_rounded),
                  label: Text(
                    _isDownloading
                        ? context.l10n.downloadInProgress
                        : canDownload
                            ? context.l10n.downloadRecitation
                            : context.l10n.streamingOnly,
                  ),
                ),
              ),
              if (!canDownload)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    selectedReciter.downloadNote ??
                        context.l10n.downloadNotAllowed,
                    style: kSubtitle.copyWith(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        SurahAudioSettings(
                          speed: _speed,
                          repeatCount: _repeat,
                          sleepMinutes: _sleepMinutes,
                          edition: _edition,
                        ),
                      );
                    },
                    child: Text(context.l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _filterReciters(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredReciters = List<AudioReciterOption>.of(_reciters));
      return;
    }
    setState(() {
      _filteredReciters = _reciters
          .where((reciter) =>
              reciter.labelAr.toLowerCase().contains(query) ||
              reciter.labelEn.toLowerCase().contains(query))
          .toList();
      if (!_filteredReciters.any((reciter) => reciter.edition == _edition)) {
        _filteredReciters.insert(
          0,
          _reciters.firstWhere(
            (reciter) => reciter.edition == _edition,
            orElse: () => AudioReciterOption(
              edition: _edition,
              labelAr: _edition,
              labelEn: _edition,
            ),
          ),
        );
      }
    });
  }

  Future<void> _downloadSurah() async {
    if (widget.onDownloadSurah == null) return;
    setState(() => _isDownloading = true);
    try {
      await widget.onDownloadSurah!.call();
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  List<int> _withCurrentOption(List<int> options, int current) {
    if (options.contains(current)) {
      return options;
    }
    return [...options, current];
  }
}
