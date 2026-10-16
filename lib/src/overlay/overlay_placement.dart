import 'package:flutter/widgets.dart';

/// Alignment along an anchor's cross axis.
enum OverlayAlignment {
  /// Align starting edges, respecting the text direction on horizontal axes.
  start,

  /// Align the centers.
  center,

  /// Align ending edges, respecting the text direction on horizontal axes.
  end,
}

/// When an anchored panel can move to the opposite side of its anchor.
enum OverlayFlip {
  /// Always retain the preferred side.
  none,

  /// Flip when the panel does not fit and the opposite side has more room.
  ifNeeded,

  /// Always choose the side with more room, preferring the original on ties.
  toLargerSide,
}

/// How an anchored panel handles the available overlay bounds.
enum OverlayOverflow {
  /// Reduce its size to fit its chosen side and shift along the cross axis.
  shrink,

  /// Keep its size and shift both axes into the available bounds.
  shift,

  /// Keep its size and attachment, shifting only along the cross axis.
  keepSize,
}

/// How an anchored panel's width follows its anchor.
enum OverlayAnchorWidth {
  /// Use the panel's own width.
  none,

  /// Use at least the anchor's width, subject to the panel's constraints.
  min,

  /// Use the anchor's width, subject to the panel's constraints.
  exact,
}

/// Immutable policy for positioning a panel relative to an anchor.
@immutable
class OverlayPlacement {
  /// Creates an anchored placement policy.
  const OverlayPlacement({
    this.preferredSide = AxisDirection.down,
    this.alignment = OverlayAlignment.start,
    this.coverAnchor = false,
    this.gap = 0,
    this.crossOffset = 0,
    this.flip = OverlayFlip.ifNeeded,
    this.overflow = OverlayOverflow.shrink,
    this.margin = EdgeInsets.zero,
    this.constraints = const BoxConstraints(),
    this.anchorWidth = OverlayAnchorWidth.none,
  });

  /// The preferred physical side of the anchor.
  final AxisDirection preferredSide;

  /// Alignment on the axis perpendicular to [preferredSide].
  final OverlayAlignment alignment;

  /// Whether the panel starts at the anchor's near edge and covers it.
  final bool coverAnchor;

  /// Distance away from the attachment edge, mirrored when the panel flips.
  final double gap;

  /// Cross-axis displacement, mirrored horizontally in right-to-left layouts.
  final double crossOffset;

  /// The policy for choosing the opposite side.
  final OverlayFlip flip;

  /// The policy for panels that do not fit the available space.
  final OverlayOverflow overflow;

  /// Additional space kept clear inside the safe overlay bounds.
  final EdgeInsetsGeometry margin;

  /// Explicit size bounds for the panel.
  final BoxConstraints constraints;

  /// How the panel's width follows the anchor's width.
  final OverlayAnchorWidth anchorWidth;

  /// Returns a policy with the supplied values replaced.
  OverlayPlacement copyWith({
    AxisDirection? preferredSide,
    OverlayAlignment? alignment,
    bool? coverAnchor,
    double? gap,
    double? crossOffset,
    OverlayFlip? flip,
    OverlayOverflow? overflow,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    OverlayAnchorWidth? anchorWidth,
  }) => OverlayPlacement(
    preferredSide: preferredSide ?? this.preferredSide,
    alignment: alignment ?? this.alignment,
    coverAnchor: coverAnchor ?? this.coverAnchor,
    gap: gap ?? this.gap,
    crossOffset: crossOffset ?? this.crossOffset,
    flip: flip ?? this.flip,
    overflow: overflow ?? this.overflow,
    margin: margin ?? this.margin,
    constraints: constraints ?? this.constraints,
    anchorWidth: anchorWidth ?? this.anchorWidth,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverlayPlacement &&
          preferredSide == other.preferredSide &&
          alignment == other.alignment &&
          coverAnchor == other.coverAnchor &&
          gap == other.gap &&
          crossOffset == other.crossOffset &&
          flip == other.flip &&
          overflow == other.overflow &&
          margin == other.margin &&
          constraints == other.constraints &&
          anchorWidth == other.anchorWidth;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    preferredSide,
    alignment,
    coverAnchor,
    gap,
    crossOffset,
    flip,
    overflow,
    margin,
    constraints,
    anchorWidth,
  ]);

  @override
  String toString() =>
      'OverlayPlacement(preferredSide: $preferredSide, alignment: $alignment, '
      'coverAnchor: $coverAnchor, gap: $gap, crossOffset: $crossOffset, '
      'flip: $flip, overflow: $overflow, margin: $margin, '
      'constraints: $constraints, anchorWidth: $anchorWidth)';
}

/// The bounds and physical attachment side of a resolved overlay panel.
@immutable
class OverlayPlacementResult {
  /// Creates a resolved placement.
  const OverlayPlacementResult({required this.rect, required this.side});

  /// The panel's bounds in overlay coordinates.
  final Rect rect;

