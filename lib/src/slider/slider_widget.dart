import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../styles/slider_style.dart';
import '../theme/slider_theme.dart';

/// A controlled value selector whose appearance comes entirely from its style.
class Slider extends StatefulWidget {
  /// Creates a slider for a value between [min] and [max].
  const Slider({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHover,
    this.allowedInteraction,
    this.style,
    this.trackDecoration,
    this.activeTrackDecoration,
    this.secondaryActiveTrackDecoration,
    this.thumbDecoration,
    this.tickMarkDecoration,
    this.activeTickMarkDecoration,
  }) : assert(min <= max),
       assert(value >= min && value <= max),
       assert(
         secondaryTrackValue == null ||
             (secondaryTrackValue >= min && secondaryTrackValue <= max),
       ),
       assert(divisions == null || divisions > 0),
       assert(
         tickMarkDecoration == null || divisions != null,
         'tickMarkDecoration requires divisions.',
       ),
       assert(
         activeTickMarkDecoration == null || divisions != null,
         'activeTickMarkDecoration requires divisions.',
       ),
       assert(
         secondaryActiveTrackDecoration == null || secondaryTrackValue != null,
         'secondaryActiveTrackDecoration requires secondaryTrackValue.',
       );

  /// The current value supplied by the parent.
  final double value;

  /// An optional secondary value represented by another track segment.
  final double? secondaryTrackValue;

  /// Requests a new value, or disables interaction when null.
  final ValueChanged<double>? onChanged;

  /// Reports the current value when an interaction begins.
  final ValueChanged<double>? onChangeStart;

  /// Reports the last computed value when an interaction ends.
  final ValueChanged<double>? onChangeEnd;

  /// The lower bound of the value range.
  final double min;

  /// The upper bound of the value range.
  final double max;

  /// The number of discrete intervals, or null for continuous values.
  final int? divisions;

  /// The accessible label and optional value indicator label.
  final String? label;

  /// Formats actual values for accessibility services.
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// An externally owned focus node.
  final FocusNode? focusNode;

  /// Whether to request initial focus.
  final bool autofocus;

  /// Reports raw focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Reports enabled hover changes.
  final ValueChanged<bool>? onHover;

  /// Overrides the permitted pointer interactions from the style.
  final SliderInteraction? allowedInteraction;

  /// Inline tokens that take precedence over the component theme.
  final SliderStyle? style;

  /// Replaces the inactive track decoration in every interaction state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.trackDecoration`.
  final BoxDecoration? trackDecoration;

  /// Replaces the active track decoration in every interaction state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.activeTrackDecoration`.
  final BoxDecoration? activeTrackDecoration;

  /// Replaces the secondary track decoration in every interaction state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.secondaryActiveTrackDecoration`.
  /// Requires [secondaryTrackValue] to be non-null.
  final BoxDecoration? secondaryActiveTrackDecoration;

  /// Replaces the thumb decoration in every interaction state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.thumbDecoration`.
  final BoxDecoration? thumbDecoration;

  /// Replaces the inactive tick marks decoration in every interaction state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.tickMarkDecoration`.
  /// Requires [divisions] to be non-null.
  final BoxDecoration? tickMarkDecoration;

  /// Replaces the active tick marks decoration in every interaction state.
  ///
  /// Overrides inherited themes. Cannot be combined with `style.activeTickMarkDecoration`.
  /// Requires [divisions] to be non-null.
  final BoxDecoration? activeTickMarkDecoration;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  bool _active = false;
  bool _dragging = false;
  double? _lastEmitted;
  double? _lastComputed;
  double? _pointerDownX;
  double _grabOffset = 0;
  double _trackLeft = 0;
  double _trackWidth = 0;
  double _thumbX = 0;
  double _thumbHitRadius = 24;
  bool _rtl = false;
  double _keyboardStep = 0.05;
  int _interactionGeneration = 0;
  SliderInteraction? _interaction;

  bool get _interactive => widget.onChanged != null && widget.max > widget.min;

  double _normalized(double value) => widget.max == widget.min
      ? 0
      : ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  double _valueForFraction(double fraction) {
    final int? divisions = widget.divisions;
    final double snapped = divisions == null
        ? fraction.clamp(0.0, 1.0)
        : (fraction.clamp(0.0, 1.0) * divisions).round() / divisions;
    return widget.min + snapped * (widget.max - widget.min);
  }

  double _valueForX(double x) {
    final double fraction = _trackWidth > 0
        ? ((x - _grabOffset - _trackLeft) / _trackWidth).clamp(0.0, 1.0)
        : 0;
    return _valueForFraction(_rtl ? 1 - fraction : fraction);
  }

