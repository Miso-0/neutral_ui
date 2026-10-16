import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets(
    'dropdown notifies once after exit even with repeated activation',
    (WidgetTester tester) async {
      final List<String> calls = <String>[];
      await pumpPure(
        tester,
        DropdownButton<int>(
          items: <DropdownMenuItem<int>>[
            DropdownMenuItem<int>(
              value: 1,
              onTap: () => calls.add('item'),
              child: const Text('Choose'),
            ),
          ],
          hint: const Text('Open'),
          onChanged: (int? value) {
            expect(
              tester
                  .widget<RawMenuAnchor>(find.byType(RawMenuAnchor))
                  .controller
                  .isOpen,
              isFalse,
            );
            calls.add('selected');
          },
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(calls, <String>['item']);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump(const Duration(milliseconds: 50));
      expect(calls, <String>['item']);
      await tester.pumpAndSettle();
      expect(calls, <String>['item', 'selected']);
    },
  );

  testWidgets('popup selection callbacks wait for the complete exit', (
    WidgetTester tester,
  ) async {
    final List<String> calls = <String>[];
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1,
            onTap: () => calls.add('item'),
            child: const Text('Choose'),
          ),
        ],
        onSelected: (int value) => calls.add('selected'),
        onCanceled: () => calls.add('cancel'),
        child: const Text('Open'),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(calls, isEmpty);
    await tester.pump(const Duration(milliseconds: 50));
    expect(calls, isEmpty);
    await tester.pumpAndSettle();
    expect(calls, <String>['item', 'selected']);
  });
}
