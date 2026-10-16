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
/// shadows. Every other pair, including gradients, uses [Decoration.lerp].
Decoration? lerpDecoration(Decoration? a, Decoration? b, double t) {
  if (a is! BoxDecoration || b is! BoxDecoration) {
    return Decoration.lerp(a, b, t);
  }
  if (t == 0) return a;
  if (t == 1) return b;
  final BoxDecoration? result = BoxDecoration.lerp(a, b, t);
  if (result == null) return null;
  return result.copyWith(
    color: lerpColorPremultiplied(a.color, b.color, t),
    border: _lerpBorder(a.border, b.border, t),
    boxShadow: _lerpShadows(a.boxShadow, b.boxShadow, t),
  );
}

BoxBorder? _lerpBorder(BoxBorder? a, BoxBorder? b, double t) {
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
