import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

class _CustomStrings extends DefaultNeutralLocalizations {
  const _CustomStrings();

  @override
  String get cancelButtonLabel => 'Back';
}

class _CustomDelegate extends LocalizationsDelegate<NeutralLocalizations> {
  const _CustomDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<NeutralLocalizations> load(Locale locale) async =>
      const _CustomStrings();

  @override
  bool shouldReload(_CustomDelegate old) => false;
}

void main() {
  testWidgets('supplies theme, English strings, Navigator and hero scope', (
    WidgetTester tester,
  ) async {
    final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
    const ThemeData theme = ThemeData(textButtonStyle: ButtonStyle(spacing: 7));
    await tester.pumpWidget(
      NeutralApp(
        color: const Color(0xFFFFFFFF),
        theme: theme,
        navigatorKey: navigator,
        builder: (BuildContext context, Widget? child) {
          expect(HeroControllerScope.of(context), isA<HeroController>());
          return child!;
        },
        home: Builder(
          builder: (BuildContext context) {
            expect(NeutralTheme.of(context), theme);
            return Text(NeutralLocalizations.of(context).cancelButtonLabel);
          },
        ),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) {
            expect(NeutralTheme.of(context), theme);
            return Text(NeutralLocalizations.of(context).okButtonLabel);
          },
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cancel'), findsOneWidget);
    navigator.currentState!.pushNamed('/details');
    await tester.pumpAndSettle();
    expect(find.text('OK'), findsOneWidget);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('custom delegate takes precedence and builder sees theme', (
    WidgetTester tester,
  ) async {
    const ThemeData theme = ThemeData(iconButtonStyle: ButtonStyle(spacing: 8));
    await tester.pumpWidget(
      NeutralApp(
        color: const Color(0xFFFFFFFF),
        theme: theme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          _CustomDelegate(),
        ],
        builder: (BuildContext context, Widget? child) {
          expect(NeutralTheme.of(context), theme);
          return child!;
        },
        home: Builder(
          builder: (BuildContext context) =>
              Text(NeutralLocalizations.of(context).cancelButtonLabel),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets(
    'navigator-free builder retains content and updates its Overlay',
    (WidgetTester tester) async {
      int count = 0;
      Widget app(String label) => NeutralApp.builder(
        color: const Color(0xFFFFFFFF),
        builder: (BuildContext context) {
          expect(Overlay.of(context), isA<OverlayState>());
          expect(Navigator.maybeOf(context), isNull);
          expect(
            NeutralLocalizations.of(context),
            isA<DefaultNeutralLocalizations>(),
          );
          return Center(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  TextButton(
                    onPressed: () => setState(() {
                      count++;
                    }),
                    child: Text('$label $count'),
                  ),
            ),
          );
        },
      );
      await tester.pumpWidget(app('First'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('First 0'));
      await tester.pumpAndSettle();
      expect(find.text('First 1'), findsOneWidget);
      await tester.pumpWidget(app('Second'));
      await tester.pumpAndSettle();
      expect(find.text('Second 1'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('onGenerateRoute handles application routes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      NeutralApp(
        color: const Color(0xFFFFFFFF),
        onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => const Text('Generated'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Generated'), findsOneWidget);
  });
}
