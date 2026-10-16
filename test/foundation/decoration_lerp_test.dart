import 'dart:ui' show ColorSpace;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/foundation/decoration_lerp.dart';

import '../helpers/pump.dart';

const Color _clear = Color(0x00000000);
const Color _light = Color(0xFFF0F5F0);
const Color _accent = Color(0xFF087F6D);

List<double> _steps() => <double>[
  for (int index = 0; index <= 10; index += 1) index / 10,
];

void _expectChannels(Color actual, Color expected, {double? alpha}) {
  const double tolerance = 1e-9;
  expect(actual.r, closeTo(expected.r, tolerance));
  expect(actual.g, closeTo(expected.g, tolerance));
  expect(actual.b, closeTo(expected.b, tolerance));
  expect(actual.a, closeTo(alpha ?? expected.a, tolerance));
}

void main() {
  group('lerpColorPremultiplied', () {
    test('fades from transparent black through the visible color', () {
      _expectChannels(
        lerpColorPremultiplied(_clear, _light, 0.5)!,
        _light,
        alpha: 0.5,
      );
      _expectChannels(
        lerpColorPremultiplied(_light, _clear, 0.25)!,
        _light,
        alpha: 0.75,
      );
    });

    test('Color.lerp darkens the same fade, which this replaces', () {
      final double light = brightnessOverWhite(_light);
      expect(
        brightnessOverWhite(Color.lerp(_clear, _light, 0.5)),
        lessThan(light - 0.1),
      );
    });

    test('brightness over white never leaves the endpoint range', () {
      final List<(Color, Color)> pairs = <(Color, Color)>[
        (_clear, _light),
        (_light, _clear),
        (_clear, _accent),
        (const Color(0x80FF0000), const Color(0x400000FF)),
      ];
      for (final (Color from, Color to) in pairs) {
        final double a = brightnessOverWhite(from);
        final double b = brightnessOverWhite(to);
        final double low = a < b ? a : b;
        final double high = a < b ? b : a;
        for (final double t in _steps()) {
          final double value = brightnessOverWhite(
            lerpColorPremultiplied(from, to, t),
          );
          expect(
            value,
            greaterThanOrEqualTo(low - 1e-9),
            reason: '$from $to $t',
          );
          expect(value, lessThanOrEqualTo(high + 1e-9), reason: '$from $to $t');
        }
      }
    });

    test('opaque endpoints match Color.lerp', () {
      for (final double t in _steps()) {
        _expectChannels(
          lerpColorPremultiplied(_accent, _light, t)!,
          Color.lerp(_accent, _light, t)!,
        );
      }
    });

    test('null endpoints and mixed color spaces defer to Color.lerp', () {
      expect(
        lerpColorPremultiplied(null, _light, 0.3),
        Color.lerp(null, _light, 0.3),
      );
      expect(
        lerpColorPremultiplied(_light, null, 0.3),
        Color.lerp(_light, null, 0.3),
      );
      expect(lerpColorPremultiplied(null, null, 0.3), isNull);
      const Color p3 = Color.from(
        alpha: 0,
        red: 0,
        green: 0,
        blue: 0,
        colorSpace: ColorSpace.displayP3,
      );
      expect(
        lerpColorPremultiplied(p3, _light, 0.5),
        Color.lerp(p3, _light, 0.5),
      );
    });

    test('returns exact endpoints and handles two transparent colors', () {
      expect(
        identical(lerpColorPremultiplied(_clear, _light, 0), _clear),
        isTrue,
      );
      expect(
        identical(lerpColorPremultiplied(_clear, _light, 1), _light),
        isTrue,
      );
      expect(
        lerpColorPremultiplied(_clear, const Color(0x00FFFFFF), 0.5)!.a,
        0,
      );
    });
  });

  group('lerpDecoration', () {
    test(
      'box fills fade premultiplied while geometry follows BoxDecoration',
      () {
        final BoxDecoration from = BoxDecoration(
          color: _clear,
          borderRadius: BorderRadius.circular(4),
        );
        final BoxDecoration to = BoxDecoration(
          color: _light,
          borderRadius: BorderRadius.circular(12),
        );
        final BoxDecoration result =
            lerpDecoration(from, to, 0.5)! as BoxDecoration;
        _expectChannels(result.color!, _light, alpha: 0.5);
        expect(result.borderRadius, BorderRadius.circular(8));
        expect(identical(lerpDecoration(from, to, 0), from), isTrue);
        expect(identical(lerpDecoration(from, to, 1), to), isTrue);
      },
    );

    test(
      'border colors fade premultiplied for Border and BorderDirectional',
      () {
        final BoxDecoration from = BoxDecoration(
          border: Border.all(color: _clear),
        );
        final BoxDecoration to = BoxDecoration(
          border: Border.all(color: _accent, width: 3),
        );
        final Border border =
            (lerpDecoration(from, to, 0.5)! as BoxDecoration).border! as Border;
        _expectChannels(border.top.color, _accent, alpha: 0.5);
        expect(border.left.width, 2);

        const BoxDecoration start = BoxDecoration(
          border: BorderDirectional(start: BorderSide(color: _clear)),
        );
        const BoxDecoration end = BoxDecoration(
          border: BorderDirectional(start: BorderSide(color: _accent)),
        );
        final BorderDirectional directional =
            (lerpDecoration(start, end, 0.5)! as BoxDecoration).border!
                as BorderDirectional;
        _expectChannels(directional.start.color, _accent, alpha: 0.5);
      },
    );

    test('a side appearing from BorderStyle.none keeps its own hue', () {
      const BoxDecoration from = BoxDecoration(
        border: Border(
          top: BorderSide(color: _light, style: BorderStyle.none),
        ),
      );
      const BoxDecoration to = BoxDecoration(
        border: Border(top: BorderSide(color: _accent)),
      );
      final Border border =
          (lerpDecoration(from, to, 0.5)! as BoxDecoration).border! as Border;
      expect(
        brightnessOverWhite(border.top.color),
        greaterThanOrEqualTo(brightnessOverWhite(_accent) - 1e-9),
      );
    });

    test('matching shadows fade premultiplied; mismatched lists fall back', () {
      const BoxDecoration from = BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(color: _clear, blurRadius: 4)],
      );
      const BoxDecoration to = BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(color: _accent, blurRadius: 8)],
      );
      final BoxShadow shadow =
          (lerpDecoration(from, to, 0.5)! as BoxDecoration).boxShadow!.single;
      _expectChannels(shadow.color, _accent, alpha: 0.5);
      expect(shadow.blurRadius, 6);

      const BoxDecoration two = BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: _accent),
          BoxShadow(color: _light),
        ],
      );
      expect(
        (lerpDecoration(from, two, 0.5)! as BoxDecoration).boxShadow,
        BoxDecoration.lerp(from, two, 0.5)!.boxShadow,
      );
    });

    test('other decoration pairs use Decoration.lerp', () {
      const BoxDecoration box = BoxDecoration(color: _light);
      const ShapeDecoration shape = ShapeDecoration(
        color: _accent,
        shape: StadiumBorder(),
      );
      expect(lerpDecoration(box, shape, 0.5), Decoration.lerp(box, shape, 0.5));
      expect(lerpDecoration(null, box, 0.5), Decoration.lerp(null, box, 0.5));
      expect(lerpDecoration(box, null, 0.5), Decoration.lerp(box, null, 0.5));
      const BoxDecoration gradient = BoxDecoration(
        gradient: LinearGradient(colors: <Color>[_clear, _light]),
      );
      expect(
        (lerpDecoration(box, gradient, 0.5)! as BoxDecoration).gradient,
        BoxDecoration.lerp(box, gradient, 0.5)!.gradient,
      );
    });
  });
}
