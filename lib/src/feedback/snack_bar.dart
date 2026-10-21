import '../buttons/icon_button.dart';
import '../buttons/text_button.dart';
import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/motion.dart';
import '../localizations/neutral_localizations.dart';
import '../styles/button_style.dart';
import '../styles/snack_bar_style.dart';
import '../theme/feedback_themes.dart';

import 'package:flutter/widgets.dart';

/// Why a snack bar left its host.
enum SnackBarClosedReason {
  /// A notification action was activated.
  action,

  /// The close control was activated.
  dismiss,

  /// The user swiped the notification away.
  swipe,

  /// The host animated the notification out.
  hide,

  /// The host removed the notification immediately.
  remove,

  /// The display duration elapsed.
  timeout,
}

/// The placement behavior of a notification.
enum SnackBarBehavior {
  /// The notification rests at the available edge.
  fixed,

  /// The notification uses the configured outer margin.
  floating,
}

/// A notification with optional action and close controls.
class SnackBar extends StatelessWidget {
  /// Creates a snack bar.
  const SnackBar({
    super.key,
    required this.content,
    this.action,
    this.duration = const Duration(seconds: 4),
    bool? persist,
    this.onVisible,
    this.showCloseIcon = false,
    this.dismissDirection = DismissDirection.down,
    this.animation,
    this.hitTestBehavior,
    this.actionOverflowThreshold,
    this.style,
    this.decoration,
    this.clipBehavior,
  }) : assert(
         actionOverflowThreshold == null ||
             (actionOverflowThreshold >= 0 && actionOverflowThreshold <= 1),
       ),
       persist = persist ?? action != null;

  /// The primary message content.
  final Widget content;

  /// An optional notification action.
  final SnackBarAction? action;

  /// How long the notification remains visible before auto-hide.
  final Duration duration;

  /// Whether the notification waits for explicit dismissal.
  final bool persist;

  /// Called once the notification finishes entering.
  final VoidCallback? onVisible;

  /// Whether to display an explicit close control.
  final bool showCloseIcon;

  /// The allowed swipe dismissal direction.
  final DismissDirection dismissDirection;

  /// An optional custom notification transition animation.
  final Animation<double>? animation;

  /// The pointer hit testing behavior of the notification.
  final HitTestBehavior? hitTestBehavior;

  /// The available width fraction at which the action wraps.
  final double? actionOverflowThreshold;

  /// Local appearance and motion tokens.
  final SnackBarStyle? style;

  /// A surface decoration overriding inherited tokens.
  final BoxDecoration? decoration;

  /// How content is clipped to the surface.
  final Clip? clipBehavior;
  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'SnackBar',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: decoration,
        styleValue: style?.decoration,
      ),
    );
    final SnackBarStyle resolved =
        style?.merge(SnackBarTheme.of(context)) ?? SnackBarTheme.of(context);
    final Widget? close = showCloseIcon
        ? IconButton(
            onPressed: () =>
                _SnackBarScope.maybeOf(context)
                    ?.close(SnackBarClosedReason.dismiss),
            style: resolved.closeButtonStyle,
            icon: Semantics(
              label: NeutralLocalizations.of(context).closeButtonTooltip,
              child: const CloseGlyph(),
            ),
          )
        : null;
    return Listener(
      behavior: hitTestBehavior ?? HitTestBehavior.opaque,
      child: Semantics(
        liveRegion: true,
        container: true,
        label: NeutralLocalizations.of(context).snackBarLabel,
        child: AnimatedSurface(
          duration: reducedMotionDuration(
            context,
            resolved.transitionDuration ?? const Duration(milliseconds: 250),
          ),
          curve: resolved.transitionCurve ?? Curves.easeOutCubic,
          decoration: decoration ?? resolved.decoration,
          padding: resolved.padding,
          constraints: resolved.constraints,
          clipBehavior: clipBehavior ?? resolved.clipBehavior ?? Clip.none,
          child: DefaultTextStyle.merge(
            style: resolved.textStyle,
            child: _SnackContent(
              content: content,
              action: action,
              close: close,
              spacing: resolved.spacing ?? 0,
              threshold: actionOverflowThreshold ?? .25,
            ),
          ),
        ),
      ),
    );
  }
}

