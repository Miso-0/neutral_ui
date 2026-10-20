import 'package:flutter/widgets.dart';

import '../foundation/style_resolution.dart';
import '../styles/button_style.dart';
import '../styles/dropdown_style.dart';

/// Turns a dropdown's single trailing icon while its menu is open.
///
/// The turn amount comes from [DropdownStyle.iconTurns] and defaults to a half
/// turn. Timing follows the trigger's button style, defaulting to 200 ms with
/// [Curves.easeInOut] like every other NeutralUI transition.
class DropdownIcon extends StatelessWidget {
  /// Creates a rotating icon resolved against [layers].
  const DropdownIcon({
    super.key,
    required this.icon,
    required this.open,
    required this.layers,
  });

  /// The application-provided icon, drawn in its closed orientation.
  final Widget icon;

  /// Whether the menu is open.
  final bool open;

  /// The dropdown style layers, highest precedence first.
  final List<DropdownStyle?> layers;

  @override
  Widget build(BuildContext context) {
    final List<ButtonStyle?> buttonLayers = <ButtonStyle?>[
      for (final DropdownStyle? style in layers) style?.buttonStyle,
    ];
    final double turns =
        resolvePlain<DropdownStyle, double>(
          layers,
          (DropdownStyle style) => style.iconTurns,
        ) ??
        0.5;
    return AnimatedRotation(
      turns: open ? turns : 0,
      duration:
          resolvePlain<ButtonStyle, Duration>(
            buttonLayers,
            (ButtonStyle style) => style.animationDuration,
          ) ??
          const Duration(milliseconds: 200),
      curve:
          resolvePlain<ButtonStyle, Curve>(
            buttonLayers,
            (ButtonStyle style) => style.animationCurve,
          ) ??
          Curves.easeInOut,
      child: icon,
    );
  }
}
