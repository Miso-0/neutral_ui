import 'package:flutter/widgets.dart';

/// Interpolates two colors in premultiplied-alpha space.
///
/// [Color.lerp] blends each channel independently, so a fade from a fully
/// transparent color takes on that color's hidden channels along the way. A
/// fade from `Color(0x00000000)` to a light color therefore darkens before it
/// brightens. Weighting each channel by its alpha, as CSS transitions do,
/// fades through the visible color instead.
///
/// A null endpoint, or endpoints in different color spaces, use [Color.lerp].
Color? lerpColorPremultiplied(Color? a, Color? b, double t) {
  if (a == null || b == null || a.colorSpace != b.colorSpace) {
    return Color.lerp(a, b, t);
  }
  if (t == 0) return a;
  if (t == 1) return b;
  final double alpha = (a.a + (b.a - a.a) * t).clamp(0.0, 1.0);
  if (alpha == 0) {
    return Color.from(
      alpha: 0,
      red: b.r,
      green: b.g,
      blue: b.b,
      colorSpace: b.colorSpace,
    );
  }
  double channel(double from, double to) =>
      ((from * a.a + (to * b.a - from * a.a) * t) / alpha).clamp(0.0, 1.0);
  return Color.from(
    alpha: alpha,
    red: channel(a.r, b.r),
    green: channel(a.g, b.g),
    blue: channel(a.b, b.b),
    colorSpace: b.colorSpace,
  );
}

/// Interpolates two decorations without dark fringes from transparent colors.
///
/// Pairs of [BoxDecoration]s use [BoxDecoration.lerp] for geometry and
/// [lerpColorPremultiplied] for the fill, matching border sides and matching
/// shadows. A null decoration, border or shadow list fades through a
/// transparent copy of the other endpoint, so shapes and radii stay put while
/// colors fade. A [ShapeDecoration] with an [OutlinedBorder] fades the same way
/// against null. Every other pair, including gradients, uses [Decoration.lerp].
Decoration? lerpDecoration(Decoration? a, Decoration? b, double t) {
  if (t == 0) return a;
  if (t == 1 || a == b) return b;
  final Decoration? from = a ?? _transparent(b);
  final Decoration? to = b ?? _transparent(a);
  if (from is ShapeDecoration &&
      to is ShapeDecoration &&
      (a == null || b == null)) {
    return ShapeDecoration.lerp(from, to, t);
  }
  if (from is! BoxDecoration || to is! BoxDecoration) {
    return Decoration.lerp(a, b, t);
  }
  final BoxDecoration? result = BoxDecoration.lerp(from, to, t);
  if (result == null) return null;
  return result.copyWith(
    color: lerpColorPremultiplied(from.color, to.color, t),
    border: _lerpBorder(from.border, to.border, t),
    boxShadow: _lerpShadows(from.boxShadow, to.boxShadow, t),
  );
}

/// Returns [decoration] with every color made transparent, or null when it
/// cannot be faded that way.
Decoration? _transparent(Decoration? decoration) {
  if (decoration is BoxDecoration) {
    return BoxDecoration(
      color: decoration.color?.withAlpha(0),
      border: _transparentBorder(decoration.border),
      borderRadius: decoration.borderRadius,
      boxShadow: decoration.boxShadow?.map(_transparentShadow).toList(),
      gradient: decoration.gradient?.scale(0),
      backgroundBlendMode: decoration.backgroundBlendMode,
      shape: decoration.shape,
    );
  }
  if (decoration is ShapeDecoration) {
    final ShapeBorder shape = decoration.shape;
    if (shape is! OutlinedBorder) return null;
    return ShapeDecoration(
      color: decoration.color?.withAlpha(0),
      gradient: decoration.gradient?.scale(0),
      shadows: decoration.shadows?.map(_transparentShadow).toList(),
      shape: shape.copyWith(side: _transparentSide(shape.side)),
    );
  }
  return null;
}

BoxBorder? _transparentBorder(BoxBorder? border) => switch (border) {
  final Border border => Border(
    top: _transparentSide(border.top),
    right: _transparentSide(border.right),
    bottom: _transparentSide(border.bottom),
    left: _transparentSide(border.left),
  ),
  final BorderDirectional border => BorderDirectional(
    top: _transparentSide(border.top),
    start: _transparentSide(border.start),
    end: _transparentSide(border.end),
    bottom: _transparentSide(border.bottom),
  ),
  _ => null,
};

// The width starts at zero so the layout inset grows continuously.
BorderSide _transparentSide(BorderSide side) =>
    side.copyWith(color: side.color.withAlpha(0), width: 0);

BoxShadow _transparentShadow(BoxShadow shadow) => BoxShadow(
  color: shadow.color.withAlpha(0),
  offset: shadow.offset,
  blurRadius: shadow.blurRadius,
  spreadRadius: shadow.spreadRadius,
  blurStyle: shadow.blurStyle,
);

BoxBorder? _lerpBorder(BoxBorder? a, BoxBorder? b, double t) {
  a ??= _transparentBorder(b);
  b ??= _transparentBorder(a);
  if (a is Border && b is Border) {
    return Border(
      top: _lerpSide(a.top, b.top, t),
      right: _lerpSide(a.right, b.right, t),
      bottom: _lerpSide(a.bottom, b.bottom, t),
      left: _lerpSide(a.left, b.left, t),
    );
  }
  if (a is BorderDirectional && b is BorderDirectional) {
    return BorderDirectional(
      top: _lerpSide(a.top, b.top, t),
      start: _lerpSide(a.start, b.start, t),
      end: _lerpSide(a.end, b.end, t),
      bottom: _lerpSide(a.bottom, b.bottom, t),
    );
  }
  return null;
}

BorderSide _lerpSide(BorderSide a, BorderSide b, double t) {
  final BorderSide result = BorderSide.lerp(a, b, t);
  if (result == BorderSide.none) return result;
  final Color from = a.style == BorderStyle.none
      ? a.color.withAlpha(0)
      : a.color;
  final Color to = b.style == BorderStyle.none ? b.color.withAlpha(0) : b.color;
  return result.copyWith(color: lerpColorPremultiplied(from, to, t));
}

List<BoxShadow>? _lerpShadows(
  List<BoxShadow>? a,
  List<BoxShadow>? b,
  double t,
) {
  a ??= b?.map(_transparentShadow).toList();
  b ??= a?.map(_transparentShadow).toList();
  if (a == null || b == null || a.length != b.length) return null;
  return <BoxShadow>[
    for (int index = 0; index < a.length; index += 1)
      _lerpShadow(a[index], b[index], t),
  ];
}

BoxShadow _lerpShadow(BoxShadow a, BoxShadow b, double t) {
  final BoxShadow shadow = BoxShadow.lerp(a, b, t)!;
  return BoxShadow(
    color: lerpColorPremultiplied(a.color, b.color, t)!,
    offset: shadow.offset,
    blurRadius: shadow.blurRadius,
    spreadRadius: shadow.spreadRadius,
    blurStyle: shadow.blurStyle,
  );
}
