import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/motion.dart';
import '../menus/key_activators.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_insets.dart';
import '../overlay/overlay_placement.dart';
import '../styles/tooltip_style.dart';
import '../theme/feedback_themes.dart';

/// Controls tooltip visibility for a subtree.
class TooltipVisibility extends InheritedWidget {
  /// Creates a tooltip visibility.
  const TooltipVisibility({
    super.key,
    required this.visible,
    required super.child,
  });

  /// Whether tooltips in this subtree may open.
  final bool visible;

  /// Returns the nearest component host.
  static bool of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<TooltipVisibility>()
          ?.visible ??
      true;
  @override
  bool updateShouldNotify(TooltipVisibility oldWidget) =>
      visible != oldWidget.visible;
}

/// A tooltip triggered by hover, touch, keyboard focus or a state key.
///
/// RawTooltip owns gesture delays, exclusivity and feedback. PureUI owns the
/// visible overlay, allowing an individual tooltip to finish its exit before
/// removal and to update its animation tokens while mounted.
class Tooltip extends StatefulWidget {
  /// Creates a tooltip.
  const Tooltip({
    super.key,
    this.message,
    this.richMessage,
    required this.child,
    this.style,
    this.decoration,
    this.waitDuration,
    this.showDuration,
    this.exitDuration,
    this.triggerMode,
    this.enableTapToDismiss = true,
    this.enableFeedback,
    this.onTriggered,
    this.excludeFromSemantics,
    this.ignorePointer,
    this.preferBelow,
    this.verticalOffset,
    this.positionDelegate,
    this.mouseCursor,
  }) : assert((message == null) != (richMessage == null));

  /// Plain text displayed by the tooltip.
  final String? message;

  /// Styled text displayed by the tooltip.
  final InlineSpan? richMessage;

  /// The widget displayed by this component.
  final Widget child;

  /// Local appearance and motion tokens.
  final TooltipStyle? style;

  /// A surface decoration overriding inherited tokens.
  final BoxDecoration? decoration;

  /// The hover delay before the tooltip opens.
  final Duration? waitDuration;

  /// How long a touch-triggered tooltip remains visible.
  final Duration? showDuration;

  /// The delay before dismissing a tooltip after pointer exit.
  final Duration? exitDuration;

  /// How touch gestures trigger the tooltip.
  final TooltipTriggerMode? triggerMode;

  /// Whether taps dismiss the tooltip.
  final bool enableTapToDismiss;

  /// Whether triggers produce platform feedback.
  final bool? enableFeedback;

  /// Reports a tooltip trigger.
  final TooltipTriggeredCallback? onTriggered;

  /// Whether the tooltip message is omitted from accessibility.
  final bool? excludeFromSemantics;

  /// Whether the tooltip panel ignores pointer events.
  final bool? ignorePointer;

  /// Whether the tooltip prefers the side below its anchor.
  final bool? preferBelow;

  /// The gap between the anchor and tooltip.
  final double? verticalOffset;

  /// An optional custom tooltip positioning function.
  final TooltipPositionDelegate? positionDelegate;

  /// The cursor displayed over the tooltip anchor.
  final MouseCursor? mouseCursor;

  /// Dismisses all currently visible PureUI tooltips.
  static bool dismissAllToolTips() {
    final bool hadVisible = TooltipState._visible.isNotEmpty;
    for (final TooltipState state in TooltipState._visible.toList()) {
      state.dismiss();
    }
    return hadVisible;
  }

  @override
  TooltipState createState() => TooltipState();
}

/// Imperative control over one [Tooltip].
class TooltipState extends State<Tooltip> with SingleTickerProviderStateMixin {
  static final Set<TooltipState> _visible = <TooltipState>{};
  final OverlayPortalController _portal = OverlayPortalController();
  GlobalKey<RawTooltipState> _rawKey = GlobalKey<RawTooltipState>();
  late final AnimationController _controller = AnimationController(vsync: this)
    ..addStatusListener(_status);
  CurvedAnimation? _curve;
  TooltipStyle _style = const TooltipStyle();
  bool _allowed = true;
  bool _shown = false;
  bool _focused = false;
  bool _suppressSignal = false;
  AxisDirection _side = AxisDirection.down;

  void _status(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _portal.hide();
      _visible.remove(this);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool allowed = TooltipVisibility.of(context);
    _allowed = allowed;
    _configure();
    if (!allowed && _shown) dismiss();
  }

  @override
  void didUpdateWidget(Tooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _configure();
  }

