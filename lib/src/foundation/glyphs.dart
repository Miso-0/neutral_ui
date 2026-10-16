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

/// A painted downward chevron, the default dropdown arrow.
///
/// Dropdowns turn it while their menu is open, so it points up when open.
class ChevronGlyph extends StatelessWidget {
  /// Creates a chevron sized and colored by the ambient icon theme.
  const ChevronGlyph({super.key, this.size, this.color});

  /// The square extent, defaulting to the icon theme size.
  final double? size;

  /// The stroke color, defaulting to the icon theme color.
  final Color? color;

  @override
  Widget build(BuildContext context) => _glyph(
    context,
    size: size,
    color: color,
    painter: (Color color) => _ChevronPainter(color),
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
  const _ChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.25, size.height * 0.38)
        ..lineTo(size.width * 0.5, size.height * 0.63)
        ..lineTo(size.width * 0.75, size.height * 0.38),
      _stroke(color, size),
    );
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) => color != oldDelegate.color;
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
