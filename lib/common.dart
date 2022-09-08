export 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'styles/style.dart';

import 'package:flutter/material.dart';

import 'styles/style.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

TextStyle? txtThemeH1(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.headline1?.copyWith(color: color);
}

TextStyle? txtThemeH2(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.headline2?.copyWith(color: color);
}

TextStyle? txtThemeH3(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.headline3?.copyWith(color: color);
}

TextStyle? txtThemeH4(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.headline4?.copyWith(color: color);
}

TextStyle? txtThemeH5(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.headline5?.copyWith(color: color);
}

TextStyle? txtThemeH6(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.headline6?.copyWith(color: color);
}

TextStyle? txtThemeSub1(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.subtitle1?.copyWith(color: color);
}

TextStyle? txtThemeSub2(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.subtitle2?.copyWith(color: color);
}

TextStyle? txtThemeButton(
  BuildContext context, {
  required Color color,
  TextDecoration decoration = TextDecoration.none,
}) {
  return Theme.of(context)
      .textTheme
      .button
      ?.copyWith(color: color, decoration: decoration);
}

TextStyle? txtThemeCaption(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.caption?.copyWith(color: color);
}

TextStyle? txtThemeOverline(BuildContext context, {required Color color}) {
  return Theme.of(context).textTheme.overline?.copyWith(color: color);
}
