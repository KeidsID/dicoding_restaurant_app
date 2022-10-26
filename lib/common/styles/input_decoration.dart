import 'package:flutter/material.dart';

import '../common.dart';

InputDecoration inputDeco({String? hintText, Widget? label}) {
  return InputDecoration(
    label: label,
    hintText: hintText,
    filled: true,
    fillColor: primaryColorBrightest.withOpacity(0.25),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: secondaryColor,
        width: 2,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ),
  );
}
