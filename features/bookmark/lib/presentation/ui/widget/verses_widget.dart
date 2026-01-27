import 'dart:async';
import 'dart:developer';

import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/just_audio/just_audio.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:detail_surah/presentation/cubits/bookmark_verses/bookmark_verses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/bookmark_verses_entity.dart';
import 'package:quran/domain/entities/detail_surah_entity.dart';
import 'package:quran/domain/entities/surah_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/usecases/get_ayah_audio_usecase.dart';
import 'package:quran/domain/usecases/get_surah_usecase.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class VersesWidget extends StatefulWidget {
  final BookmarkVersesEntity bookmark;
  final PreferenceSettingsProvider prefSetProvider;
  final AudioPlayer player = AudioPlayer();

  VersesWidget({
    super.key,
    required this.bookmark,
    required this.prefSetProvider,
  });

  @override
  State<VersesWidget> createState() => _VersesWidgetState();
}

class _VersesWidgetState extends State<VersesWidget> {
  bool isBookmark = false;
  bool _isAudioLoading = false;
  AyahAudioEntity? _currentAudio;
  Duration _lastPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  final _sl = GetIt.instance;
  int? _surahNumber;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final bookmarkCubit = context.read<BookmarkVersesCubit>();
      await bookmarkCubit.loadBookmarkVerse(widget.bookmark.id);
      if (!mounted) {
        return;
      }

