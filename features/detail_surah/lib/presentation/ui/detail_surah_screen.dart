import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'dart:async';

import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/just_audio/just_audio.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:detail_surah/presentation/bloc/bloc.dart';
import 'package:detail_surah/presentation/cubits/last_read/last_read_cubit.dart';
import 'package:detail_surah/presentation/ui/widget/banner_verses_widget.dart';
import 'package:detail_surah/presentation/ui/widget/verses_widget.dart';
import 'package:detail_surah/presentation/ui/widget/verse_skeleton_item.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/detail_surah_entity.dart';
import 'package:quran/domain/usecases/get_ayah_audio_usecase.dart';
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
  GlobalKey? _highlightKey;
  bool _didScrollToHighlight = false;
  final AudioPlayer _surahPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _surahPlayerSubscription;
  final _sl = GetIt.instance;
  List<AyahRef> _surahQueue = [];
  int _currentSurahIndex = 0;
  bool _isSurahPlaying = false;
  bool _isSurahLoading = false;
  String? _surahError;
  int _repeatCount = 1;
  int _repeatRemaining = 1;
  Timer? _sleepTimer;

  @override
  void initState() {
    super.initState();
    if (widget.highlightAyah != null) {
      _highlightKey = GlobalKey();
    }

    _surahPlayerSubscription =
        _surahPlayer.playerStateStream.listen((state) {
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
    setState(() {
      _surahError = null;
      _isSurahLoading = true;
    });
    _repeatCount = prefSetProvider.audioRepeatCount;
    _repeatRemaining = _repeatCount;
    await _surahPlayer.setSpeed(prefSetProvider.audioSpeed);
    _scheduleSleepTimer(prefSetProvider.audioSleepMinutes);
    _surahQueue = surah.verses
        .map((verse) =>
            AyahRef(surah: surah.number, ayah: verse.number.inSurah))
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
          _surahError = failure.message;
          _isSurahLoading = false;
          _isSurahPlaying = false;
        });
      },
      (audio) async {
        try {
          final source = audio.localPath != null
              ? AudioSource.uri(Uri.file(audio.localPath!))
              : AudioSource.uri(Uri.parse(audio.url));
          await _surahPlayer.setAudioSource(source);
          await _surahPlayer.play();
          if (mounted) {
            setState(() {
              _isSurahLoading = false;
              _isSurahPlaying = true;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _surahError = e.toString();
              _isSurahLoading = false;
              _isSurahPlaying = false;
            });
          }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
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
                        final current = _highlightKey?.currentContext;
                        if (current != null && mounted) {
                          Scrollable.ensureVisible(
                            current,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _didScrollToHighlight = true;
                          });
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
                        color: kGrey,
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
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kPurpleSecondary,
                        ),
                      ),
                    );
                    final headerChildren = isRtl
                        ? [
                            titleWidget,
                            const SizedBox(width: 18.0),
                            backButton,
                          ]
                        : [
                            backButton,
                            const SizedBox(width: 18.0),
                            titleWidget,
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
                          child: SingleChildScrollView(
                            child: Column(
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
                                _buildSurahAudioControls(
                                  surah,
                                  prefSetProvider,
                                ),
                                const SizedBox(height: 30.0),
                                ShowUpAnimation(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: surah.verses.length,
                                          itemBuilder: (context, index) {
                                            return VersesWidget(
                                              verses: surah.verses[index],
                                              prefSetProvider: prefSetProvider,
                                              surah: isArabic
                                                  ? surah.name.short
                                                  : surah.name.transliteration.en,
                                              surahNumber: surah.number,
                                              highlight: widget.highlightAyah ==
                                                  surah.verses[index].number
                                                      .inSurah,
                                              key: widget.highlightAyah ==
                                                      surah.verses[index].number
                                                          .inSurah
                                                  ? _highlightKey
                                                  : null,
                                              onPlayRequest: _isSurahPlaying
                                                  ? _stopSurahPlayback
                                                  : null,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
    final isDarkTheme = prefSetProvider.isDarkTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color:
            isDarkTheme ? kDarkPurple.withValues(alpha: 0.5) : kGrey92,
      ),
      child: Row(
        children: [
          Icon(
            Icons.volume_up_rounded,
            color: isDarkTheme ? Colors.white : kPurplePrimary,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              context.l10n.playSurah,
              style: kHeading6.copyWith(
                fontSize: 14.0,
                color: isDarkTheme ? Colors.white : kDarkPurple,
              ),
            ),
          ),
          TextButton(
            onPressed: _isSurahLoading
                ? null
                : () => _toggleSurahPlayback(surah, prefSetProvider),
            child: Text(
              _isSurahPlaying ? context.l10n.pause : context.l10n.play,
              style: kSubtitle.copyWith(
                color: isDarkTheme ? Colors.white : kPurplePrimary,
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
    final currentAyah = _surahQueue.isNotEmpty &&
            _currentSurahIndex < _surahQueue.length
        ? _surahQueue[_currentSurahIndex].ayah
        : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isDarkTheme ? kDarkPurple : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        boxShadow: [
          if (!isDarkTheme)
            BoxShadow(
              color: kGrey.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.graphic_eq_rounded,
            color: isDarkTheme ? Colors.white : kPurplePrimary,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.audioPlaying,
                  style: kSubtitle.copyWith(
                    color: isDarkTheme ? Colors.white : kDarkPurple,
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
                    color: isDarkTheme ? kGreyLight : kGrey,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${speed}x · ${context.l10n.repeatCount}: $repeatCount · ${context.l10n.sleepTimer}: ${sleepMinutes == 0 ? context.l10n.off : '$sleepMinutes ${context.l10n.minutes}'}',
                  style: kSubtitle.copyWith(
                    fontSize: 11.0,
                    color: isDarkTheme ? kGreyLight : kGrey,
                  ),
                ),
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
              color: isDarkTheme ? Colors.white : kPurplePrimary,
            ),
          ),
          IconButton(
            onPressed: _stopSurahPlayback,
            icon: Icon(
              Icons.stop_rounded,
              color: isDarkTheme ? Colors.white : kPurplePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
