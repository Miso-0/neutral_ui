import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('checkbox cycles false, true, null, false when tristate', (
    WidgetTester tester,
  ) async {
    bool? value = false;
    final List<bool?> changes = <bool?>[];
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Checkbox(
          value: value,
          tristate: true,
          onChanged: (bool? next) {
            changes.add(next);
            setState(() {
              value = next;
            });
          },
        ),
      ),
    );
    for (int index = 0; index < 3; index += 1) {
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
    }
    expect(changes, <bool?>[true, null, false]);
  });

  testWidgets(
    'two-state checkbox requests false from true and stays controlled',
    (WidgetTester tester) async {
      bool? requested;
      await pumpPure(
        tester,
        Checkbox(value: true, onChanged: (bool? next) => requested = next),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(requested, isFalse);
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    },
  );

  testWidgets('checkbox defaults to a 48 square and corners are interactive', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    await pumpPure(
      tester,
      Checkbox(value: false, onChanged: (bool? next) => calls += 1),
    );
    expect(tester.getSize(find.byType(Checkbox)), const Size(48.0, 48.0));
    await tester.tapAt(
      tester.getTopLeft(find.byType(Checkbox)) + const Offset(1.0, 1.0),
    );
    expect(calls, 1);
  });

  testWidgets('disabled checkbox has checked semantics without a tap action', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpPure(
      tester,
      const Checkbox(value: true, onChanged: null, semanticLabel: 'Choice'),
    );
    await tester.tap(find.byType(Checkbox));
    expect(
      tester.getSemantics(find.byType(Checkbox)),
      isSemantics(
        label: 'Choice',
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
      ),
    );
    semantics.dispose();
  });

  testWidgets('indeterminate checkbox exposes mixed semantics', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpPure(
      tester,
      Checkbox(value: null, tristate: true, onChanged: (bool? next) {}),
    );
    expect(
      tester.getSemantics(find.byType(Checkbox)),
      isSemantics(
        hasCheckedState: true,
        isChecked: false,
        isCheckStateMixed: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('selection interpolates decoration and cross-fades indicators', (
    WidgetTester tester,
  ) async {
    bool value = false;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Checkbox(
          value: value,
          onChanged: (bool? next) => setState(() => value = next!),
          style: ToggleStyle(
            size: const StateProperty<Size?>.all(Size(24.0, 24.0)),
            decoration: StateProperty<Decoration?>.resolveWith(
              (InteractionState state) => BoxDecoration(
                color: state.isSelected
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF000000),
              ),
            ),
            indicator: StateProperty<Widget?>.resolveWith(
              (InteractionState state) => Text(state.isSelected ? 'on' : 'off'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final BoxDecoration decoration =
        tester
                .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration!
            as BoxDecoration;
    expect(decoration.color!.r, closeTo(0.5, 0.001));
    expect(decoration.color!.g, closeTo(0.5, 0.001));
    expect(decoration.color!.b, closeTo(0.5, 0.001));
    for (final String label in <String>['off', 'on']) {
      final Opacity opacity = tester.widget<Opacity>(
        find
            .ancestor(of: find.text(label), matching: find.byType(Opacity))
            .first,
      );
      expect(opacity.opacity, closeTo(0.5, 0.001));
    }
    await tester.pumpAndSettle();
    expect(find.text('off'), findsNothing);
    expect(find.text('on'), findsOneWidget);
  });

  testWidgets('true to null restarts animation using the mixed indicator', (
    WidgetTester tester,
  ) async {
    bool? value = true;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Checkbox(
          value: value,
          tristate: true,
          onChanged: (bool? next) => setState(() => value = next),
          style: ToggleStyle(
            indicator: StateProperty<Widget?>.resolveWith(
              (InteractionState state) =>
                  state.isSelected ? const Text('check') : null,
            ),
            indeterminateIndicator: StateProperty<Widget?>.resolveWith(
              (InteractionState state) =>
                  state.isSelected ? const Text('mixed') : null,
            ),
          ),
        ),
      ),
    );
    expect(find.text('check'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('check'), findsNothing);
    expect(find.text('mixed'), findsNothing);
    await tester.pump(const Duration(milliseconds: 100));
    final Opacity opacity = tester.widget<Opacity>(
      find
          .ancestor(of: find.text('mixed'), matching: find.byType(Opacity))
          .first,
    );
    expect(opacity.opacity, closeTo(0.5, 0.001));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('mixed'), findsOneWidget);
    expect(find.text('check'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('mixed'), findsNothing);
  });

  test('non-tristate checkbox rejects a null value', () {
    expect(
      () => Checkbox(value: null, onChanged: (bool? next) {}),
      throwsAssertionError,
    );
  });
}
