import 'package:ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import 'package:ai_assistant/presentation/ui/ai_assistant_screen.dart';
import 'package:bookmark/presentation/bloc/bloc.dart';
import 'package:bookmark/presentation/ui/bookmark_screen.dart';
import 'package:common/utils/config/app_config.dart';
import 'package:common/utils/helper/preference_settings_helper.dart';
import 'package:common/utils/navigation/navigation.dart';
import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/route_observer/route_observer.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:detail_surah/presentation/bloc/bloc.dart';
import 'package:detail_surah/presentation/cubits/ayah_translation/ayah_translation_cubit.dart';
import 'package:detail_surah/presentation/cubits/ayah_tafsir/ayah_tafsir_cubit.dart';
import 'package:detail_surah/presentation/cubits/bookmark_verses/bookmark_verses_cubit.dart';
import 'package:detail_surah/presentation/cubits/last_read/last_read_cubit.dart';
import 'package:detail_surah/presentation/ui/detail_surah_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home/presentation/bloc/home_bloc.dart';
import 'package:home/presentation/ui/home_screen.dart';
import 'package:library_feature/presentation/ui/library_manage_screen.dart';
import 'package:library_feature/presentation/ui/library_screen.dart';
import 'package:quran_app/di/injections.dart';
import 'package:resources/constant/named_routes.dart';
import 'package:resources/constant/route_args.dart';
import 'package:resources/localization/app_localizations.dart';
import 'package:search/presentation/cubit/search_cubit.dart';
import 'package:search/presentation/ui/search_screen.dart';
import 'package:settings/presentation/ui/settings_screen.dart';
import 'package:settings/presentation/ui/audio_storage_screen.dart';
import 'package:splash/presentation/ui/onboard_screen.dart';
import 'package:splash/presentation/ui/splash_screen.dart';
import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart'
    as riverpod;

import 'dart:async';
import 'package:quran/data/database/database_helper.dart';
import 'core/services/notification_service.dart';
import 'core/services/workmanager_service.dart';
import 'package:core/network/ai_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await dotenv.load(fileName: ".env");
  await AppConfig.load();
  Injections().init();
  
  await NotificationService().init();
  await WorkmanagerService().init();
  AiService().init();

  runApp(const riverpod.ProviderScope(child: MyApp()));
  unawaited(sl<DatabaseHelper>().ensureQuranCoreData());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferenceSettingsProvider(
            preferenceSettingsHelper: PreferenceSettingsHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferenceSettingsProvider>(
        builder: (context, prefSetProvider, _) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            theme: prefSetProvider.themeData,
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          locale: prefSetProvider.locale,
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          builder: (context, child) {
            final isArabic = prefSetProvider.locale.languageCode == 'ar';
            return Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: NamedRoutes.splashScreen,
            routes: {
              NamedRoutes.splashScreen: (_) => const SplashScreen(),
              NamedRoutes.onBoardScreen: (_) => const OnBoardScreen(),
              NamedRoutes.homeScreen: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => HomeBloc(
                          getSurahUsecase: sl(),
                        ),
                      ),
                    ],
                    child: const HomeScreen(),
                  ),
              NamedRoutes.detailScreen: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => DetailSurahBloc(
                          getDetailSurahUsecase: sl(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => AyahTranslationCubit(
                          getAyahTranslationUsecase: sl(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => AyahTafsirCubit(
                          getAyahTafsirUsecase: sl(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => LastReadCubit(
                          saveLastReadUsecase: sl(),
                          updateLastReadUsecase: sl(),
                          getLastReadUsecase: sl(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => BookmarkVersesCubit(
                            saveBookmarkVersesUseCase: sl(),
                            removeBookmarkVersesUsecase: sl(),
                            statusBookmarkVerseUsecase: sl()),
                      ),
                    ],
                    child: Builder(
                      builder: (context) {
                        final args =
                            ModalRoute.of(context)?.settings.arguments;
                        final surahId = args is DetailScreenArgs
                            ? args.surahNumber
                            : args as int;
                        final highlightAyah = args is DetailScreenArgs
                            ? args.highlightAyah
                            : null;
                        return DetailSurahScreen(
                          id: surahId,
                          highlightAyah: highlightAyah,
                        );
                      },
                    ),
                  ),
              NamedRoutes.bookmarkScreen: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => BookmarkBloc(
                          getBookmarkVersesUsecase: sl(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) => BookmarkVersesCubit(
                          removeBookmarkVersesUsecase: sl(),
                          saveBookmarkVersesUseCase: sl(),
                          statusBookmarkVerseUsecase: sl(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => LastReadCubit(
                          getLastReadUsecase: sl(),
                          saveLastReadUsecase: sl(),
                          updateLastReadUsecase: sl(),
                        ),
                      ),
                    ],
                    child: const BookmarkScreen(),
                  ),
              NamedRoutes.searchScreen: (context) => BlocProvider(
                    create: (_) => SearchCubit(
                      searchVersesUsecase: sl(),
                      buildSearchIndexUsecase: sl(),
                      isSearchIndexReadyUsecase: sl(),
                    ),
                    child: const SearchScreen(),
                  ),
              NamedRoutes.aiAssistantScreen: (context) => BlocProvider(
                    create: (_) => AiAssistantCubit(
                      getAiTadabburUsecase: sl(),
                    ),
                    child: const AiAssistantScreen(),
                  ),
              NamedRoutes.settingsScreen: (_) => const SettingsScreen(),
              NamedRoutes.audioStorageScreen: (_) =>
                  const AudioStorageScreen(),
              NamedRoutes.libraryScreen: (_) => const LibraryScreen(),
              NamedRoutes.libraryManageScreen: (_) =>
                  const LibraryManageScreen(),
            },
          );
        },
      ),
    );
  }
}

