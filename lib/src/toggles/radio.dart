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

/// A controlled, headless radio that can participate in a [RadioGroup].
class Radio<T> extends StatefulWidget {
  /// Creates a radio using a registry, explicit group value, or ancestor group.
  const Radio({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.toggleable = false,
    this.enabled,
    this.groupRegistry,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.thumbDecoration,
  });

  /// The value represented by this radio.
  final T value;

  /// The selected value when explicitly managing the group.
  final T? groupValue;

  /// Requests explicit group changes when no registry is supplied.
  final ValueChanged<T?>? onChanged;

  /// Whether activating the selected radio requests a null group value.
  final bool toggleable;

  /// Overrides the enabled state derived from the selection source.
  final bool? enabled;

  /// A registry that takes precedence over explicit and inherited groups.
  final RadioGroupRegistry<T>? groupRegistry;

  /// An optional focus node owned by the caller.
  final FocusNode? focusNode;

  /// Whether this radio requests focus when first inserted.
  final bool autofocus;

  /// Reports changes to raw keyboard focus.
  final ValueChanged<bool>? onFocusChange;

  /// An accessibility label for this radio.
  final String? semanticLabel;

  /// Inline tokens that override the inherited radio theme.
  final ToggleStyle? style;

  /// Replaces the ring decoration in every interaction and selection state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.decoration`.
  final BoxDecoration? decoration;

  /// Replaces the dot decoration in every interaction and selection state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.thumbDecoration`.
  final BoxDecoration? thumbDecoration;

  @override
  State<Radio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<Radio<T>>
    with
        SingleTickerProviderStateMixin<Radio<T>>,
        ToggleEngine<Radio<T>>,
        RadioClient<T> {
  FocusNode? _ownedFocusNode;
  RadioGroupRegistry<T>? _effectiveRegistry;
  bool _explicit = false;
  bool _selected = false;
  bool _sourceInitialized = false;

  @override
  ToggleStyle? get inlineToggleStyle => widget.style;

  @override
  ToggleStyle toggleThemeOf(BuildContext context) => RadioTheme.of(context);

  @override
  bool toggleSelected(Radio<T> configuration) {
    if (configuration.groupRegistry != null) {
      return configuration.value == configuration.groupRegistry!.groupValue;
    }
    if (configuration.onChanged != null || configuration.groupValue != null) {
      return configuration.value == configuration.groupValue;
    }
    return configuration.value == _effectiveRegistry?.groupValue;
  }

  @override
  bool get tristate => widget.toggleable;

  @override
  T get radioValue => widget.value;

  @override
  bool get enabled =>
      widget.enabled ??
      (_explicit ? widget.onChanged != null : _effectiveRegistry != null);

  @override
  FocusNode get focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  void _updateRegistry() {
    final RadioGroupRegistry<T>? supplied = widget.groupRegistry;
    _explicit =
        supplied == null &&
        (widget.onChanged != null || widget.groupValue != null);
    _effectiveRegistry =
        supplied ?? (_explicit ? null : RadioGroup.maybeOf<T>(context));
    if (registry != _effectiveRegistry) {
      registry = _effectiveRegistry;
    }
    final bool nextSelected = toggleSelected(widget);
    if (!_sourceInitialized) {
      _sourceInitialized = true;
      _selected = nextSelected;
      position.value = nextSelected ? 1.0 : 0.0;
    } else if (_selected != nextSelected) {
      _selected = nextSelected;
      animateSelection();
    }
  }

  @override
  void initState() {
    super.initState();
    _selected = toggleSelected(widget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateRegistry();
  }

  @override
  void didUpdateWidget(covariant Radio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateRegistry();
    if (widget.focusNode != null && _ownedFocusNode != null) {
      _ownedFocusNode!.dispose();
      _ownedFocusNode = null;
    }
  }

  void _handleTap() {
    final ValueChanged<T?>? onChanged =
        _effectiveRegistry?.onChanged ?? widget.onChanged;
    if (!_selected) {
      onChanged?.call(widget.value);
    } else if (widget.toggleable) {
      onChanged?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'Radio',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Radio',
        parameter: 'thumbDecoration',
        styleToken: 'style.thumbDecoration',
        value: widget.thumbDecoration,
        styleValue: widget.style?.thumbDecoration,
      ),
    );
    configureToggle();
    return Semantics(
      container: true,
      checked: _selected,
      inMutuallyExclusiveGroup: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: InteractionDetector(
        enabled: enabled,
        isSelected: _selected,
        onTap: _handleTap,
        focusNode: focusNode,
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
                final Size? thumb = sizeToken(
                  state,
                  (ToggleStyle style) => style.thumbSize,
                );
                return AnimatedSurface(
                  duration: interactionDuration,
                  curve: interactionCurve,
                  width: size?.width,
                  height: size?.height,
                  decoration: decorationToken(
                    state,
                    (ToggleStyle style) => style.decoration,
                    override: widget.decoration,
                  ),
                  padding: plainToken<EdgeInsetsGeometry>(
                    (ToggleStyle style) => style.padding,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        AnimatedSurface(
                          duration: interactionDuration,
                          curve: interactionCurve,
                          width: thumb?.width ?? 0.0,
                          height: thumb?.height ?? 0.0,
                          decoration: decorationToken(
                            state,
                            (ToggleStyle style) => style.thumbDecoration,
                            override: widget.thumbDecoration,
                          ),
                        ),
                        indicators(state),
                      ],
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

  @override
  void dispose() {
    registry = null;
    _ownedFocusNode?.dispose();
    super.dispose();
  }
}
