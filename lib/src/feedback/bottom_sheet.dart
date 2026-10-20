import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/motion.dart';
import '../localizations/neutral_localizations.dart';
import '../menus/key_activators.dart';
import '../styles/bottom_sheet_style.dart';
import '../theme/feedback_themes.dart';

/// Reports the beginning of a sheet drag.
typedef BottomSheetDragStartHandler = void Function(DragStartDetails details);

/// Reports a sheet release and whether it will close.
typedef BottomSheetDragEndHandler = void Function(
  DragEndDetails details, {
  required bool isClosing,
});

/// A sheet surface whose transition controller follows vertical drags directly.
class BottomSheet extends StatefulWidget {
  /// Creates a bottom sheet.
  const BottomSheet({
    super.key,
    required this.onClosing,
    required this.builder,
    this.animationController,
    this.enableDrag = true,
    this.showDragHandle,
    this.onDragStart,
    this.onDragEnd,
    this.style,
    this.decoration,
    this.constraints,
    this.clipBehavior,
    this.snapPoints,
    this.isDismissible = true,
  });

  /// Invoked when the sheet requests dismissal.
  final VoidCallback onClosing;

  /// Builds the sheet content.
  final WidgetBuilder builder;

  /// The shared transition controller, also manipulated by dragging.
  final AnimationController? animationController;

  /// Whether vertical drags move and dismiss the sheet.
  final bool enableDrag;

  /// Whether to display the painted draggable handle.
  final bool? showDragHandle;

  /// Reports the beginning of a sheet drag.
  final BottomSheetDragStartHandler? onDragStart;

  /// Reports the drag release and dismissal decision.
  final BottomSheetDragEndHandler? onDragEnd;

  /// Local appearance and motion tokens.
  final BottomSheetStyle? style;

  /// A surface decoration overriding inherited tokens.
  final BoxDecoration? decoration;

  /// Optional size constraints.
  final BoxConstraints? constraints;

  /// How content is clipped to the surface.
  final Clip? clipBehavior;

  /// Allowed sheet extents, expressed as fractions of its height.
  final List<double>? snapPoints;

  /// Whether a downward drag may close the sheet.
  final bool isDismissible;
  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey _surfaceKey = GlobalKey();
  AnimationController? _ownedController;
  AnimationController get _controller =>
      widget.animationController ??
      (_ownedController ??= AnimationController(
        vsync: this,
        value: 1,
        duration: const Duration(milliseconds: 250),
      ));
  BottomSheetStyle get _style =>
      widget.style?.merge(BottomSheetTheme.of(context)) ??
      BottomSheetTheme.of(context);
  double get _height =>
      (_surfaceKey.currentContext?.findRenderObject() as RenderBox?)
          ?.size
          .height ??
      1;
  bool _settlingClosed = false;

  void _start(DragStartDetails details) {
    _settlingClosed = false;
    _controller.stop();
    widget.onDragStart?.call(details);
  }

  void _update(DragUpdateDetails details) {
    final double height = _height;
    if (height > 0) {
      _controller.value = (_controller.value - details.delta.dy / height).clamp(
        0,
        1,
      );
    }
  }

  void _end(DragEndDetails details) {
    final double velocity = -details.velocity.pixelsPerSecond.dy / _height;
    final List<double> snaps = <double>{
      if (widget.isDismissible) 0,
      ...?widget.snapPoints ?? _style.snapPoints,
      1,
    }.toList()..sort();
    assert(snaps.every((double point) => point >= 0 && point <= 1));
    final double projected = (_controller.value + velocity * .15).clamp(0, 1);
    double target = snaps.first;
    for (final double point in snaps) {
      if ((point - projected).abs() < (target - projected).abs()) {
        target = point;
      }
    }
    final bool isClosing = target == 0;
    widget.onDragEnd?.call(details, isClosing: isClosing);
    _settlingClosed = isClosing;
    animateWithSpring(
      context,
      _controller,
      target,
      velocity: velocity,
      spring: _style.spring ?? MotionSpring.standard,
    ).whenCompleteOrCancel(() {
      if (mounted && _settlingClosed && _controller.value < .001) {
        _settlingClosed = false;
        widget.onClosing();
      }
    });
  }

