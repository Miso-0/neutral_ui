import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// A favorite action with a controlled selected state.
class FavoriteIconButtonExample extends StatefulWidget {
  /// Creates the favorite icon button example.
  const FavoriteIconButtonExample({super.key});
  @override
  State<FavoriteIconButtonExample> createState() =>
      _FavoriteIconButtonExampleState();
}

class _FavoriteIconButtonExampleState extends State<FavoriteIconButtonExample> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: Wrap(
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        IconButton(
          style: _button().copyWith(
            padding: const StateProperty<EdgeInsetsGeometry?>.all(
              EdgeInsets.all(10),
            ),
          ),
          icon: const SizedBox.square(
            dimension: 20,
            child: CustomPaint(painter: _StarPainter()),
          ),
          selectedIcon: const SizedBox.square(
            dimension: 20,
            child: CustomPaint(painter: _StarPainter(filled: true)),
          ),
          isSelected: _selected,
          tooltip: 'Favorite',
          onPressed: () => setState(() => _selected = !_selected),
        ),
        Text(_selected ? 'Favorited' : 'Add to favorites'),
      ],
    ),
  );
}

ButtonStyle _button({bool solid = false}) => ButtonStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => _surface(state, solid: solid),
  ),
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 18, vertical: 13),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  spacing: 9,
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      size: 16,
    ),
  ),
);

class _StarPainter extends CustomPainter {
  const _StarPainter({this.filled = false});

  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    const List<Offset> points = <Offset>[
      Offset(0.5, 0.04),
      Offset(0.64, 0.34),
      Offset(0.97, 0.39),
      Offset(0.73, 0.63),
      Offset(0.79, 0.96),
      Offset(0.5, 0.8),
      Offset(0.21, 0.96),
      Offset(0.27, 0.63),
      Offset(0.03, 0.39),
      Offset(0.36, 0.34),
    ];
    final Path path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    path.close();
    final Paint paint = Paint()
      ..color = _ink
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => filled != oldDelegate.filled;
}

Decoration _surface(InteractionState state, {bool solid = false}) =>
    BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : solid
          ? (state.isPressed
                ? const Color(0xFF065F53)
                : state.isHovered
                ? const Color(0xFF0A927E)
                : _accent)
          : (state.isPressed
                ? const Color(0xFFD5EAE0)
                : state.isHovered
                ? const Color(0xFFE9F2EB)
                : const Color(0xFFFFFFFF)),
      borderRadius: BorderRadius.circular(12),
      // A constant border width keeps content still; focus adds a ring.
      border: Border.all(
        color: state.isFocused
            ? _accent
            : solid
            ? const Color(0x00000000)
            : _line,
      ),
      boxShadow: state.isFocused ? _focusRing : null,
    );
