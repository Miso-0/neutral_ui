import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('focusing a visible field preserves its anchor and open panel', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    await pumpPureApp(
      tester,
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 800),
            SizedBox(
              width: 240,
              child: DropdownMenu<int>(
                menuController: controller,
                requestFocusOnTap: true,
                hintText: 'Choose',
                style: const DropdownStyle(
                  buttonStyle: ButtonStyle(
                    padding: StateProperty<EdgeInsetsGeometry?>.all(
                      EdgeInsets.all(15),
                    ),
                  ),
                ),
                dropdownMenuEntries: const <DropdownMenuEntry<int>>[
                  DropdownMenuEntry<int>(value: 1, label: 'One'),
                  DropdownMenuEntry<int>(value: 2, label: 'Two'),
                ],
              ),
            ),
            const SizedBox(height: 800),
          ],
        ),
      ),
    );
    final Finder field = find.byType(EditableText);
    await tester.ensureVisible(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();
    final Rect before = tester.getRect(field);
    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(tester.getRect(field), before);
    expect(controller.isOpen, isTrue);
    expect(find.text('One').hitTestable(), findsOneWidget);
  });
}
