import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color backgroundColorPrimary = const Color(0xFFCB1414);
Color primaryTextColor = const Color(0xFF100F0F);
Color secondaryTextColor = const Color(0xFFF8F8F8);
Color tertiaryTextColor = const Color(0xFFB0B0B0);
Color formFieldColor = const Color(0xFFDDDDDD);

TextStyle primaryTextStyle = GoogleFonts.quicksand(
  color: primaryTextColor,
);

TextStyle secondaryTextStyle = GoogleFonts.quicksand(
  color: secondaryTextColor,
);

TextStyle tertiaryTextStyle = GoogleFonts.quicksand(
  color: tertiaryTextColor,
);

TextStyle redTextStyle = GoogleFonts.quicksand(
  color: backgroundColorPrimary,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

double defaultMargin = 20;