import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class Navigation {
  static pushNamed(String routeName, {dynamic arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static pop() => navigatorKey.currentState?.pop();
}
