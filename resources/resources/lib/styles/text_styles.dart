import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

// text theme
final kTextTheme = TextTheme(
  headlineSmall: kHeading5,
  titleLarge: kHeading6,
  titleMedium: kSubtitle,
  bodyMedium: kBodyText,
);
