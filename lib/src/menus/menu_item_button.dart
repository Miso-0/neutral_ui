import 'package:flutter/widgets.dart';

import '../buttons/button_style_button.dart';
import '../foundation/state_property.dart';
import '../foundation/interaction_state.dart';
import '../foundation/style_resolution.dart';
import '../styles/button_style.dart';

/// Reuses the button pipeline for menu triggers and option rows.
class MenuItemButton extends ButtonStyleButton {
  /// Creates a headless menu button.
  const MenuItemButton({
    super.key,
    required super.child,
    required super.onPressed,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    this.themeStyle,
    bool? isSelected,
    bool? isChecked,
    bool? isFocused,
    bool? isExpanded,
    super.focusNode,
    super.autofocus,
    super.leading,
    super.trailing,
    super.statesController,
    this.tooltip,
    this.defaultTapTarget,
  }) : _selected = isSelected,
       _checked = isChecked,
       _focused = isFocused,
       _expanded = isExpanded;

  /// The lower-precedence component tokens.
  final ButtonStyle? themeStyle;

  /// The accessible tooltip.
  final String? tooltip;

  /// A structural minimum hit target for icon triggers.
  final Size? defaultTapTarget;
  final bool? _selected;
  final bool? _checked;
  final bool? _focused;
  final bool? _expanded;

  @override
  bool? get selected => _selected;
  @override
  bool? get checked => _checked;
  @override
  bool? get virtualFocused => _focused;
  @override
  bool? get expanded => _expanded;
  @override
  String? get semanticTooltip => tooltip;
  @override
  ButtonStyle? themeStyleOf(BuildContext context) => themeStyle;
  @override
  ButtonStyle defaultStyleOf(BuildContext context) => super
      .defaultStyleOf(context)
      .copyWith(
        alignment: AlignmentDirectional.centerStart,
        tapTargetSize: defaultTapTarget,
      );
}

/// Preserves per-state null fallback across any number of button style layers.
ButtonStyle layeredButtonStyle(List<ButtonStyle?> layers) {
  StateProperty<T?> property<T>(
    StateProperty<T?>? Function(ButtonStyle) select,
  ) => StateProperty<T?>.resolveWith(
    (InteractionState state) =>
        resolveStateful<ButtonStyle, T>(state, layers, select),
  );
  T? plain<T>(T? Function(ButtonStyle) select) =>
      resolvePlain<ButtonStyle, T>(layers, select);
  return ButtonStyle(
    decoration: property<Decoration>((ButtonStyle s) => s.decoration),
    foregroundDecoration: property<Decoration>(
      (ButtonStyle s) => s.foregroundDecoration,
    ),
    padding: property<EdgeInsetsGeometry>((ButtonStyle s) => s.padding),
    minimumSize: property<Size>((ButtonStyle s) => s.minimumSize),
    fixedSize: property<Size>((ButtonStyle s) => s.fixedSize),
    maximumSize: property<Size>((ButtonStyle s) => s.maximumSize),
    textStyle: property<TextStyle>((ButtonStyle s) => s.textStyle),
    iconTheme: property<IconThemeData>((ButtonStyle s) => s.iconTheme),
    mouseCursor: property<MouseCursor>((ButtonStyle s) => s.mouseCursor),
    loadingIndicator: property<Widget>((ButtonStyle s) => s.loadingIndicator),
    alignment: plain<AlignmentGeometry>((ButtonStyle s) => s.alignment),
    spacing: plain<double>((ButtonStyle s) => s.spacing),
    iconAlignment: plain<IconAlignment>((ButtonStyle s) => s.iconAlignment),
    tapTargetSize: plain<Size>((ButtonStyle s) => s.tapTargetSize),
    clipBehavior: plain<Clip>((ButtonStyle s) => s.clipBehavior),
    animationDuration: plain<Duration>((ButtonStyle s) => s.animationDuration),
    animationCurve: plain<Curve>((ButtonStyle s) => s.animationCurve),
    enableFeedback: plain<bool>((ButtonStyle s) => s.enableFeedback),
  );
}
