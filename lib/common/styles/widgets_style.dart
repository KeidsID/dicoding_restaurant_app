import 'package:flutter/material.dart';

import 'style.dart';

final appBarTheme = AppBarTheme(
  foregroundColor: primaryColor,
  backgroundColor: backgroundColor,
  titleTextStyle: textTheme.headline6?.copyWith(color: primaryColor),
);

const listTileThemeData = ListTileThemeData(
  textColor: primaryColor,
  iconColor: primaryColor,
);

final tabBarTheme = TabBarTheme(
  indicator: const BoxDecoration(
      border: Border(
    bottom: BorderSide(
      color: primaryColor,
      width: 1,
    ),
  )),
  labelColor: primaryColor,
  labelStyle: textTheme.button?.copyWith(color: primaryColor),
);

final elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: backgroundColor,
  ),
);

final textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryColorBrighter,
    textStyle: textTheme.button,
  ),
);

const iconThemeData = IconThemeData(color: primaryColor);

final chipThemeData = ChipThemeData(
  backgroundColor: primaryColorBrightest.withOpacity(0.25),
  labelStyle: textTheme.bodyText1?.copyWith(
    color: primaryColor,
  ),
);

final snackBarThemeData = SnackBarThemeData(
  contentTextStyle: textTheme.subtitle2?.copyWith(color: secondaryColor),
);
