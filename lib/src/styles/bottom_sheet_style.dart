import 'package:flutter/widgets.dart';

import '../feedback/feedback_transition.dart';
import '../foundation/motion.dart';

/// Optional appearance and motion tokens for bottomsheet components.
@immutable
class BottomSheetStyle {
  /// Creates inheritable component tokens.
  const BottomSheetStyle({
    this.decoration,
    this.padding,
    this.constraints,
    this.clipBehavior,
    this.barrierColor,
    this.dragHandleColor,
    this.dragHandleSize,
    this.dragHandleDecoration,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.transitionCurve,
    this.reverseTransitionCurve,
    this.snapPoints,
    this.spring,
    this.transitionBuilder,
  });

  /// The decoration token. Null inherits from the enclosing style.
  final Decoration? decoration;

  /// The padding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? padding;

  /// The constraints token. Null inherits from the enclosing style.
  final BoxConstraints? constraints;

  /// The clipBehavior token. Null inherits from the enclosing style.
  final Clip? clipBehavior;

  /// The barrierColor token. Null inherits from the enclosing style.
  final Color? barrierColor;

  /// The dragHandleColor token. Null inherits from the enclosing style.
  final Color? dragHandleColor;

  /// The dragHandleSize token. Null inherits from the enclosing style.
  final Size? dragHandleSize;

  /// The dragHandleDecoration token. Null inherits from the enclosing style.
  final Decoration? dragHandleDecoration;

  /// The transitionDuration token. Null inherits from the enclosing style.
  final Duration? transitionDuration;

  /// The reverseTransitionDuration token. Null inherits from the enclosing style.
  final Duration? reverseTransitionDuration;

  /// The transitionCurve token. Null inherits from the enclosing style.
  final Curve? transitionCurve;

  /// The reverseTransitionCurve token. Null inherits from the enclosing style.
  final Curve? reverseTransitionCurve;

  /// The snapPoints token. Null inherits from the enclosing style.
  final List<double>? snapPoints;

  /// The spring token. Null inherits from the enclosing style.
  final MotionSpring? spring;

  /// The transitionBuilder token. Null inherits from the enclosing style.
  final FeedbackTransitionBuilder? transitionBuilder;

  /// Copies this style, replacing supplied tokens.
  BottomSheetStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    Clip? clipBehavior,
    Color? barrierColor,
    Color? dragHandleColor,
    Size? dragHandleSize,
    Decoration? dragHandleDecoration,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
    List<double>? snapPoints,
    MotionSpring? spring,
    FeedbackTransitionBuilder? transitionBuilder,
  }) => BottomSheetStyle(
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    constraints: constraints ?? this.constraints,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    barrierColor: barrierColor ?? this.barrierColor,
    dragHandleColor: dragHandleColor ?? this.dragHandleColor,
    dragHandleSize: dragHandleSize ?? this.dragHandleSize,
    dragHandleDecoration: dragHandleDecoration ?? this.dragHandleDecoration,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    reverseTransitionDuration:
        reverseTransitionDuration ?? this.reverseTransitionDuration,
    transitionCurve: transitionCurve ?? this.transitionCurve,
    reverseTransitionCurve:
        reverseTransitionCurve ?? this.reverseTransitionCurve,
    snapPoints: snapPoints ?? this.snapPoints,
    spring: spring ?? this.spring,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );

  /// Fills unset tokens from [other], preserving this style.
  BottomSheetStyle merge(BottomSheetStyle? other) {
    if (other == null) return this;
    return BottomSheetStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      constraints: constraints ?? other.constraints,
      clipBehavior: clipBehavior ?? other.clipBehavior,
      barrierColor: barrierColor ?? other.barrierColor,
      dragHandleColor: dragHandleColor ?? other.dragHandleColor,
      dragHandleSize: dragHandleSize ?? other.dragHandleSize,
      dragHandleDecoration: dragHandleDecoration ?? other.dragHandleDecoration,
      transitionDuration: transitionDuration ?? other.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? other.reverseTransitionDuration,
      transitionCurve: transitionCurve ?? other.transitionCurve,
      reverseTransitionCurve:
          reverseTransitionCurve ?? other.reverseTransitionCurve,
      snapPoints: snapPoints ?? other.snapPoints,
      spring: spring ?? other.spring,
      transitionBuilder: transitionBuilder ?? other.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BottomSheetStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          constraints == other.constraints &&
          clipBehavior == other.clipBehavior &&
          barrierColor == other.barrierColor &&
          dragHandleColor == other.dragHandleColor &&
          dragHandleSize == other.dragHandleSize &&
          dragHandleDecoration == other.dragHandleDecoration &&
          transitionDuration == other.transitionDuration &&
          reverseTransitionDuration == other.reverseTransitionDuration &&
          transitionCurve == other.transitionCurve &&
          reverseTransitionCurve == other.reverseTransitionCurve &&
          snapPoints == other.snapPoints &&
          spring == other.spring &&
          transitionBuilder == other.transitionBuilder;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    padding,
    constraints,
    clipBehavior,
    barrierColor,
    dragHandleColor,
    dragHandleSize,
    dragHandleDecoration,
    transitionDuration,
    reverseTransitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    snapPoints,
    spring,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'BottomSheetStyle(decoration: $decoration, padding: $padding, constraints: $constraints, clipBehavior: $clipBehavior, barrierColor: $barrierColor, dragHandleColor: $dragHandleColor, dragHandleSize: $dragHandleSize, dragHandleDecoration: $dragHandleDecoration, transitionDuration: $transitionDuration, reverseTransitionDuration: $reverseTransitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, snapPoints: $snapPoints, spring: $spring, transitionBuilder: $transitionBuilder)';
}
