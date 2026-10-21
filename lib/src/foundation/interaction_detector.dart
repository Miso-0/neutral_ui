import 'package:flutter/widgets.dart';

import 'focus_visibility.dart';
import 'interaction_state.dart';
import 'state_property.dart';

/// Builds a control from its current interaction state.
typedef InteractionWidgetBuilder = Widget Function(
  BuildContext context,
  InteractionState state,
);

/// Supplies pointer, keyboard, focus and controller state to a headless control.
///
/// Only the innermost interactive surface shows interaction: while a nested
/// detector is hovered or pressed, this detector's state reports neither, and
/// focus is visible only on the detector that holds primary focus. Visible
/// focus follows keyboard use, so a pointer press hides it until the next key
/// press. [onHover] and [onFocusChange] still report the raw pointer and focus.
class InteractionDetector extends StatefulWidget {
  /// Creates an interaction surface without painting any visual treatment.
  const InteractionDetector({
    super.key,
    required this.builder,
    this.enabled = true,
    this.isSelected,
    this.isFocused,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.mouseCursor,
    this.statesController,
    this.enableFeedback = true,
    this.actions,
    this.excludeFromSemantics = false,
  });

  /// Builds the content and its entire hit target.
  ///
  /// The supplied context is inside this detector's [Actions] and [Focus].
  final InteractionWidgetBuilder builder;

  /// Whether interaction is enabled.
  final bool enabled;

  /// Selection supplied by a controlled widget, or read from the controller.
  final bool? isSelected;

  /// Overrides focus visibility, including virtual focus in editable menus.
  final bool? isFocused;

  /// Called by taps, activation intents and semantic activation.
  final VoidCallback? onTap;

  /// Called after recognizing a long press.
  final VoidCallback? onLongPress;

  /// Called when a tap enters the gesture arena.
  final GestureTapDownCallback? onTapDown;

  /// Called when a tap is released.
  final GestureTapUpCallback? onTapUp;

  /// Called when a tap loses the gesture arena or is canceled.
  final GestureTapCancelCallback? onTapCancel;

  /// Called when a horizontal drag starts.
  final GestureDragStartCallback? onHorizontalDragStart;

  /// Called when a horizontal drag moves.
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  /// Called when a horizontal drag ends.
  final GestureDragEndCallback? onHorizontalDragEnd;

  /// Called when a horizontal drag is canceled.
  final GestureDragCancelCallback? onHorizontalDragCancel;

  /// Reports whether an enabled pointer is over the detector, including over
  /// nested interactive controls.
  final ValueChanged<bool>? onHover;

  /// Reports raw focus, including focus held by a descendant, independently
  /// of whether focus is visible.
  final ValueChanged<bool>? onFocusChange;

  /// An externally owned focus node.
  final FocusNode? focusNode;

  /// Whether to request initial focus.
  final bool autofocus;

  /// Whether this surface can receive focus.
  final bool canRequestFocus;

  /// Resolves the pointer cursor, falling back to click or basic.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// An externally owned controller synchronized with interaction state.
  final WidgetStatesController? statesController;

  /// Whether platform interaction feedback is enabled.
  final bool enableFeedback;

  /// Intent actions that take precedence over built-in activation actions.
  final Map<Type, Action<Intent>>? actions;

  /// Whether semantic gesture callbacks are supplied by an enclosing widget.
  final bool excludeFromSemantics;

  @override
  State<InteractionDetector> createState() => _InteractionDetectorState();
}

class _ActivationAction<T extends Intent> extends Action<T> {
  _ActivationAction(this.owner);

  final _InteractionDetectorState owner;

  @override
  bool isEnabled(T intent) =>
      owner.widget.enabled && owner.widget.onTap != null;

  @override
  Object? invoke(T intent) {
    owner._activate();
    return null;
  }
}

