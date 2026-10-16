import 'package:flutter/widgets.dart';

import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_placement.dart';

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
    this.placement,
    this.overlayLocation,
    this.outsideTapBehavior,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.transitionCurve,
    this.reverseTransitionCurve,
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

  /// The directional displacement from the anchor position.
  ///
  /// A positive horizontal displacement moves toward the reading direction.
  final Offset? offset;

  /// The inset kept clear around the overlay edges.
  final EdgeInsets? edgePadding;

  /// The clipping behavior of the panel.
  final Clip? clipBehavior;

  /// The placement policy, overriding the menu's legacy positioning tokens.
  final OverlayPlacement? placement;

  /// The overlay receiving the panel. Defaults to [OverlayLocation.root].
  final OverlayLocation? overlayLocation;

  /// Whether an outside tap also activates the control beneath the menu.
  ///
  /// Defaults to [OutsideTapBehavior.passThrough].
  final OutsideTapBehavior? outsideTapBehavior;

  /// The opening duration. Defaults to 150 milliseconds.
  final Duration? transitionDuration;

  /// The closing duration. Defaults to 100 milliseconds.
  ///
  /// A zero [transitionDuration] also disables closing unless overridden.
  final Duration? reverseTransitionDuration;

  /// The opening curve. Defaults to [Curves.easeOutCubic].
  final Curve? transitionCurve;

  /// The closing curve. Defaults to [Curves.easeInCubic].
  final Curve? reverseTransitionCurve;

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
    OverlayPlacement? placement,
    OverlayLocation? overlayLocation,
    OutsideTapBehavior? outsideTapBehavior,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
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
      placement: placement ?? this.placement,
      overlayLocation: overlayLocation ?? this.overlayLocation,
      outsideTapBehavior: outsideTapBehavior ?? this.outsideTapBehavior,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
      reverseTransitionCurve:
          reverseTransitionCurve ?? this.reverseTransitionCurve,
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
      placement: placement ?? other.placement,
      overlayLocation: overlayLocation ?? other.overlayLocation,
      outsideTapBehavior: outsideTapBehavior ?? other.outsideTapBehavior,
      transitionDuration: transitionDuration ?? other.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? other.reverseTransitionDuration,
      transitionCurve: transitionCurve ?? other.transitionCurve,
      reverseTransitionCurve:
          reverseTransitionCurve ?? other.reverseTransitionCurve,
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
            placement == other.placement &&
            overlayLocation == other.overlayLocation &&
            outsideTapBehavior == other.outsideTapBehavior &&
            transitionDuration == other.transitionDuration &&
            reverseTransitionDuration == other.reverseTransitionDuration &&
            transitionCurve == other.transitionCurve &&
            reverseTransitionCurve == other.reverseTransitionCurve &&
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
    placement,
    overlayLocation,
    outsideTapBehavior,
    transitionDuration,
    reverseTransitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'MenuStyle(decoration: $decoration, padding: $padding, minimumSize: $minimumSize, maximumSize: $maximumSize, matchAnchorWidth: $matchAnchorWidth, offset: $offset, edgePadding: $edgePadding, clipBehavior: $clipBehavior, placement: $placement, overlayLocation: $overlayLocation, outsideTapBehavior: $outsideTapBehavior, transitionDuration: $transitionDuration, reverseTransitionDuration: $reverseTransitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, transitionBuilder: $transitionBuilder)';
}
