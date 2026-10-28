import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/library/catalog.dart';
import 'package:neutral_ui_example/library/chrome_theme.dart';
import 'package:neutral_ui_example/library/example_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('category, example and source identifiers are globally unique', () {
    final Set<String> ids = <String>{};
    final Set<String> sources = <String>{};
    for (final ComponentCategory category in componentCategories) {
      expect(
        ids.add(category.id),
        isTrue,
        reason: 'Duplicate category ${category.id}',
      );
      expect(category.examples, isNotEmpty, reason: category.id);
      for (final ExampleEntry entry in category.examples) {
        expect(
          ids.add(entry.id),
          isTrue,
          reason: 'Duplicate example ${entry.id}',
        );
        expect(entry.id, startsWith('${category.id}/'));
        expect(
          sources.add(entry.sourcePath),
          isTrue,
          reason: 'Duplicate source ${entry.sourcePath}',
        );
        expect(entry.title, isNotEmpty);
        expect(entry.description, isNotEmpty);
      }
    }
  });

  for (final ComponentCategory category in componentCategories) {
    for (final ExampleEntry entry in category.examples) {
      testWidgets(
        '${entry.id} bundles its exact standalone source and fits a narrow preview',
        (WidgetTester tester) async {
          final String source = await rootBundle.loadString(entry.sourcePath);
          final List<String> imports =
              RegExp(r'''^import\s+['"]([^'"]+)['"];''', multiLine: true)
                  .allMatches(source)
                  .map((RegExpMatch match) => match.group(1)!)
                  .toList();
          expect(
            imports,
            unorderedEquals(<String>[
              'package:flutter/widgets.dart',
              'package:neutral_ui/neutral_ui.dart',
            ]),
            reason: entry.sourcePath,
          );
          expect(
            source,
            isNot(contains(RegExp(r'\bValueKey\b'))),
            reason: entry.sourcePath,
          );
          final List<String> publicWidgets =
              RegExp(
                    r'^class\s+([A-Z]\w*)\s+extends\s+(?:StatefulWidget|StatelessWidget)\b',
                    multiLine: true,
                  )
                  .allMatches(source)
                  .map((RegExpMatch match) => match.group(1)!)
                  .toList();
          expect(publicWidgets, hasLength(1), reason: entry.sourcePath);

          tester.view.physicalSize = const Size(390, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          Widget? preview;
          ThemeData? theme;
          await tester.pumpWidget(
            NeutralApp(
              color: const Color(0xFFFFFFFF),
              theme: const ThemeData(),
              home: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Builder(
                    builder: (BuildContext context) {
                      theme = NeutralTheme.of(context);
                      preview = entry.builder(context);
                      return preview!;
                    },
                  ),
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 250));
          expect(theme, const ThemeData());
          expect(
            preview.runtimeType.toString(),
            publicWidgets.single,
            reason: entry.sourcePath,
          );
          expect(tester.takeException(), isNull, reason: entry.sourcePath);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        },
      );
    }
  }

  testWidgets(
    'example card resets all preview theme tokens below styled chrome',
    (WidgetTester tester) async {
      ThemeData? chrome;
      ThemeData? preview;
      final ExampleEntry entry = ExampleEntry(
        id: 'theme-isolation',
        title: 'Theme isolation',
        description: 'Capture the inherited preview theme.',
        sourcePath: componentCategories.first.examples.first.sourcePath,
        builder: (BuildContext context) {
          preview = NeutralTheme.of(context);
          return const SizedBox(height: 40);
        },
      );
      await tester.pumpWidget(
        NeutralApp(
          color: const Color(0xFFFFFFFF),
          theme: const ThemeData(),
          home: ScaffoldMessenger(
            child: NeutralTheme(
              data: chromeTheme(),
              child: Builder(
                builder: (BuildContext context) {
                  chrome = NeutralTheme.of(context);
                  return SingleChildScrollView(
                    child: ExampleCard(entry: entry),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(chrome, isNot(const ThemeData()));
      expect(chrome!.outlinedButtonStyle.decoration, isNotNull);
      // ThemeData equality compares every component token, including nested styles.
      expect(preview, const ThemeData());
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}
