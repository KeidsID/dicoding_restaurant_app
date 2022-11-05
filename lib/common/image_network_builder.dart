import 'package:flutter/material.dart';

import 'common.dart';

Widget frameBuilder(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
) {
  return child;
}

Widget loadingBuilder(
  BuildContext context,
  Widget child,
  ImageChunkEvent? loadingProgress,
) {
  if (loadingProgress == null) {
    return child;
  } else {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: primaryColorBrightest,
        color: primaryColor,
      ),
    );
  }
}

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
