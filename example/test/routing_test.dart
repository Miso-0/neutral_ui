import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/examples/feedback/alert_dialog_example.dart';
import 'package:neutral_ui_example/library/app.dart';
import 'package:neutral_ui_example/library/catalog.dart';
import 'package:neutral_ui_example/library/category_page.dart';
import 'package:neutral_ui_example/library/example_card.dart';
import 'package:neutral_ui_example/library/getting_started_page.dart';
import 'package:neutral_ui_example/library/search.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final ComponentCategory category in componentCategories) {
      for (final ExampleEntry entry in category.examples) {
        await ExampleSource.load(entry.sourcePath);
      }
    }
  });

  Future<void> pumpLibrary(
    WidgetTester tester, {
    String? route,
    double width = 1280,
  }) async {
    tester.view.physicalSize = Size(width, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(LibraryApp(initialRoute: route));
    await tester.pumpAndSettle();
  }

  testWidgets('initial category and sidebar navigation use named routes', (
    WidgetTester tester,
  ) async {
    await pumpLibrary(tester, route: '/tables');
    expect(
      tester.widget<CategoryPage>(find.byType(CategoryPage)).category.id,
      'tables',
    );
    expect(
      ModalRoute.of(tester.element(find.byType(CategoryPage)))!.settings.name,
      '/tables',
    );
    await tester.tap(find.widgetWithText(ListTile, 'Buttons'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<CategoryPage>(find.byType(CategoryPage)).category.id,
      'buttons',
    );
    expect(
      ModalRoute.of(tester.element(find.byType(CategoryPage)))!.settings.name,
      '/buttons',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown route opens Getting started', (
    WidgetTester tester,
  ) async {
    await pumpLibrary(tester, route: '/does-not-exist');
    expect(find.byType(GettingStartedPage), findsOneWidget);
    expect(
      ModalRoute.of(tester.element(find.byType(GettingStartedPage)))!
          .settings
          .name,
      '/',
    );
    expect(tester.takeException(), isNull);
  });

  test('search matches category, title and description across families', () {
    expect(
      searchExamples('calendar')
          .any((ExampleEntry entry) => entry.id.startsWith('pickers/')),
      isTrue,
    );
    expect(
      searchExamples('local')
          .map((ExampleEntry entry) => entry.id)
          .any((String id) => id.startsWith('foundations/')),
      isTrue,
    );
    expect(
      searchExamples('table')
          .every((ExampleEntry entry) => entry.id.startsWith('tables/')),
      isTrue,
    );
    expect(searchExamples('no_such_component_123'), isEmpty);
  });

  testWidgets(
    'search filters cards across categories and keyboard shortcuts focus it',
    (WidgetTester tester) async {
      await pumpLibrary(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.slash);
      await tester.pump();
      final Finder field = find.byType(EditableText).first;
      expect(tester.widget<EditableText>(field).focusNode.hasFocus, isTrue);
      await tester.enterText(field, 'calendar date picker');
      await tester.pumpAndSettle();
      expect(find.byType(SearchResults), findsOneWidget);
      expect(
        tester.widget<ExampleCard>(find.byType(ExampleCard).first).entry.id,
        'pickers/calendar_date_picker',
      );
      await tester.enterText(field, 'no_such_component_123');
      await tester.pumpAndSettle();
      expect(find.byType(ExampleCard), findsNothing);
      expect(find.textContaining('No examples found'), findsOneWidget);
      await tester.enterText(field, '');
      await tester.pumpAndSettle();
      expect(find.byType(GettingStartedPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('phone categories sheet navigates and pickers fit the preview', (
    WidgetTester tester,
  ) async {
    await pumpLibrary(tester, width: 390);
    await tester.tap(find.text('Categories'));
    await tester.pumpAndSettle();
    final Finder category = find.widgetWithText(ListTile, 'Dates and time');
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    expect(
      tester.widget<CategoryPage>(find.byType(CategoryPage)).category.id,
      'pickers',
    );
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'app RTL and reduced motion reach modal routes without chrome styles',
    (WidgetTester tester) async {
      await pumpLibrary(tester);
      final Finder switches = find.byType(Switch);
      await tester.tap(switches.at(0));
      await tester.pumpAndSettle();
      await tester.tap(switches.at(1));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText).first, 'alert dialog');
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialogExample), findsOneWidget);
      await tester.tap(find.text('Open dialog'));
      await tester.pump();
      final BuildContext dialog = tester.element(find.byType(AlertDialog));
      expect(Directionality.of(dialog), TextDirection.rtl);
      expect(MediaQuery.disableAnimationsOf(dialog), isTrue);
      expect(ModalRoute.of(dialog)!.animation!.value, 1);
      expect(NeutralTheme.of(dialog).switchStyle, const ToggleStyle());
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
