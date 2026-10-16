import 'package:flutter/widgets.dart';

import '../overlay/overlay_placement.dart';
import '../styles/menu_style.dart';
import '../styles/popup_menu_style.dart';

/// Positions a menu in overlay coordinates, respecting available space.
class MenuPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates the menu's structural layout policy.
  const MenuPositionDelegate({
    required this.anchorRect,
    required this.textDirection,
    this.style = const MenuStyle(),
    this.matchAnchorWidth = true,
    this.position = PopupMenuPosition.under,
    this.offset = Offset.zero,
    this.maxHeight,
    this.placement,
    this.padding = EdgeInsets.zero,
    this.viewInsets = EdgeInsets.zero,
    this.onSideResolved,
  });

  /// The trigger's bounds within the overlay.
  final Rect anchorRect;

  /// The direction used to align the starting edge.
  final TextDirection textDirection;

  /// Optional panel constraints and edge padding.
  final MenuStyle style;

  /// Whether the panel should be at least as wide as the trigger.
  final bool matchAnchorWidth;

  /// The preferred vertical attachment.
  final PopupMenuPosition position;

  /// Directional displacement: horizontal start and vertical attachment gap.
  final Offset offset;

  /// A widget-level maximum height override.
  final double? maxHeight;

  /// An explicit placement policy overriding the legacy menu position tokens.
  final OverlayPlacement? placement;

  /// Safe padding in target overlay coordinates.
  final EdgeInsets padding;

  /// Obscuring insets in target overlay coordinates, such as a keyboard.
  final EdgeInsets viewInsets;

  /// Receives the selected side during layout, without triggering a rebuild.
  final ValueChanged<AxisDirection>? onSideResolved;

  OverlayPositionDelegate get _delegate {
    final double width = style.maximumSize?.width ?? double.infinity;
    final double height =
        maxHeight ?? style.maximumSize?.height ?? double.infinity;
    return OverlayPositionDelegate(
      anchorRect: anchorRect,
      textDirection: textDirection,
      padding: padding,
      viewInsets: viewInsets,
      placement:
          placement ??
          style.placement ??
          OverlayPlacement(
            coverAnchor: position == PopupMenuPosition.over,
            gap: offset.dy,
            crossOffset: offset.dx,
            margin: style.edgePadding ?? EdgeInsets.zero,
            anchorWidth: (style.matchAnchorWidth ?? matchAnchorWidth)
                ? OverlayAnchorWidth.min
                : OverlayAnchorWidth.none,
            constraints: BoxConstraints(
              minWidth: (style.minimumSize?.width ?? 0).clamp(0, width),
              maxWidth: width,
              minHeight: (style.minimumSize?.height ?? 0).clamp(0, height),
              maxHeight: height,
            ),
          ),
    );
  }

  /// Resolves bounds and attachment side using the shared placement engine.
  OverlayPlacementResult placementResult(Size size, Size childSize) =>
      _delegate.placementResult(size, childSize);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      _delegate.getConstraintsForChild(constraints);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final OverlayPlacementResult result = placementResult(size, childSize);
    onSideResolved?.call(result.side);
    return result.rect.topLeft;
  }

  @override
  bool shouldRelayout(MenuPositionDelegate oldDelegate) =>
      anchorRect != oldDelegate.anchorRect ||
      textDirection != oldDelegate.textDirection ||
      style != oldDelegate.style ||
      matchAnchorWidth != oldDelegate.matchAnchorWidth ||
      position != oldDelegate.position ||
      offset != oldDelegate.offset ||
      maxHeight != oldDelegate.maxHeight ||
      placement != oldDelegate.placement ||
      padding != oldDelegate.padding ||
      viewInsets != oldDelegate.viewInsets;
}
