import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../styles/slider_style.dart';
import '../theme/slider_theme.dart';

/// The ordered lower and upper values of a range slider.
@immutable
class RangeValues {
  /// Creates range values.
  const RangeValues(this.start, this.end) : assert(start <= end);

  /// The start for this component.
  final double start;

  /// The end for this component.
  final double end;
  @override
  bool operator ==(Object other) =>
      other is RangeValues && start == other.start && end == other.end;
  @override
  int get hashCode => Object.hash(start, end);
  @override
  String toString() => 'RangeValues($start, $end)';
}

/// Optional labels for the start and end thumbs.
@immutable
class RangeLabels {
  /// Creates range labels.
  const RangeLabels(this.start, this.end);

  /// The start for this component.
  final String start;

  /// The end for this component.
  final String end;
  @override
  bool operator ==(Object other) =>
      other is RangeLabels && start == other.start && end == other.end;
  @override
  int get hashCode => Object.hash(start, end);
  @override
  String toString() => 'RangeLabels($start, $end)';
}

/// Determines how a dragged thumb behaves on reaching the other thumb.
enum RangeSliderThumbPolicy {
  /// Stop the dragged thumb at the other thumb.
  stop,

  /// Move the other thumb along when the dragged thumb reaches it.
  push,
}

/// A two-thumb slider sharing the [SliderStyle] resolution and gestures.
class RangeSlider extends StatefulWidget {
  /// Creates range slider.
  RangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.labels,
    this.semanticFormatterCallback,
    this.startFocusNode,
    this.endFocusNode,
    this.autofocus = false,
    this.style,
    this.allowedInteraction,
    this.thumbPolicy = RangeSliderThumbPolicy.stop,
    this.trackDecoration,
    this.activeTrackDecoration,
    this.thumbDecoration,
    this.tickMarkDecoration,
    this.activeTickMarkDecoration,
  }) : assert(min <= max),
       assert(values.start >= min && values.end <= max),
       assert(divisions == null || divisions > 0);

  /// The values for this component.
  final RangeValues values;

  /// The on changed for this component.
  final ValueChanged<RangeValues>? onChanged;

  /// The on change start for this component.
  final ValueChanged<RangeValues>? onChangeStart;

  /// The on change end for this component.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// The min for this component.
  final double min;

  /// The max for this component.
  final double max;

  /// The divisions for this component.
  final int? divisions;

  /// The labels for this component.
  final RangeLabels? labels;

  /// The semantic formatter callback for this component.
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// The start focus node for this component.
  final FocusNode? startFocusNode;

  /// The end focus node for this component.
  final FocusNode? endFocusNode;

  /// The autofocus for this component.
  final bool autofocus;

  /// The style for this component.
  final SliderStyle? style;

  /// The allowed interaction for this component.
  final SliderInteraction? allowedInteraction;

  /// The thumb policy for this component.
  final RangeSliderThumbPolicy thumbPolicy;

  /// The track decoration for this component.
  final BoxDecoration? trackDecoration;

  /// The active track decoration for this component.
  final BoxDecoration? activeTrackDecoration;

  /// The thumb decoration for this component.
  final BoxDecoration? thumbDecoration;

  /// The tick mark decoration for this component.
  final BoxDecoration? tickMarkDecoration;

  /// The active tick mark decoration for this component.
  final BoxDecoration? activeTickMarkDecoration;
  @override
  State<RangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<RangeSlider>
    with TickerProviderStateMixin {
  late final List<AnimationController> _positions;
  final FocusNode _start = FocusNode();
  final FocusNode _end = FocusNode();
  int? _active;
  bool _dragging = false;
  double? _pointerX;
  double _grab = 0;
  double _left = 0;
  double _width = 0;
  double _startX = 0;
  double _endX = 0;
  double _targetWidth = 48;
  bool _rtl = false;
  RangeValues? _computed;
  double _keyboardStep = 0.05;
  @override
  void initState() {
    super.initState();
    _positions = <AnimationController>[
      AnimationController.unbounded(
        value: _fraction(widget.values.start),
        vsync: this,
      ),
      AnimationController.unbounded(
        value: _fraction(widget.values.end),
        vsync: this,
      ),
    ];
    for (final AnimationController controller in _positions) {
      controller.addListener(_positionChanged);
    }
  }

  void _positionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_active == null) {
      for (int i = 0; i < 2; i++) {
        if (!_positions[i].isAnimating) {
          _positions[i].value = _fraction(
            i == 0 ? widget.values.start : widget.values.end,
          );
        }
      }
    }
  }

  bool get _enabled => widget.onChanged != null && widget.min < widget.max;
  FocusNode _focus(int thumb) => thumb == 0
      ? widget.startFocusNode ?? _start
      : widget.endFocusNode ?? _end;
  double _fraction(double value) => widget.max == widget.min
      ? 0
      : ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  double _snap(double fraction) {
    double value = fraction.clamp(0.0, 1.0);
    if (widget.divisions != null) {
      value = (value * widget.divisions!).round() / widget.divisions!;
    }
    return widget.min + value * (widget.max - widget.min);
  }

  RangeValues _updated(int thumb, double value, RangeValues current) {
    if (thumb == 0) {
      return RangeValues(
        widget.thumbPolicy == RangeSliderThumbPolicy.push
            ? value
            : math.min(value, current.end),
        widget.thumbPolicy == RangeSliderThumbPolicy.push
            ? math.max(value, current.end)
            : current.end,
      );
    }
    return RangeValues(
      widget.thumbPolicy == RangeSliderThumbPolicy.push
          ? math.min(value, current.start)
          : current.start,
      widget.thumbPolicy == RangeSliderThumbPolicy.push
          ? value
          : math.max(value, current.start),
    );
  }

  void _emit(double x) {
    if (!_enabled || _active == null) return;
    final double visual = _width == 0
        ? 0
        : ((x - _grab - _left) / _width).clamp(0.0, 1.0);
    final double raw = _rtl ? 1 - visual : visual;
    if (_active == 0) {
      _positions[0].value = widget.thumbPolicy == RangeSliderThumbPolicy.stop
          ? math.min(raw, _positions[1].value)
          : raw;
      if (widget.thumbPolicy == RangeSliderThumbPolicy.push &&
          raw > _positions[1].value) {
        _positions[1].value = raw;
      }
    } else {
      _positions[1].value = widget.thumbPolicy == RangeSliderThumbPolicy.stop
          ? math.max(raw, _positions[0].value)
          : raw;
      if (widget.thumbPolicy == RangeSliderThumbPolicy.push &&
          raw < _positions[0].value) {
        _positions[0].value = raw;
      }
    }
    final RangeValues next = _updated(
      _active!,
      _snap(_rtl ? 1 - visual : visual),
      _computed ?? widget.values,
    );
    if (next != _computed && next != widget.values) widget.onChanged!(next);
    _computed = next;
  }

  void _begin(double x, SliderInteraction interaction) {
    if (!_enabled || _active != null) return;
    final int thumb = (x - _startX).abs() < (x - _endX).abs() ? 0 : 1;
    final double center = thumb == 0 ? _startX : _endX;
    if (interaction == SliderInteraction.slideThumb &&
        (x - center).abs() > _targetWidth / 2) {
      return;
    }
    _active = thumb;
    for (final AnimationController controller in _positions) {
      controller.stop();
    }
    _computed = widget.values;
    _focus(thumb).requestFocus();
    _grab =
        (x - center).abs() <= _targetWidth / 2 ||
            interaction == SliderInteraction.slideOnly
        ? x - center
        : 0;
    widget.onChangeStart?.call(widget.values);
    if (interaction == SliderInteraction.tapAndSlide ||
        interaction == SliderInteraction.tapOnly) {
      _emit(x);
    }
    setState(() {});
  }

  void _finish({double velocity = 0}) {
    if (_active == null) return;
    final RangeValues values = _computed ?? widget.values;
    final int active = _active!;
    final double normalizedVelocity = _width == 0
        ? 0
        : velocity / _width * (_rtl ? -1 : 1);
    for (int i = 0; i < 2; i++) {
      animateWithSpring(
        context,
        _positions[i],
        _fraction(i == 0 ? widget.values.start : widget.values.end),
        velocity: i == active ? normalizedVelocity : 0,
        spring: MotionSpring.quick,
      );
    }
    setState(() {
      _active = null;
      _dragging = false;
      _computed = null;
    });
    widget.onChangeEnd?.call(values);
  }

  double _adjusted(int thumb, bool increase) {
    final double current = thumb == 0 ? widget.values.start : widget.values.end;
    return _snap(
      _fraction(current) +
          (increase ? 1 : -1) *
              (widget.divisions == null
                  ? _keyboardStep
                  : 1 / widget.divisions!),
    );
  }

  void _adjust(int thumb, bool increase) {
    if (!_enabled) return;
    final RangeValues next = _updated(
      thumb,
      _adjusted(thumb, increase),
      widget.values,
    );
    widget.onChangeStart?.call(widget.values);
    if (next != widget.values) widget.onChanged!(next);
    widget.onChangeEnd?.call(next);
  }

  Object? _direction(int thumb, TraversalDirection direction) {
    _adjust(thumb, switch (direction) {
      TraversalDirection.left => _rtl,
      TraversalDirection.right => !_rtl,
      TraversalDirection.up => true,
      TraversalDirection.down => false,
    });
    return null;
  }

  @override
  void dispose() {
    for (final AnimationController controller in _positions) {
      controller.removeListener(_positionChanged);
      controller.dispose();
    }
    _start.dispose();
    _end.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'RangeSlider',
        parameter: 'trackDecoration',
        styleToken: 'style.trackDecoration',
        value: widget.trackDecoration,
        styleValue: widget.style?.trackDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'RangeSlider',
        parameter: 'activeTrackDecoration',
        styleToken: 'style.activeTrackDecoration',
        value: widget.activeTrackDecoration,
        styleValue: widget.style?.activeTrackDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'RangeSlider',
        parameter: 'thumbDecoration',
        styleToken: 'style.thumbDecoration',
        value: widget.thumbDecoration,
        styleValue: widget.style?.thumbDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'RangeSlider',
        parameter: 'tickMarkDecoration',
        styleToken: 'style.tickMarkDecoration',
        value: widget.tickMarkDecoration,
        styleValue: widget.style?.tickMarkDecoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'RangeSlider',
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
        thumbDecoration: decorationLayer(widget.thumbDecoration),
        tickMarkDecoration: decorationLayer(widget.tickMarkDecoration),
        activeTickMarkDecoration: decorationLayer(
          widget.activeTickMarkDecoration,
        ),
      ),
      widget.style,
      SliderTheme.of(context),
    ];
    final SliderStyle effective =
        widget.style?.merge(SliderTheme.of(context)) ?? SliderTheme.of(context);
    _keyboardStep = effective.keyboardStep ?? 0.05;
    _rtl = Directionality.of(context) == TextDirection.rtl;
    final SliderInteraction interaction =
        widget.allowedInteraction ??
        effective.allowedInteraction ??
        SliderInteraction.tapAndSlide;
    final bool tap =
        interaction == SliderInteraction.tapAndSlide ||
        interaction == SliderInteraction.tapOnly;
    final bool drag = interaction != SliderInteraction.tapOnly;
    return InteractionDetector(
      enabled: _enabled,
      mouseCursor: StateProperty<MouseCursor?>.resolveWith(
        (InteractionState state) => resolveStateful<SliderStyle, MouseCursor>(
          state,
          layers,
          (SliderStyle style) => style.mouseCursor,
        ),
      ),
      canRequestFocus: false,
      excludeFromSemantics: true,
      onTapDown: tap
          ? (TapDownDetails details) =>
                _begin(details.localPosition.dx, interaction)
          : null,
      onTapUp: tap ? (_) => _finish() : null,
      onTapCancel: tap
          ? () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_dragging) _finish();
              });
            }
          : null,
      onHorizontalDragStart: drag
          ? (DragStartDetails details) {
              _dragging = true;
              _begin(_pointerX ?? details.localPosition.dx, interaction);
              _emit(details.localPosition.dx);
            }
          : null,
      onHorizontalDragUpdate: drag
          ? (DragUpdateDetails details) => _emit(details.localPosition.dx)
          : null,
      onHorizontalDragEnd: drag
          ? (DragEndDetails details) =>
                _finish(velocity: details.primaryVelocity ?? 0)
          : null,
      onHorizontalDragCancel: drag ? () => _finish() : null,
      builder: (BuildContext context, InteractionState state) {
        final Size thumb =
            resolveStateful<SliderStyle, Size>(
              state,
              layers,
              (SliderStyle s) => s.thumbSize,
            ) ??
            Size.zero;
        final Size target = effective.tapTargetSize ?? const Size(48, 48);
        final double trackHeight =
            resolveStateful<SliderStyle, double>(
              state,
              layers,
              (SliderStyle s) => s.trackHeight,
            ) ??
            0;
        final Size tick =
            resolveStateful<SliderStyle, Size>(
              state,
              layers,
              (SliderStyle s) => s.tickMarkSize,
            ) ??
            Size.zero;
        final EdgeInsets padding = (effective.padding ?? EdgeInsets.zero)
            .resolve(Directionality.of(context));
        final Duration duration = reducedMotionDuration(
          context,
          effective.animationDuration ?? const Duration(milliseconds: 200),
        );
        final Curve curve = effective.animationCurve ?? Curves.easeInOut;
        _targetWidth = math.max(thumb.width, target.width);
        return Listener(
          onPointerDown: (PointerDownEvent event) =>
              _pointerX = event.localPosition.dx,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : constraints.constrainWidth(effective.preferredWidth ?? 144);
              final double height = constraints.constrainHeight(
                math.max(target.height, math.max(thumb.height, trackHeight)),
              );
              _left = padding.left + thumb.width / 2;
              _width = math.max(0, width - padding.horizontal - thumb.width);
              final double end = _positions[1].value.clamp(0.0, 1.0),
                  start = _positions[0].value.clamp(0.0, end);
              double x(double fraction) =>
                  _left + (_rtl ? 1 - fraction : fraction) * _width;
              _startX = x(start);
              _endX = x(end);
              Widget track(double left, double width, Decoration? decoration) =>
                  Positioned(
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
              return SizedBox(
                width: width,
                height: height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    track(
                      _left,
                      _width,
                      resolveStateful<SliderStyle, Decoration>(
                        state,
                        layers,
                        (SliderStyle s) => s.trackDecoration,
                      ),
                    ),
                    track(
                      math.min(_startX, _endX),
                      (end - start) * _width,
                      resolveStateful<SliderStyle, Decoration>(
                        state,
                        layers,
                        (SliderStyle s) => s.activeTrackDecoration,
                      ),
                    ),
                    if (widget.divisions != null)
                      for (int i = 0; i <= widget.divisions!; i++)
                        Positioned(
                          left: x(i / widget.divisions!),
                          top: height / 2,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, -0.5),
                            child: AnimatedSurface(
                              width: tick.width,
                              height: tick.height,
                              duration: duration,
                              curve: curve,
                              decoration:
                                  resolveStateful<SliderStyle, Decoration>(
                                    state,
                                    layers,
                                    (SliderStyle s) =>
                                        i / widget.divisions! >= start &&
                                            i / widget.divisions! <= end
                                        ? s.activeTickMarkDecoration
                                        : s.tickMarkDecoration,
                                  ),
                            ),
                          ),
                        ),
                    for (int index = 0; index < 2; index++)
                      Positioned(
                        left: (index == 0 ? _startX : _endX) - _targetWidth / 2,
                        top: 0,
                        width: _targetWidth,
                        height: height,
                        child: _thumb(index, layers, thumb, duration, curve),
                      ),
                    if (effective.valueIndicatorBuilder != null)
                      for (int index = 0; index < 2; index++)
                        Positioned(
                          left: index == 0 ? _startX : _endX,
                          top: height / 2 - thumb.height / 2,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, -1),
                            child: effective.valueIndicatorBuilder!(
                              context,
                              state.copyWith(
                                isPressed: _active == index,
                                isDragged: _active == index && _dragging,
                              ),
                              index == 0
                                  ? widget.values.start
                                  : widget.values.end,
                              index == 0
                                  ? widget.labels?.start
                                  : widget.labels?.end,
                            ),
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _thumb(
    int thumb,
    List<SliderStyle?> layers,
    Size size,
    Duration duration,
    Curve curve,
  ) {
    final double value = thumb == 0 ? widget.values.start : widget.values.end;
    String format(double value) =>
        widget.semanticFormatterCallback?.call(value) ??
        '${(_fraction(value) * 100).round()}%';
    return Semantics(
      container: true,
      slider: true,
      enabled: _enabled,
      label: thumb == 0 ? widget.labels?.start : widget.labels?.end,
      value: format(value),
      increasedValue: format(
        thumb == 0
            ? _updated(thumb, _adjusted(thumb, true), widget.values).start
            : _updated(thumb, _adjusted(thumb, true), widget.values).end,
      ),
      decreasedValue: format(
        thumb == 0
            ? _updated(thumb, _adjusted(thumb, false), widget.values).start
            : _updated(thumb, _adjusted(thumb, false), widget.values).end,
      ),
      onIncrease: _enabled ? () => _adjust(thumb, true) : null,
      onDecrease: _enabled ? () => _adjust(thumb, false) : null,
      child: InteractionDetector(
        enabled: _enabled,
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) => resolveStateful<SliderStyle, MouseCursor>(
            state,
            layers,
            (SliderStyle style) => style.mouseCursor,
          ),
        ),
        focusNode: _focus(thumb),
        autofocus: thumb == 0 && widget.autofocus,
        excludeFromSemantics: true,
        actions: <Type, Action<Intent>>{
          DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
            onInvoke: (DirectionalFocusIntent intent) =>
                _direction(thumb, intent.direction),
          ),
          ScrollIntent: CallbackAction<ScrollIntent>(
            onInvoke: (ScrollIntent intent) =>
                _direction(thumb, switch (intent.direction) {
                  AxisDirection.left => TraversalDirection.left,
                  AxisDirection.right => TraversalDirection.right,
                  AxisDirection.up => TraversalDirection.up,
                  AxisDirection.down => TraversalDirection.down,
                }),
          ),
        },
        builder: (BuildContext context, InteractionState state) => Center(
          child: AnimatedSurface(
            duration: duration,
            curve: curve,
            width: size.width,
            height: size.height,
            decoration: resolveStateful<SliderStyle, Decoration>(
              state.copyWith(
                isPressed: _active == thumb,
                isDragged: _active == thumb && _dragging,
              ),
              layers,
              (SliderStyle s) => s.thumbDecoration,
            ),
          ),
        ),
      ),
    );
  }
}
