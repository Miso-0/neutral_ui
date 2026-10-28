import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/library/catalog.dart';
import 'package:neutral_ui_example/library/chrome_theme.dart';
import 'package:neutral_ui_example/library/code_view.dart';
import 'package:neutral_ui_example/library/example_card.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  final ExampleEntry entry = categoryById('pickers')!.examples.first;

  Future<String> pumpCard(WidgetTester tester) async {
    final String source = (await tester.runAsync(() async {
      final String asset = await rootBundle.loadString(entry.sourcePath);
      expect(await ExampleSource.load(entry.sourcePath), asset);
      return asset;
    }))!;
    await tester.pumpWidget(
      NeutralApp(
        color: canvas,
        home: ScaffoldMessenger(
          child: NeutralTheme(
            data: chromeTheme(),
            child: ListView(children: <Widget>[ExampleCard(entry: entry)]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CodeView), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(find.byType(OutlinedButton).first)
          .onPressed,
      isNotNull,
    );
    return source;
  }

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  testWidgets(
    'Copy writes the exact rendered source asset and shows feedback',
    (WidgetTester tester) async {
      String? clipboard;
      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard =
                (call.arguments as Map<Object?, Object?>)['text'] as String;
          }
          return null;
        },
      );
      final String source = await pumpCard(tester);
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();
      expect(clipboard, source);
      expect(find.text('Copied'), findsOneWidget);
      expect(find.text('Copied example code'), findsOneWidget);
      expect(tester.widget<CodeView>(find.byType(CodeView)).source, source);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Copy'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('clipboard denial exposes complete selectable source', (
    WidgetTester tester,
  ) async {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async {
        if (call.method == 'Clipboard.setData') {
          throw PlatformException(code: 'denied');
        }
        return null;
      },
    );
    await pumpCard(tester);
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();
    expect(find.text('Copy failed, select the code instead'), findsOneWidget);
    expect(tester.widget<CodeView>(find.byType(CodeView)).maxLines, isNull);
    expect(find.byType(SelectableRegion), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
