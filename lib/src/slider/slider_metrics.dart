import 'package:flutter/widgets.dart';

/// The slider sizes that can change with interaction state.
@immutable
class SliderMetrics {
  /// Creates slider sizes.
  const SliderMetrics({
    required this.thumb,
    required this.trackHeight,
    required this.tick,
  });

  /// The thumb size.
  final Size thumb;

  /// The track height.
  final double trackHeight;

  /// The tick mark size.
  final Size tick;

  @override
  bool operator ==(Object other) =>
      other is SliderMetrics &&
      other.thumb == thumb &&
      other.trackHeight == trackHeight &&
      other.tick == tick;

  @override
  int get hashCode => Object.hash(thumb, trackHeight, tick);
}

/// Interpolates [SliderMetrics] field by field.
class SliderMetricsTween extends Tween<SliderMetrics> {
  /// Creates a tween that starts at its first end value.
  SliderMetricsTween({super.end});

  @override
  SliderMetrics lerp(double t) => SliderMetrics(
    thumb: Size.lerp(begin!.thumb, end!.thumb, t)!,
    trackHeight:
        begin!.trackHeight + (end!.trackHeight - begin!.trackHeight) * t,
    tick: Size.lerp(begin!.tick, end!.tick, t)!,
  );
}
