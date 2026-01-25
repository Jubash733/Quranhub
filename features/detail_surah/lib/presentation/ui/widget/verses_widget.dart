// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/just_audio/just_audio.dart';
import 'package:detail_surah/presentation/cubits/ayah_translation/ayah_translation_cubit.dart';
import 'package:detail_surah/presentation/cubits/bookmark_verses/bookmark_verses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/detail_surah_entity.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class VersesWidget extends StatefulWidget {
  final VerseEntity verses;
  final PreferenceSettingsProvider prefSetProvider;
  final String surah;
  final int surahNumber;
  final AudioPlayer player = AudioPlayer();

  VersesWidget({
    super.key,
    required this.verses,
    required this.prefSetProvider,
    required this.surah,
    required this.surahNumber,
  });

  @override
  State<VersesWidget> createState() => _VersesWidgetState();
}

class _VersesWidgetState extends State<VersesWidget> {
  bool isBookmark = false;

  @override
  void initState() {
    super.initState();

    // setAudioUrl();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<BookmarkVersesCubit>()
          .loadBookmarkVerse(widget.verses.number.inQuran);
      if (!context.mounted) {
        return;
      }

      if (context.read<BookmarkVersesCubit>().state.isBookmark) {
        setState(() {
          isBookmark = true;
        });
      } else {
        setState(() {
          isBookmark = false;
        });
      }
    });
  }

  Future<void> setAudioUrl() async {
    try {
      await widget.player.setAudioSource(
          AudioSource.uri(Uri.parse(widget.verses.audio.primary)));
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

  void _showTranslationBottomSheet(BuildContext context) {
    final ref = AyahRef(
      surah: widget.surahNumber,
      ayah: widget.verses.number.inSurah,
    );

    context.read<AyahTranslationCubit>().fetchTranslation(ref);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<AyahTranslationCubit>(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20.0,
              16.0,
              20.0,
              24.0 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: BlocBuilder<AyahTranslationCubit, AyahTranslationState>(
              builder: (context, state) {
                final status = state.status.status;

                if (status.isLoading || status.isInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: widget.prefSetProvider.isDarkTheme
                          ? Colors.white
                          : kPurplePrimary,
                    ),
                  );
                }

                if (status.isError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.status.message,
                        style: kHeading6.copyWith(
                          fontSize: 12.0,
                          color: widget.prefSetProvider.isDarkTheme
                              ? kGreyLight
                              : kDarkPurple,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context
                              .read<AyahTranslationCubit>()
                              .fetchTranslation(ref),
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  );
                }

                if (!status.isHasData || state.status.data == null) {
                  return Text(
                    'No Translation',
                    style: kHeading6.copyWith(
                      fontSize: 12.0,
                      color: widget.prefSetProvider.isDarkTheme
                          ? kGreyLight
                          : kDarkPurple,
                    ),
                  );
                }

                final translation = state.status.data!;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                          color: kGrey.withValues(
                            alpha: 0.4,
                          ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Translation',
                        style: kHeading6.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: widget.prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kDarkPurple,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        '${widget.surah} : ${widget.verses.number.inSurah}',
                        style: kHeading6.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: widget.prefSetProvider.isDarkTheme
                              ? kGreyLight
                              : kDarkPurple.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        translation.text,
                        style: kHeading6.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: widget.prefSetProvider.isDarkTheme
                              ? kGreyLight
                              : kDarkPurple,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
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
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: kPurplePrimary,
                  ),
                  child: Center(
                    child: Text(
                      widget.verses.number.inSurah.toString(),
                      style: kHeading6.copyWith(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
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
                            .removeBookmarkVerse(widget.verses, widget.surah);
                        if (!context.mounted) {
                          return;
                        }

                        context.showCustomFlashMessage(
                          status: 'success',
                          title: 'Hapus Bookmark Ayat',
                          darkTheme: widget.prefSetProvider.isDarkTheme,
                          message:
                              'Surah ${widget.surah} Ayat ${widget.verses.number.inSurah} berhasil dihapus dari Bookmark',
                        );
                      } else {
                        await context
                            .read<BookmarkVersesCubit>()
                            .saveBookmarkVerse(widget.verses, widget.surah);
                        if (!context.mounted) {
                          return;
                        }

                        context.showCustomFlashMessage(
                          status: 'success',
                          title: 'Tambah Bookmark Ayat',
                          darkTheme: widget.prefSetProvider.isDarkTheme,
                          message:
                              'Surah ${widget.surah} Ayat ${widget.verses.number.inSurah} berhasil ditambah ke Bookmark',
                        );
                      }

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
          InkWell(
            onTap: () => _showTranslationBottomSheet(context),
            borderRadius: BorderRadius.circular(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.verses.text.arab,
                    textAlign: TextAlign.right,
                    style: kHeading6.copyWith(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                      color: widget.prefSetProvider.isDarkTheme
                          ? Colors.white
                          : kDarkPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Text(
                  widget.verses.text.transliteration.en,
                  style: kHeading6.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: widget.prefSetProvider.isDarkTheme
                        ? kGreyLight
                        : kDarkPurple,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
