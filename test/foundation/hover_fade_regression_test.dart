import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';
import 'package:neutral_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

// Transparent black is the classic trigger: blending its hidden black channels
// into a light hover color darkens the surface part-way through the fade.
const Color _idle = Color(0x00000000);
const Color _hovered = Color(0xFFF0F5F0);

final double _idleBrightness = brightnessOverWhite(_idle);
final double _hoverBrightness = brightnessOverWhite(_hovered);

ButtonStyle _rowStyle() => ButtonStyle(
  animationDuration: const Duration(milliseconds: 200),
  animationCurve: Curves.linear,
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) =>
        BoxDecoration(color: state.isHovered ? _hovered : _idle),
  ),
);

Finder _menuRow(String label) => find
    .ancestor(
      of: find.descendant(
        of: find.byType(MenuPanel),
        matching: find.text(label),
      ),
      matching: find.byType(AnimatedSurface),
    )
    .first;

/// Hovers [target], then leaves it, expecting both fades to stay smooth.
Future<void> _expectSmoothHover(
  WidgetTester tester,
  Finder target,
  Finder surface,
) async {
  final TestGesture mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await mouse.addPointer(location: Offset.zero);
  await tester.pump();
  expect(paintedColor(tester, surface), _idle);

  await mouse.moveTo(tester.getCenter(target));
  expectNoDip(
    await sampleBrightness(tester, surface),
    from: _idleBrightness,
    to: _hoverBrightness,
  );
  await tester.pumpAndSettle();
  expect(paintedColor(tester, surface), _hovered);

  await mouse.moveTo(Offset.zero);
  expectNoDip(
    await sampleBrightness(tester, surface),
    from: _hoverBrightness,
    to: _idleBrightness,
  );
  await tester.pumpAndSettle();
  expect(paintedColor(tester, surface), _idle);
  await mouse.removePointer();
}

void main() {
  testWidgets('DropdownButton rows fade without a dark flash', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      DropdownButton<String>(
        items: const <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(value: 'one', child: Text('One')),
          DropdownMenuItem<String>(value: 'two', child: Text('Two')),
        ],
        value: 'one',
        onChanged: (String? value) {},
        style: DropdownStyle(itemStyle: _rowStyle()),
      ),
    );
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await _expectSmoothHover(
      tester,
      find.descendant(of: find.byType(MenuPanel), matching: find.text('Two')),
      _menuRow('Two'),
    );
  });

  testWidgets('DropdownMenu entries fade without a dark flash', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: const <DropdownMenuEntry<int>>[
          DropdownMenuEntry<int>(value: 1, label: 'Apple'),
          DropdownMenuEntry<int>(value: 2, label: 'Banana'),
        ],
        requestFocusOnTap: true,
        style: DropdownStyle(itemStyle: _rowStyle()),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    await _expectSmoothHover(
      tester,
      find.descendant(
        of: find.byType(MenuPanel),
        matching: find.text('Banana'),
      ),
      _menuRow('Banana'),
    );
  });

  testWidgets('PopupMenuButton items fade without a dark flash', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
          PopupMenuItem<int>(value: 1, child: Text('First')),
          PopupMenuItem<int>(value: 2, child: Text('Second')),
        ],
        style: PopupMenuStyle(itemStyle: _rowStyle()),
        child: const Text('Actions'),
      ),
    );
    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
    await _expectSmoothHover(
      tester,
      find.descendant(
        of: find.byType(MenuPanel),
        matching: find.text('Second'),
      ),
      _menuRow('Second'),
    );
  });

  testWidgets('TextButton hover fades without a dark flash', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      TextButton(onPressed: () {}, style: _rowStyle(), child: const Text('Go')),
    );
    await _expectSmoothHover(
      tester,
      find.byType(TextButton),
      find.descendant(
        of: find.byType(TextButton),
        matching: find.byType(AnimatedSurface),
      ),
    );
  });

  testWidgets('Checkbox selection fades without a dark flash', (
    WidgetTester tester,
  ) async {
    bool value = false;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Checkbox(
          value: value,
          onChanged: (bool? next) => setState(() => value = next!),
          style: ToggleStyle(
            size: const StateProperty<Size?>.all(Size(20, 20)),
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.linear,
            decoration: StateProperty<Decoration?>.resolveWith(
              (InteractionState state) =>
                  BoxDecoration(color: state.isSelected ? _hovered : _idle),
            ),
          ),
        ),
      ),
    );
    final Finder box = find
        .descendant(
          of: find.byType(Checkbox),
          matching: find.byType(AnimatedSurface),
        )
        .first;
    expect(paintedColor(tester, box), _idle);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expectNoDip(
      await sampleBrightness(tester, box),
      from: _idleBrightness,
      to: _hoverBrightness,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expectNoDip(
      await sampleBrightness(tester, box),
      from: _hoverBrightness,
      to: _idleBrightness,
    );
  });
}
