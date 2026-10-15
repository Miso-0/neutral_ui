import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import '../foundation/interaction_state.dart';

/// The pointer interactions a slider accepts.
enum SliderInteraction {
  /// Taps jump to a value and dragging moves the thumb.
  tapAndSlide,

  /// Only taps jump to a value.
  tapOnly,

  /// Dragging moves the thumb without an initial jump.
  slideOnly,

  /// Only dragging that begins on the thumb moves it.
  slideThumb,
}

/// Formats a slider value for accessibility services.
typedef SemanticFormatterCallback = String Function(double value);

/// Builds a slider's optional value indicator.
typedef SliderValueIndicatorBuilder = Widget Function(
  BuildContext context,
  InteractionState state,
  double value,
  String? label,
);

/// Tokens for the structure and appearance of a slider.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
@immutable
class SliderStyle {
  /// Creates a collection of optional component tokens.
  const SliderStyle({
    this.trackHeight,
    this.trackDecoration,
    this.activeTrackDecoration,
    this.secondaryActiveTrackDecoration,
    this.thumbSize,
    this.thumbDecoration,
    this.tickMarkSize,
    this.tickMarkDecoration,
    this.activeTickMarkDecoration,
    this.mouseCursor,
    this.valueIndicatorBuilder,
    this.padding,
    this.tapTargetSize,
    this.preferredWidth,
    this.keyboardStep,
    this.allowedInteraction,
    this.animationDuration,
    this.animationCurve,
  });

  /// The visual height of every track segment.
  final StateProperty<double?>? trackHeight;

  /// The decoration of the full track.
  final StateProperty<Decoration?>? trackDecoration;

  /// The decoration of the selected track segment.
  final StateProperty<Decoration?>? activeTrackDecoration;

  /// The decoration of the secondary track segment.
  final StateProperty<Decoration?>? secondaryActiveTrackDecoration;

  /// The visual size of the thumb.
  final StateProperty<Size?>? thumbSize;

  /// The decoration of the thumb.
  final StateProperty<Decoration?>? thumbDecoration;

  /// The visual size of a discrete tick mark.
  final StateProperty<Size?>? tickMarkSize;

  /// The decoration of an inactive tick mark.
  final StateProperty<Decoration?>? tickMarkDecoration;

  /// The decoration of an active tick mark.
  final StateProperty<Decoration?>? activeTickMarkDecoration;

  /// The pointer cursor for the current interaction state.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// Builds optional content above the thumb.
  final SliderValueIndicatorBuilder? valueIndicatorBuilder;

  /// The inset at the ends of the track.
  final EdgeInsetsGeometry? padding;

  /// The minimum interactive size.
  final Size? tapTargetSize;

  /// The width used when horizontal constraints are unbounded.
  final double? preferredWidth;

  /// The normalized keyboard step for a continuous slider.
  final double? keyboardStep;

  /// The permitted pointer interactions.
  final SliderInteraction? allowedInteraction;

  /// The duration of decoration and size transitions.
  final Duration? animationDuration;

  /// The curve of decoration and size transitions.
  final Curve? animationCurve;