  @override
  void didUpdateWidget(BottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationController != widget.animationController) {
      _settlingClosed = false;
    }
    if (oldWidget.animationController == null &&
        widget.animationController != null) {
      _ownedController?.dispose();
      _ownedController = null;
    }
    if (oldWidget.animationController != null &&
        widget.animationController == null) {
      _ownedController = AnimationController(
        vsync: this,
        value: oldWidget.animationController!.value,
        duration: const Duration(milliseconds: 250),
      );
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'BottomSheet',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    final BottomSheetStyle resolved = _style;
    final Size handleSize = resolved.dragHandleSize ?? const Size(32, 4);
    final Color handleColor =
        resolved.dragHandleColor ??
        IconTheme.of(context).color ??
        const Color(0xff000000);
    Widget content = AnimatedSurface(
      key: _surfaceKey,
      duration: reducedMotionDuration(
        context,
        resolved.transitionDuration ?? const Duration(milliseconds: 250),
      ),
      curve: resolved.transitionCurve ?? Curves.easeOutCubic,
      decoration: widget.decoration ?? resolved.decoration,
      padding: resolved.padding,
      constraints: widget.constraints ?? resolved.constraints,
      clipBehavior: widget.clipBehavior ?? resolved.clipBehavior ?? Clip.none,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.showDragHandle ?? false)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: _start,
              onVerticalDragUpdate: _update,
              onVerticalDragEnd: _end,
              child: Center(
                child: Semantics(
                  label: NeutralLocalizations.of(context).bottomSheetLabel,
                  child: SizedBox(
                    width: handleSize.width,
                    height: handleSize.height,
                    child: DecoratedBox(
                      decoration:
                          resolved.dragHandleDecoration ??
                          BoxDecoration(color: handleColor),
                    ),
                  ),
                ),
              ),
            ),
          Flexible(child: widget.builder(context)),
        ],
      ),
    );
    if (widget.enableDrag) {
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: _start,
        onVerticalDragUpdate: _update,
        onVerticalDragEnd: _end,
        child: content,
      );
    }
    content = NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification notification) {
        if (notification.extent <= notification.minExtent &&
            notification.shouldCloseOnMinExtent &&
            widget.isDismissible) {
          widget.onClosing();
        }
        return false;
      },
      child: content,
    );
    content = Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: NeutralLocalizations.of(context).bottomSheetLabel,
      explicitChildNodes: true,
      child: RepaintBoundary(child: content),
    );
    return AnimatedBuilder(
      animation: _controller,
      child: content,
      builder: (BuildContext context, Widget? child) {
        return resolved.transitionBuilder?.call(context, _controller, child!) ??
            FractionalTranslation(
              translation: Offset(0, 1 - _controller.value),
              child: child,
            );
      },
    );
  }
}

