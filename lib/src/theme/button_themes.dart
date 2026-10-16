import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import 'pure_theme.dart';

/// Overrides elevatedButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class ElevatedButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const ElevatedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).elevatedButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ElevatedButtonTheme>()
        ?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return ElevatedButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ElevatedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ElevatedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides outlinedButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class OutlinedButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const OutlinedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).outlinedButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OutlinedButtonTheme>()
        ?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return OutlinedButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OutlinedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(OutlinedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides textButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class TextButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const TextButtonTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).textButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TextButtonTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return TextButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TextButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TextButtonTheme oldWidget) => data != oldWidget.data;
}

/// Overrides iconButton tokens for a subtree.
///
/// The nearest instance replaces the enclosing component style. Use [merge]
/// to retain tokens that are not explicitly supplied.
class IconButtonTheme extends InheritedTheme {
  /// Creates a component theme for [child].
  const IconButtonTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest component theme or its PureTheme style.
  static ButtonStyle of(BuildContext context) {
    return maybeOf(context) ?? PureTheme.of(context).iconButtonStyle;
  }

  /// Returns the nearest local component theme, if present.
  static ButtonStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IconButtonTheme>()?.data;
  }

  /// Adds [data] while inheriting its unset tokens from the enclosing theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (BuildContext context) {
        return IconButtonTheme(data: data.merge(of(context)), child: child);
      },
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return IconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(IconButtonTheme oldWidget) => data != oldWidget.data;
}

/// Overrides filledButton tokens within a subtree.
class FilledButtonTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const FilledButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ButtonStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).filledButtonStyle;

  /// Returns local tokens when this component theme is present.
  static ButtonStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FilledButtonTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        FilledButtonTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      FilledButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(FilledButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides floatingActionButton tokens within a subtree.
class FloatingActionButtonTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const FloatingActionButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ButtonStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).floatingActionButtonStyle;

  /// Returns local tokens when this component theme is present.
  static ButtonStyle? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<FloatingActionButtonTheme>()
      ?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        FloatingActionButtonTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      FloatingActionButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(FloatingActionButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides segmentedButton tokens within a subtree.
class SegmentedButtonTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const SegmentedButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ButtonStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).segmentedButtonStyle;

  /// Returns local tokens when this component theme is present.
  static ButtonStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SegmentedButtonTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        SegmentedButtonTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      SegmentedButtonTheme(data: data, child: child);

  @override
  bool updateShouldNotify(SegmentedButtonTheme oldWidget) =>
      data != oldWidget.data;
}

/// Overrides toggleButtons tokens within a subtree.
class ToggleButtonsTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const ToggleButtonsTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The component tokens inherited by this subtree.
  final ButtonStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static ButtonStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).toggleButtonsStyle;

  /// Returns local tokens when this component theme is present.
  static ButtonStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ToggleButtonsTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required ButtonStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        ToggleButtonsTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ToggleButtonsTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ToggleButtonsTheme oldWidget) =>
      data != oldWidget.data;
}