      if (bookmarkCubit.state.isBookmark) {
        setState(() {
          isBookmark = true;
        });
      } else {
        setState(() {
          isBookmark = false;
        });
      }
    });

    _resolveSurahNumber();
    _positionSubscription =
        widget.player.positionStream.listen((position) {
      _lastPosition = position;
    });
    _playerStateSubscription =
        widget.player.playerStateStream.listen((state) {
      if (!state.playing) {
        _persistPosition();
      }
      if (state.processingState == ProcessingState.completed) {
        _persistPosition(reset: true);
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    widget.player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _persistPosition();
      widget.player.stop();
    }
  }

  Future<void> _playAudio() async {
    if (_isAudioLoading) {
      return;
    }
    final surahNumber = _surahNumber;
    if (surahNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unexpectedError)),
      );
      return;
    }
    setState(() => _isAudioLoading = true);
    final ref = AyahRef(
      surah: surahNumber,
      ayah: widget.bookmark.inSurah,
    );
    final result = await _sl<GetAyahAudioUsecase>().call(ref);
    if (!mounted) {
      return;
    }
    await result.fold(
      (failure) async {
        if (!mounted) {
          return;
        }
        setState(() => _isAudioLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (audio) async {
        if (!mounted) {
          return;
        }
        _currentAudio = audio;
        try {
          final source = audio.localPath != null
              ? AudioSource.uri(Uri.file(audio.localPath!))
              : AudioSource.uri(Uri.parse(audio.url));
          await widget.player.setAudioSource(source);
          final savedPosition = await _loadSavedPosition(audio);
          if (savedPosition > Duration.zero) {
            await widget.player.seek(savedPosition);
          }
          await widget.player.play();
        } catch (e) {
          log("Error loading audio source: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.unexpectedError)),
            );
          }
        } finally {
          if (mounted) {
            setState(() => _isAudioLoading = false);
          }
        }
      },
    );
  }

  Future<void> _persistPosition({bool reset = false}) async {
    final audio = _currentAudio;
    if (audio == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final key = _positionKey(audio);
    final millis = reset ? 0 : _lastPosition.inMilliseconds;
    await prefs.setInt(key, millis);
  }

  Future<Duration> _loadSavedPosition(AyahAudioEntity audio) async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_positionKey(audio)) ?? 0;
    return Duration(milliseconds: millis);
  }

  String _positionKey(AyahAudioEntity audio) {
    return 'audio_pos:${audio.edition}:${audio.ref.surah}:${audio.ref.ayah}';
  }

  Future<void> _resolveSurahNumber() async {
    final result = await _sl<GetSurahUsecase>().call();
    result.fold(
      (_) => _surahNumber = null,
      (list) {
        final match = list.firstWhere(
          (surah) =>
              surah.name.short == widget.bookmark.surah ||
              surah.name.transliteration.en == widget.bookmark.surah,
          orElse: () => list.first,
        );
        _surahNumber = match.number;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
            decoration: BoxDecoration(
              color: kPurplePrimary.withValues(
                alpha: 0.065,
              ),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: kPurplePrimary,
                    ),
                    child: Text(
                      context.l10n.formatSurahAyah(
                        widget.bookmark.surah,
                        widget.bookmark.inSurah,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: kHeading6.copyWith(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                StreamBuilder<PlayerState>(
                  stream: widget.player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;

                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          color: widget.prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kPurplePrimary,
                        ),
                      );
                    } else if (_isAudioLoading) {
                      return SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          color: widget.prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kPurplePrimary,
                        ),
                      );
                    } else if (playing != true) {
                      return InkWell(
                        onTap: () async {
                          await _playAudio();
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset('assets/icon_play.png', width: 16.0),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return InkWell(
                        onTap: () {
                          _persistPosition();
                          widget.player.stop();
                          widget.player.seek(Duration.zero);
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: const Icon(
                          Icons.pause,
                          size: 24.0,
                          color: kPurplePrimary,
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () => widget.player.seek(Duration.zero),
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset('assets/icon_play.png', width: 16.0),
                      );
                    }
                  },
                ),
                const SizedBox(width: 12.0),
                BlocBuilder<BookmarkVersesCubit, BookmarkVersesState>(
                    builder: (context, state) {
                  final isAddedBookmark = state.isBookmark;

                  return InkWell(
                    onTap: () async {
                      if (isAddedBookmark) {
                        await context
                            .read<BookmarkVersesCubit>()
                            .removeBookmarkVerse(
                              VerseEntity(
                                  number: NumberEntity(
                                      inQuran: widget.bookmark.id,
                                      inSurah: widget.bookmark.inSurah),
                                  meta: null,
                                  text: TextEntity(
                                      arab: widget.bookmark.textArab,
                                      transliteration: TransliterationEntity(
                                          en: widget.bookmark.transliteration)),
                                  translation: TranslationEntity(
                                      en: 'en',
                                      id: widget.bookmark.transliteration),
                                  audio: AudioEntity(
                                      primary: widget.bookmark.audioUri,
                                      secondary: const ['secondary']),
                                  tafsir: null),
                              widget.bookmark.surah,
                            );
                        if (!context.mounted) {
                          return;
                        }

                        context.showCustomFlashMessage(
                          status: 'success',
                          title: context.l10n.bookmarkRemovedTitle,
                          darkTheme: widget.prefSetProvider.isDarkTheme,
                          message: context.l10n.bookmarkRemovedMessage(
                            widget.bookmark.surah,
                            widget.bookmark.inSurah,
                          ),
                        );
                      } else {
                        await context
                            .read<BookmarkVersesCubit>()
                            .saveBookmarkVerse(
                              VerseEntity(
                                  number: NumberEntity(
                                      inQuran: widget.bookmark.id,
                                      inSurah: widget.bookmark.inSurah),
                                  meta: null,
                                  text: TextEntity(
                                      arab: widget.bookmark.textArab,
                                      transliteration: TransliterationEntity(
                                          en: widget.bookmark.transliteration)),
                                  translation: TranslationEntity(
                                      en: 'en',
                                      id: widget.bookmark.transliteration),
                                  audio: AudioEntity(
                                      primary: widget.bookmark.audioUri,
                                      secondary: const ['secondary']),
                                  tafsir: null),
                              widget.bookmark.surah,
                            );
                        if (!context.mounted) {
                          return;
                        }
                        context.showCustomFlashMessage(
                          status: 'success',
                          title: context.l10n.bookmarkAddedTitle,
                          darkTheme: widget.prefSetProvider.isDarkTheme,
                          message: context.l10n.bookmarkAddedMessage(
                            widget.bookmark.surah,
                            widget.bookmark.inSurah,
                          ),
                        );
                      }

                      // final message =
                      //     context.read<BookmarkVersesCubit>().state.message;

                      // if (message ==
                      //         BookmarkVersesCubit.bookmarkAddSuccessMessage ||
                      //     message ==
                      //         BookmarkVersesCubit
                      //             .bookmarkRemoveSuccessMessage) {
                      //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(message),
                      //     backgroundColor: kPurplePrimary,
                      //   ));
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       content: Text(message),
                      //     ),
                      //   );
                      // }
                      setState(() {
                        isBookmark = !isAddedBookmark;
                      });
                    },
                    child: isBookmark
                        ? const Icon(Icons.bookmark_rounded,
                            size: 24.0, color: kPurpleSecondary)
                        : Image.asset('assets/icon_bookmark.png', width: 16.0),
                  );
                }),
                const SizedBox(width: 6.0),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.bookmark.textArab,
              textAlign: TextAlign.right,
              style: arabicVerseStyle(
                widget.prefSetProvider.arabicFontFamily,
                scale: widget.prefSetProvider.arabicFontScale,
              ).copyWith(
                color: widget.prefSetProvider.isDarkTheme
                    ? Colors.white
                    : kDarkPurple,
              ),
            ),
          ),
          const SizedBox(height: 18.0),
          Text(
            widget.bookmark.transliteration,
            style: kHeading6.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color:
                  widget.prefSetProvider.isDarkTheme ? kGreyLight : kDarkPurple,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (widget.prefSetProvider.showTranslation)
            Text(
              widget.bookmark.translation,
              style: kHeading6.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: widget.prefSetProvider.isDarkTheme
                    ? kGreyLight
                    : kDarkPurple.withValues(
                        alpha: 0.85,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
