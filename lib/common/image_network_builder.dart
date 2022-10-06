import 'package:flutter/material.dart';

Widget errorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return Image.asset(
    'assets/images/photo_error_icon.png',
    fit: BoxFit.fill,
  );
}

Widget loadingBuilder(
  BuildContext context,
  Widget child,
  ImageChunkEvent? loadingProgress,
) {
  return Center(
    child: CircularProgressIndicator(),
  );
}