/// An action that can be invoked at most once for a displayed notification.
class SnackBarAction extends StatefulWidget {
  /// Creates a snack bar action.
  const SnackBarAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
  });

  /// The accessible text displayed by the action.
  final String label;

  /// Invoked when the control is activated.
  final VoidCallback onPressed;

  /// Local appearance and motion tokens.
  final ButtonStyle? style;
  @override
  State<SnackBarAction> createState() => _SnackBarActionState();
}

class _SnackBarActionState extends State<SnackBarAction> {
  bool _triggered = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style:
          widget.style?.merge(SnackBarTheme.of(context).actionStyle) ??
          SnackBarTheme.of(context).actionStyle,
      onPressed: _triggered
          ? null
          : () {
              setState(() {
                _triggered = true;
              });
              widget.onPressed();
              if (context.mounted) {
                _SnackBarScope.maybeOf(context)
                    ?.close(SnackBarClosedReason.action);
              }
            },
      child: Text(widget.label),
    );
  }
}

/// Controls a queued notification and completes when it leaves the overlay.
class ScaffoldFeatureController<T extends Widget, U> {
  ScaffoldFeatureController._(this._entry, this._close);
  final _SnackBarEntry _entry;
  final VoidCallback _close;

  /// Completes with the reason the notification closed.
  Future<U> get closed =>
      _entry.closed.then((SnackBarClosedReason reason) => reason as U);

  /// Requests the notification's normal exit animation.
  void close() => _close();
}

/// An overlay host that displays snack bars in first-in-first-out order.
class ScaffoldMessenger extends StatefulWidget {
  /// Creates a scaffold messenger.
  const ScaffoldMessenger({super.key, required this.child});

  /// The widget displayed by this component.
  final Widget child;

  /// Returns the nearest component host.
  static ScaffoldMessengerState of(BuildContext context) {
    final ScaffoldMessengerState? result = maybeOf(context);
    assert(result != null, 'No ScaffoldMessenger ancestor found.');
    return result!;
  }

  /// Returns the nearest component host, or null.
  static ScaffoldMessengerState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MessengerScope>()?.state;
  @override
  ScaffoldMessengerState createState() => ScaffoldMessengerState();
}

