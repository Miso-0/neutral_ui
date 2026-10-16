import 'package:flutter/widgets.dart';

import '../styles/tooltip_style.dart';
import '../styles/dialog_style.dart';
import '../styles/bottom_sheet_style.dart';
import '../styles/snack_bar_style.dart';
import 'pure_theme.dart';

/// Overrides tooltip tokens within a subtree.
class TooltipTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const TooltipTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final TooltipStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static TooltipStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).tooltipStyle;

  /// Returns local tokens when this component theme is present.
  static TooltipStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TooltipTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required TooltipStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        TooltipTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      TooltipTheme(data: data, child: child);

  @override
  bool updateShouldNotify(TooltipTheme oldWidget) => data != oldWidget.data;
}

/// Overrides dialog tokens within a subtree.
class DialogTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const DialogTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final DialogStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static DialogStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).dialogStyle;

  /// Returns local tokens when this component theme is present.
  static DialogStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DialogTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required DialogStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        DialogTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      DialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(DialogTheme oldWidget) => data != oldWidget.data;
}

/// Overrides bottomSheet tokens within a subtree.
class BottomSheetTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const BottomSheetTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final BottomSheetStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static BottomSheetStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).bottomSheetStyle;

  /// Returns local tokens when this component theme is present.
  static BottomSheetStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BottomSheetTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required BottomSheetStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        BottomSheetTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      BottomSheetTheme(data: data, child: child);

  @override
  bool updateShouldNotify(BottomSheetTheme oldWidget) => data != oldWidget.data;
}

/// Overrides snackBar tokens within a subtree.
class SnackBarTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const SnackBarTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final SnackBarStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static SnackBarStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).snackBarStyle;

  /// Returns local tokens when this component theme is present.
  static SnackBarStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SnackBarTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required SnackBarStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        SnackBarTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      SnackBarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(SnackBarTheme oldWidget) => data != oldWidget.data;
}
