import 'package:flutter/widgets.dart';

import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/state_property.dart';
import '../foundation/tap_target.dart';
import '../styles/toggle_style.dart';
import '../theme/toggle_themes.dart';
import 'toggle_engine.dart';

/// A controlled, headless checkbox with optional indeterminate selection.
class Checkbox extends StatefulWidget {
  /// Creates a checkbox whose appearance comes entirely from toggle tokens.
  const Checkbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.style,
  }) : assert(tristate || value != null);

  /// The current selection, or null for an indeterminate checkbox.
  final bool? value;

  /// Whether the tap cycle includes the indeterminate value.
  final bool tristate;

  /// Requests a selection change; null disables this checkbox.
  final ValueChanged<bool?>? onChanged;

  /// An optional focus node owned by the caller.
  final FocusNode? focusNode;

  /// Whether this checkbox requests focus when first inserted.
  final bool autofocus;

  /// Reports changes to raw keyboard focus.
  final ValueChanged<bool>? onFocusChange;

  /// An accessibility label for this checkbox.
  final String? semanticLabel;

  /// Inline tokens that override the inherited checkbox theme.
  final ToggleStyle? style;

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox>
    with SingleTickerProviderStateMixin<Checkbox>, ToggleEngine<Checkbox> {
  late bool _indeterminate;

  @override
  ToggleStyle? get inlineToggleStyle => widget.style;

  @override
  ToggleStyle toggleThemeOf(BuildContext context) => CheckboxTheme.of(context);

  @override
  bool toggleSelected(Checkbox configuration) => configuration.value != false;

  @override
  void initState() {
    super.initState();
    _indeterminate = widget.value == null;
  }

  @override
  void didUpdateWidget(covariant Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != false) {
      _indeterminate = widget.value == null;
    }
    if (oldWidget.value != widget.value &&
        oldWidget.value != false &&
        widget.value != false) {
      position.value = 0.0;
      animateSelection();
    }
  }

  void _handleTap() {
    final bool? next = switch (widget.value) {
      false => true,
      true => widget.tristate ? null : false,
      null => false,
    };
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    configureToggle();
    final bool enabled = widget.onChanged != null;
    return Semantics(
      container: true,
      checked: widget.value ?? false,
      mixed: widget.tristate ? widget.value == null : null,
      enabled: enabled,
      label: widget.semanticLabel,
      child: InteractionDetector(
        enabled: enabled,
        isSelected: toggleSelected(widget),
        onTap: _handleTap,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: widget.onFocusChange,
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) => stateToken<MouseCursor>(
            state,
            (ToggleStyle style) => style.mouseCursor,
          ),
        ),
        enableFeedback:
            plainToken<bool>((ToggleStyle style) => style.enableFeedback) ??
            true,
        builder: (BuildContext context, InteractionState state) {
          return TapTarget(
            minSize:
                plainToken<Size>((ToggleStyle style) => style.tapTargetSize) ??
                const Size(48.0, 48.0),
            child: AnimatedBuilder(
              animation: position,
              builder: (BuildContext context, Widget? child) {
                final Size? size = sizeToken(
                  state,
                  (ToggleStyle style) => style.size,
                );
                return AnimatedContainer(
                  duration: interactionDuration,
                  curve: interactionCurve,
                  width: size?.width,
                  height: size?.height,
                  decoration: decorationToken(
                    state,
                    (ToggleStyle style) => style.decoration,
                  ),
                  padding: plainToken<EdgeInsetsGeometry>(
                    (ToggleStyle style) => style.padding,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: indicators(state, indeterminate: _indeterminate),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
