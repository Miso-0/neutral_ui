import 'package:flutter/widgets.dart';

import 'overlay_behavior.dart';

/// Converts view padding and obscuring insets to the target overlay's bounds.
///
/// Insets that do not intersect a smaller, offset overlay contribute no space.
/// Read the target overlay's media query so padding consumed around the anchor
/// does not hide the root overlay's safe-area information.
({EdgeInsets padding, EdgeInsets viewInsets}) overlayInsetsFor(
  BuildContext context, {
  required Size overlaySize,
  required OverlayLocation overlayLocation,
}) {
  final OverlayState overlay = Overlay.of(
    context,
    rootOverlay: overlayLocation == OverlayLocation.root,
  );
  final MediaQueryData? media = MediaQuery.maybeOf(overlay.context);
  if (media == null) {
    return (padding: EdgeInsets.zero, viewInsets: EdgeInsets.zero);
  }
  final RenderObject? object = overlay.context.findRenderObject();
  if (object == null || !object.attached) {
    return (padding: media.padding, viewInsets: media.viewInsets);
  }
  final Size viewport = media.size.isEmpty
      ? View.of(context).physicalSize / View.of(context).devicePixelRatio
      : media.size;
  final Matrix4 transform = object.getTransformTo(null);
  EdgeInsets localInsets(EdgeInsets insets) {
    final Rect available = MatrixUtils.inverseTransformRect(
      transform,
      Rect.fromLTRB(
        insets.left,
        insets.top,
        viewport.width - insets.right,
        viewport.height - insets.bottom,
      ),
    );
    return EdgeInsets.fromLTRB(
      available.left.clamp(0, overlaySize.width),
      available.top.clamp(0, overlaySize.height),
      (overlaySize.width - available.right).clamp(0, overlaySize.width),
      (overlaySize.height - available.bottom).clamp(0, overlaySize.height),
    );
  }

  return (
    padding: localInsets(media.padding),
    viewInsets: localInsets(media.viewInsets),
  );
}
