import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import 'button_style_button.dart';

/// Internal button foundation for selectable controls.
class SelectionButton extends ButtonStyleButton {
  /// Creates selection button.
  const SelectionButton({
    super.key,
    required super.child,
    required super.onPressed,
    required this.isSelected,
    this.themeStyle,
    super.style,
    super.focusNode,
    super.autofocus,
    super.decoration,
    super.foregroundDecoration,
    super.leading,
    super.trailing,
    super.icon,
    super.isSemanticButton,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.clipBehavior,
  });

  /// The is selected for this component.
  final bool isSelected;

  /// The theme style for this component.
  final ButtonStyle? themeStyle;
  @override
  bool get selected => isSelected;
  @override
  ButtonStyle? themeStyleOf(BuildContext context) => themeStyle;
}
