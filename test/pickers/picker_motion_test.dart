import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/pickers/picker_common.dart';

import '../helpers/pump.dart';

class _Probe extends StatefulWidget {
  const _Probe({super.key});

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  Widget build(BuildContext context) => const Text('7');
}

void main() {
  testWidgets('a cell keeps its content when its styles change', (
    WidgetTester tester,
  ) async {
    final GlobalKey<_ProbeState> probe = GlobalKey<_ProbeState>();
    Widget cell(bool selected) => SizedBox(
      width: 40,
      height: 40,
      child: PickerCell(
        onPressed: () {},
        selected: selected,
        styles: <ButtonStyle?>[
          if (selected)
            const ButtonStyle(
              decoration: StateProperty<Decoration?>.all(
                BoxDecoration(color: Color(0xFF087F6D)),
              ),
            ),
        ],
        child: _Probe(key: probe),
      ),
    );
    await pumpNeutral(tester, cell(false));
    final _ProbeState state = probe.currentState!;
    await pumpNeutral(tester, cell(true));
    expect(identical(probe.currentState, state), isTrue);
    await pumpNeutral(tester, cell(false));
    expect(identical(probe.currentState, state), isTrue);
  });

  testWidgets('keyboard focus shows the default indicator on a cell', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    await pumpNeutral(
      tester,
      SizedBox(
        width: 60,
        height: 40,
        child: PickerCell(onPressed: () {}, child: const Text('2026')),
      ),
    );
    double opacity() =>
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;
    expect(opacity(), 0);
    tester
        .widget<Focus>(
          find
              .descendant(
                of: find.byType(PickerCell),
                matching: find.byType(Focus),
              )
              .first,
        )
        .focusNode!
        .requestFocus();
    await tester.pumpAndSettle();
    expect(opacity(), 1);
  });

  testWidgets('range calendar arrows scroll only as far as the row needs', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      SizedBox(
        width: 320,
        height: 220,
        child: CalendarDateRangePicker(
          firstDate: DateTime(2026, 10),
          lastDate: DateTime(2026, 12, 31),
          initialStartDate: DateTime(2026, 10),
          autofocus: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final ScrollPosition position = tester
        // The month list encloses each month's grid.
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position;
    expect(position.pixels, 0);
    // October 1, 2026 is in the first row; each arrow moves one row down.
    for (int row = 1; row <= 4; row++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      final double rowBottom = 40 + 40.0 * (row + 2);
      final double expected = rowBottom > position.viewportDimension
          ? rowBottom - position.viewportDimension
          : 0;
      expect(position.pixels, closeTo(expected, 0.5), reason: 'row $row');
    }
  });
}
