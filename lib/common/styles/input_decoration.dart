import 'package:flutter/material.dart';

import '../common.dart';

InputDecoration inputDeco({
  String? hintText,
  Widget? label,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    label: label,
    hintText: hintText,
    suffixIcon: suffixIcon,
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
