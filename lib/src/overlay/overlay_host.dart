import '../foundation/interaction_detector.dart';
import 'overlay_behavior.dart';
import 'overlay_insets.dart';
import 'overlay_placement.dart';

import 'package:flutter/widgets.dart';

/// A lightweight anchored overlay that leaves focus and shortcuts to its caller.
///
/// The caller owns visibility through [controller] and any enter or exit
/// animation. A shared [tapRegionGroupId] can join nested anchors and panels
/// into one outside-tap group. A [TapRegionSurface] must enclose the target
/// overlay when [onTapOutside] is used, as it does in [WidgetsApp].
class OverlayHost extends StatelessWidget {
  /// Creates an anchored overlay, targeting the root overlay by default.
  const OverlayHost({
    super.key,
    required this.controller,
    required this.overlayBuilder,
    required this.child,
    this.placement = const OverlayPlacement(),
    this.overlayLocation = OverlayLocation.root,
    this.outsideTapBehavior = OutsideTapBehavior.passThrough,
    this.onTapOutside,
    this.tapRegionGroupId,
    this.onSideResolved,
  });

  /// Controls whether the panel is visible.
  final OverlayPortalController controller;

  /// Builds the unpositioned panel in the anchor's inherited context.
  final WidgetBuilder overlayBuilder;

  /// The anchor whose layout bounds position the panel.
  final Widget child;

  /// The placement policy used for the panel.
  final OverlayPlacement placement;

  /// The overlay in which the panel appears.
  final OverlayLocation overlayLocation;

  /// Whether an outside pointer gesture also reaches underlying controls.
  final OutsideTapBehavior outsideTapBehavior;

  /// Called when a pointer is pressed outside the anchor and panel group.
  final TapRegionCallback? onTapOutside;

  /// An optional group shared by nested anchors and panels.
  final Object? tapRegionGroupId;

  /// Receives the selected side during layout, without triggering a rebuild.
  final ValueChanged<AxisDirection>? onSideResolved;

  @override
  Widget build(BuildContext context) {
    final Object groupId = tapRegionGroupId ?? controller;
    // Read inherited layout data before entering the portal's layout callback.
    final TextDirection direction = Directionality.of(context);
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: controller,
      overlayLocation: overlayLocation == OverlayLocation.root
          ? OverlayChildLocation.rootOverlay
          : OverlayChildLocation.nearestOverlay,
      overlayChildBuilder: (BuildContext context, OverlayChildLayoutInfo info) {
        final ({EdgeInsets padding, EdgeInsets viewInsets}) insets =
            overlayInsetsFor(
              context,
              overlaySize: info.overlaySize,
              overlayLocation: overlayLocation,
            );
        final Rect anchor = MatrixUtils.transformRect(
          info.childPaintTransform,
          Offset.zero & info.childSize,
        );
        return Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: OverlayPositionDelegate(
              anchorRect: anchor,
              textDirection: direction,
              placement: placement,
              padding: insets.padding,
              viewInsets: insets.viewInsets,
              onSideResolved: onSideResolved,
            ),
            child: TapRegion(
              groupId: groupId,
              behavior: HitTestBehavior.opaque,
              onTapOutside: onTapOutside,
              consumeOutsideTaps:
                  outsideTapBehavior == OutsideTapBehavior.consume,
              child: RepaintBoundary(
                child: InteractionBoundary(
                  inherit: false,
                  child: overlayBuilder(context),
                ),
              ),
            ),
          ),
        );
      },
      child: TapRegion(
        groupId: groupId,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}
