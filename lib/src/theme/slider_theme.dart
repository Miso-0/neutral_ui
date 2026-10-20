import 'package:flutter/widgets.dart';

import '../styles/slider_style.dart';
import 'neutral_theme.dart';

/// Overrides slider tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class SliderTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const SliderTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final SliderStyle data;

  /// Returns the nearest component theme or its NeutralTheme style.
  static SliderStyle of(BuildContext context) {
    return maybeOf(context) ?? NeutralTheme.of(context).sliderStyle;
  }

  /// Returns the nearest local component theme, if present.
  static SliderStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SliderTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required SliderStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return SliderTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return SliderTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(SliderTheme oldWidget) => data != oldWidget.data;
}