class _InteractionDetectorState extends State<InteractionDetector> {
  late final Action<ActivateIntent> _activateAction;
  late final Action<ButtonActivateIntent> _buttonAction;
  int _keyboardPressGeneration = 0;
  Future<void> Function()? _cancelKeyboardPress;
  final Set<int> _pointers = <int>{};
  bool _dragCanceled = false;
  bool _pressed = false;
  bool _dragged = false;
  bool _hovering = false;
  bool _hasFocus = false;
  bool _writingController = false;
  bool _reportedHover = false;
  NavigationMode _navigationMode = NavigationMode.traditional;
  FocusNode? _ownedFocusNode;
  bool _listeningToVisibility = false;

  // Nesting: the enclosing detector, and nested detectors that are active.
  _InteractionDetectorState? _parent;
  final Set<_InteractionDetectorState> _hoveredChildren =
      <_InteractionDetectorState>{};
  final Set<_InteractionDetectorState> _pressedChildren =
      <_InteractionDetectorState>{};
  bool _pressSuppressed = false;
  bool _childUpdateScheduled = false;

  // A frozen scope keeps the hover and press look captured when it froze; a
  // masked scope hides hover, as after keyboard navigation in a menu.
  bool _frozen = false;
  bool _hoverMasked = false;
  bool _frozenHovered = false;
  bool _frozenPressed = false;

