import 'package:flutter/widgets.dart';

import '../foundation/interaction_state.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../styles/toggle_style.dart';

/// Shared selection animation and token resolution for headless toggles.
mixin ToggleEngine<W extends StatefulWidget>
    on State<W>, SingleTickerProviderStateMixin<W> {
  /// The animation between unselected and selected appearances.
  late final AnimationController position;

  /// Whether the selection animation currently follows a drag directly.
  bool linearPosition = false;

  /// Whether a pointer is dragging this toggle.
  bool dragging = false;

  Duration _duration = const Duration(milliseconds: 200);
  Curve _curve = Curves.easeInOut;

  /// The instance's inline tokens.
  ToggleStyle? get inlineToggleStyle;

  /// Reads the component's inherited tokens.
  ToggleStyle toggleThemeOf(BuildContext context);

  /// Returns the selected appearance for a widget configuration.
  bool toggleSelected(W configuration);

  /// The current position after applying the configured animation curve.
  double get togglePosition => linearPosition || dragging
      ? position.value
      : _curve.transform(position.value);

  /// The duration for interaction transitions that do not change selection.
  Duration get interactionDuration =>
      position.isAnimating || dragging ? Duration.zero : _duration;

  /// The curve used by interaction transitions.
  Curve get interactionCurve => _curve;

  @override
  void initState() {
    super.initState();
    position = AnimationController(
      vsync: this,
      value: toggleSelected(widget) ? 1.0 : 0.0,
      duration: _duration,
    )..addStatusListener(_handleStatus);
  }

  void _handleStatus(AnimationStatus status) {
    if (linearPosition &&
        !dragging &&
        (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed)) {
      if (mounted) {
        setState(() {
          linearPosition = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    configureToggle();
    if (toggleSelected(oldWidget) != toggleSelected(widget)) {
      animateSelection();
    }
  }

  /// Refreshes the structural animation tokens for the current build.
  void configureToggle() {
    _duration =
        plainToken<Duration>((ToggleStyle style) => style.animationDuration) ??
        const Duration(milliseconds: 200);
    _curve =
        plainToken<Curve>((ToggleStyle style) => style.animationCurve) ??
        Curves.easeInOut;
    position.duration = _duration;
  }

  /// Animates to the selected appearance requested by the parent.
  void animateSelection() {
    final double target = toggleSelected(widget) ? 1.0 : 0.0;
    if (!dragging && position.value == target) {
      linearPosition = false;
    }
    position.animateTo(target);
  }

  /// Resolves a stateful token with inline precedence and null fall-through.
  T? stateToken<T>(
    InteractionState state,
    StateProperty<T?>? Function(ToggleStyle style) select,
  ) {
    return resolveStateful<ToggleStyle, T>(state, <ToggleStyle?>[
      inlineToggleStyle,
      toggleThemeOf(context),
    ], select);
  }

  /// Resolves a structural token with inline precedence.
  T? plainToken<T>(T? Function(ToggleStyle style) select) {
    return resolvePlain<ToggleStyle, T>(<ToggleStyle?>[
      inlineToggleStyle,
      toggleThemeOf(context),
    ], select);
  }

  /// Interpolates a size token between its unselected and selected values.
  Size? sizeToken(
    InteractionState state,
    StateProperty<Size?>? Function(ToggleStyle style) select,
  ) {
    return Size.lerp(
      stateToken<Size>(state.copyWith(isSelected: false), select),
      stateToken<Size>(state.copyWith(isSelected: true), select),
      togglePosition,
    );
  }

  /// Interpolates a decoration token between both selection appearances.
  Decoration? decorationToken(
    InteractionState state,
    StateProperty<Decoration?>? Function(ToggleStyle style) select,
  ) {
    return Decoration.lerp(
      stateToken<Decoration>(state.copyWith(isSelected: false), select),
      stateToken<Decoration>(state.copyWith(isSelected: true), select),
      togglePosition,
    );
  }

  /// Cross-fades the indicators resolved for both selection appearances.
  Widget indicators(InteractionState state, {bool indeterminate = false}) {
    final Widget? off = stateToken<Widget>(
      state.copyWith(isSelected: false),
      (ToggleStyle style) =>
          indeterminate ? style.indeterminateIndicator : style.indicator,
    );
    final Widget? on = stateToken<Widget>(
      state.copyWith(isSelected: true),
      (ToggleStyle style) =>
          indeterminate ? style.indeterminateIndicator : style.indicator,
    );
    final double progress = togglePosition;
    final List<Widget> children = <Widget>[
      if (off != null && progress < 1.0)
        Opacity(opacity: 1.0 - progress, child: off),
      if (on != null && progress > 0.0) Opacity(opacity: progress, child: on),
    ];
    return ExcludeSemantics(
      child: children.isEmpty
          ? const SizedBox.shrink()
          : Stack(alignment: Alignment.center, children: children),
    );
  }

  @override
  void dispose() {
    position.dispose();
    super.dispose();
  }
}