  /// Returns a copy with the supplied non-null tokens replaced.
  SliderStyle copyWith({
    StateProperty<double?>? trackHeight,
    StateProperty<Decoration?>? trackDecoration,
    StateProperty<Decoration?>? activeTrackDecoration,
    StateProperty<Decoration?>? secondaryActiveTrackDecoration,
    StateProperty<Size?>? thumbSize,
    StateProperty<Decoration?>? thumbDecoration,
    StateProperty<Size?>? tickMarkSize,
    StateProperty<Decoration?>? tickMarkDecoration,
    StateProperty<Decoration?>? activeTickMarkDecoration,
    StateProperty<MouseCursor?>? mouseCursor,
    SliderValueIndicatorBuilder? valueIndicatorBuilder,
    EdgeInsetsGeometry? padding,
    Size? tapTargetSize,
    double? preferredWidth,
    double? keyboardStep,
    SliderInteraction? allowedInteraction,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return SliderStyle(
      trackHeight: trackHeight ?? this.trackHeight,
      trackDecoration: trackDecoration ?? this.trackDecoration,
      activeTrackDecoration:
          activeTrackDecoration ?? this.activeTrackDecoration,
      secondaryActiveTrackDecoration:
          secondaryActiveTrackDecoration ?? this.secondaryActiveTrackDecoration,
      thumbSize: thumbSize ?? this.thumbSize,
      thumbDecoration: thumbDecoration ?? this.thumbDecoration,
      tickMarkSize: tickMarkSize ?? this.tickMarkSize,
      tickMarkDecoration: tickMarkDecoration ?? this.tickMarkDecoration,
      activeTickMarkDecoration:
          activeTickMarkDecoration ?? this.activeTickMarkDecoration,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      valueIndicatorBuilder:
          valueIndicatorBuilder ?? this.valueIndicatorBuilder,
      padding: padding ?? this.padding,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
      preferredWidth: preferredWidth ?? this.preferredWidth,
      keyboardStep: keyboardStep ?? this.keyboardStep,
      allowedInteraction: allowedInteraction ?? this.allowedInteraction,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  SliderStyle merge(SliderStyle? other) {
    if (other == null) {
      return this;
    }
    return SliderStyle(
      trackHeight: trackHeight ?? other.trackHeight,
      trackDecoration: trackDecoration ?? other.trackDecoration,
      activeTrackDecoration:
          activeTrackDecoration ?? other.activeTrackDecoration,
      secondaryActiveTrackDecoration:
          secondaryActiveTrackDecoration ??
          other.secondaryActiveTrackDecoration,
      thumbSize: thumbSize ?? other.thumbSize,
      thumbDecoration: thumbDecoration ?? other.thumbDecoration,
      tickMarkSize: tickMarkSize ?? other.tickMarkSize,
      tickMarkDecoration: tickMarkDecoration ?? other.tickMarkDecoration,
      activeTickMarkDecoration:
          activeTickMarkDecoration ?? other.activeTickMarkDecoration,
      mouseCursor: mouseCursor ?? other.mouseCursor,
      valueIndicatorBuilder:
          valueIndicatorBuilder ?? other.valueIndicatorBuilder,
      padding: padding ?? other.padding,
      tapTargetSize: tapTargetSize ?? other.tapTargetSize,
      preferredWidth: preferredWidth ?? other.preferredWidth,
      keyboardStep: keyboardStep ?? other.keyboardStep,
      allowedInteraction: allowedInteraction ?? other.allowedInteraction,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SliderStyle &&
            trackHeight == other.trackHeight &&
            trackDecoration == other.trackDecoration &&
            activeTrackDecoration == other.activeTrackDecoration &&
            secondaryActiveTrackDecoration ==
                other.secondaryActiveTrackDecoration &&
            thumbSize == other.thumbSize &&
            thumbDecoration == other.thumbDecoration &&
            tickMarkSize == other.tickMarkSize &&
            tickMarkDecoration == other.tickMarkDecoration &&
            activeTickMarkDecoration == other.activeTickMarkDecoration &&
            mouseCursor == other.mouseCursor &&
            valueIndicatorBuilder == other.valueIndicatorBuilder &&
            padding == other.padding &&
            tapTargetSize == other.tapTargetSize &&
            preferredWidth == other.preferredWidth &&
            keyboardStep == other.keyboardStep &&
            allowedInteraction == other.allowedInteraction &&
            animationDuration == other.animationDuration &&
            animationCurve == other.animationCurve;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    trackHeight,
    trackDecoration,
    activeTrackDecoration,
    secondaryActiveTrackDecoration,
    thumbSize,
    thumbDecoration,
    tickMarkSize,
    tickMarkDecoration,
    activeTickMarkDecoration,
    mouseCursor,
    valueIndicatorBuilder,
    padding,
    tapTargetSize,
    preferredWidth,
    keyboardStep,
    allowedInteraction,
    animationDuration,
    animationCurve,
  ]);

  @override
  String toString() =>
      'SliderStyle(trackHeight: $trackHeight, trackDecoration: $trackDecoration, activeTrackDecoration: $activeTrackDecoration, secondaryActiveTrackDecoration: $secondaryActiveTrackDecoration, thumbSize: $thumbSize, thumbDecoration: $thumbDecoration, tickMarkSize: $tickMarkSize, tickMarkDecoration: $tickMarkDecoration, activeTickMarkDecoration: $activeTickMarkDecoration, mouseCursor: $mouseCursor, valueIndicatorBuilder: $valueIndicatorBuilder, padding: $padding, tapTargetSize: $tapTargetSize, preferredWidth: $preferredWidth, keyboardStep: $keyboardStep, allowedInteraction: $allowedInteraction, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
