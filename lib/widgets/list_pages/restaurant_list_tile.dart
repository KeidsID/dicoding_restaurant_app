import 'package:flutter/material.dart';

class RestaurantListTile extends StatelessWidget {
  const RestaurantListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically an [icon] or a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// A widget to display after the title
  ///
  /// Typically an [Icon] widget
  final Widget trailing;

  /// Called when the user taps this list tile.
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
    );
  }
}
