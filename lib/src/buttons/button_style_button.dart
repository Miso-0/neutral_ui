import '../foundation/animated_icon_theme.dart';
import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../foundation/tap_target.dart';
import '../styles/button_style.dart';

import 'package:flutter/widgets.dart';

/// The unpainted, interactive foundation for buttons styled by [ButtonStyle].
///
/// Subclasses choose a component theme with [themeStyleOf]. Inline [style]
/// values take precedence over that theme, including state-dependent values.
abstract class ButtonStyleButton extends StatefulWidget {
  /// Creates a button sized by its style, with optional decoration overrides.
  const ButtonStyleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.decoration,
    this.foregroundDecoration,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton = true,
    this.leading,
    this.trailing,
    this.icon,
    this.iconAlignment,
    this.isLoading = false,
    this.loadingIndicator,
  });

  /// Called when the enabled button is activated by pointer or keyboard.
  final VoidCallback? onPressed;

  /// Called when the enabled button receives a long press.
  final VoidCallback? onLongPress;

  /// Called when the enabled button's hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the button gains or loses raw keyboard focus.
  final ValueChanged<bool>? onFocusChange;

  /// Per-instance tokens that take precedence over the component theme.
  final ButtonStyle? style;

  /// Replaces the background decoration and theme defaults in every state.
  ///
  /// Must not be supplied together with [ButtonStyle.decoration] in [style].
  final BoxDecoration? decoration;

  /// Replaces the foreground decoration and theme defaults in every state.
  ///
  /// Must not be supplied with [ButtonStyle.foregroundDecoration] in [style].
  final BoxDecoration? foregroundDecoration;

  /// The externally managed focus node, if any.
  final FocusNode? focusNode;

  /// Whether this button initially requests focus.
  final bool autofocus;

  /// Overrides the style's clipping behavior when a decoration is present.
  final Clip? clipBehavior;

  /// An optional controller shared with other interaction observers.
  final WidgetStatesController? statesController;

  /// Whether accessibility identifies this widget as a button.
  final bool isSemanticButton;

  /// Optional content before the icon and primary child.
  final Widget? leading;

  /// Optional content after the icon and primary child.
  final Widget? trailing;

  /// The optional icon accompanying [child].
  final Widget? icon;

  /// Overrides which logical side of the child contains the icon.
  final IconAlignment? iconAlignment;

  /// The primary content of this button.
  final Widget? child;

  /// Whether the button is disabled while work is in progress.
  final bool isLoading;

  /// Overrides the loading indicator resolved from the style.
  ///
  /// When present during loading, the original content retains its layout
  /// space and accessibility label underneath this indicator.
  final Widget? loadingIndicator;

  /// Whether this button currently accepts user interaction.
  bool get enabled => !isLoading && (onPressed != null || onLongPress != null);

  /// Returns this variant's component style from the current context.
  @protected
  ButtonStyle? themeStyleOf(BuildContext context);

  /// Returns structural defaults without introducing a visual appearance.
  @protected
  ButtonStyle defaultStyleOf(BuildContext context) => const ButtonStyle(
    alignment: Alignment.center,
    iconAlignment: IconAlignment.start,
    animationDuration: Duration(milliseconds: 200),
    animationCurve: Curves.easeInOut,
    enableFeedback: true,
  );

  /// The optional selected state exposed to styles and accessibility.
  @protected
  bool? get selected => null;

  /// Whether the menu controlled by this button is expanded.
  @protected
  bool? get expanded => null;

  /// The optional checked state exposed to accessibility.
  @protected
  bool? get checked => null;

  /// Overrides focus visibility for a virtually focused menu option.
  @protected
  bool? get virtualFocused => null;

  /// Whether the button reacts to input.
  ///
  /// A button that does not keeps its enabled appearance but takes no focus,
  /// recognizes no gestures, shows no hover or press and uses the basic cursor,
  /// as for a chip that only displays information.
  @protected
  bool get interactive => true;

  /// Alternative primary content displayed when [selected] is true.
  @protected
  Widget? get selectedChild => null;

  /// The optional accessibility tooltip for this button.
  @protected
  String? get semanticTooltip => null;

  @override
  State<ButtonStyleButton> createState() => _ButtonStyleButtonState();
}

