import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import '../theme/button_themes.dart';
import 'button_style_button.dart';

/// A headless icon button with a default 48 by 48 logical pixel touch target.
///
/// [tooltip] supplies an accessibility tooltip only. Wrap this widget in
/// [RawTooltip] when a visible tooltip is needed.
class IconButton extends ButtonStyleButton {
  /// Creates an optionally selectable icon button.
  const IconButton({
    super.key,
    required super.onPressed,
    required Widget icon,
    this.selectedIcon,
    this.isSelected,
    this.tooltip,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    super.statesController,
    super.isSemanticButton = true,
    super.isLoading = false,
    super.loadingIndicator,
  }) : super(child: null, icon: icon);

  @override
  Widget get icon => super.icon!;

  /// Replaces [icon] when [isSelected] is true.
  final Widget? selectedIcon;

  /// Whether the icon is selected, or null for a button without selection.
  final bool? isSelected;

  /// Accessibility tooltip text; this does not display a visual tooltip.
  final String? tooltip;

  @override
  bool? get selected => isSelected;

  @override
  Widget? get selectedChild => selectedIcon;

  @override
  String? get semanticTooltip => tooltip;

  @override
  ButtonStyle? themeStyleOf(BuildContext context) =>
      IconButtonTheme.of(context);

  @override
  ButtonStyle defaultStyleOf(BuildContext context) =>
      super.defaultStyleOf(context).copyWith(tapTargetSize: const Size(48, 48));
}
