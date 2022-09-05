import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets_style.dart';

String appName = 'RESTAURantS';

const Color primaryColor = Color(0xFF356859); // Basil Green [800]
const Color primaryColorBrighter = Color(0xFF37966F); // [500]
const Color primaryColorBrightest = Color(0xFFB9E4C9); // [100]

const Color secondaryColor = Color(0xFFFD5523); // Basil Orange [800]
const Color backgroundColor = Color(0xFFFFFBE6); // [50]

final myTheme = ThemeData(
  primaryColor: primaryColor,
  canvasColor: backgroundColor,
  textTheme: textTheme,
  appBarTheme: appBarTheme,
  listTileTheme: listTileThemeData,
  tabBarTheme: tabBarTheme,
  elevatedButtonTheme: elevatedButtonThemeData,
  iconTheme: iconThemeData,
);

final textTheme = TextTheme(
  headline1: GoogleFonts.montserrat(
    fontSize: 96,
    fontWeight: FontWeight.w600,
  ),
  headline2: GoogleFonts.montserrat(
    fontSize: 60,
    fontWeight: FontWeight.w600,
  ),
  headline3: GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.w600,
  ),
  headline4: GoogleFonts.montserrat(
    fontSize: 34,
    fontWeight: FontWeight.w600,
  ),
  headline5: GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  ),
  headline6: GoogleFonts.lekton(
    fontSize: 21,
    fontWeight: FontWeight.bold,
  ),
  subtitle1: GoogleFonts.lekton(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  ),
  subtitle2: GoogleFonts.lekton(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  bodyText1: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  bodyText2: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  button: GoogleFonts.montserrat(
    /// CAPS Lock
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  caption: GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  overline: GoogleFonts.montserrat(
    /// CAPS Lock
    fontSize: 10,
    fontWeight: FontWeight.normal,
  ),
);