  /// The chosen side, after applying the flip policy.
  final AxisDirection side;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverlayPlacementResult &&
          rect == other.rect &&
          side == other.side;

  @override
  int get hashCode => Object.hash(rect, side);

  @override
  String toString() => 'OverlayPlacementResult(rect: $rect, side: $side)';
}

/// Resolves an anchored panel without accessing widget or render state.
///
/// [anchorRect], [overlaySize], [padding] and [viewInsets] share the target
/// overlay's coordinate system. Safe padding and obscuring insets are combined
/// by taking the larger inset on each edge; [OverlayPlacement.margin] is added
/// afterwards. Explicit panel constraints and anchor width are applied before
/// the overflow policy.
OverlayPlacementResult resolvePlacement({
  required Rect anchorRect,
  required Size overlaySize,
  required Size childSize,
  required TextDirection textDirection,
  OverlayPlacement placement = const OverlayPlacement(),
  EdgeInsets padding = EdgeInsets.zero,
  EdgeInsets viewInsets = EdgeInsets.zero,
}) {
  final Rect bounds = _availableBounds(
    overlaySize,
    textDirection,
    placement,
    padding,
    viewInsets,
  );
  Size size = _panelConstraints(anchorRect, placement).constrain(childSize);
  final AxisDirection preferred = placement.preferredSide;
  final AxisDirection opposite = _opposite(preferred);
  final double preferredSpace = _space(
    anchorRect,
    bounds,
    preferred,
    placement,
  );
  final double oppositeSpace = _space(anchorRect, bounds, opposite, placement);
  final double extent = _vertical(preferred) ? size.height : size.width;
  final bool flip = switch (placement.flip) {
    OverlayFlip.none => false,
    OverlayFlip.ifNeeded =>
      extent > preferredSpace && oppositeSpace > preferredSpace,
    OverlayFlip.toLargerSide => oppositeSpace > preferredSpace,
  };
  final AxisDirection side = flip ? opposite : preferred;
  if (placement.overflow == OverlayOverflow.shrink) {
    final double main = flip ? oppositeSpace : preferredSpace;
    size = Size(
      _min(size.width, _vertical(side) ? bounds.width : main),
      _min(size.height, _vertical(side) ? main : bounds.height),
    );
  }
  double x;
  double y;
  if (_vertical(side)) {
    x =
        _aligned(
          anchorRect.left,
          anchorRect.right,
          size.width,
          placement.alignment,
          textDirection == TextDirection.rtl,
        ) +
        (textDirection == TextDirection.rtl
            ? -placement.crossOffset
            : placement.crossOffset);
    y = side == AxisDirection.down
        ? (placement.coverAnchor ? anchorRect.top : anchorRect.bottom) +
              placement.gap
        : (placement.coverAnchor ? anchorRect.bottom : anchorRect.top) -
              placement.gap -
              size.height;
    x = _shift(x, size.width, bounds.left, bounds.right);
    if (placement.overflow != OverlayOverflow.keepSize) {
      y = _shift(y, size.height, bounds.top, bounds.bottom);
    }
  } else {
    x = side == AxisDirection.right
        ? (placement.coverAnchor ? anchorRect.left : anchorRect.right) +
              placement.gap
        : (placement.coverAnchor ? anchorRect.right : anchorRect.left) -
              placement.gap -
              size.width;
    y =
        _aligned(
          anchorRect.top,
          anchorRect.bottom,
          size.height,
          placement.alignment,
          false,
        ) +
        placement.crossOffset;
    y = _shift(y, size.height, bounds.top, bounds.bottom);
    if (placement.overflow != OverlayOverflow.keepSize) {
      x = _shift(x, size.width, bounds.left, bounds.right);
    }
  }
  return OverlayPlacementResult(
    rect: Rect.fromLTWH(x, y, size.width, size.height),
    side: side,
  );
}