class _ButtonStyleButtonState extends State<ButtonStyleButton> {
  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: widget.runtimeType.toString(),
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: widget.runtimeType.toString(),
        parameter: 'foregroundDecoration',
        styleToken: 'style.foregroundDecoration',
        value: widget.foregroundDecoration,
        styleValue: widget.style?.foregroundDecoration,
      ),
    );
    final List<ButtonStyle?> layers = <ButtonStyle?>[
      ButtonStyle(
        decoration: decorationLayer(widget.decoration),
        foregroundDecoration: decorationLayer(widget.foregroundDecoration),
      ),
      widget.style,
      widget.themeStyleOf(context),
      widget.defaultStyleOf(context),
    ];
    final bool enableFeedback =
        resolvePlain<ButtonStyle, bool>(
          layers,
          (ButtonStyle style) => style.enableFeedback,
        ) ??
        true;

    return Semantics(
      container: true,
      button: widget.isSemanticButton,
      enabled: widget.enabled,
      selected: widget.selected,
      expanded: widget.expanded,
      checked: widget.checked,
      onExpand: widget.enabled && widget.expanded == false
          ? widget.onPressed
          : null,
      onCollapse: widget.enabled && widget.expanded == true
          ? widget.onPressed
          : null,
      tooltip: widget.semanticTooltip,
      child: InteractionDetector(
        enabled: widget.enabled,
        isSelected: widget.selected ?? widget.expanded,
        isFocused: widget.virtualFocused,
        canRequestFocus: widget.interactive,
        onTap: widget.interactive ? widget.onPressed : null,
        onLongPress: widget.interactive ? widget.onLongPress : null,
        onHover: widget.onHover,
        onFocusChange: widget.onFocusChange,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        statesController: widget.statesController,
        enableFeedback: enableFeedback,
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) => widget.interactive
              ? resolveStateful<ButtonStyle, MouseCursor>(
                  state,
                  layers,
                  (ButtonStyle style) => style.mouseCursor,
                )
              : SystemMouseCursors.basic,
        ),
        builder: (BuildContext context, InteractionState state) {
          return _buildStyledContent(
            context,
            widget.interactive
                ? state
                : state.copyWith(isHovered: false, isPressed: false),
            layers,
          );
        },
      ),
    );
  }

  Widget _buildStyledContent(
    BuildContext context,
    InteractionState state,
    List<ButtonStyle?> layers,
  ) {
    final Duration duration = reducedMotionDuration(
      context,
      resolvePlain<ButtonStyle, Duration>(
            layers,
            (ButtonStyle style) => style.animationDuration,
          ) ??
          const Duration(milliseconds: 200),
    );
    final Curve curve =
        resolvePlain<ButtonStyle, Curve>(
          layers,
          (ButtonStyle style) => style.animationCurve,
        ) ??
        Curves.easeInOut;
    final Decoration? decoration = resolveStateful<ButtonStyle, Decoration>(
      state,
      layers,
      (ButtonStyle style) => style.decoration,
    );
    final Decoration? foregroundDecoration =
        resolveStateful<ButtonStyle, Decoration>(
          state,
          layers,
          (ButtonStyle style) => style.foregroundDecoration,
        );
    final EdgeInsetsGeometry? padding =
        resolveStateful<ButtonStyle, EdgeInsetsGeometry>(
          state,
          layers,
          (ButtonStyle style) => style.padding,
        );
    final TextStyle? textStyle = resolveStateful<ButtonStyle, TextStyle>(
      state,
      layers,
      (ButtonStyle style) => style.textStyle,
    );
    final IconThemeData? iconTheme =
        resolveStateful<ButtonStyle, IconThemeData>(
          state,
          layers,
          (ButtonStyle style) => style.iconTheme,
        );
    final AlignmentGeometry alignment =
        resolvePlain<ButtonStyle, AlignmentGeometry>(
          layers,
          (ButtonStyle style) => style.alignment,
        ) ??
        Alignment.center;
    final Clip clipBehavior =
        widget.clipBehavior ??
        resolvePlain<ButtonStyle, Clip>(
          layers,
          (ButtonStyle style) => style.clipBehavior,
        ) ??
        Clip.none;
    final Size? tapTargetSize = resolvePlain<ButtonStyle, Size>(
      layers,
      (ButtonStyle style) => style.tapTargetSize,
    );
    final DefaultTextStyle ambient = DefaultTextStyle.of(context);
    final Widget? indicator = widget.isLoading
        ? widget.loadingIndicator ??
              resolveStatefulOrDefault<ButtonStyle, Widget>(
                state,
                layers,
                (ButtonStyle style) => style.loadingIndicator,
                () => const DotsGlyph(),
              )
        : null;
    final Widget content = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        Visibility(
          visible: indicator == null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          maintainSemantics: true,
          child: _buildContent(layers),
        ),
        if (indicator != null)
          Positioned.fill(
            child: Center(child: ExcludeSemantics(child: indicator)),
          ),
      ],
    );

    return TapTarget(
      minSize: tapTargetSize,
      child: _AnimatedButtonConstraints(
        duration: duration,
        curve: curve,
        constraints: _resolveConstraints(state, layers),
        child: AnimatedSurface(
          duration: duration,
          curve: curve,
          padding: padding,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          clipBehavior: clipBehavior,
          child: Align(
            alignment: alignment,
            widthFactor: 1,
            heightFactor: 1,
            child: AnimatedIconTheme(
              data: iconTheme ?? const IconThemeData(),
              duration: duration,
              curve: curve,
              child: AnimatedDefaultTextStyle(
                style: ambient.style.merge(textStyle),
                textAlign: ambient.textAlign,
                softWrap: ambient.softWrap,
                overflow: ambient.overflow,
                maxLines: ambient.maxLines,
                textWidthBasis: ambient.textWidthBasis,
                textHeightBehavior: ambient.textHeightBehavior,
                duration: duration,
                curve: curve,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<ButtonStyle?> layers) {
    final IconAlignment iconAlignment =
        widget.iconAlignment ??
        resolvePlain<ButtonStyle, IconAlignment>(
          layers,
          (ButtonStyle style) => style.iconAlignment,
        ) ??
        IconAlignment.start;
    final double spacing =
        resolvePlain<ButtonStyle, double>(
          layers,
          (ButtonStyle style) => style.spacing,
        ) ??
        0;
    Widget? child = widget.child;
    Widget? icon = widget.icon;
    if (widget.selected == true && widget.selectedChild != null) {
      if (child == null && icon != null) {
        icon = widget.selectedChild;
      } else {
        child = widget.selectedChild;
      }
    }
    if (widget.leading == null && icon == null && widget.trailing == null) {
      return child ?? const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children: <Widget>[
        if (widget.leading != null) widget.leading!,
        if (icon != null && iconAlignment == IconAlignment.start) icon,
        if (child != null) Flexible(child: child),
        if (icon != null && iconAlignment == IconAlignment.end) icon,
        if (widget.trailing != null) widget.trailing!,
      ],
    );
  }

  BoxConstraints _resolveConstraints(
    InteractionState state,
    List<ButtonStyle?> layers,
  ) => sizeConstraints(
    minimum: resolveStateful<ButtonStyle, Size>(
      state,
      layers,
      (ButtonStyle style) => style.minimumSize,
    ),
    maximum: resolveStateful<ButtonStyle, Size>(
      state,
      layers,
      (ButtonStyle style) => style.maximumSize,
    ),
    fixed: resolveStateful<ButtonStyle, Size>(
      state,
      layers,
      (ButtonStyle style) => style.fixedSize,
    ),
  );
}

// BoxConstraintsTween rejects finite-to-unbounded transitions. Bounds that
// become finite or infinite switch immediately; finite bounds still animate.
class _AnimatedButtonConstraints extends ImplicitlyAnimatedWidget {
  const _AnimatedButtonConstraints({
    required this.constraints,
    required super.duration,
    required super.curve,
    required this.child,
  });

  final BoxConstraints constraints;
  final Widget child;

  @override
  AnimatedWidgetBaseState<_AnimatedButtonConstraints> createState() =>
      _AnimatedButtonConstraintsState();
}

class _AnimatedButtonConstraintsState
    extends AnimatedWidgetBaseState<_AnimatedButtonConstraints> {
  _ButtonConstraintsTween? _constraints;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) =>
          _ButtonConstraintsTween(begin: value as BoxConstraints),
    ) as _ButtonConstraintsTween?;
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: _constraints!.evaluate(animation),
    child: widget.child,
  );
}

class _ButtonConstraintsTween extends Tween<BoxConstraints> {
  _ButtonConstraintsTween({super.begin});

  double _bound(double begin, double end, double t) =>
      begin.isFinite && end.isFinite ? begin + (end - begin) * t : end;

  @override
  BoxConstraints lerp(double t) {
    final BoxConstraints start = begin!;
    final BoxConstraints target = end!;
    final double maxWidth = _bound(start.maxWidth, target.maxWidth, t);
    final double maxHeight = _bound(start.maxHeight, target.maxHeight, t);
    return BoxConstraints(
      minWidth: _bound(
        start.minWidth,
        target.minWidth,
        t,
      ).clamp(0, maxWidth).toDouble(),
      maxWidth: maxWidth,
      minHeight: _bound(
        start.minHeight,
        target.minHeight,
        t,
      ).clamp(0, maxHeight).toDouble(),
      maxHeight: maxHeight,
    );
  }
}
