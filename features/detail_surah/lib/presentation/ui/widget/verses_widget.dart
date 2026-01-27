import 'dart:async';
import 'dart:developer';

import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/just_audio/just_audio.dart';
import 'package:dependencies/share_plus/share_plus.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:detail_surah/presentation/cubits/ayah_translation/ayah_translation_cubit.dart';
import 'package:detail_surah/presentation/cubits/ayah_tafsir/ayah_tafsir_cubit.dart';
import 'package:detail_surah/presentation/cubits/bookmark_verses/bookmark_verses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/detail_surah_entity.dart';
import 'package:quran/domain/usecases/get_ayah_audio_usecase.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class VersesWidget extends StatefulWidget {
  final VerseEntity verses;
  final PreferenceSettingsProvider prefSetProvider;
  final String surah;
  final int surahNumber;
  final bool highlight;
  final AudioPlayer player = AudioPlayer();

  VersesWidget({
    super.key,
    required this.verses,
    required this.prefSetProvider,
    required this.surah,
    required this.surahNumber,
    this.highlight = false,
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

  @override
  void initState() {
    super.initState();

    // setAudioUrl();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final bookmarkCubit = context.read<BookmarkVersesCubit>();
      await bookmarkCubit.loadBookmarkVerse(widget.verses.number.inQuran);
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
    setState(() => _isAudioLoading = true);
    final ref = AyahRef(
      surah: widget.surahNumber,
      ayah: widget.verses.number.inSurah,
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


  void _showTranslationBottomSheet(BuildContext context) {
    final ref = AyahRef(
      surah: widget.surahNumber,
      ayah: widget.verses.number.inSurah,
    );

    final languageCode = widget.prefSetProvider.locale.languageCode;
    final showTranslation = widget.prefSetProvider.showTranslation;
    final showTafsir = widget.prefSetProvider.showTafsir;
    if (showTranslation) {
      context
          .read<AyahTranslationCubit>()
          .fetchTranslation(ref, languageCode);
    }
    if (showTafsir) {
      context.read<AyahTafsirCubit>().fetchTafsir(ref, languageCode);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        final sheetHeight = MediaQuery.of(sheetContext).size.height * 0.8;
        final tabs = <Tab>[];
        final views = <Widget>[];
        if (showTranslation) {
          tabs.add(Tab(text: context.l10n.translation));
          views.add(_buildTranslationTab(
            ref,
            languageCode,
            showTafsirButton: showTafsir,
          ));
        }
        if (showTafsir) {
          tabs.add(Tab(text: context.l10n.tafsir));
          views.add(_buildTafsirTab(ref, languageCode));
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<AyahTranslationCubit>(),
            ),
            BlocProvider.value(
              value: context.read<AyahTafsirCubit>(),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24.0,
              16.0,
              24.0,
              28.0 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: SizedBox(
              height: sheetHeight,
              child: DefaultTabController(
                length: tabs.isEmpty ? 1 : tabs.length,
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
                    const SizedBox(height: 12.0),
                    Text(
                      context.l10n.verseDetails,
                      style: kHeading6.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: widget.prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kDarkPurple,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      context.l10n.formatSurahAyah(
                        widget.surah,
                        widget.verses.number.inSurah,
                      ),
                      style: kHeading6.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: widget.prefSetProvider.isDarkTheme
                            ? kGreyLight
                            : kDarkPurple.withValues(
                                alpha: 0.8,
                              ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    if (tabs.length > 1)
                      TabBar(
                        labelColor: widget.prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kDarkPurple,
                        indicatorColor: widget.prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kPurplePrimary,
                        tabs: tabs,
                      ),
                    if (tabs.length > 1) const SizedBox(height: 12.0),
                    Expanded(
                      child: tabs.isEmpty
                          ? Center(
                              child: Text(
                                context.l10n.contentDisabled,
                                textAlign: TextAlign.center,
                                style: kHeading6.copyWith(
                                  fontSize: 13.0,
                                  color: widget.prefSetProvider.isDarkTheme
                                      ? kGreyLight
                                      : kDarkPurple.withValues(alpha: 0.8),
                                ),
                              ),
                            )
                          : tabs.length == 1
                              ? views.first
                              : TabBarView(
                                  children: views,
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTranslationTab(
    AyahRef ref,
    String languageCode, {
    required bool showTafsirButton,
  }) {
    return BlocBuilder<AyahTranslationCubit, AyahTranslationState>(
      builder: (context, state) {
        final status = state.status.status;

        if (status.isLoading || status.isInitial) {
          return _buildLoadingState();
        }

        if (status.isError) {
          return _buildErrorState(
            title: context.l10n.translationErrorTitle,
            message: state.status.message,
            onRetry: () => context
                .read<AyahTranslationCubit>()
                .fetchTranslation(ref, languageCode),
          );
        }

        if (!status.isHasData || state.status.data == null) {
          return _buildEmptyState(context.l10n.noTranslation);
        }

        final translation = state.status.data!;
        if (translation.text.trim().isEmpty) {
          return _buildEmptyState(context.l10n.noTranslation);
        }
        return _buildContentState(
          text: translation.text,
          isArabic: languageCode == 'ar',
          onCopy: () => _copyText(context, translation.text),
          onShare: () => _shareText(translation.text),
          showTafsirButton: showTafsirButton,
          onShowTafsir: showTafsirButton
              ? () {
                  DefaultTabController.of(context).animateTo(1);
                }
              : null,
        );
      },
    );
  }

  Widget _buildTafsirTab(AyahRef ref, String languageCode) {
    return BlocBuilder<AyahTafsirCubit, AyahTafsirState>(
      builder: (context, state) {
        final status = state.status.status;

        if (status.isLoading || status.isInitial) {
          return _buildLoadingState();
        }

        if (status.isError) {
          return _buildErrorState(
            title: context.l10n.tafsirErrorTitle,
            message: state.status.message,
            onRetry: () => context
                .read<AyahTafsirCubit>()
                .fetchTafsir(ref, languageCode),
          );
        }

        if (!status.isHasData || state.status.data == null) {
          return _buildEmptyState(context.l10n.noTafsir);
        }

        final tafsir = state.status.data!;
        if (tafsir.text.trim().isEmpty) {
          return _buildEmptyState(context.l10n.noTafsir);
        }
        return _buildContentState(
          text: tafsir.text,
          isArabic: languageCode == 'ar',
          onCopy: () => _copyText(context, tafsir.text),
          onShare: () => _shareText(tafsir.text),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: widget.prefSetProvider.isDarkTheme ? Colors.white : kPurplePrimary,
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: kHeading6.copyWith(
          fontSize: 12.0,
          color: widget.prefSetProvider.isDarkTheme ? kGreyLight : kDarkPurple,
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kHeading6.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: widget.prefSetProvider.isDarkTheme
                  ? Colors.white
                  : kDarkPurple,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            message,
            style: kHeading6.copyWith(
              fontSize: 12.0,
              color: widget.prefSetProvider.isDarkTheme
                  ? kGreyLight
                  : kDarkPurple,
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentState({
    required String text,
    required VoidCallback onCopy,
    required VoidCallback onShare,
    bool showTafsirButton = false,
    VoidCallback? onShowTafsir,
    bool isArabic = false,
  }) {
    final actionColor = widget.prefSetProvider.isDarkTheme
        ? Colors.white
        : kPurplePrimary;
    final lineHeight = isArabic ? 1.9 : 1.6;
    final arabicStyle = arabicBodyStyle(
      widget.prefSetProvider.arabicFontFamily,
      scale: widget.prefSetProvider.arabicFontScale,
    );
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _actionButton(
              icon: Icons.copy_rounded,
              label: context.l10n.copy,
              onPressed: onCopy,
              color: actionColor,
            ),
            _actionButton(
              icon: Icons.share_rounded,
              label: context.l10n.share,
              onPressed: onShare,
              color: actionColor,
            ),
            if (showTafsirButton)
              _actionButton(
                icon: Icons.menu_book_rounded,
                label: context.l10n.showTafsir,
                onPressed: onShowTafsir ?? () {},
                color: actionColor,
              ),
          ],
        ),
        const SizedBox(height: 14.0),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SelectableText(
              text,
              textAlign: isArabic ? TextAlign.right : TextAlign.start,
              style: isArabic
                  ? arabicStyle.copyWith(
                      height: lineHeight,
                      color: widget.prefSetProvider.isDarkTheme
                          ? Colors.white
                          : kDarkPurple,
                    )
                  : kHeading6.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      height: lineHeight,
                      color: widget.prefSetProvider.isDarkTheme
                          ? Colors.white
                          : kDarkPurple,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        textStyle: kSubtitle.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.copied)),
    );
  }

  void _shareText(String text) {
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final highlightColor = kPurplePrimary.withValues(alpha: 0.12);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: widget.highlight ? highlightColor : Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        border: widget.highlight
            ? Border.all(color: kPurplePrimary.withValues(alpha: 0.4))
            : null,
      ),
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
                            .removeBookmarkVerse(widget.verses, widget.surah);
                        if (!context.mounted) {
                          return;
                        }

                        context.showCustomFlashMessage(
                          status: 'success',
                          title: context.l10n.bookmarkRemovedTitle,
                          darkTheme: widget.prefSetProvider.isDarkTheme,
                          message: context.l10n.bookmarkRemovedMessage(
                            widget.surah,
                            widget.verses.number.inSurah,
                          ),
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
                          title: context.l10n.bookmarkAddedTitle,
                          darkTheme: widget.prefSetProvider.isDarkTheme,
                          message: context.l10n.bookmarkAddedMessage(
                            widget.surah,
                            widget.verses.number.inSurah,
                          ),
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
                  widget.verses.text.transliteration.en,
                  style: kHeading6.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
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
