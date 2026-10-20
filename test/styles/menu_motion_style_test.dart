import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

void main() {
  void token<T>(
    String name,
    T first,
    T second,
    MenuStyle Function(T) create,
    T? Function(MenuStyle) read,
    MenuStyle Function(MenuStyle, T?) copy,
  ) {
    test('MenuStyle $name participates in the complete token contract', () {
      const MenuStyle empty = MenuStyle();
      final MenuStyle local = create(first);
      final MenuStyle inherited = create(second);
      expect(read(empty), isNull);
      expect(read(local), first);
      expect(copy(local, second), inherited);
      expect(copy(local, null), local);
      expect(empty.merge(local), local);
      expect(local.merge(inherited), local);
      expect(local.merge(null), same(local));
      expect(local, create(first));
      expect(local.hashCode, create(first).hashCode);
      expect(local, isNot(inherited));
      expect(local.toString(), contains('$name: $first'));
    });
  }

  token<OverlayPlacement>(
    'placement',
    const OverlayPlacement(gap: 4),
    const OverlayPlacement(preferredSide: AxisDirection.up),
    (OverlayPlacement value) => MenuStyle(placement: value),
    (MenuStyle style) => style.placement,
    (MenuStyle style, OverlayPlacement? value) =>
        style.copyWith(placement: value),
  );
  token<OverlayLocation>(
    'overlayLocation',
    OverlayLocation.root,
    OverlayLocation.nearest,
    (OverlayLocation value) => MenuStyle(overlayLocation: value),
    (MenuStyle style) => style.overlayLocation,
    (MenuStyle style, OverlayLocation? value) =>
        style.copyWith(overlayLocation: value),
  );
  token<OutsideTapBehavior>(
    'outsideTapBehavior',
    OutsideTapBehavior.consume,
    OutsideTapBehavior.passThrough,
    (OutsideTapBehavior value) => MenuStyle(outsideTapBehavior: value),
    (MenuStyle style) => style.outsideTapBehavior,
    (MenuStyle style, OutsideTapBehavior? value) =>
        style.copyWith(outsideTapBehavior: value),
  );
  token<Duration>(
    'reverseTransitionDuration',
    const Duration(milliseconds: 25),
    const Duration(milliseconds: 50),
    (Duration value) => MenuStyle(reverseTransitionDuration: value),
    (MenuStyle style) => style.reverseTransitionDuration,
    (MenuStyle style, Duration? value) =>
        style.copyWith(reverseTransitionDuration: value),
  );
  token<Curve>(
    'reverseTransitionCurve',
    Curves.linear,
    Curves.easeInOutCubic,
    (Curve value) => MenuStyle(reverseTransitionCurve: value),
    (MenuStyle style) => style.reverseTransitionCurve,
    (MenuStyle style, Curve? value) =>
        style.copyWith(reverseTransitionCurve: value),
  );
}
