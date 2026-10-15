import 'package:flutter/widgets.dart';

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

  /// An additional displacement from the anchor.
  final Offset offset;

  /// A widget-level maximum height override.
  final double? maxHeight;

  EdgeInsets get _edges => style.edgePadding ?? EdgeInsets.zero;
  double get _top =>
      (position == PopupMenuPosition.under
          ? anchorRect.bottom
          : anchorRect.top) +
      offset.dy;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final Size size = constraints.biggest;
    final double width = (size.width - _edges.horizontal).clamp(
      0,
      double.infinity,
    );
    final double below = (size.height - _edges.bottom - _top).clamp(
      0,
      double.infinity,
    );
    final double above = (anchorRect.top + offset.dy - _edges.top).clamp(
      0,
      double.infinity,
    );
    final double available = below > above ? below : above;
    final double height = available.clamp(
      0,
      (size.height - _edges.vertical).clamp(0, double.infinity),
    );
    final double panelWidth = (style.maximumSize?.width ?? double.infinity)
        .clamp(0, width);
    final double panelHeight =
        (maxHeight ?? style.maximumSize?.height ?? double.infinity).clamp(
          0,
          height,
        );
    final double minimumWidth = style.minimumSize?.width ?? 0;
    final double anchorWidth = (style.matchAnchorWidth ?? matchAnchorWidth)
        ? anchorRect.width
        : 0;
    return BoxConstraints(
      minWidth: (minimumWidth > anchorWidth ? minimumWidth : anchorWidth).clamp(
        0,
        panelWidth,
      ),
      maxWidth: panelWidth,
      minHeight: (style.minimumSize?.height ?? 0).clamp(0, panelHeight),
      maxHeight: panelHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double left = _edges.left.clamp(0, size.width);
    final double top = _edges.top.clamp(0, size.height);
    final double right = (size.width - _edges.right - childSize.width).clamp(
      left,
      size.width,
    );
    final double bottom = (size.height - _edges.bottom - childSize.height)
        .clamp(top, size.height);
    final double x =
        (textDirection == TextDirection.ltr
            ? anchorRect.left
            : anchorRect.right - childSize.width) +
        offset.dx;
    double y = _top;
    if (y + childSize.height > size.height - _edges.bottom) {
      y = anchorRect.top + offset.dy - childSize.height;
    }
    return Offset(x.clamp(left, right), y.clamp(top, bottom));
  }

  @override
  bool shouldRelayout(MenuPositionDelegate oldDelegate) =>
      anchorRect != oldDelegate.anchorRect ||
      textDirection != oldDelegate.textDirection ||
      style != oldDelegate.style ||
      matchAnchorWidth != oldDelegate.matchAnchorWidth ||
      position != oldDelegate.position ||
      offset != oldDelegate.offset ||
      maxHeight != oldDelegate.maxHeight;
}