  void _configure() {
    _style =
        widget.style?.merge(TooltipTheme.of(context)) ??
        TooltipTheme.of(context);
    _controller.duration = reducedMotionDuration(
      context,
      _style.transitionDuration ?? const Duration(milliseconds: 150),
    );
    _controller.reverseDuration = reducedMotionDuration(
      context,
      _style.reverseTransitionDuration ?? const Duration(milliseconds: 75),
    );
    _curve?.dispose();
    _curve = CurvedAnimation(
      parent: _controller,
      curve: _style.transitionCurve ?? Curves.easeOutCubic,
      reverseCurve: _style.reverseTransitionCurve ?? Curves.easeInCubic,
    );
  }

  void _show({bool explicit = false}) {
    if (!mounted ||
        !_allowed ||
        _shown ||
        (_suppressSignal && !explicit) ||
        (widget.message ?? widget.richMessage!.toPlainText()).isEmpty) {
      return;
    }
    _shown = true;
    _visible.add(this);
    _portal.show();
    _controller.forward();
  }

  void _hide() {
    if (!mounted || _suppressSignal || _focused || !_shown) return;
    _shown = false;
    if (_controller.isDismissed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_shown) {
          _portal.hide();
          _visible.remove(this);
        }
      });
    } else {
      _controller.reverse();
    }
  }

  /// Shows this tooltip, returning whether a new opening was requested.
  bool ensureTooltipVisible() {
    if (!_allowed ||
        _shown ||
        (widget.message ?? widget.richMessage!.toPlainText()).isEmpty) {
      return false;
    }
    final RawTooltipState? raw = _rawKey.currentState;
    if (raw != null) {
      raw.ensureTooltipVisible();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted && _shown) _rawKey.currentState?.ensureTooltipVisible();
      });
    }
    _show(explicit: true);
    return true;
  }

  /// Dismisses this tooltip, allowing its exit animation to finish.
  void dismiss() {
    if (!mounted) return;
    _focused = false;
    _shown = false;
    _controller.reverse();
    // RawTooltip exposes no per-instance hide. Replacing only this trigger
    // clears its timer and hover registration while our overlay exits.
    _suppressSignal = true;
    setState(() {
      _rawKey = GlobalKey<RawTooltipState>();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _suppressSignal = false;
    });
  }

  void _focusChanged(bool focused) {
    _focused =
        focused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    if (_focused) {
      ensureTooltipVisible();
    } else {
      _hide();
    }
  }

  @override
  void dispose() {
    _visible.remove(this);
    _curve?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _panel(BuildContext context) {
    Widget content = widget.richMessage == null
        ? Text(widget.message!, textAlign: _style.textAlign)
        : Text.rich(widget.richMessage!, textAlign: _style.textAlign);
    content = DefaultTextStyle.merge(style: _style.textStyle, child: content);
    content = AnimatedSurface(
      duration: reducedMotionDuration(
        context,
        _style.transitionDuration ?? const Duration(milliseconds: 150),
      ),
      curve: _style.transitionCurve ?? Curves.easeOutCubic,
      decoration: widget.decoration ?? _style.decoration,
      padding: _style.padding,
      constraints: _style.constraints,
      child: content,
    );
    if (_style.margin != null) {
      content = Padding(padding: _style.margin!, child: content);
    }
    content = RepaintBoundary(child: content);
    final Animation<double> animation = _curve!;
    return IgnorePointer(
      ignoring: widget.ignorePointer ?? widget.richMessage == null,
      child:
          _style.transitionBuilder?.call(context, animation, content) ??
          FadeTransition(
            opacity: animation,
            child: AnimatedBuilder(
              animation: animation,
              child: content,
              builder: (BuildContext context, Widget? child) {
                final Offset begin = switch (_side) {
                  AxisDirection.up => const Offset(0, .08),
                  AxisDirection.down => const Offset(0, -.08),
                  AxisDirection.left => const Offset(.08, 0),
                  AxisDirection.right => const Offset(-.08, 0),
                };
                return FractionalTranslation(
                  translation: begin * (1 - animation.value),
                  child: child,
                );
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'Tooltip',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    final String text = widget.message ?? widget.richMessage!.toPlainText();
    final TextDirection direction = Directionality.of(context);
    final OverlayPlacement placement =
        _style.placement ??
        OverlayPlacement(
          preferredSide: (widget.preferBelow ?? _style.preferBelow ?? true)
              ? AxisDirection.down
              : AxisDirection.up,
          gap: widget.verticalOffset ?? _style.verticalOffset ?? 8,
        );
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _portal,
      overlayLocation: _style.overlayLocation == OverlayLocation.nearest
          ? OverlayChildLocation.nearestOverlay
          : OverlayChildLocation.rootOverlay,
      overlayChildBuilder:
          (BuildContext overlayContext, OverlayChildLayoutInfo info) {
            final Rect anchor = MatrixUtils.transformRect(
              info.childPaintTransform,
              Offset.zero & info.childSize,
            );
            final ({EdgeInsets padding, EdgeInsets viewInsets}) insets =
                overlayInsetsFor(
                  overlayContext,
                  overlaySize: info.overlaySize,
                  overlayLocation:
                      _style.overlayLocation ?? OverlayLocation.root,
                );
            return Positioned.fill(
              child: CustomSingleChildLayout(
                delegate: _TooltipLayout(
                  anchor: anchor,
                  placement: placement,
                  direction: direction,
                  padding: insets.padding,
                  viewInsets: insets.viewInsets,
                  positionDelegate: widget.positionDelegate,
                  onSide: (AxisDirection side) {
                    _side = side;
                  },
                ),
                child: _panel(overlayContext),
              ),
            );
          },
      child: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          menuKeyActivator(0x10000001b): const DismissIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (DismissIntent intent) {
                dismiss();
                return null;
              },
            ),
          },
          child: Focus(
            canRequestFocus: false,
            onFocusChange: _focusChanged,
            child: MouseRegion(
              cursor: widget.mouseCursor ?? MouseCursor.defer,
              child: _allowed && text.isNotEmpty
                  ? RawTooltip(
                      key: _rawKey,
                      semanticsTooltip: widget.excludeFromSemantics == true
                          ? null
                          : text,
                      hoverDelay: widget.waitDuration ?? Duration.zero,
                      touchDelay:
                          widget.showDuration ??
                          const Duration(milliseconds: 1500),
                      dismissDelay:
                          widget.exitDuration ??
                          const Duration(milliseconds: 100),
                      triggerMode:
                          widget.triggerMode ?? TooltipTriggerMode.longPress,
                      enableTapToDismiss: widget.enableTapToDismiss,
                      enableFeedback: widget.enableFeedback ?? true,
                      onTriggered: widget.onTriggered,
                      animationStyle: AnimationStyle.noAnimation,
                      ignorePointer: true,
                      tooltipBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                      ) => _TooltipSignal(onShow: _show, onHide: _hide),
                      child: widget.child,
                    )
                  : widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _TooltipSignal extends StatefulWidget {
  const _TooltipSignal({required this.onShow, required this.onHide});

  /// The onShow associated with this component.
  final VoidCallback onShow;

  /// The onHide associated with this component.
  final VoidCallback onHide;
  @override
  State<_TooltipSignal> createState() => _TooltipSignalState();
}

class _TooltipSignalState extends State<_TooltipSignal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onShow();
    });
  }

  @override
  void dispose() {
    final VoidCallback hide = widget.onHide;
    hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _TooltipLayout extends SingleChildLayoutDelegate {
  _TooltipLayout({
    required this.anchor,
    required this.placement,
    required this.direction,
    required this.padding,
    required this.viewInsets,
    required this.onSide,
    this.positionDelegate,
  });

  /// The anchor associated with this component.
  final Rect anchor;

  /// The placement associated with this component.
  final OverlayPlacement placement;

  /// The direction associated with this component.
  final TextDirection direction;

  /// Space around the content.
  final EdgeInsets padding;

  /// The viewInsets associated with this component.
  final EdgeInsets viewInsets;

  /// The onSide associated with this component.
  final ValueChanged<AxisDirection> onSide;

  /// An optional custom tooltip positioning function.
  final TooltipPositionDelegate? positionDelegate;
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if (positionDelegate != null) {
      return positionDelegate!(
        TooltipPositionContext(
          target: anchor.center,
          targetSize: anchor.size,
          tooltipSize: childSize,
          verticalOffset: placement.gap,
          preferBelow: placement.preferredSide == AxisDirection.down,
          overlaySize: size,
        ),
      );
    }
    final OverlayPlacementResult result = resolvePlacement(
      anchorRect: anchor,
      overlaySize: size,
      childSize: childSize,
      textDirection: direction,
      placement: placement,
      padding: padding,
      viewInsets: viewInsets,
    );
    onSide(result.side);
    return result.rect.topLeft;
  }

  @override
  bool shouldRelayout(_TooltipLayout oldDelegate) =>
      anchor != oldDelegate.anchor ||
      placement != oldDelegate.placement ||
      direction != oldDelegate.direction ||
      padding != oldDelegate.padding ||
      viewInsets != oldDelegate.viewInsets ||
      positionDelegate != oldDelegate.positionDelegate;
}
