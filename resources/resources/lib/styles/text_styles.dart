import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ArabicFontFamily { amiri, cairo }

ArabicFontFamily arabicFontFamilyFromString(String? value) {
  switch (value) {
    case 'cairo':
      return ArabicFontFamily.cairo;
    case 'amiri':
    default:
      return ArabicFontFamily.amiri;
  }
}

String arabicFontFamilyKey(ArabicFontFamily family) {
  return family == ArabicFontFamily.cairo ? 'cairo' : 'amiri';
}

TextStyle arabicVerseStyle(
  ArabicFontFamily family, {
  double scale = 1.0,
}) {
  final isAmiri = family == ArabicFontFamily.amiri;
  final base = isAmiri ? GoogleFonts.amiri() : GoogleFonts.cairo();
  return base.copyWith(
    fontSize: (isAmiri ? 30 : 28) * scale,
    fontWeight: FontWeight.w400,
    height: isAmiri ? 1.8 : 1.6,
  );
}

TextStyle arabicBodyStyle(
  ArabicFontFamily family, {
  double scale = 1.0,
}) {
  final isAmiri = family == ArabicFontFamily.amiri;
  final base = isAmiri ? GoogleFonts.amiri() : GoogleFonts.cairo();
  return base.copyWith(
    fontSize: (isAmiri ? 18 : 17) * scale,
    fontWeight: FontWeight.w400,
    height: isAmiri ? 1.7 : 1.55,
  );
}

// text style
final TextStyle kHeading5 = GoogleFonts.cairo(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
final TextStyle kHeading6 = GoogleFonts.cairo(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.25,
);
final TextStyle kSubtitle = GoogleFonts.cairo(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.35,
);
final TextStyle kBodyText = GoogleFonts.cairo(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

final TextStyle kArabicVerse = arabicVerseStyle(ArabicFontFamily.amiri);
final TextStyle kArabicBody = arabicBodyStyle(ArabicFontFamily.amiri);

// text theme
final kTextTheme = TextTheme(
  headlineSmall: kHeading5,
  titleLarge: kHeading6,
  titleMedium: kSubtitle,
  bodyMedium: kBodyText,
);
