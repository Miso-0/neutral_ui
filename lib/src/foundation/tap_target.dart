import 'package:flutter/widgets.dart';

/// Enlarges a child's interactive area without expanding its visual content.
class TapTarget extends StatelessWidget {
  /// Creates an optional minimum interactive size around [child].
  const TapTarget({super.key, this.minSize, required this.child});

  /// The minimum interactive dimensions, or null to use the child's dimensions.
  final Size? minSize;

  /// The visual content centered inside the interactive area.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size? size = minSize;
    if (size == null) {
      return child;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: size.width, minHeight: size.height),
      child: Align(widthFactor: 1, heightFactor: 1, child: child),
    );
  }
}
