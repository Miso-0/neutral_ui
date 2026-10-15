import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import '../theme/button_themes.dart';
import 'button_style_button.dart';

/// A headless button styled by the nearest [ElevatedButtonTheme].
///
/// Appearance comes from the decoration parameters and inherited or inline style.
class ElevatedButton extends ButtonStyleButton {
  /// Creates a button with optional leading, trailing, and icon content.
  const ElevatedButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    super.statesController,
    super.isSemanticButton = true,
    super.leading,
    super.trailing,
    super.icon,
    super.iconAlignment,
    super.isLoading = false,
    super.loadingIndicator,
  });

  /// Creates a button with an icon alongside its label.
  const ElevatedButton.icon({
    super.key,
    required super.onPressed,
    required Widget label,
    super.icon,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    super.statesController,
    super.isSemanticButton = true,
    super.leading,
    super.trailing,
    super.iconAlignment,
    super.isLoading = false,
    super.loadingIndicator,
  }) : super(child: label);

  @override
  ButtonStyle? themeStyleOf(BuildContext context) =>
      ElevatedButtonTheme.of(context);
}
