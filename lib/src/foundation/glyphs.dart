import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints a glyph in the ambient [IconTheme], exactly as an [Icon] would.
///
/// Size defaults to the icon theme size, color to the icon theme color, and
/// the icon theme opacity always applies. Glyphs are decorative and excluded
/// from semantics.
Widget _glyph(
  BuildContext context, {
  required double? size,
  required Color? color,
  required CustomPainter Function(Color color) painter,
}) {
  final IconThemeData theme = IconTheme.of(context);
  final double extent = size ?? theme.size ?? 24;
  final double opacity = theme.opacity ?? 1;
  Color paint = color ?? theme.color ?? const Color(0xFF000000);
  if (opacity != 1) {
    paint = paint.withValues(alpha: paint.a * opacity);
  }
  return ExcludeSemantics(
    child: SizedBox.square(
      dimension: extent,
      child: CustomPaint(painter: painter(paint)),
    ),
  );
}

Paint _stroke(Color color, Size size) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = size.shortestSide / 12 < 1 ? 1 : size.shortestSide / 12
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

/// Physical or reading-direction-relative directions for painted glyphs.
enum GlyphDirection {
  /// Toward the top edge.
  up,

  /// Toward the bottom edge.
  down,

  /// Toward the physical left edge.
  left,

  /// Toward the physical right edge.
  right,

  /// Toward the leading edge in the ambient text direction.
  start,

  /// Toward the trailing edge in the ambient text direction.
  end,
}

GlyphDirection _physicalDirection(
  BuildContext context,
  GlyphDirection direction,
) {
  if (direction != GlyphDirection.start && direction != GlyphDirection.end) {
    return direction;
  }
  final bool rtl = Directionality.of(context) == TextDirection.rtl;
  return switch (direction) {
    GlyphDirection.start => rtl ? GlyphDirection.right : GlyphDirection.left,
    GlyphDirection.end => rtl ? GlyphDirection.left : GlyphDirection.right,
    _ => direction,
  };
}

/// A painted directional chevron, the default dropdown arrow.
///
/// Dropdowns turn it while their menu is open, so it points up when open.
class ChevronGlyph extends StatelessWidget {
  /// Creates a chevron sized and colored by the ambient icon theme.
  const ChevronGlyph({
    super.key,
    this.direction = GlyphDirection.down,
    this.size,
    this.color,
  });

  /// The pointing direction, including reading-direction-relative edges.
  final GlyphDirection direction;

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) =>
        _ChevronPainter(color, _physicalDirection(context, direction)),
  );
}

/// A painted check mark, the default selected and checked option indicator.
class CheckGlyph extends StatelessWidget {
  /// Creates a check mark sized and colored by the ambient icon theme.
  const CheckGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _CheckPainter(color),
  );
}

/// Three painted dots, the default button loading indicator.
class DotsGlyph extends StatelessWidget {
  /// Creates three dots sized and colored by the ambient icon theme.
  const DotsGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The fill color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _DotsPainter(color),
  );
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter(this.color, this.direction);

  final Color color;
  final GlyphDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(switch (direction) {
      GlyphDirection.up => math.pi,
      GlyphDirection.left => math.pi / 2,
      GlyphDirection.right => -math.pi / 2,
      _ => 0,
    });
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.25, size.height * 0.38)
        ..lineTo(size.width * 0.5, size.height * 0.63)
        ..lineTo(size.width * 0.75, size.height * 0.38),
      _stroke(color, size),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) =>
      color != oldDelegate.color || direction != oldDelegate.direction;
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.2, size.height * 0.52)
        ..lineTo(size.width * 0.41, size.height * 0.72)
        ..lineTo(size.width * 0.8, size.height * 0.3),
      _stroke(color, size),
    );
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => color != oldDelegate.color;
}

class _DotsPainter extends CustomPainter {
  const _DotsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..color = color;
    final double radius = size.shortestSide * 0.08;
    for (final double x in <double>[0.25, 0.5, 0.75]) {
      canvas.drawCircle(
        Offset(size.width * x, size.height * 0.5),
        radius,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => color != oldDelegate.color;
}

/// A painted close cross using the ambient icon theme.
class CloseGlyph extends StatelessWidget {
  /// Creates a close cross sized and colored by the ambient icon theme.
  const CloseGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _SymbolPainter(color, _Symbol.close),
  );
}

/// A painted search magnifier using the ambient icon theme.
class SearchGlyph extends StatelessWidget {
  /// Creates a search magnifier sized and colored by the ambient icon theme.
  const SearchGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _SymbolPainter(color, _Symbol.search),
  );
}

/// A painted calendar using the ambient icon theme.
class CalendarGlyph extends StatelessWidget {
  /// Creates a calendar sized and colored by the ambient icon theme.
  const CalendarGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _SymbolPainter(color, _Symbol.calendar),
  );
}

/// A painted clock using the ambient icon theme.
class ClockGlyph extends StatelessWidget {
  /// Creates a clock sized and colored by the ambient icon theme.
  const ClockGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _SymbolPainter(color, _Symbol.clock),
  );
}

