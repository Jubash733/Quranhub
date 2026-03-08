import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'dart:async';
import 'package:core/network/ai_api.dart';

import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/just_audio/just_audio.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:detail_surah/presentation/bloc/bloc.dart';
import 'package:detail_surah/presentation/cubits/last_read/last_read_cubit.dart';
import 'package:detail_surah/presentation/ui/widget/banner_verses_widget.dart';
import 'package:detail_surah/presentation/ui/widget/surah_audio_settings_sheet.dart';
import 'package:detail_surah/presentation/ui/widget/surah_info_card.dart';
import 'package:detail_surah/presentation/ui/widget/verses_widget.dart';
import 'package:detail_surah/presentation/ui/widget/verse_skeleton_item.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:quran/domain/entities/audio_reciter_entity.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/detail_surah_entity.dart';
import 'package:quran/domain/usecases/get_ayah_audio_usecase.dart';
import 'package:quran/domain/usecases/cache_ayah_audio_usecase.dart';
import 'package:quran/domain/usecases/cache_surah_audio_usecase.dart';
import 'package:quran/domain/usecases/get_audio_reciters_usecase.dart';
import 'package:quran/domain/usecases/get_app_settings_usecase.dart';
import 'package:quran/domain/usecases/update_audio_settings_usecase.dart';
import 'package:resources/constant/api_constant.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:resources/widgets/state_message.dart';

class DetailSurahScreen extends StatefulWidget {
  final int id;
  final int? highlightAyah;

