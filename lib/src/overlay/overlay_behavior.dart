/// Whether dismissing an overlay also activates the control underneath it.
enum OutsideTapBehavior {
  /// Dismiss the overlay and let the pointer reach the underlying control.
  passThrough,

  /// Dismiss the overlay and consume the outside pointer gesture.
  consume,
}

/// The overlay in which an anchored panel is displayed.
enum OverlayLocation {
  /// Use the closest enclosing overlay.
  nearest,

  /// Use the outermost enclosing overlay.
  root,
}