/// A painted edit pencil using the ambient icon theme.
class EditGlyph extends StatelessWidget {
  /// Creates a edit pencil sized and colored by the ambient icon theme.
  const EditGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _SymbolPainter(color, _Symbol.edit),
  );
}

/// A painted directional arrow using the ambient icon theme.
class ArrowGlyph extends StatelessWidget {
  /// Creates a directional arrow sized and colored by the ambient icon theme.
  const ArrowGlyph({
    super.key,
    this.size,
    this.color,
    this.direction = GlyphDirection.end,
  });

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  /// The pointing direction, including reading-direction-relative edges.
  final GlyphDirection direction;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _SymbolPainter(
      color,
      _Symbol.arrow,
      direction: _physicalDirection(context, direction),
    ),
  );
}

/// A painted password visibility indicator using the ambient icon theme.
class EyeGlyph extends StatelessWidget {
  /// Creates an eye, optionally crossed out to indicate concealed content.
  const EyeGlyph({super.key, this.size, this.color, this.obscured = false});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  /// Whether to cross out the eye.
  final bool obscured;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) =>
        _SymbolPainter(color, obscured ? _Symbol.eyeOff : _Symbol.eye),
  );
}

enum _Symbol { close, search, calendar, clock, edit, arrow, eye, eyeOff }

class _SymbolPainter extends CustomPainter {
  const _SymbolPainter(
    this.color,
    this.symbol, {
    this.direction = GlyphDirection.down,
  });

  final Color color;
  final _Symbol symbol;
  final GlyphDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = _stroke(color, size);
    final Path path = Path();
    canvas.save();
    canvas.scale(size.width, size.height);
    // The path uses a unit square; keep the stroke in physical icon units.
    stroke.strokeWidth /= size.shortestSide == 0 ? 1 : size.shortestSide;
    switch (symbol) {
      case _Symbol.close:
        path
          ..moveTo(0.25, 0.25)
          ..lineTo(0.75, 0.75)
          ..moveTo(0.75, 0.25)
          ..lineTo(0.25, 0.75);
      case _Symbol.search:
        path
          ..addOval(const Rect.fromLTWH(0.17, 0.17, 0.48, 0.48))
          ..moveTo(0.59, 0.59)
          ..lineTo(0.82, 0.82);
      case _Symbol.calendar:
        path
          ..addRRect(
            RRect.fromRectAndRadius(
              const Rect.fromLTWH(0.18, 0.25, 0.64, 0.57),
              const Radius.circular(0.06),
            ),
          )
          ..moveTo(0.18, 0.43)
          ..lineTo(0.82, 0.43)
          ..moveTo(0.34, 0.16)
          ..lineTo(0.34, 0.33)
          ..moveTo(0.66, 0.16)
          ..lineTo(0.66, 0.33)
          ..moveTo(0.34, 0.58)
          ..lineTo(0.4, 0.58)
          ..moveTo(0.59, 0.58)
          ..lineTo(0.65, 0.58)
          ..moveTo(0.34, 0.71)
          ..lineTo(0.4, 0.71);
      case _Symbol.clock:
        path
          ..addOval(const Rect.fromLTWH(0.15, 0.15, 0.7, 0.7))
          ..moveTo(0.5, 0.29)
          ..lineTo(0.5, 0.5)
          ..lineTo(0.66, 0.6);
      case _Symbol.edit:
        path
          ..moveTo(0.2, 0.8)
          ..lineTo(0.25, 0.6)
          ..lineTo(0.66, 0.19)
          ..quadraticBezierTo(0.7, 0.15, 0.74, 0.19)
          ..lineTo(0.81, 0.26)
          ..quadraticBezierTo(0.85, 0.3, 0.81, 0.34)
          ..lineTo(0.4, 0.75)
          ..close()
          ..moveTo(0.59, 0.26)
          ..lineTo(0.74, 0.41);
      case _Symbol.eye:
      case _Symbol.eyeOff:
        path
          ..moveTo(0.1, 0.5)
          ..cubicTo(0.3, 0.13, 0.7, 0.13, 0.9, 0.5)
          ..cubicTo(0.7, 0.87, 0.3, 0.87, 0.1, 0.5)
          ..close()
          ..addOval(const Rect.fromLTWH(0.38, 0.38, 0.24, 0.24));
        if (symbol == _Symbol.eyeOff) {
          path
            ..moveTo(0.15, 0.15)
            ..lineTo(0.85, 0.85);
        }
      case _Symbol.arrow:
        canvas.translate(0.5, 0.5);
        canvas.rotate(switch (direction) {
          GlyphDirection.up => math.pi,
          GlyphDirection.left => math.pi / 2,
          GlyphDirection.right => -math.pi / 2,
          _ => 0,
        });
        canvas.translate(-0.5, -0.5);
        path
          ..moveTo(0.5, 0.18)
          ..lineTo(0.5, 0.8)
          ..moveTo(0.25, 0.55)
          ..lineTo(0.5, 0.8)
          ..lineTo(0.75, 0.55);
    }
    canvas.drawPath(path, stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SymbolPainter oldDelegate) =>
      color != oldDelegate.color ||
      symbol != oldDelegate.symbol ||
      direction != oldDelegate.direction;
}
