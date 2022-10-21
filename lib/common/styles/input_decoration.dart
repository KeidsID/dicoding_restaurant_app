import 'package:flutter/material.dart';

import '../common.dart';

InputDecoration inputDeco({String? hintText}) {
  return InputDecoration(
    filled: true,
    fillColor: primaryColorBrightest.withOpacity(0.25),
    hintText: hintText,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: secondaryColor,
        width: 2,
      ),
    ),
  );
}