  FocusNode get _focusNode =>
      widget.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'InteractionDetector'));

  bool get _acceptsTap =>
      widget.enabled &&
      (widget.onTap != null ||
          widget.onTapDown != null ||
          widget.onTapUp != null ||
          widget.onTapCancel != null ||
          widget.onLongPress != null);

  bool get _acceptsDrag =>
      widget.enabled &&
      (widget.onHorizontalDragStart != null ||
          widget.onHorizontalDragUpdate != null ||
          widget.onHorizontalDragEnd != null ||
          widget.onHorizontalDragCancel != null);

  bool get _rawHovered => widget.enabled && _hovering;

  bool get _rawPressed => widget.enabled && _pressed;

  // Surfaces that only display state, such as a tile without an action, do
  // not take hover from the control around them.
  bool get _interactive =>
      _acceptsTap ||
      _acceptsDrag ||
      (widget.enabled && (widget.canRequestFocus || widget.isFocused != null));

  // What this detector reports to its parent: itself or any nested control.
  bool get _activeHover =>
      (_interactive && _rawHovered) || _hoveredChildren.isNotEmpty;

  bool get _activePress => _rawPressed || _pressedChildren.isNotEmpty;

  InteractionState get _state => InteractionState(
    isPressed: _frozen
        ? _frozenPressed
        : _rawPressed && !_pressSuppressed && _pressedChildren.isEmpty,
    isDragged: widget.enabled && _dragged,
    isHovered: _frozen
        ? _frozenHovered
        : !_hoverMasked && _rawHovered && _hoveredChildren.isEmpty,
    isFocused:
        widget.isFocused ??
        (_hasFocus &&
            (_navigationMode == NavigationMode.directional ||
                (widget.enabled && FocusVisibility.isVisible))),
    isSelected:
        widget.isSelected ??
        widget.statesController?.value.contains(WidgetState.selected) ??
        false,
    isDisabled: !widget.enabled,
  );

  @override
  void initState() {
    super.initState();
    _activateAction = _ActivationAction<ActivateIntent>(this);
    _buttonAction = _ActivationAction<ButtonActivateIntent>(this);
    FocusVisibility.ensureInitialized();
    widget.statesController?.addListener(_controllerChanged);
    _syncController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationMode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    final _InteractionScope? scope = context
        .dependOnInheritedWidgetOfExactType<_InteractionScope>();
    _setParent(scope?.owner);
    final bool frozen = scope?.frozen ?? false;
    if (frozen && !_frozen) {
      final InteractionState current = _state;
      _frozenHovered = current.isHovered;
      _frozenPressed = current.isPressed;
    }
    _frozen = frozen;
    _hoverMasked = scope?.hoverMasked ?? false;
    _syncController();
  }

  @override
  void didUpdateWidget(InteractionDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool previousHover = oldWidget.enabled && _hovering;
    if (oldWidget.statesController != widget.statesController) {
      oldWidget.statesController?.removeListener(_controllerChanged);
      widget.statesController?.addListener(_controllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _hasFocus = _focusNode.hasPrimaryFocus;
      _syncVisibilityListener();
    }
    if (oldWidget.isFocused != widget.isFocused) _syncVisibilityListener();
    if (!_acceptsTap) {
      _stopKeyboardPress();
      _pressed = false;
      _pressSuppressed = false;
    }
    if (!_acceptsDrag) {
      _dragged = false;
      _dragCanceled = false;
      _pointers.clear();
    }
    _syncController();
    _reportToParent();
    if (previousHover != _rawHovered) {
      final bool hovered = _rawHovered;
      _reportedHover = hovered;
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted && _rawHovered == hovered) {
          widget.onHover?.call(hovered);
        }
      });
    }
  }

  @override
  void deactivate() {
    _setParent(null);
    super.deactivate();
  }

  void _setParent(_InteractionDetectorState? parent) {
    if (identical(parent, _parent)) return;
    _parent?._updateChild(this, hovered: false, pressed: false);
    _parent = parent;
    _reportToParent();
  }

  void _reportToParent() {
    _parent?._updateChild(this, hovered: _activeHover, pressed: _activePress);
  }

  // Called by nested detectors, possibly while the tree is building, so the
  // sets update at once and the rebuild waits for the current frame's work.
  void _updateChild(
    _InteractionDetectorState child, {
    required bool hovered,
    required bool pressed,
  }) {
    final bool hoverChanged = hovered
        ? _hoveredChildren.add(child)
        : _hoveredChildren.remove(child);
    final bool pressChanged = pressed
        ? _pressedChildren.add(child)
        : _pressedChildren.remove(child);
    // A nested press can begin after this detector's own tap down. Keep the
    // press hidden until this gesture ends, so the inner release that runs
    // before the outer cancel does not flash it.
    if (pressed && _pressed) _pressSuppressed = true;
    if (!hoverChanged && !pressChanged) return;
    if (_childUpdateScheduled) return;
    _childUpdateScheduled = true;
    Future<void>.microtask(() {
      _childUpdateScheduled = false;
      _change(() {});
    });
  }

  void _syncVisibilityListener() {
    final bool listen = _hasFocus && widget.isFocused == null;
    if (listen == _listeningToVisibility) return;
    _listeningToVisibility = listen;
    if (listen) {
      FocusVisibility.addListener(_visibilityChanged);
    } else {
      FocusVisibility.removeListener(_visibilityChanged);
    }
  }

  void _syncController() {
    final WidgetStatesController? controller = widget.statesController;
    if (controller == null || _writingController) return;
    final Set<WidgetState> states = <WidgetState>{...controller.value};
    final InteractionState current = _state;
    final Map<WidgetState, bool> values = <WidgetState, bool>{
      WidgetState.pressed: current.isPressed,
      WidgetState.dragged: current.isDragged,
      WidgetState.hovered: current.isHovered,
      WidgetState.focused: current.isFocused,
      WidgetState.disabled: current.isDisabled,
      if (widget.isSelected != null) WidgetState.selected: current.isSelected,
    };
    for (final MapEntry<WidgetState, bool> entry in values.entries) {
      entry.value ? states.add(entry.key) : states.remove(entry.key);
    }
    if (states.length == controller.value.length &&
        states.containsAll(controller.value)) {
      return;
    }
    _writingController = true;
    try {
      controller.value = states;
    } finally {
      _writingController = false;
    }
  }

  void _controllerChanged() {
    if (_writingController || !mounted) return;
    _change(() {});
  }

  void _visibilityChanged() {
    if (mounted) _change(() {});
  }

  void _change(VoidCallback change) {
    if (!mounted) return;
    setState(change);
    if (!_rawPressed) _pressSuppressed = false;
    _syncController();
    _reportToParent();
    if (_reportedHover != _rawHovered) {
      _reportedHover = _rawHovered;
      widget.onHover?.call(_reportedHover);
    }
  }

  void _pressStarted() {
    _stopKeyboardPress();
    _change(() {
      _pressed = true;
      _pressSuppressed = _pressedChildren.isNotEmpty;
    });
  }

  void _activate() {
    if (!widget.enabled || widget.onTap == null) return;
    _change(() {
      _pressed = true;
    });
    _stopKeyboardPress();
    final int generation = _keyboardPressGeneration;
    // Store the cancellation tear-off so no dart:async type needs importing.
    // Unlike animation tickers, this timeout also runs under TickerMode(false).
    _cancelKeyboardPress =
        Stream<int>.periodic(
          const Duration(milliseconds: 100),
          (int tick) => tick,
        ).listen((int tick) {
          if (generation == _keyboardPressGeneration) {
            _stopKeyboardPress();
            if (!mounted) return;
            _change(() {
              _pressed = false;
            });
          }
        }).cancel;
    _tap();
  }

  void _stopKeyboardPress() {
    _keyboardPressGeneration++;
    _cancelKeyboardPress?.call();
    _cancelKeyboardPress = null;
  }

  void _tap() {
    if (!widget.enabled || widget.onTap == null) return;
    if (widget.enableFeedback) Feedback.forTap(context);
    widget.onTap!();
  }

  void _longPress() {
    if (!widget.enabled || widget.onLongPress == null) return;
    if (widget.enableFeedback) Feedback.forLongPress(context);
    widget.onLongPress!();
  }

  @override
  void dispose() {
    widget.statesController?.removeListener(_controllerChanged);
    if (_listeningToVisibility) {
      FocusVisibility.removeListener(_visibilityChanged);
    }
    _stopKeyboardPress();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InteractionState state = _state;
    final bool tap = _acceptsTap;
    final bool drag = _acceptsDrag;
    return Actions(
      actions: <Type, Action<Intent>>{
        ActivateIntent: _activateAction,
        ButtonActivateIntent: _buttonAction,
        ...?widget.actions,
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        canRequestFocus:
            widget.canRequestFocus &&
            (widget.enabled || _navigationMode == NavigationMode.directional),
        onFocusChange: (bool focused) {
          // Called again when primary focus moves to or from a descendant.
          _change(() {
            _hasFocus = _focusNode.hasPrimaryFocus;
          });
          _syncVisibilityListener();
          widget.onFocusChange?.call(focused);
        },
        child: MouseRegion(
          cursor:
              widget.mouseCursor?.resolve(state) ??
              (widget.enabled && (tap || drag)
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic),
          onEnter: (Object event) => _change(() {
            _hovering = true;
          }),
          onExit: (Object event) => _change(() {
            _hovering = false;
          }),
          child: Semantics(
            onTap:
                !widget.excludeFromSemantics &&
                    widget.enabled &&
                    widget.onTap != null
                ? _tap
                : null,
            onLongPress:
                !widget.excludeFromSemantics &&
                    widget.enabled &&
                    widget.onLongPress != null
                ? _longPress
                : null,
            child: Listener(
              onPointerDown: drag
                  ? (PointerDownEvent event) {
                      _pointers.add(event.pointer);
                    }
                  : null,
              onPointerUp: drag
                  ? (PointerUpEvent event) {
                      _pointers.remove(event.pointer);
                    }
                  : null,
              onPointerCancel: drag
                  ? (PointerCancelEvent event) {
                      if (!_pointers.remove(event.pointer) ||
                          _pointers.isNotEmpty ||
                          !_dragged) {
                        return;
                      }
                      // Flutter reports cancellation as an end after a drag
                      // wins. Preserve cancellation for controlled controls.
                      _dragCanceled = true;
                      _change(() {
                        _dragged = false;
                      });
                      widget.onHorizontalDragCancel?.call();
                    }
                  : null,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTap: tap && widget.onTap != null ? _tap : null,
                onTapDown: tap
                    ? (TapDownDetails details) {
                        _pressStarted();
                        widget.onTapDown?.call(details);
                      }
                    : null,
                onTapUp: tap
                    ? (TapUpDetails details) {
                        _change(() {
                          _pressed = false;
                        });
                        widget.onTapUp?.call(details);
                      }
                    : null,
                onTapCancel: tap
                    ? () {
                        if (!mounted || !_acceptsTap) return;
                        _change(() {
                          _pressed = false;
                        });
                        widget.onTapCancel?.call();
                      }
                    : null,
                onLongPress: widget.enabled && widget.onLongPress != null
                    ? _longPress
                    : null,
                onLongPressStart: widget.enabled && widget.onLongPress != null
                    ? (LongPressStartDetails details) => _pressStarted()
                    : null,
                onLongPressEnd: widget.enabled && widget.onLongPress != null
                    ? (LongPressEndDetails details) {
                        _change(() {
                          _pressed = false;
                        });
                      }
                    : null,
                onLongPressCancel: widget.enabled && widget.onLongPress != null
                    ? () {
                        if (!mounted ||
                            !widget.enabled ||
                            widget.onLongPress == null) {
                          return;
                        }
                        _change(() {
                          _pressed = false;
                        });
                      }
                    : null,
                onHorizontalDragStart: drag
                    ? (DragStartDetails details) {
                        _dragCanceled = false;
                        _change(() {
                          _dragged = true;
                        });
                        widget.onHorizontalDragStart?.call(details);
                      }
                    : null,
                onHorizontalDragUpdate: drag
                    ? widget.onHorizontalDragUpdate
                    : null,
                onHorizontalDragEnd: drag
                    ? (DragEndDetails details) {
                        if (_dragCanceled) {
                          _dragCanceled = false;
                          return;
                        }
                        _change(() {
                          _dragged = false;
                        });
                        widget.onHorizontalDragEnd?.call(details);
                      }
                    : null,
                onHorizontalDragCancel: drag
                    ? () {
                        if (!mounted || !_acceptsDrag) return;
                        _change(() {
                          _dragged = false;
                        });
                        widget.onHorizontalDragCancel?.call();
                      }
                    : null,
                child: _InteractionScope(
                  owner: this,
                  frozen: _frozen,
                  hoverMasked: _hoverMasked,
                  child: Builder(
                    builder: (BuildContext context) =>
                        widget.builder(context, state),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Starts a new nesting context for [InteractionDetector]s below it.
///
/// Detectors below a boundary do not mask detectors above it. Overlay content
/// inherits from the widget that shows it, so overlays place a boundary that
/// does not [inherit] at their root.
///
/// A [frozen] boundary keeps the hover and press appearance that detectors
/// below it had when it froze, for content that is leaving. A [hoverMasked]
/// boundary hides hover below it, for a menu navigated by keyboard under a
/// resting pointer. Both combine with an enclosing boundary when [inherit] is
/// true.
class InteractionBoundary extends StatelessWidget {
  /// Creates a nesting boundary.
  const InteractionBoundary({
    super.key,
    this.frozen = false,
    this.hoverMasked = false,
    this.inherit = true,
    required this.child,
  });

  /// Whether detectors below keep their current hover and press appearance.
  final bool frozen;

  /// Whether detectors below show no hover.
  final bool hoverMasked;

  /// Whether an enclosing boundary's [frozen] and [hoverMasked] still apply.
  final bool inherit;

  /// The subtree in the new context.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _InteractionScope? outer = inherit
        ? context.dependOnInheritedWidgetOfExactType<_InteractionScope>()
        : null;
    return _InteractionScope(
      owner: null,
      frozen: frozen || (outer?.frozen ?? false),
      hoverMasked: hoverMasked || (outer?.hoverMasked ?? false),
      child: child,
    );
  }
}

class _InteractionScope extends InheritedWidget {
  const _InteractionScope({
    required this.owner,
    required this.frozen,
    required this.hoverMasked,
    required super.child,
  });

  final _InteractionDetectorState? owner;
  final bool frozen;
  final bool hoverMasked;

  @override
  bool updateShouldNotify(_InteractionScope oldWidget) =>
      owner != oldWidget.owner ||
      frozen != oldWidget.frozen ||
      hoverMasked != oldWidget.hoverMasked;
}
