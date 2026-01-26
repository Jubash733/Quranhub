import 'package:flutter/material.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: kColorScheme.copyWith(
    brightness: Brightness.light,
    surface: Colors.white,
    onSurface: kDarkPurple,
    primary: kPurplePrimary,
    onPrimary: Colors.white,
  ),
  appBarTheme: const AppBarTheme(elevation: 0),
  scaffoldBackgroundColor: Colors.white,
  textTheme: kTextTheme.apply(
    bodyColor: kDarkPurple,
    decorationColor: kDarkPurple,
    displayColor: kDarkPurple,
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: kColorScheme.copyWith(
    brightness: Brightness.dark,
    primary: kPurplePrimary,
    onPrimary: Colors.white,
    surface: kDarkTheme,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(elevation: 0),
  scaffoldBackgroundColor: kDarkTheme,
  textTheme: kTextTheme.apply(
    bodyColor: Colors.white,
    decorationColor: Colors.white,
    displayColor: Colors.white,
  ),
);
