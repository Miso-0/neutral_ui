import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/src/menus/key_activators.dart';

void main() {
  test(
    'framework exposes all menu keys through default shortcut activators',
    () {
      for (final LogicalKeyboardKey key in <LogicalKeyboardKey>[
        LogicalKeyboardKey.arrowUp,
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.arrowRight,
        LogicalKeyboardKey.enter,
      ]) {
        expect(menuKeyActivator(key.keyId).trigger, key);
      }
    },
  );
  test('unsupported keys explain the SDK compatibility failure', () {
    expect(() => menuKeyActivator(-1), throwsStateError);
  });
}
