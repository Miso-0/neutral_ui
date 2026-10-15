import 'package:flutter/widgets.dart';

import 'interaction_state.dart';
import 'state_property.dart';

/// Builds a control from its current interaction state.
typedef InteractionWidgetBuilder = Widget Function(
  BuildContext context,
  InteractionState state,
);

/// Supplies pointer, keyboard, focus and controller state to a headless control.
class InteractionDetector extends StatefulWidget {
  /// Creates an interaction surface without painting any visual treatment.
  const InteractionDetector({
    super.key,
    required this.builder,
    this.enabled = true,
    this.isSelected,
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

  /// Reports changes to enabled hover state.
  final ValueChanged<bool>? onHover;

  /// Reports raw focus, independently of whether focus is visible.
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
  NavigationMode _navigationMode = NavigationMode.traditional;

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

  InteractionState get _state => InteractionState(
    isPressed: widget.enabled && _pressed,
    isDragged: widget.enabled && _dragged,
    isHovered: widget.enabled && _hovering,
    isFocused:
        _hasFocus &&
        (_navigationMode == NavigationMode.directional ||
            (widget.enabled &&
                FocusManager.instance.highlightMode ==
                    FocusHighlightMode.traditional)),
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
    FocusManager.instance.addHighlightModeListener(_highlightChanged);
    widget.statesController?.addListener(_controllerChanged);
    _syncController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationMode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
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
    if (!_acceptsTap) {
      _stopKeyboardPress();
      _pressed = false;
    }
    if (!_acceptsDrag) {
      _dragged = false;
      _dragCanceled = false;
      _pointers.clear();
    }
    _syncController();
    if (previousHover != _state.isHovered) {
      final bool hovered = _state.isHovered;
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted && _state.isHovered == hovered) {
          widget.onHover?.call(hovered);
        }
      });
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

  void _highlightChanged(FocusHighlightMode mode) {
    if (mounted) _change(() {});
  }

  void _change(VoidCallback change) {
    if (!mounted) return;
    final bool wasHovered = _state.isHovered;
    setState(change);
    _syncController();
    if (wasHovered != _state.isHovered) widget.onHover?.call(_state.isHovered);
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
    FocusManager.instance.removeHighlightModeListener(_highlightChanged);
    _stopKeyboardPress();
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
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        canRequestFocus:
            widget.canRequestFocus &&
            (widget.enabled || _navigationMode == NavigationMode.directional),
        onFocusChange: (bool focused) {
          _change(() {
            _hasFocus = focused;
          });
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
                        _stopKeyboardPress();
                        _change(() {
                          _pressed = true;
                        });
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
                    ? (LongPressStartDetails details) {
                        _change(() {
                          _pressed = true;
                        });
                      }
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
                child: Builder(
                  builder: (BuildContext context) =>
                      widget.builder(context, state),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
