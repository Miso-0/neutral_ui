import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

const Color _idle = Color(0xFFFFFFFF);
const Color _hovered = Color(0xFF087F6D);

StateProperty<Decoration?> get _decoration =>
    StateProperty<Decoration?>.resolveWith(
      (InteractionState state) =>
          BoxDecoration(color: state.isHovered ? _hovered : _idle),
    );

Widget _reduced(Widget child) => Builder(
  builder: (BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child,
  ),
);

/// Whether a box under [finder] paints [color] right now.
bool _paints(WidgetTester tester, Finder finder, Color color) => tester
    .widgetList<DecoratedBox>(
      find.descendant(of: finder, matching: find.byType(DecoratedBox)),
    )
    .any(
      (DecoratedBox box) =>
          box.decoration is BoxDecoration &&
          (box.decoration as BoxDecoration).color == color,
    );

void main() {
  final Map<String, Widget> controls = <String, Widget>{
    'button': TextButton(
      onPressed: () {},
      style: ButtonStyle(decoration: _decoration),
      child: const Text('Button'),
    ),
    'list tile': SizedBox(
      width: 200,
      child: ListTile(
        onTap: () {},
        style: ListTileStyle(decoration: _decoration),
        title: const Text('Tile'),
      ),
    ),
    'checkbox': Checkbox(
      value: false,
      onChanged: (bool? value) {},
      style: ToggleStyle(decoration: _decoration),
    ),
    'slider': Slider(
      value: 0.5,
      onChanged: (double value) {},
      style: SliderStyle(thumbDecoration: _decoration),
    ),
  };
  for (final MapEntry<String, Widget> control in controls.entries) {
    testWidgets('${control.key} hover is immediate under reduced motion', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(tester, _reduced(control.value));
      final Finder target = find.byWidget(control.value);
      expect(_paints(tester, target, _idle), isTrue);
      final TestGesture mouse = await hover(tester, target);
      expect(_paints(tester, target, _hovered), isTrue);
      await mouse.removePointer();
    });
  }

  testWidgets('dropdown arrow turns immediately under reduced motion', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      _reduced(
        DropdownButton<String>(
          value: 'one',
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'one', child: Text('One')),
          ],
          onChanged: (String? value) {},
        ),
      ),
    );
    expect(
      tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).duration,
      Duration.zero,
    );
  });
}
