import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui_example/main.dart';

void main() {
  testWidgets('gallery renders and controlled interactions work', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('pureui'), findsOneWidget);
    expect(find.text('Create project'), findsOneWidget);
    await tester.tap(find.text('Create project'));
    await tester.pumpAndSettle();
    expect(find.text('Primary action activated'), findsOneWidget);
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(
      tester.widget<IconButton>(find.byType(IconButton).first).isSelected,
      isTrue,
    );
    final Finder rtl = find.byType(Switch).first;
    await tester.tap(rtl);
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.text('pureui'))),
      TextDirection.rtl,
    );
    await tester.scrollUntilVisible(find.text('05 / Local themes'), 500);
    await tester.pumpAndSettle();
    expect(find.text('Local button theme'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
