import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/state_property.dart';
import '../foundation/tap_target.dart';
import '../styles/toggle_style.dart';
import '../theme/toggle_themes.dart';
import 'toggle_engine.dart';

/// A controlled, headless switch that supports taps and horizontal drags.
class Switch extends StatefulWidget {
  /// Creates a switch whose track and thumb come entirely from toggle tokens.
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.thumbDecoration,
  });

  /// Whether the switch is on.
  final bool value;

  /// Requests a value change; null disables this switch.
  final ValueChanged<bool>? onChanged;

  /// An optional focus node owned by the caller.
  final FocusNode? focusNode;

  /// Whether this switch requests focus when first inserted.
  final bool autofocus;

  /// Reports changes to raw keyboard focus.
  final ValueChanged<bool>? onFocusChange;

  /// An accessibility label for this switch.
  final String? semanticLabel;

  /// Inline tokens that override the inherited switch theme.
  final ToggleStyle? style;

  /// Replaces the track decoration in every interaction and selection state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.decoration`.
  final BoxDecoration? decoration;

  /// Replaces the thumb decoration in every interaction and selection state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.thumbDecoration`.
  final BoxDecoration? thumbDecoration;

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch>
    with SingleTickerProviderStateMixin<Switch>, ToggleEngine<Switch> {
  double _travel = 0.0;

  @override
  ToggleStyle? get inlineToggleStyle => widget.style;

  @override
  ToggleStyle toggleThemeOf(BuildContext context) => SwitchTheme.of(context);

  @override
  bool toggleSelected(Switch configuration) => configuration.value;

  @override
  void didUpdateWidget(covariant Switch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onChanged != null && widget.onChanged == null && dragging) {
      dragging = false;
      animateSelection();
    }
  }

  void _handleTap() {
    widget.onChanged?.call(!widget.value);
  }

  void _handleDragStart(DragStartDetails details) {
    final double currentPosition = togglePosition;
    position.stop();
    setState(() {
      dragging = true;
      linearPosition = true;
      position.value = currentPosition;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_travel <= 0.0) {
      return;
    }
    final double direction = Directionality.of(context) == TextDirection.rtl
        ? -1.0
        : 1.0;
    position.value += (details.primaryDelta ?? 0.0) / _travel * direction;
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      dragging = false;
    });
    final bool next = position.value >= 0.5;
    if (next != widget.value) {
      widget.onChanged?.call(next);
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted && !dragging) {
          animateSelection();
        }
      });
    } else {
      animateSelection();
    }
  }

  void _handleDragCancel() {
    setState(() {
      dragging = false;
    });
    animateSelection();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'Switch',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Switch',
        parameter: 'thumbDecoration',
        styleToken: 'style.thumbDecoration',
        value: widget.thumbDecoration,
        styleValue: widget.style?.thumbDecoration,
      ),
    );
    configureToggle();
    final bool enabled = widget.onChanged != null;
    return Semantics(
      container: true,
      toggled: widget.value,
      enabled: enabled,
      label: widget.semanticLabel,
      child: InteractionDetector(
        enabled: enabled,
        isSelected: widget.value,
        onTap: _handleTap,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        onHorizontalDragCancel: _handleDragCancel,
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
                final Size thumb =
                    sizeToken(state, (ToggleStyle style) => style.thumbSize) ??
                    Size.zero;
                final EdgeInsetsGeometry padding =
                    plainToken<EdgeInsetsGeometry>(
                      (ToggleStyle style) => style.padding,
                    ) ??
                    EdgeInsets.zero;
                final EdgeInsets resolvedPadding = padding.resolve(
                  Directionality.of(context),
                );
                final Size size =
                    sizeToken(state, (ToggleStyle style) => style.size) ??
                    Size(
                      2.0 * thumb.width + resolvedPadding.horizontal,
                      thumb.height + resolvedPadding.vertical,
                    );
                _travel = size.width - resolvedPadding.horizontal - thumb.width;
                return AnimatedSurface(
                  duration: interactionDuration,
                  curve: interactionCurve,
                  transitionKey: interactionKey(state),
                  width: size.width,
                  height: size.height,
                  decoration: decorationToken(
                    state,
                    (ToggleStyle style) => style.decoration,
                    override: widget.decoration,
                  ),
                  padding: padding,
                  child: Align(
                    alignment: AlignmentDirectional(
                      -1.0 + 2.0 * togglePosition,
                      0.0,
                    ),
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: AnimatedSurface(
                      duration: interactionDuration,
                      curve: interactionCurve,
                      transitionKey: interactionKey(state),
                      width: thumb.width,
                      height: thumb.height,
                      decoration: decorationToken(
                        state,
                        (ToggleStyle style) => style.thumbDecoration,
                        override: widget.thumbDecoration,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: indicators(state),
                      ),
                    ),
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
