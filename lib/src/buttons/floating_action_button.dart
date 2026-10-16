import 'package:flutter/widgets.dart';

import '../feedback/tooltip.dart';
import '../foundation/state_property.dart';
import '../styles/button_style.dart';
import '../theme/button_themes.dart';
import 'button_style_button.dart';

/// A headless floating action with a 48 by 48 minimum interactive target.
class FloatingActionButton extends ButtonStyleButton {
  /// Creates floating action button.
  const FloatingActionButton({
    super.key,
    required super.onPressed,
    super.child,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    this.mini = false,
    this.isExtended = false,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : _dimension = mini ? 40 : 56;

  /// Creates floating action button.small.
  const FloatingActionButton.small({
    super.key,
    required super.onPressed,
    super.child,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : mini = true,
       _dimension = 40,
       isExtended = false;

  /// Creates floating action button.large.
  const FloatingActionButton.large({
    super.key,
    required super.onPressed,
    super.child,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : mini = false,
       _dimension = 96,
       isExtended = false;

  /// Creates floating action button.extended.
  const FloatingActionButton.extended({
    super.key,
    required super.onPressed,
    required Widget label,
    super.icon,
    this.tooltip,
    this.heroTag = const _DefaultHeroTag(),
    this.isExtended = true,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : mini = false,
       _dimension = 56,
       super(child: label);

  /// The tooltip for this component.
  final String? tooltip;

  /// The hero tag for this component.
  final Object? heroTag;

  /// The mini for this component.
  final bool mini;

  /// The is extended for this component.
  final bool isExtended;
  final double _dimension;

  @override
  String? get semanticTooltip => tooltip;
  @override
  ButtonStyle? themeStyleOf(BuildContext context) =>
      FloatingActionButtonTheme.of(context);
  @override
  ButtonStyle defaultStyleOf(BuildContext context) => super
      .defaultStyleOf(context)
      .copyWith(
        minimumSize: StateProperty<Size?>.all(Size.square(_dimension)),
        tapTargetSize: const Size(48, 48),
      );
  @override
  State<ButtonStyleButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<FloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    Widget result = _FloatingButton(
      onPressed: widget.onPressed,
      icon: widget.icon,
      style: widget.style,
      decoration: widget.decoration,
      foregroundDecoration: widget.foregroundDecoration,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      onLongPress: widget.onLongPress,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      tooltip: widget.tooltip,
      dimension: widget._dimension,
      child: widget.isExtended || widget.icon == null ? widget.child : null,
    );
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip, child: result);
    }
    if (widget.heroTag != null) {
      result = Hero(tag: widget.heroTag!, child: result);
    }
    return result;
  }
}

class _FloatingButton extends ButtonStyleButton {
  const _FloatingButton({
    required super.onPressed,
    super.child,
    super.icon,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    this.tooltip,
    required this.dimension,
  });
  final String? tooltip;
  final double dimension;
  @override
  String? get semanticTooltip => tooltip;
  @override
  ButtonStyle? themeStyleOf(BuildContext context) =>
      FloatingActionButtonTheme.of(context);
  @override
  ButtonStyle defaultStyleOf(BuildContext context) => super
      .defaultStyleOf(context)
      .copyWith(
        minimumSize: StateProperty<Size?>.all(Size.square(dimension)),
        tapTargetSize: const Size(48, 48),
      );
}

class _DefaultHeroTag {
  const _DefaultHeroTag();
}