/// Presents a modal bottom sheet, sharing its route controller with dragging.
Future<T?> showModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? barrierLabel,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  double scrollControlDisabledMaxHeightRatio = 9 / 16,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  AnimationStyle? sheetAnimationStyle,
  bool? requestFocus,
  BottomSheetStyle? style,
  BoxDecoration? decoration,
  List<double>? snapPoints,
}) {
  assert(
    scrollControlDisabledMaxHeightRatio > 0 &&
        scrollControlDisabledMaxHeightRatio <= 1,
  );
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  final BottomSheetStyle resolved =
      style?.merge(BottomSheetTheme.of(context)) ??
      BottomSheetTheme.of(context);
  return navigator.push<T>(
    _ModalBottomSheetRoute<T>(
      builder: builder,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      style: resolved.copyWith(
        transitionCurve: sheetAnimationStyle?.curve,
        reverseTransitionCurve: sheetAnimationStyle?.reverseCurve,
      ),
      decoration: decoration,
      constraints: constraints,
      clipBehavior: clipBehavior,
      isScrollControlled: isScrollControlled,
      maximumHeightRatio: scrollControlDisabledMaxHeightRatio,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      externalController: transitionAnimationController,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
      label:
          barrierLabel ??
          NeutralLocalizations.of(context).modalBarrierDismissLabel,
      color: barrierColor ?? resolved.barrierColor,
      duration: reducedMotionDuration(
        context,
        sheetAnimationStyle?.duration ??
            resolved.transitionDuration ??
            const Duration(milliseconds: 250),
      ),
      reverseDuration: reducedMotionDuration(
        context,
        sheetAnimationStyle?.reverseDuration ??
            resolved.reverseTransitionDuration ??
            const Duration(milliseconds: 200),
      ),
      snapPoints: snapPoints,
    ),
  );
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    required this.builder,
    required this.capturedThemes,
    required this.style,
    required this.decoration,
    required this.constraints,
    required this.clipBehavior,
    required this.isScrollControlled,
    required this.maximumHeightRatio,
    required this.isDismissible,
    required this.enableDrag,
    required this.showDragHandle,
    required this.useSafeArea,
    required this.label,
    required this.color,
    required this.duration,
    required this.reverseDuration,
    required this.externalController,
    required this.anchorPoint,
    required this.snapPoints,
    super.settings,
    super.requestFocus,
  }) : super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  /// Builds the sheet content.
  final WidgetBuilder builder;

  /// The capturedThemes associated with this component.
  final CapturedThemes capturedThemes;

  /// Local appearance and motion tokens.
  final BottomSheetStyle style;

  /// A surface decoration overriding inherited tokens.
  final BoxDecoration? decoration;

  /// Optional size constraints.
  final BoxConstraints? constraints;

  /// How content is clipped to the surface.
  final Clip? clipBehavior;

  /// The isScrollControlled associated with this component.
  final bool isScrollControlled;

  /// The maximumHeightRatio associated with this component.
  final double maximumHeightRatio;

  /// Whether a downward drag may close the sheet.
  final bool isDismissible;

  /// Whether vertical drags move and dismiss the sheet.
  final bool enableDrag;

  /// Whether to display the painted draggable handle.
  final bool? showDragHandle;

  /// The useSafeArea associated with this component.
  final bool useSafeArea;

  /// The accessible text displayed by the action.
  final String label;

  /// The color associated with this component.
  final Color? color;

  /// How long the notification remains visible before auto-hide.
  final Duration duration;

  /// The reverseDuration associated with this component.
  final Duration reverseDuration;

  /// The externalController associated with this component.
  final AnimationController? externalController;

  /// The anchorPoint associated with this component.
  final Offset? anchorPoint;

  /// Allowed sheet extents, expressed as fractions of its height.
  final List<double>? snapPoints;
  @override
  bool get barrierDismissible => isDismissible;
  @override
  String get barrierLabel => label;
  @override
  Color? get barrierColor => color;
  @override
  Duration get transitionDuration => duration;
  @override
  Duration get reverseTransitionDuration => reverseDuration;
  @override
  AnimationController createAnimationController() {
    if (externalController != null) {
      willDisposeAnimationController = false;
      return externalController!;
    }
    return super.createAnimationController();
  }

  @override
  Simulation? createSimulation({required bool forward}) {
    final Duration elapsed = forward ? duration : reverseDuration;
    if (elapsed == Duration.zero) return null;
    return _SheetMotionSimulation(
      from: controller!.value,
      to: forward ? 1 : 0,
      duration: elapsed,
      curve: forward
          ? style.transitionCurve ?? Curves.easeOutCubic
          : style.reverseTransitionCurve ?? Curves.easeInCubic,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints available) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  available.maxHeight *
                  (isScrollControlled ? 1 : maximumHeightRatio),
            ),
            child: BottomSheet(
              animationController: controller,
              onClosing: () {
                if (isCurrent) navigator!.pop();
              },
              builder: (BuildContext context) =>
                  capturedThemes.wrap(Builder(builder: builder)),
              style: style,
              decoration: decoration,
              constraints: constraints,
              clipBehavior: clipBehavior,
              enableDrag: enableDrag,
              showDragHandle: showDragHandle,
              isDismissible: isDismissible,
              snapPoints: snapPoints,
            ),
          ),
        );
      },
    );
    result = Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        menuKeyActivator(0x10000001b): const DismissIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (DismissIntent intent) {
              if (isDismissible) navigator!.maybePop();
              return null;
            },
          ),
        },
        child: result,
      ),
    );
    if (useSafeArea) {
      result = SafeArea(bottom: false, child: result);
    } else {
      result = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: result,
      );
    }
    return DisplayFeatureSubScreen(anchorPoint: anchorPoint, child: result);
  }
}

class _SheetMotionSimulation extends Simulation {
  _SheetMotionSimulation({
    required this.from,
    required this.to,
    required Duration duration,
    required this.curve,
  }) : seconds = duration.inMicroseconds / Duration.microsecondsPerSecond;
  final double from;
  final double to;
  final double seconds;
  final Curve curve;
  @override
  double x(double time) => from == to
      ? to
      : from + (to - from) * curve.transform((time / seconds).clamp(0, 1));
  @override
  double dx(double time) {
    if (isDone(time)) return 0;
    const double step = .00001;
    return (x(time + step) - x(time - step)) / (2 * step);
  }

  @override
  bool isDone(double time) => from == to || time >= seconds;
}