  const DetailSurahScreen({super.key, required this.id, this.highlightAyah});

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen> {
  static const Map<String, String> _audioHeaders = {
    'User-Agent': 'Mozilla/5.0',
    'Accept': '*/*',
  };
  static const int _maxAudioRetries = 2;
  static const List<AudioReciterOption> _fallbackReciters = [
    AudioReciterOption(
      edition: 'ar.alafasy',
      labelAr:
          '\u0645\u0634\u0627\u0631\u064A \u0627\u0644\u0639\u0641\u0627\u0633\u064A',
      labelEn: 'Mishary Alafasy',
    ),
    AudioReciterOption(
      edition: 'ar.abdurrahmaansudais',
      labelAr: '\u0627\u0644\u0633\u062F\u064A\u0633',
      labelEn: 'Abdurrahman Al-Sudais',
    ),
  ];

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  bool _didScrollToHighlight = false;
  final AudioPlayer _surahPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _surahPlayerSubscription;
  final _sl = GetIt.instance;
  List<AyahRef> _surahQueue = [];
  int _currentSurahIndex = 0;
  bool _isSurahPlaying = false;
  bool _isSurahLoading = false;
  String? _surahError;
  String _currentSurahEdition = ApiConstant.alquranAudioEdition;
  late List<AudioReciterOption> _reciterOptions;
  bool _recitersLoading = false;
  bool _recitersLoaded = false;
  int _repeatCount = 1;
  int _repeatRemaining = 1;
  Timer? _sleepTimer;

  @override
  void initState() {
    super.initState();
    _reciterOptions = List<AudioReciterOption>.of(_fallbackReciters);
    _reciterOptions = List<AudioReciterOption>.of(_fallbackReciters);

    _surahPlayerSubscription = _surahPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextAyah();
      } else if (!state.playing && mounted && _isSurahPlaying) {
        setState(() => _isSurahPlaying = false);
      } else if (state.playing && mounted) {
        setState(() => _isSurahPlaying = true);
      }
    });

    Future.microtask(() {
      if (!mounted) {
        return;
      }
      context.read<DetailSurahBloc>().add(FetchDetailSurah(id: widget.id));
      context.read<LastReadCubit>().getLastRead();
    });

    _ensureRecitersLoaded();
  }

  @override
  void dispose() {
    _surahPlayerSubscription?.cancel();
    _sleepTimer?.cancel();
    _surahPlayer.dispose();
    super.dispose();
  }

  Future<void> _startSurahPlayback(
    DetailSurahEntity surah,
    PreferenceSettingsProvider prefSetProvider,
  ) async {
    if (_isSurahLoading) {
      return;
    }
    if (_isSurahPlaying) {
      await _surahPlayer.stop();
    }
    setState(() {
      _surahError = null;
      _isSurahLoading = true;
    });
    _repeatCount = prefSetProvider.audioRepeatCount;
    _repeatRemaining = _repeatCount;
    await _surahPlayer.setSpeed(prefSetProvider.audioSpeed);
    _scheduleSleepTimer(prefSetProvider.audioSleepMinutes);
    _surahQueue = surah.verses
        .map(
            (verse) => AyahRef(surah: surah.number, ayah: verse.number.inSurah))
        .toList();
    _currentSurahIndex = 0;
    await _playCurrentAyah();
  }

  Future<void> _toggleSurahPlayback(
    DetailSurahEntity surah,
    PreferenceSettingsProvider prefSetProvider,
  ) async {
    if (_isSurahPlaying) {
      await _surahPlayer.pause();
      return;
    }
    if (_surahQueue.isEmpty) {
      await _startSurahPlayback(surah, prefSetProvider);
      return;
    }
    await _surahPlayer.setSpeed(prefSetProvider.audioSpeed);
    _scheduleSleepTimer(prefSetProvider.audioSleepMinutes);
    await _surahPlayer.play();
  }

  Future<void> _stopSurahPlayback() async {
    await _surahPlayer.stop();
    _sleepTimer?.cancel();
    setState(() {
      _isSurahPlaying = false;
      _isSurahLoading = false;
      _currentSurahIndex = 0;
    });
  }

  Future<void> _playCurrentAyah() async {
    await _playCurrentAyahWithRetry();
  }

  Future<void> _playCurrentAyahWithRetry({int attempt = 0}) async {
    if (_currentSurahIndex >= _surahQueue.length) {
      await _stopSurahPlayback();
      return;
    }
    final ref = _surahQueue[_currentSurahIndex];
    final result = await _sl<GetAyahAudioUsecase>().call(ref);
    if (!mounted) {
      return;
    }
    await result.fold(
      (failure) async {
        if (!mounted) {
          return;
        }
        setState(() {
          _surahError = _friendlyAudioError(failure.message);
          _isSurahLoading = false;
          _isSurahPlaying = false;
        });
      },
      (audio) async {
        _currentSurahEdition = audio.edition;

        // Fire-and-forget cache for current verse (if not already cached)
        if (audio.localPath == null || audio.localPath!.isEmpty) {
          _sl<CacheAyahAudioUsecase>().call(audio.ref, edition: audio.edition);
        }

        // Fire-and-forget preload for next verse
        if (_currentSurahIndex + 1 < _surahQueue.length) {
          final nextRef = _surahQueue[_currentSurahIndex + 1];
          _sl<CacheAyahAudioUsecase>().call(nextRef, edition: audio.edition);
        }

        try {
          await _playAudioSource(_surahPlayer, audio);
          if (!mounted) return;
          setState(() {
            _isSurahLoading = false;
            _isSurahPlaying = true;
            _surahError = null;
          });
        } catch (e) {
          if (!mounted) return;
          if (attempt < _maxAudioRetries) {
            await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
            return _playCurrentAyahWithRetry(attempt: attempt + 1);
          }
          setState(() {
            _surahError = _friendlyAudioError(e.toString());
            _isSurahLoading = false;
            _isSurahPlaying = false;
          });
        }
      },
    );
  }

  Future<void> _playNextAyah() async {
    if (_repeatRemaining > 1) {
      _repeatRemaining -= 1;
      await _surahPlayer.seek(Duration.zero);
      await _surahPlayer.play();
      return;
    }
    _repeatRemaining = _repeatCount;
    if (_currentSurahIndex + 1 >= _surahQueue.length) {
      await _stopSurahPlayback();
      return;
    }
    _currentSurahIndex += 1;
    await _playCurrentAyah();
  }

  void _scheduleSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    if (minutes <= 0) {
      return;
    }
    _sleepTimer = Timer(Duration(minutes: minutes), () {
      _stopSurahPlayback();
    });
  }

  Future<void> _playAudioSource(
    AudioPlayer player,
    AyahAudioEntity audio,
  ) async {
    final localPath = audio.localPath;
    if (localPath != null && localPath.isNotEmpty) {
      try {
        await player.setAudioSource(AudioSource.uri(Uri.file(localPath)));
        await player.play();
        return;
      } catch (_) {
        // Fallback to remote if cached file fails.
      }
    }
    try {
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(audio.url),
          headers: _audioHeaders,
        ),
      );
      await player.play();
      return;
    } catch (e, st) {
      final cachedResult = await _sl<CacheAyahAudioUsecase>()
          .call(audio.ref, edition: audio.edition);
      AyahAudioEntity? cachedAudio;
      cachedResult.fold(
        (_) => cachedAudio = null,
        (cached) => cachedAudio = cached,
      );
      if (cachedAudio == null) {
        Error.throwWithStackTrace(e, st);
      }
      final cachedPath = cachedAudio!.localPath;
      if (cachedPath != null && cachedPath.isNotEmpty) {
        await player.setAudioSource(AudioSource.uri(Uri.file(cachedPath)));
        await player.play();
        return;
      }
      Error.throwWithStackTrace(e, st);
    }
  }

  String _friendlyAudioError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('connection aborted') ||
        lower.contains('socketexception') ||
        lower.contains('timeout')) {
      return context.l10n.audioConnectionError;
    }
    return message.isEmpty ? context.l10n.unexpectedError : message;
  }

  Future<void> _ensureRecitersLoaded() async {
    if (_recitersLoading || _recitersLoaded) {
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
        final options = _mapReciterOptions(items);
        if (options.isNotEmpty) {
          setState(() => _reciterOptions = options);
        }
      },
    );
    _recitersLoading = false;
    _recitersLoaded = true;
  }

  Future<void> _downloadSurahRecitation(DetailSurahEntity surah) async {
    final settings = await _sl<GetAppSettingsUsecase>().call();
    final edition = settings.audioEdition.isNotEmpty
        ? settings.audioEdition
        : _currentSurahEdition;
    final total = surah.verses.length;
    final result = await _sl<CacheSurahAudioUsecase>().call(
      surah: surah.number,
      ayahCount: total,
      edition: edition,
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        final message = failure.message == 'DOWNLOAD_NOT_ALLOWED'
            ? context.l10n.downloadNotAllowed
            : (failure.message.isNotEmpty
                ? failure.message
                : context.l10n.downloadFailed);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      (count) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.downloadCompleted} ($count/$total)',
          ),
        ),
      ),
    );
  }

  List<AudioReciterOption> _mapReciterOptions(
    List<AudioReciterEntity> reciters,
  ) {
    final map = <String, AudioReciterOption>{
      for (final reciter in _fallbackReciters) reciter.edition: reciter,
    };
    for (final reciter in reciters) {
      if (reciter.identifier.isEmpty) {
        continue;
      }
      final labelAr =
          reciter.name.isNotEmpty ? reciter.name : reciter.englishName;
      final labelEn =
          reciter.englishName.isNotEmpty ? reciter.englishName : reciter.name;
      map[reciter.identifier] = AudioReciterOption(
        edition: reciter.identifier,
        labelAr: labelAr,
        labelEn: labelEn,
        allowDownload: reciter.allowDownload,
        downloadNote: reciter.downloadNote,
      );
    }
    final list = map.values.toList();
    list.sort((a, b) => a.labelEn.compareTo(b.labelEn));
    return list;
  }

  Future<void> _openAudioSettings(
    DetailSurahEntity surah,
    PreferenceSettingsProvider prefSetProvider,
  ) async {
    await _ensureRecitersLoaded();
    if (!mounted) return;
    final settings = await _sl<GetAppSettingsUsecase>().call();
    final currentEdition = settings.audioEdition.isNotEmpty
        ? settings.audioEdition
        : ApiConstant.alquranAudioEdition;
    if (!mounted) return;
    final initial = SurahAudioSettings(
      speed: prefSetProvider.audioSpeed,
      repeatCount: prefSetProvider.audioRepeatCount,
      sleepMinutes: prefSetProvider.audioSleepMinutes,
      edition: currentEdition,
    );
    final result = await showModalBottomSheet<SurahAudioSettings>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SurahAudioSettingsSheet(
        initial: initial,
        reciters: _reciterOptions,
        isDarkTheme: prefSetProvider.isDarkTheme,
        onDownloadSurah: () => _downloadSurahRecitation(surah),
      ),
    );
    if (result == null) {
      return;
    }

    prefSetProvider.setAudioSpeed(result.speed);
    prefSetProvider.setAudioRepeatCount(result.repeatCount);
    prefSetProvider.setAudioSleepMinutes(result.sleepMinutes);

    final editionChanged = result.edition != currentEdition;
    if (editionChanged) {
      await _sl<UpdateAudioSettingsUsecase>().call(result.edition);
    }

    if (!mounted) return;
    setState(() {
      _repeatCount = result.repeatCount;
      _repeatRemaining = result.repeatCount;
      _currentSurahEdition = result.edition;
    });

    if (_surahQueue.isNotEmpty || _isSurahPlaying) {
      await _surahPlayer.setSpeed(result.speed);
      _scheduleSleepTimer(result.sleepMinutes);
      if (editionChanged) {
        setState(() {
          _surahError = null;
          _isSurahLoading = true;
        });
        await _surahPlayer.stop();
        await _playCurrentAyah();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
              child: BlocBuilder<DetailSurahBloc, DetailSurahState>(
                builder: (context, state) {
                  final status = state.statusDetailSurah.status;

                  if (status.isLoading) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: prefSetProvider.isDarkTheme
                                  ? kDarkPurple.withValues(alpha: 0.6)
                                  : kGrey92,
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return VerseSkeletonItem(
                                isDarkTheme: prefSetProvider.isDarkTheme,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (status.isNoData) {
                    return StateMessage(
                      title: context.l10n.noData,
                      message: context.l10n.unexpectedError,
                      icon: Icons.menu_book_outlined,
                      isDarkTheme: prefSetProvider.isDarkTheme,
                    );
                  } else if (status.isError) {
                    return StateMessage(
                      title: context.l10n.unexpectedError,
                      message: state.statusDetailSurah.message.isNotEmpty
                          ? state.statusDetailSurah.message
                          : context.l10n.unexpectedError,
                      icon: Icons.wifi_off_rounded,
                      isDarkTheme: prefSetProvider.isDarkTheme,
                      actionLabel: context.l10n.retry,
                      onAction: () => context
                          .read<DetailSurahBloc>()
                          .add(FetchDetailSurah(id: widget.id)),
                    );
                  } else if (status.isHasData) {
                    final surah = state.statusDetailSurah.data;
                    final isArabic = context.l10n.isArabic;

                    if (widget.highlightAyah != null &&
                        !_didScrollToHighlight) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && surah != null) {
                          final index = surah.verses.indexWhere(
                              (v) => v.number.inSurah == widget.highlightAyah);
                          if (index != -1) {
                            _itemScrollController.jumpTo(index: index + 1);
                            setState(() {
                              _didScrollToHighlight = true;
                            });
                          }
                        }
                      });
                    }

                    if (context.read<LastReadCubit>().state.data.isEmpty) {
                      context.read<LastReadCubit>().addLastRead(surah!);
                    } else {
                      context.read<LastReadCubit>().updateLastRead(surah!);
                    }

                    final isRtl =
                        Directionality.of(context) == TextDirection.rtl;
                    final backButton = InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        isRtl ? Icons.arrow_forward : Icons.arrow_back,
                        size: 24.0,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    );
                    final titleWidget = Expanded(
                      child: Text(
                        isArabic
                            ? surah.name.short
                            : surah.name.transliteration.en,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    );
                    final toggleTranslationButton = IconButton(
                      onPressed: () {
                        prefSetProvider.setTranslationEnabled(
                          !prefSetProvider.showTranslation,
                        );
                      },
                      icon: Icon(
                        prefSetProvider.showTranslation
                            ? Icons.translate_rounded
                            : Icons.g_translate_rounded,
                        color: prefSetProvider.showTranslation
                            ? kPurplePrimary
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                        size: 24.0,
                      ),
                    );

                    final headerChildren = isRtl
                        ? [
                            titleWidget,
                            toggleTranslationButton,
                            const SizedBox(width: 8.0),
                            backButton,
                          ]
                        : [
                            backButton,
                            const SizedBox(width: 8.0),
                            titleWidget,
                            toggleTranslationButton,
                          ];

                    return Column(
                      children: [
                        ShowUpAnimation(
                          child: Row(
                            children: headerChildren,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _itemScrollController,
                            itemPositionsListener: _itemPositionsListener,
                            itemCount: surah.verses.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Header Section (Banner, Info, Audio Controls)
                                return Column(
                                  children: [
                                    Hero(
                                      tag: 'surah-card-${surah.number}',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: BannerVersesWidget(
                                          surah: surah,
                                          prefSetProvider: prefSetProvider,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    SurahInfoCard(
                                      surahNumber: surah.number,
                                      isDarkTheme: prefSetProvider.isDarkTheme,
                                    ),
                                    const SizedBox(height: 12.0),
                                    _buildSurahAudioControls(
                                      surah,
                                      prefSetProvider,
                                    ),
                                    const SizedBox(height: 30.0),
                                  ],
                                );
                              }
                              // Verse Section
                              final verseIndex = index - 1;
                              return VersesWidget(
                                verses: surah.verses[verseIndex],
                                prefSetProvider: prefSetProvider,
                                surah: isArabic
                                    ? surah.name.short
                                    : surah.name.transliteration.en,
                                surahNumber: surah.number,
                                highlight: widget.highlightAyah ==
                                    surah.verses[verseIndex].number.inSurah,
                                onPlayRequest:
                                    _isSurahPlaying ? _stopSurahPlayback : null,
                                onWordTap: (word) => _showWordTafsirBottomSheet(
                                  word,
                                  surah.verses[verseIndex].text.arab,
                                ),
                              );
                            },
                          ),
                        ),
                        if (_isSurahPlaying ||
                            _isSurahLoading ||
                            _surahError != null)
                          _buildSurahAudioBar(
                            surah,
                            prefSetProvider,
                            prefSetProvider.isDarkTheme,
                            prefSetProvider.audioSpeed,
                            prefSetProvider.audioRepeatCount,
                            prefSetProvider.audioSleepMinutes,
                          ),
                      ],
                    );
                  } else {
                    return Center(child: Text(context.l10n.unexpectedError));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahAudioControls(
    DetailSurahEntity surah,
    PreferenceSettingsProvider prefSetProvider,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: colorScheme.surface,
      ),
      child: Row(
        children: [
          Icon(
            Icons.volume_up_rounded,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              context.l10n.playSurah,
              style: kHeading6.copyWith(
                fontSize: 14.0,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _openAudioSettings(surah, prefSetProvider),
            icon: Icon(
              Icons.tune_rounded,
              color: colorScheme.primary,
            ),
          ),
          TextButton(
            onPressed: _isSurahLoading
                ? null
                : () => _toggleSurahPlayback(surah, prefSetProvider),
            child: Text(
              _isSurahPlaying ? context.l10n.pause : context.l10n.play,
              style: kSubtitle.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahAudioBar(
    DetailSurahEntity surah,
    PreferenceSettingsProvider prefSetProvider,
    bool isDarkTheme,
    double speed,
    int repeatCount,
    int sleepMinutes,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentAyah =
        _surahQueue.isNotEmpty && _currentSurahIndex < _surahQueue.length
            ? _surahQueue[_currentSurahIndex].ayah
            : null;
    final reciterLabel = _reciterOptions
        .firstWhere(
          (reciter) => reciter.edition == _currentSurahEdition,
          orElse: () => const AudioReciterOption(
            edition: '',
            labelAr: '',
            labelEn: '',
          ),
        )
        .label(context.l10n.isArabic);
    final speedLabel = speed.toStringAsFixed(2);
    final sleepLabel = sleepMinutes == 0
        ? context.l10n.off
        : '$sleepMinutes ${context.l10n.minutes}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.graphic_eq_rounded,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.audioPlaying,
                  style: kSubtitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  currentAyah != null
                      ? context.l10n.formatSurahAyah(
                          context.l10n.isArabic
                              ? surah.name.short
                              : surah.name.transliteration.en,
                          currentAyah,
                        )
                      : context.l10n.loading,
                  style: kSubtitle.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${speedLabel}x - ${context.l10n.repeatCount}: $repeatCount - ${context.l10n.sleepTimer}: $sleepLabel',
                  style: kSubtitle.copyWith(
                    fontSize: 11.0,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (reciterLabel.isNotEmpty) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    reciterLabel,
                    style: kSubtitle.copyWith(
                      fontSize: 11.0,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
                if (_surahError != null && _surahError!.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    _surahError!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: kSubtitle.copyWith(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: _isSurahLoading
                ? null
                : () => _toggleSurahPlayback(surah, prefSetProvider),
            icon: Icon(
              _isSurahPlaying ? Icons.pause : Icons.play_arrow,
              color: colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: _stopSurahPlayback,
            icon: Icon(
              Icons.stop_rounded,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
  void _showWordTafsirBottomSheet(String word, String verseText) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder<String>(
          future: AiService().getWordTafsir(word, verseText),
          builder: (context, snapshot) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'معنى كلمة: $word',
                    style: kHeading6.copyWith(color: isDark ? Colors.white : kPurplePrimary),
                  ),
                  const SizedBox(height: 16),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const CircularProgressIndicator()
                  else if (snapshot.hasError)
                    Text('خطأ في جلب التفسير: ${snapshot.error}')
                  else
                    Text(
                      snapshot.data ?? 'لا يوجد تفسير متاح',
                      textAlign: TextAlign.center,
                      style: kSubtitle.copyWith(height: 1.5),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'بواسطة الذكاء الاصطناعي (Gemini)',
                    style: kSubtitle.copyWith(fontSize: 10, color: kGrey),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
