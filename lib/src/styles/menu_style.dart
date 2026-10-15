import 'package:flutter/widgets.dart';

/// Builds the transition around a menu panel.
typedef MenuTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// Tokens for the structure and appearance of a menu panel.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
@immutable
class MenuStyle {
  /// Creates a collection of optional component tokens.
  const MenuStyle({
    this.decoration,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.matchAnchorWidth,
    this.offset,
    this.edgePadding,
    this.clipBehavior,
    this.transitionDuration,
    this.transitionCurve,
    this.transitionBuilder,
  });

  /// The decoration behind the menu panel.
  final Decoration? decoration;

  /// The inset around the menu content.
  final EdgeInsetsGeometry? padding;

  /// The minimum size of the menu panel.
  final Size? minimumSize;

  /// The maximum size of the menu panel.
  final Size? maximumSize;

  /// Whether the panel is at least as wide as its anchor.
  final bool? matchAnchorWidth;

  /// The displacement from the anchor position.
  final Offset? offset;

  /// The inset kept clear around the overlay edges.
  final EdgeInsets? edgePadding;

  /// The clipping behavior of the panel.
  final Clip? clipBehavior;

  /// The duration of opening and closing transitions.
  final Duration? transitionDuration;

  /// The curve of opening and closing transitions.
  final Curve? transitionCurve;

  /// Builds an optional transition around the panel.
  final MenuTransitionBuilder? transitionBuilder;

  /// Returns a copy with the supplied non-null tokens replaced.
  MenuStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? maximumSize,
    bool? matchAnchorWidth,
    Offset? offset,
    EdgeInsets? edgePadding,
    Clip? clipBehavior,
    Duration? transitionDuration,
    Curve? transitionCurve,
    MenuTransitionBuilder? transitionBuilder,
  }) {
    return MenuStyle(
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      maximumSize: maximumSize ?? this.maximumSize,
      matchAnchorWidth: matchAnchorWidth ?? this.matchAnchorWidth,
      offset: offset ?? this.offset,
      edgePadding: edgePadding ?? this.edgePadding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
      transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  MenuStyle merge(MenuStyle? other) {
    if (other == null) {
      return this;
    }
    return MenuStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      minimumSize: minimumSize ?? other.minimumSize,
      maximumSize: maximumSize ?? other.maximumSize,
      matchAnchorWidth: matchAnchorWidth ?? other.matchAnchorWidth,
      offset: offset ?? other.offset,
      edgePadding: edgePadding ?? other.edgePadding,
      clipBehavior: clipBehavior ?? other.clipBehavior,
      transitionDuration: transitionDuration ?? other.transitionDuration,
      transitionCurve: transitionCurve ?? other.transitionCurve,
      transitionBuilder: transitionBuilder ?? other.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MenuStyle &&
            decoration == other.decoration &&
            padding == other.padding &&
            minimumSize == other.minimumSize &&
            maximumSize == other.maximumSize &&
            matchAnchorWidth == other.matchAnchorWidth &&
            offset == other.offset &&
            edgePadding == other.edgePadding &&
            clipBehavior == other.clipBehavior &&
            transitionDuration == other.transitionDuration &&
            transitionCurve == other.transitionCurve &&
            transitionBuilder == other.transitionBuilder;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    padding,
    minimumSize,
    maximumSize,
    matchAnchorWidth,
    offset,
    edgePadding,
    clipBehavior,
    transitionDuration,
    transitionCurve,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'MenuStyle(decoration: $decoration, padding: $padding, minimumSize: $minimumSize, maximumSize: $maximumSize, matchAnchorWidth: $matchAnchorWidth, offset: $offset, edgePadding: $edgePadding, clipBehavior: $clipBehavior, transitionDuration: $transitionDuration, transitionCurve: $transitionCurve, transitionBuilder: $transitionBuilder)';
}
