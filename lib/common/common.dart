export 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'styles/style.dart';
export 'styles/input_decoration.dart';
export 'navigation.dart';

import 'package:flutter/material.dart';

import 'styles/style.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

/// Extremely large text
TextStyle? txtThemeH1 = textTheme.headline1;

/// Very, very large text
///
/// Used for the date in the dialog shown by [showDatePicker].
TextStyle? txtThemeH2 = textTheme.headline2;

/// Very large text
TextStyle? txtThemeH3 = textTheme.headline3;

/// Large text
TextStyle? txtThemeH4 = textTheme.headline4;

/// Used for large text in dialogs
///
/// (e.g., the month and year in the dialog shown by [showDatePicker]).
TextStyle? txtThemeH5 = textTheme.headline5;

/// Used for the primary text in app bars and dialogs
///
/// (e.g., [AppBar.title] and [AlertDialog.title]).
TextStyle? txtThemeH6 = textTheme.headline6;

/// Used for the primary text in lists (e.g., [ListTile.title]).
TextStyle? txtThemeSub1 = textTheme.subtitle1;

/// For medium emphasis text that's a little smaller than [txtThemeSub1].
TextStyle? txtThemeSub2 = textTheme.subtitle2;

/// Used for emphasizing text that would otherwise be [txtThemeBody2].
TextStyle? txtThemeBody1 = textTheme.bodyText1;

/// The default text style for [Material].
TextStyle? txtThemeBody2 = textTheme.bodyText2;

/// Used for text on [ElevatedButton], [TextButton] and [OutlinedButton].
TextStyle? txtThemeBtn = textTheme.button;

/// Used for auxiliary text associated with images.
TextStyle? txtThemeCap = textTheme.caption;

/// The smallest style.
///
/// Typically used for captions or to introduce a (larger) headline.
TextStyle? txtThemeOverline = textTheme.overline;