/// Lays out a single panel using [resolvePlacement].
class OverlayPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates an anchored panel layout delegate.
  const OverlayPositionDelegate({
    required this.anchorRect,
    required this.textDirection,
    this.placement = const OverlayPlacement(),
    this.padding = EdgeInsets.zero,
    this.viewInsets = EdgeInsets.zero,
    this.onSideResolved,
  });

  /// The anchor bounds in target overlay coordinates.
  final Rect anchorRect;

  /// The direction used for cross-axis alignment and offsets.
  final TextDirection textDirection;

  /// The panel's placement policy.
  final OverlayPlacement placement;

  /// Safe padding in target overlay coordinates.
  final EdgeInsets padding;

  /// Obscuring insets in target overlay coordinates, such as a keyboard.
  final EdgeInsets viewInsets;

  /// Receives the chosen side during layout, without triggering a rebuild.
  final ValueChanged<AxisDirection>? onSideResolved;

  /// Resolves the panel bounds and chosen side for the supplied sizes.
  OverlayPlacementResult placementResult(Size size, Size childSize) =>
      resolvePlacement(
        anchorRect: anchorRect,
        overlaySize: size,
        childSize: childSize,
        textDirection: textDirection,
        placement: placement,
        padding: padding,
        viewInsets: viewInsets,
      );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final BoxConstraints panel = _panelConstraints(anchorRect, placement);
    if (placement.overflow != OverlayOverflow.shrink) return panel;
    final Rect bounds = _availableBounds(
      constraints.biggest,
      textDirection,
      placement,
      padding,
      viewInsets,
    );
    double main = _space(
      anchorRect,
      bounds,
      placement.preferredSide,
      placement,
    );
    if (placement.flip != OverlayFlip.none) {
      main = _max(
        main,
        _space(
          anchorRect,
          bounds,
          _opposite(placement.preferredSide),
          placement,
        ),
      );
    }
    final double maxWidth = _min(
      panel.maxWidth,
      _vertical(placement.preferredSide) ? bounds.width : main,
    );
    final double maxHeight = _min(
      panel.maxHeight,
      _vertical(placement.preferredSide) ? main : bounds.height,
    );
    return BoxConstraints(
      minWidth: _min(panel.minWidth, maxWidth),
      maxWidth: maxWidth,
      minHeight: _min(panel.minHeight, maxHeight),
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final OverlayPlacementResult result = placementResult(size, childSize);
    onSideResolved?.call(result.side);
    return result.rect.topLeft;
  }

  @override
  bool shouldRelayout(OverlayPositionDelegate oldDelegate) =>
      anchorRect != oldDelegate.anchorRect ||
      textDirection != oldDelegate.textDirection ||
      placement != oldDelegate.placement ||
      padding != oldDelegate.padding ||
      viewInsets != oldDelegate.viewInsets;
}

BoxConstraints _panelConstraints(Rect anchor, OverlayPlacement placement) {
  final BoxConstraints constraints = placement.constraints;
  final double width = anchor.width.clamp(
    constraints.minWidth,
    constraints.maxWidth,
  );
  return switch (placement.anchorWidth) {
    OverlayAnchorWidth.none => constraints,
    OverlayAnchorWidth.min => constraints.copyWith(
      minWidth: _max(constraints.minWidth, width),
    ),
    OverlayAnchorWidth.exact => constraints.copyWith(
      minWidth: width,
      maxWidth: width,
    ),
  };
}

Rect _availableBounds(
  Size size,
  TextDirection direction,
  OverlayPlacement placement,
  EdgeInsets padding,
  EdgeInsets insets,
) {
  final EdgeInsets margin = placement.margin.resolve(direction);
  final double left = (_max(padding.left, insets.left) + margin.left).clamp(
    0,
    size.width,
  );
  final double top = (_max(padding.top, insets.top) + margin.top).clamp(
    0,
    size.height,
  );
  final double right =
      (size.width - _max(padding.right, insets.right) - margin.right).clamp(
        left,
        size.width,
      );
  final double bottom =
      (size.height - _max(padding.bottom, insets.bottom) - margin.bottom).clamp(
        top,
        size.height,
      );
  return Rect.fromLTRB(left, top, right, bottom);
}

double _space(
  Rect anchor,
  Rect bounds,
  AxisDirection side,
  OverlayPlacement placement,
) => _min(
  _vertical(side) ? bounds.height : bounds.width,
  _max(0, switch (side) {
    AxisDirection.down =>
      bounds.bottom -
          (placement.coverAnchor ? anchor.top : anchor.bottom) -
          placement.gap,
    AxisDirection.up =>
      (placement.coverAnchor ? anchor.bottom : anchor.top) -
          placement.gap -
          bounds.top,
    AxisDirection.right =>
      bounds.right -
          (placement.coverAnchor ? anchor.left : anchor.right) -
          placement.gap,
    AxisDirection.left =>
      (placement.coverAnchor ? anchor.right : anchor.left) -
          placement.gap -
          bounds.left,
  }),
);

bool _vertical(AxisDirection side) =>
    side == AxisDirection.up || side == AxisDirection.down;

AxisDirection _opposite(AxisDirection side) => switch (side) {
  AxisDirection.up => AxisDirection.down,
  AxisDirection.down => AxisDirection.up,
  AxisDirection.left => AxisDirection.right,
  AxisDirection.right => AxisDirection.left,
};

double _aligned(
  double start,
  double end,
  double extent,
  OverlayAlignment alignment,
  bool reverse,
) => switch (alignment) {
  OverlayAlignment.start => reverse ? end - extent : start,
  OverlayAlignment.center => (start + end - extent) / 2,
  OverlayAlignment.end => reverse ? start : end - extent,
};

double _shift(double value, double extent, double start, double end) =>
    value.clamp(start, _max(start, end - extent));

double _min(double a, double b) => a < b ? a : b;

double _max(double a, double b) => a > b ? a : b;
