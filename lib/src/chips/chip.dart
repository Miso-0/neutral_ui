import 'package:flutter/widgets.dart';

import '../buttons/selection_button.dart';
import '../buttons/text_button.dart';
import '../feedback/tooltip.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../localizations/neutral_localizations.dart';
import '../styles/button_style.dart';
import '../styles/chip_style.dart';
import '../theme/chip_theme.dart';

/// A compact label with optional avatar and independent delete action.
class Chip extends _Chip {
  /// Creates chip.
  const Chip({
    super.key,
    required super.label,
    super.avatar,
    super.onDeleted,
    super.deleteIcon,
    super.deleteButtonTooltipMessage,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
  });
}

/// A chip that supports selection, activation, and deletion.
class InputChip extends _Chip {
  /// Creates input chip.
  const InputChip({
    super.key,
    required super.label,
    super.avatar,
    super.onDeleted,
    super.deleteIcon,
    super.deleteButtonTooltipMessage,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onSelected,
    super.onPressed,
    super.selected,
    super.isEnabled,
    super.showCheckmark,
    super.selectedIcon,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : super(supportsSelection: true);
}

/// A chip used to toggle a filter.
class FilterChip extends _Chip {
  /// Creates filter chip.
  const FilterChip({
    super.key,
    required super.label,
    required super.onSelected,
    super.avatar,
    super.selected,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.showCheckmark,
    super.selectedIcon,
    super.onDeleted,
    super.deleteIcon,
    super.deleteButtonTooltipMessage,
    super.onHover,
    super.onFocusChange,
  }) : super(requireCallback: true, supportsSelection: true);

  /// Creates filter chip.elevated.
  const FilterChip.elevated({
    super.key,
    required super.label,
    required super.onSelected,
    super.avatar,
    super.selected,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.showCheckmark,
    super.selectedIcon,
    super.onDeleted,
    super.deleteIcon,
    super.deleteButtonTooltipMessage,
    super.onHover,
    super.onFocusChange,
  }) : super(requireCallback: true, supportsSelection: true);
}

/// A chip used to select a single choice from a group.
class ChoiceChip extends _Chip {
  /// Creates choice chip.
  const ChoiceChip({
    super.key,
    required super.label,
    required super.selected,
    super.onSelected,
    super.avatar,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.showCheckmark,
    super.selectedIcon,
    super.onHover,
    super.onFocusChange,
  }) : super(requireCallback: true, supportsSelection: true);

  /// Creates choice chip.elevated.
  const ChoiceChip.elevated({
    super.key,
    required super.label,
    required super.selected,
    super.onSelected,
    super.avatar,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.showCheckmark,
    super.selectedIcon,
    super.onHover,
    super.onFocusChange,
  }) : super(requireCallback: true, supportsSelection: true);
}

/// A chip that invokes an action.
class ActionChip extends _Chip {
  /// Creates action chip.
  const ActionChip({
    super.key,
    required super.label,
    required super.onPressed,
    super.avatar,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : super(requireCallback: true);

  /// Creates action chip.elevated.
  const ActionChip.elevated({
    super.key,
    required super.label,
    required super.onPressed,
    super.avatar,
    super.style,
    super.decoration,
    super.foregroundDecoration,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
  }) : super(requireCallback: true);
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.label,
    this.avatar,
    this.onDeleted,
    this.deleteIcon,
    this.deleteButtonTooltipMessage,
    this.style,
    this.decoration,
    this.foregroundDecoration,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.onSelected,
    this.onPressed,
    this.selected = false,
    this.isEnabled = true,
    this.showCheckmark = true,
    this.selectedIcon,
    this.requireCallback = false,
    this.supportsSelection = false,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
  });
  final Widget label;
  final Widget? avatar;
  final VoidCallback? onDeleted;
  final Widget? deleteIcon;
  final String? deleteButtonTooltipMessage;
  final ChipStyle? style;
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onPressed;
  final bool selected;
  final bool isEnabled;
  final bool showCheckmark;
  final Widget? selectedIcon;
  final bool requireCallback;
  final bool supportsSelection;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  @override
  Widget build(BuildContext context) {
    final ChipStyle theme = ChipTheme.of(context);
    final ChipStyle effective = style?.merge(theme) ?? theme;
    assert(
      debugCheckDecorationOverride(
        widget: runtimeType.toString(),
        parameter: 'decoration',
        styleToken: 'style.buttonStyle.decoration',
        value: decoration,
        styleValue: style?.buttonStyle?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: runtimeType.toString(),
        parameter: 'foregroundDecoration',
        styleToken: 'style.buttonStyle.foregroundDecoration',
        value: foregroundDecoration,
        styleValue: style?.buttonStyle?.foregroundDecoration,
      ),
    );
    final bool interactive =
        onSelected != null || onPressed != null || onLongPress != null;
    final bool enabled = isEnabled && (!requireCallback || interactive);
    final InteractionState state = InteractionState(
      isSelected: selected,
      isDisabled: !enabled,
    );
    final List<ChipStyle?> layers = <ChipStyle?>[style, theme];
    final Duration duration = reducedMotionDuration(
      context,
      effective.animationDuration ?? const Duration(milliseconds: 200),
    );
    Widget? leading = avatar;
    if (leading != null && effective.avatarSize != null) {
      leading = SizedBox.square(
        dimension: effective.avatarSize,
        child: leading,
      );
    }
    final Widget? check =
        selectedIcon ??
        resolveStatefulOrDefault<ChipStyle, Widget>(
          state,
          layers,
          (ChipStyle s) => s.selectedIcon,
          () => const CheckGlyph(),
        );
    if (showCheckmark && supportsSelection) {
      leading = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 0,
        children: <Widget>[
          ClipRect(
            child: AnimatedSize(
              duration: duration,
              curve: effective.animationCurve ?? Curves.easeInOut,
              alignment: AlignmentDirectional.centerStart,
              child: selected && check != null
                  ? check
                  : const SizedBox(width: 0, height: 0),
            ),
          ),
          ?leading,
        ],
      );
    }
    Widget? trailing;
    if (onDeleted != null) {
      final String message =
          deleteButtonTooltipMessage ??
          NeutralLocalizations.of(context).deleteButtonTooltip;
      final Widget? glyph =
          deleteIcon ??
          resolveStatefulOrDefault<ChipStyle, Widget>(
            state,
            layers,
            (ChipStyle s) => s.deleteIcon,
            () => const CloseGlyph(),
          );
      trailing = Tooltip(
        message: message,
        child: TextButton(
          onPressed: enabled ? onDeleted : null,
          style: effective.deleteButtonStyle,
          child: Semantics(
            label: message,
            child: ExcludeSemantics(child: glyph ?? const SizedBox.shrink()),
          ),
        ),
      );
    }
    return SelectionButton(
      isSelected: selected,
      isSemanticButton: interactive,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      onPressed: enabled
          ? (interactive
                ? () {
                    onSelected?.call(!selected);
                    onPressed?.call();
                  }
                : () {})
          : null,
      onLongPress: enabled ? onLongPress : null,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style:
          style?.buttonStyle?.copyWith(
            spacing: effective.spacing ?? style?.buttonStyle?.spacing,
            animationDuration: effective.animationDuration,
            animationCurve: effective.animationCurve,
          ) ??
          ButtonStyle(
            spacing: effective.spacing,
            animationDuration: effective.animationDuration,
            animationCurve: effective.animationCurve,
          ),
      themeStyle: theme.buttonStyle,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      leading: leading,
      trailing: trailing,
      child: label,
    );
  }
}