  void _begin(double x, {required bool jump}) {
    if (!_interactive || _active) {
      return;
    }
    _interactionGeneration += 1;
    _active = true;
    _lastComputed = widget.value;
    _lastEmitted = null;
    _grabOffset = jump ? 0 : x - _thumbX;
    widget.onChangeStart?.call(widget.value);
    if (jump) {
      _emit(_valueForX(x));
    }
  }

  void _emit(double value) {
    _lastComputed = value;
    if (_interactive && value != _lastEmitted && value != widget.value) {
      _lastEmitted = value;
      widget.onChanged!(value);
    }
  }

  void _end({bool deferNotification = false}) {
    if (!_active) {
      return;
    }
    final double value = _lastComputed ?? widget.value;
    _active = false;
    _dragging = false;
    _grabOffset = 0;
    _interactionGeneration += 1;
    final ValueChanged<double>? onChangeEnd = widget.onChangeEnd;
    if (deferNotification) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted) {
          onChangeEnd?.call(value);
        }
      });
    } else {
      onChangeEnd?.call(value);
    }
  }

  void _cancelTap() {
    final int generation = _interactionGeneration;
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted &&
          generation == _interactionGeneration &&
          _active &&
          !_dragging) {
        _end();
      }
    });
  }

  void _dragStart(DragStartDetails details, SliderInteraction interaction) {
    final double startX = _pointerDownX ?? details.localPosition.dx;
    if (interaction == SliderInteraction.slideThumb &&
        (startX - _thumbX).abs() > _thumbHitRadius) {
      return;
    }
    _dragging = true;
    if (!_active) {
      _begin(startX, jump: interaction == SliderInteraction.tapAndSlide);
      if (_active && interaction != SliderInteraction.tapAndSlide) {
        _emit(_valueForX(details.localPosition.dx));
      }
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (_active && _dragging) {
      _emit(_valueForX(details.localPosition.dx));
    }
  }

  double _adjustedValue(bool increase) {
    final double step = widget.divisions == null
        ? _keyboardStep
        : 1 / widget.divisions!;
    return _valueForFraction(
      _normalized(widget.value) + (increase ? step : -step),
    );
  }

  void _adjust(bool increase) {
    if (!_interactive) {
      return;
    }
    final double value = _adjustedValue(increase);
    widget.onChangeStart?.call(widget.value);
    if (value != widget.value) {
      widget.onChanged!(value);
    }
    widget.onChangeEnd?.call(value);
  }

  Object? _direction(TraversalDirection direction) {
    final NavigationMode navigation =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    if (!_interactive ||
        (navigation == NavigationMode.directional &&
            (direction == TraversalDirection.up ||
                direction == TraversalDirection.down))) {
      FocusManager.instance.primaryFocus?.focusInDirection(direction);
      return null;
    }
    switch (direction) {
      case TraversalDirection.left:
        _adjust(_rtl);
      case TraversalDirection.right:
        _adjust(!_rtl);
      case TraversalDirection.up:
        _adjust(true);
      case TraversalDirection.down:
        _adjust(false);
    }
    return null;
  }

  String _format(double value) =>
      widget.semanticFormatterCallback?.call(value) ??
      '${(_normalized(value) * 100).round()}%';

  @override
  void didUpdateWidget(Slider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_active && !_interactive) {
      _end(deferNotification: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'Slider',
        parameter: 'trackDecoration',
        styleToken: 'style.trackDecoration',
        value: widget.trackDecoration,
        styleValue: widget.style?.trackDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Slider',
        parameter: 'activeTrackDecoration',
        styleToken: 'style.activeTrackDecoration',
        value: widget.activeTrackDecoration,
        styleValue: widget.style?.activeTrackDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Slider',
        parameter: 'secondaryActiveTrackDecoration',
        styleToken: 'style.secondaryActiveTrackDecoration',
        value: widget.secondaryActiveTrackDecoration,
        styleValue: widget.style?.secondaryActiveTrackDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Slider',
        parameter: 'thumbDecoration',
        styleToken: 'style.thumbDecoration',
        value: widget.thumbDecoration,
        styleValue: widget.style?.thumbDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Slider',
        parameter: 'tickMarkDecoration',
        styleToken: 'style.tickMarkDecoration',
        value: widget.tickMarkDecoration,
        styleValue: widget.style?.tickMarkDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'Slider',
        parameter: 'activeTickMarkDecoration',
        styleToken: 'style.activeTickMarkDecoration',
        value: widget.activeTickMarkDecoration,
        styleValue: widget.style?.activeTickMarkDecoration,
      ),
    );
    final List<SliderStyle?> layers = <SliderStyle?>[
      SliderStyle(
        trackDecoration: decorationLayer(widget.trackDecoration),
        activeTrackDecoration: decorationLayer(widget.activeTrackDecoration),
        secondaryActiveTrackDecoration: decorationLayer(
          widget.secondaryActiveTrackDecoration,
        ),
        thumbDecoration: decorationLayer(widget.thumbDecoration),
        tickMarkDecoration: decorationLayer(widget.tickMarkDecoration),
        activeTickMarkDecoration: decorationLayer(
          widget.activeTickMarkDecoration,
        ),
      ),
      widget.style,
      SliderTheme.of(context),
    ];
    final SliderInteraction interaction =
        widget.allowedInteraction ??
        resolvePlain<SliderStyle, SliderInteraction>(
          layers,
          (SliderStyle style) => style.allowedInteraction,
        ) ??
        SliderInteraction.tapAndSlide;
    if (_active && _interaction != null && _interaction != interaction) {
      _end(deferNotification: true);
    }
    _interaction = interaction;
    final bool tap =
        interaction == SliderInteraction.tapAndSlide ||
        interaction == SliderInteraction.tapOnly;
    final bool drag = interaction != SliderInteraction.tapOnly;
    _keyboardStep =
        resolvePlain<SliderStyle, double>(
          layers,
          (SliderStyle style) => style.keyboardStep,
        ) ??
        0.05;
    _rtl = Directionality.of(context) == TextDirection.rtl;
    return Semantics(
      container: true,
      slider: true,
      enabled: _interactive,
      label: widget.label,
      value: _format(widget.value),
      increasedValue: _interactive ? _format(_adjustedValue(true)) : null,
      decreasedValue: _interactive ? _format(_adjustedValue(false)) : null,
      onIncrease: _interactive ? () => _adjust(true) : null,
      onDecrease: _interactive ? () => _adjust(false) : null,
      textDirection: Directionality.of(context),
      child: InteractionDetector(
        enabled: _interactive,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: widget.onFocusChange,
        onHover: widget.onHover,
        excludeFromSemantics: true,
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) => resolveStateful<SliderStyle, MouseCursor>(
            state,
            layers,
            (SliderStyle style) => style.mouseCursor,
          ),
        ),
        onTapDown: tap
            ? (TapDownDetails details) =>
                  _begin(details.localPosition.dx, jump: true)
            : null,
        onTapUp: tap ? (TapUpDetails details) => _end() : null,
        onTapCancel: tap
            ? interaction == SliderInteraction.tapAndSlide
                  ? _cancelTap
                  : _end
            : null,
        onHorizontalDragStart: drag
            ? (DragStartDetails details) => _dragStart(details, interaction)
            : null,
        onHorizontalDragUpdate: drag ? _dragUpdate : null,
        onHorizontalDragEnd: drag ? (DragEndDetails details) => _end() : null,
        onHorizontalDragCancel: drag ? _end : null,
        actions: <Type, Action<Intent>>{
          DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
            onInvoke: (DirectionalFocusIntent intent) =>
                _direction(intent.direction),
          ),
          ScrollIntent: CallbackAction<ScrollIntent>(
            onInvoke: (ScrollIntent intent) =>
                _direction(switch (intent.direction) {
                  AxisDirection.left => TraversalDirection.left,
                  AxisDirection.right => TraversalDirection.right,
                  AxisDirection.up => TraversalDirection.up,
                  AxisDirection.down => TraversalDirection.down,
                }),
          ),
        },
        builder: (BuildContext context, InteractionState state) {
          return Listener(
            onPointerDown: (PointerDownEvent event) {
              _pointerDownX = event.localPosition.dx;
            },
            child: _visual(context, state, layers),
          );
        },
      ),
    );
  }

  Widget _visual(
    BuildContext context,
    InteractionState state,
    List<SliderStyle?> layers,
  ) {
    final Size thumb =
        resolveStateful<SliderStyle, Size>(
          state,
          layers,
          (SliderStyle style) => style.thumbSize,
        ) ??
        Size.zero;
    final Size tick =
        resolveStateful<SliderStyle, Size>(
          state,
          layers,
          (SliderStyle style) => style.tickMarkSize,
        ) ??
        Size.zero;
    final double trackHeight =
        resolveStateful<SliderStyle, double>(
          state,
          layers,
          (SliderStyle style) => style.trackHeight,
        ) ??
        0;
    final Size target =
        resolvePlain<SliderStyle, Size>(
          layers,
          (SliderStyle style) => style.tapTargetSize,
        ) ??
        const Size(48, 48);
    final EdgeInsets padding =
        (resolvePlain<SliderStyle, EdgeInsetsGeometry>(
                  layers,
                  (SliderStyle style) => style.padding,
                ) ??
                EdgeInsets.zero)
            .resolve(Directionality.of(context));
    final Duration duration =
        resolvePlain<SliderStyle, Duration>(
          layers,
          (SliderStyle style) => style.animationDuration,
        ) ??
        const Duration(milliseconds: 200);
    final Curve curve =
        resolvePlain<SliderStyle, Curve>(
          layers,
          (SliderStyle style) => style.animationCurve,
        ) ??
        Curves.easeInOut;
    final double preferredWidth =
        resolvePlain<SliderStyle, double>(
          layers,
          (SliderStyle style) => style.preferredWidth,
        ) ??
        144;
    final SliderValueIndicatorBuilder? indicator =
        resolvePlain<SliderStyle, SliderValueIndicatorBuilder>(
          layers,
          (SliderStyle style) => style.valueIndicatorBuilder,
        );
    final Decoration? trackDecoration =
        resolveStateful<SliderStyle, Decoration>(
          state,
          layers,
          (SliderStyle style) => style.trackDecoration,
        );
    final Decoration? activeDecoration =
        resolveStateful<SliderStyle, Decoration>(
          state,
          layers,
          (SliderStyle style) => style.activeTrackDecoration,
        );
    final Decoration? secondaryDecoration =
        resolveStateful<SliderStyle, Decoration>(
          state,
          layers,
          (SliderStyle style) => style.secondaryActiveTrackDecoration,
        );
    final Decoration? thumbDecoration =
        resolveStateful<SliderStyle, Decoration>(
          state,
          layers,
          (SliderStyle style) => style.thumbDecoration,
        );
    final Decoration? tickDecoration = resolveStateful<SliderStyle, Decoration>(
      state,
      layers,
      (SliderStyle style) => style.tickMarkDecoration,
    );
    final Decoration? activeTickDecoration =
        resolveStateful<SliderStyle, Decoration>(
          state,
          layers,
          (SliderStyle style) => style.activeTickMarkDecoration,
        );
    _thumbHitRadius = math.max(thumb.width, target.width) / 2;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : constraints.constrainWidth(preferredWidth);
        final double height = constraints.constrainHeight(
          math.max(
            math.max(target.height, thumb.height),
            math.max(trackHeight, tick.height),
          ),
        );
        _trackLeft = padding.left + thumb.width / 2;
        final double trackRight = width - padding.right - thumb.width / 2;
        _trackWidth = math.max(0, trackRight - _trackLeft);
        final double fraction = _normalized(widget.value);
        final double visual = _rtl ? 1 - fraction : fraction;
        _thumbX = _trackLeft + visual * _trackWidth;
        final double activeLeft = _rtl ? _thumbX : _trackLeft;
        final double activeWidth = _trackWidth * fraction;
        final double? secondary = widget.secondaryTrackValue;
        final double secondaryFraction = secondary == null
            ? 0
            : _normalized(secondary);
        final double secondaryWidth = _trackWidth * secondaryFraction;
        final double secondaryLeft = _rtl
            ? _trackLeft + _trackWidth - secondaryWidth
            : _trackLeft;
        Widget track(double left, double width, Decoration? decoration) {
          return Positioned(
            left: left,
            top: (height - trackHeight) / 2,
            width: width,
            height: trackHeight,
            child: AnimatedSurface(
              duration: duration,
              curve: curve,
              decoration: decoration,
            ),
          );
        }

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              track(_trackLeft, _trackWidth, trackDecoration),
              if (secondary != null)
                track(secondaryLeft, secondaryWidth, secondaryDecoration),
              track(activeLeft, activeWidth, activeDecoration),
              if (widget.divisions != null)
                for (int i = 0; i <= widget.divisions!; i += 1)
                  Positioned(
                    left:
                        _trackLeft +
                        (_rtl
                                ? 1 - i / widget.divisions!
                                : i / widget.divisions!) *
                            _trackWidth,
                    top: height / 2,
                    child: FractionalTranslation(
                      translation: const Offset(-0.5, -0.5),
                      child: AnimatedSurface(
                        width: tick.width,
                        height: tick.height,
                        duration: duration,
                        curve: curve,
                        decoration: i / widget.divisions! <= fraction
                            ? activeTickDecoration
                            : tickDecoration,
                      ),
                    ),
                  ),
              Positioned(
                left: _thumbX,
                top: height / 2,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -0.5),
                  child: AnimatedSurface(
                    width: thumb.width,
                    height: thumb.height,
                    duration: duration,
                    curve: curve,
                    decoration: thumbDecoration,
                  ),
                ),
              ),
              if (indicator != null)
                Positioned(
                  left: _thumbX,
                  top: height / 2 - thumb.height / 2,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -1),
                    child: indicator(
                      context,
                      state,
                      widget.value,
                      widget.label,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
