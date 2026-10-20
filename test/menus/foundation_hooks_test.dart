import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/menus/menu_item_button.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets(
    'explicit focus overrides computed focus visibility in both directions',
    (WidgetTester tester) async {
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      InteractionState? latest;
      await pumpNeutral(
        tester,
        InteractionDetector(
          isFocused: true,
          builder: (BuildContext context, InteractionState state) {
            latest = state;
            return const SizedBox(width: 40, height: 40);
          },
        ),
      );
      expect(latest!.isFocused, isTrue);
      useTraditionalFocus();
      await pumpNeutral(
        tester,
        InteractionDetector(
          isFocused: false,
          focusNode: focus,
          builder: (BuildContext context, InteractionState state) {
            latest = state;
            return const SizedBox(width: 40, height: 40);
          },
        ),
      );
      focus.requestFocus();
      await tester.pump();
      expect(focus.hasFocus, isTrue);
      expect(latest!.isFocused, isFalse);
    },
  );

  testWidgets('menu button hooks reach interaction resolvers and semantics', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    final WidgetStatesController states = WidgetStatesController();
    addTearDown(states.dispose);
    await pumpNeutral(
      tester,
      MenuItemButton(
        isExpanded: true,
        isChecked: true,
        isFocused: true,
        statesController: states,
        onPressed: () {},
        child: const Text('Menu'),
      ),
    );
    expect(
      states.value,
      containsAll(<WidgetState>[WidgetState.selected, WidgetState.focused]),
    );
    expect(
      tester.getSemantics(find.text('Menu')),
      matchesSemantics(
        label: 'Menu',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasCheckedState: true,
        isChecked: true,
        hasExpandedState: true,
        isExpanded: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('explicit selected state takes precedence over expanded state', (
    WidgetTester tester,
  ) async {
    final WidgetStatesController states = WidgetStatesController();
    addTearDown(states.dispose);
    await pumpNeutral(
      tester,
      MenuItemButton(
        isExpanded: true,
        isSelected: false,
        statesController: states,
        onPressed: () {},
        child: const Text('Menu'),
      ),
    );
    expect(states.value, isNot(contains(WidgetState.selected)));
  });
}
