import 'package:flutter/material.dart';

class RestaurantGridViewContainer extends StatelessWidget {
  const RestaurantGridViewContainer({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.color,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.child,
  }) : super(key: key);

  /// Space between [child] and Container border.
  final EdgeInsetsGeometry padding;

  /// Container color.
  final Color? color;

  /// Space to surround the container.
  final EdgeInsetsGeometry margin;

  /// Called when the user taps this Container.
  final void Function()? onTap;

  /// The Container content.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // margin
      padding: margin,
      child: Material(
        // decoration
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            // padding
            padding: padding,
            // Container content
            child: child,
          ),
        ),
      ),
    );
  }
}
