import 'package:flutter/widgets.dart';

import '../styles/chip_style.dart';
import 'neutral_theme.dart';

/// Overrides chip tokens within a subtree.
class ChipTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const ChipTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ChipStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ChipStyle of(BuildContext context) =>
      maybeOf(context) ?? NeutralTheme.of(context).chipStyle;

  /// Returns local tokens when this component theme is present.
  static ChipStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChipTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ChipStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        ChipTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ChipTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ChipTheme oldWidget) => data != oldWidget.data;
}
