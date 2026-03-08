import 'package:flutter/material.dart';

const Color kSeedColor = Color(0xFF4F6D7A); // Calm blue-gray
const Color kSecondarySeed = Color(0xFF6B7280);
const Color kPurplePrimary = Color(0xFF55608F); // Muted indigo
const Color kPurpleSecondary = Color(0xFF47526B);
const Color kDarkPurple = Color(0xFF1E293B);
const Color kBlackPurple = Color(0xFF0B1220);
const Color kGrey = Color(0xFF8A94A6);
const Color kGrey92 = Color(0xFFF6F7F9);
const Color kGreyLight = Color(0xFFE8ECF3);
const Color kMikadoYellow = Color(0xFFE6B77A);
const Color kLinearPurple1 = Color(0xFFC9D2E8);
const Color kLinearPurple2 = Color(0xFF7C8AB5);
const Color kDarkTheme = Color(0xFF0B1220);
const Color kSurfaceDark = Color(0xFF111827);
const Color kSurfaceLight = Color(0xFFF1F3F6);

// Legendary Colors
const Color kGlassBlack = Color(0xDD000000); // Darker glass for readability
const Color kGlassWhite = Color(0xDDFFFFFF);
const Color kGoldPrimary = Color(0xFFD4AF37);
const Color kGoldDark = Color(0xFFA88621);
const Color kDeepBlue = Color(0xFF0F172A);
const Color kCyberCyan = Color(0xFF00F0FF); // For glowing accents

const kColorScheme = ColorScheme(
  primary: kSeedColor,
  primaryContainer: kSeedColor,
  secondary: kSecondarySeed,
  secondaryContainer: kSecondarySeed,
  surface: kSurfaceLight,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: kDarkPurple,
  onError: Colors.white,
  brightness: Brightness.light,
);