/// The notification queue associated with a [ScaffoldMessenger].
class ScaffoldMessengerState extends State<ScaffoldMessenger>
    with TickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final List<_SnackBarEntry> _queue = <_SnackBarEntry>[];
  late final AnimationController _transition = AnimationController(vsync: this)
    ..addStatusListener(_status);
  VoidCallback? _cancelTimeout;

  void _stopTimeout() {
    _cancelTimeout?.call();
    _cancelTimeout = null;
  }

  CurvedAnimation? _curve;
  SnackBarClosedReason? _closingReason;
  bool _dragging = false;
  bool get _accessible =>
      MediaQuery.maybeOf(context)?.accessibleNavigation ?? false;
  _SnackBarEntry? get _current => _queue.isEmpty ? null : _queue.first;

  /// Queues [snackBar] and returns its dismissal handle.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) {
    assert(snackBar.duration >= Duration.zero);
    final _SnackBarEntry entry = _SnackBarEntry(
      snackBar,
      snackBarAnimationStyle,
      this,
    );
    setState(() {
      _queue.add(entry);
    });
    if (_queue.length == 1) _showCurrent();
    return ScaffoldFeatureController<SnackBar, SnackBarClosedReason>._(
      entry,
      () {
        if (!mounted) return;
        if (_current == entry) {
          hideCurrentSnackBar();
        } else if (_queue.remove(entry)) {
          entry.complete(SnackBarClosedReason.hide);
        }
      },
    );
  }

  void _configure() {
    final _SnackBarEntry? entry = _current;
    if (entry == null) return;
    final SnackBarStyle style =
        entry.snackBar.style?.merge(SnackBarTheme.of(context)) ??
        SnackBarTheme.of(context);
    _transition.duration = reducedMotionDuration(
      context,
      entry.animationStyle?.duration ??
          style.transitionDuration ??
          const Duration(milliseconds: 250),
    );
    _transition.reverseDuration = reducedMotionDuration(
      context,
      entry.animationStyle?.reverseDuration ??
          style.reverseTransitionDuration ??
          const Duration(milliseconds: 200),
    );
    _curve?.dispose();
    _curve = CurvedAnimation(
      parent: _transition,
      curve:
          entry.animationStyle?.curve ??
          style.transitionCurve ??
          Curves.easeOutCubic,
      reverseCurve:
          entry.animationStyle?.reverseCurve ??
          style.reverseTransitionCurve ??
          Curves.easeInCubic,
    );
  }

  void _showCurrent() {
    _dragging = false;
    _stopTimeout();
    _closingReason = null;
    _configure();
    _portal.show();
    _transition.forward(from: 0);
  }

  void _startLifetime() {
    final _SnackBarEntry? entry = _current;
    if (entry == null) return;
    if (!entry.visible) {
      entry.visible = true;
      entry.snackBar.onVisible?.call();
    }
    if (!mounted ||
        _current != entry ||
        _closingReason != null ||
        !_transition.isCompleted) {
      return;
    }
    _stopTimeout();
    if (!entry.snackBar.persist && !_accessible && !_dragging) {
      // Stream is exposed by dart:core; its subscription type is not exposed
      // by widgets.dart. Capturing cancellation keeps the timeout frame-free.
      // ignore: always_specify_types
      final subscription =
          Stream<int>.periodic(
            entry.snackBar.duration,
            (int count) => count,
          ).take(1).listen((int _) {
            _cancelTimeout = null;
            if (mounted && _current == entry) {
              hideCurrentSnackBar(reason: SnackBarClosedReason.timeout);
            }
          });
      _cancelTimeout = () {
        subscription.cancel();
      };
    }
  }

  void _status(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.completed) _startLifetime();
    if (status == AnimationStatus.dismissed && _closingReason != null) {
      final _SnackBarEntry entry = _queue.removeAt(0);
      entry.complete(_closingReason!);
      _closingReason = null;
      if (_queue.isEmpty) {
        _portal.hide();
        setState(() {});
      } else {
        setState(() {});
        _showCurrent();
      }
    }
  }

  /// Animates the current notification out.
  void hideCurrentSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.hide,
  }) {
    if (!mounted || _current == null || _closingReason != null) return;
    _stopTimeout();
    _closingReason = reason;
    if (_transition.isDismissed) {
      _status(AnimationStatus.dismissed);
    } else {
      _transition.reverse();
    }
  }

  /// Removes the current notification without an exit animation.
  void removeCurrentSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.remove,
  }) {
    if (!mounted || _current == null) return;
    _stopTimeout();
    _closingReason = reason;
    if (_transition.isDismissed) {
      _status(AnimationStatus.dismissed);
    } else {
      _transition.value = 0;
    }
  }

  /// Removes queued notifications and animates the current one out.
  void clearSnackBars() {
    if (!mounted) return;
    while (_queue.length > 1) {
      _queue.removeLast().complete(SnackBarClosedReason.remove);
    }
    hideCurrentSnackBar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_current != null) {
      _configure();
      if (_transition.isCompleted) _startLifetime();
    }
  }

  @override
  void dispose() {
    _curve?.dispose();
    _transition.dispose();
    _stopTimeout();
    for (final _SnackBarEntry entry in _queue) {
      entry.complete(SnackBarClosedReason.remove);
    }
    _queue.clear();
    super.dispose();
  }

  Widget _buildOverlay(BuildContext context) {
    final _SnackBarEntry? entry = _current;
    if (entry == null) return const SizedBox.shrink();
    final SnackBarStyle style =
        entry.snackBar.style?.merge(SnackBarTheme.of(context)) ??
        SnackBarTheme.of(context);
    Widget child = _SnackBarScope(
      close: (SnackBarClosedReason reason) {
        if (mounted && _current == entry) hideCurrentSnackBar(reason: reason);
      },
      child: KeyedSubtree(key: ObjectKey(entry), child: entry.snackBar),
    );
    child = Dismissible(
      key: ObjectKey(entry),
      direction: entry.snackBar.dismissDirection,
      resizeDuration: null,
      movementDuration: reducedMotionDuration(
        context,

        const Duration(milliseconds: 200),
      ),
      onUpdate: (DismissUpdateDetails details) {
        if (_current != entry) return;
        if (details.progress == 0) {
          _resumeAfterDrag(entry);
          return;
        }
        if (!_dragging) {
          _dragging = true;
          _stopTimeout();
        }
      },
      onDismissed: (DismissDirection direction) {
        if (mounted && _current == entry) {
          removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        }
      },
      confirmDismiss: (DismissDirection direction) async => true,
      child: child,
    );
    child = Listener(
      onPointerUp: (_) => _resumeAfterDrag(entry),
      onPointerCancel: (_) => _resumeAfterDrag(entry),
      child: child,
    );
    child = RepaintBoundary(child: child);
    final Animation<double> animation = entry.snackBar.animation ?? _curve!;
    child =
        style.transitionBuilder?.call(context, animation, child) ??
        SlideTransition(
          position: animation.drive(
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero),
          ),
          child: child,
        );
    return Positioned.fill(
      child: SafeArea(
        child: Align(
          alignment: style.alignment ?? Alignment.bottomCenter,
          child: Padding(
            padding: style.margin ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }

  void _resumeAfterDrag(_SnackBarEntry entry) {
    if (!mounted || _current != entry || !_dragging) return;
    _dragging = false;
    if (_closingReason == null && _transition.isCompleted) _startLifetime();
  }

  @override
  Widget build(BuildContext context) => _MessengerScope(
    state: this,
    child: OverlayPortal.overlayChildLayoutBuilder(
      overlayLocation: OverlayChildLocation.rootOverlay,
      controller: _portal,
      overlayChildBuilder: (
        BuildContext context,
        OverlayChildLayoutInfo info,
      ) => InteractionBoundary(inherit: false, child: _buildOverlay(context)),
      child: widget.child,
    ),
  );
}

class _MessengerScope extends InheritedWidget {
  const _MessengerScope({required this.state, required super.child});

  /// The state associated with this component.
  final ScaffoldMessengerState state;
  @override
  bool updateShouldNotify(_MessengerScope oldWidget) =>
      state != oldWidget.state;
}

class _SnackBarScope extends InheritedWidget {
  const _SnackBarScope({required this.close, required super.child});

  /// The close associated with this component.
  final ValueChanged<SnackBarClosedReason> close;

  /// Returns the nearest component host, or null.
  static _SnackBarScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SnackBarScope>();
  @override
  bool updateShouldNotify(_SnackBarScope oldWidget) => close != oldWidget.close;
}

class _SnackBarEntry {
  _SnackBarEntry(this.snackBar, this.animationStyle, TickerProvider vsync) {
    // widgets.dart does not export the ticker type returned by this method.
    // ignore: always_specify_types
    final completion = vsync.createTicker((Duration elapsed) {})..muted = true;
    closed = completion.start().then((_) => _reason!);
    _complete = () {
      completion.stop();
      completion.dispose();
    };
  }

  /// The snackBar associated with this component.
  final SnackBar snackBar;

  /// The animationStyle associated with this component.
  final AnimationStyle? animationStyle;
  bool visible = false;
  late final VoidCallback _complete;
  late final Future<SnackBarClosedReason> closed;
  SnackBarClosedReason? _reason;
  void complete(SnackBarClosedReason reason) {
    if (_reason != null) return;
    _reason = reason;
    _complete();
  }
}

// Measures the action once per layout change; animation ticks reuse its layout.
class _SnackContent extends StatefulWidget {
  const _SnackContent({
    required this.content,
    required this.action,
    required this.close,
    required this.spacing,
    required this.threshold,
  });
  final Widget content;
  final Widget? action;
  final Widget? close;
  final double spacing;
  final double threshold;
  @override
  State<_SnackContent> createState() => _SnackContentState();
}

class _SnackContentState extends State<_SnackContent> {
  final GlobalKey _actionKey = GlobalKey();
  double? _actionWidth;
  bool _measurementPending = false;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      if (widget.action != null && !_measurementPending) {
        _measurementPending = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _measurementPending = false;
          if (!mounted) return;
          final RenderBox? box =
              _actionKey.currentContext?.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize && box.size.width != _actionWidth) {
            setState(() {
              _actionWidth = box.size.width;
            });
          }
        });
      }
      final Widget? action = widget.action == null
          ? null
          : KeyedSubtree(key: _actionKey, child: widget.action!);
      final bool wrap =
          action != null &&
          constraints.hasBoundedWidth &&
          (_actionWidth == null ||
              _actionWidth! > constraints.maxWidth * widget.threshold);
      final Widget row = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(child: widget.content),
          if (!wrap && action != null) ...<Widget>[
            SizedBox(width: widget.spacing),
            action,
          ],
          if (widget.close != null) widget.close!,
        ],
      );
      if (!wrap) return row;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          row,
          SizedBox(height: widget.spacing),
          Align(alignment: AlignmentDirectional.centerEnd, child: action),
        ],
      );
    },
  );
}
