import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class Navigation {
  /// Push a named route onto the navigator.
  static pushNamed(String routeName, {dynamic arguments}) {
    navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace the current route of the navigator by pushing the route named
  /// [routeName] and then disposing the previous route once the new route has
  /// finished animating in.
  static pushReplacementNamed(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  /// Pop the top-most route off the navigator.
  static pop() => navigatorKey.currentState?.pop();

  /// Calls [pop] repeatedly until the top-most route is same as parameter.
  static popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  /// Pop the current route off the navigator and push a named route in its
  /// place.
  static popAndPushNamed(String routeName) {
    navigatorKey.currentState?.popAndPushNamed(routeName);
  }
}
