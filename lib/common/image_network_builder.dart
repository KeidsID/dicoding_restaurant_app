import 'package:flutter/material.dart';

import 'common.dart';

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
  if (loadingProgress == null) return child;

  return const Center(
    child: CircularProgressIndicator(
      backgroundColor: primaryColorBrightest,
      color: primaryColor,
    ),
  );
}
