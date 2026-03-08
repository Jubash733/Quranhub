import 'package:flutter/material.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.light,
  ).copyWith(
    surface: kSurfaceLight,
    onSurface: kDarkPurple,
    primary: kSeedColor,
    secondary: kSecondarySeed,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: kGrey92,
    foregroundColor: kDarkPurple,
  ),
  scaffoldBackgroundColor: kGrey92,
  textTheme: kTextTheme.apply(
    bodyColor: kDarkPurple,
    decorationColor: kDarkPurple,
    displayColor: kDarkPurple,
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.dark,
  ).copyWith(
    surface: kSurfaceDark,
    onSurface: Colors.white,
    primary: kSeedColor,
    secondary: kSecondarySeed,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: kSurfaceDark,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: kDarkTheme,
  textTheme: kTextTheme.apply(
    bodyColor: Colors.white,
    decorationColor: Colors.white,
    displayColor: Colors.white,
  ),
);
