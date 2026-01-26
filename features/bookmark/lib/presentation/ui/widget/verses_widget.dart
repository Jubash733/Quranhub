import 'dart:developer';

import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/just_audio/just_audio.dart';
import 'package:detail_surah/presentation/cubits/bookmark_verses/bookmark_verses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/bookmark_verses_entity.dart';
import 'package:quran/domain/entities/detail_surah_entity.dart';
import 'package:quran/domain/entities/surah_entity.dart';
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

    setAudioUrl();
  }

  Future<void> setAudioUrl() async {
    try {
      await widget.player
          .setAudioSource(AudioSource.uri(Uri.parse(widget.bookmark.audioUri)));
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    widget.player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      widget.player.stop();
    }
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
                    } else if (playing != true) {
                      return InkWell(
                        onTap: () async {
                          setAudioUrl();
                          widget.player.play();
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset('assets/icon_play.png', width: 16.0),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return InkWell(
                        onTap: () {
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
              style: kArabicVerse.copyWith(
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
          Text(
            widget.bookmark.translation,
            style: kHeading6.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: widget.prefSetProvider.isDarkTheme
                  ? Colors.white70
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
