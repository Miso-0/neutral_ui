import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

class _PersistentCounter extends StatefulWidget {
  const _PersistentCounter({super.key});

  @override
  State<_PersistentCounter> createState() => _PersistentCounterState();
}

class _PersistentCounterState extends State<_PersistentCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => count += 1),
    child: Text('Count $count'),
  );
}

void main() {
  testWidgets(
    'builder keeps content state and inserted entries across theme updates',
    (WidgetTester tester) async {
      const ThemeData firstTheme = ThemeData(
        textButtonStyle: ButtonStyle(spacing: 3),
      );
      const ThemeData secondTheme = ThemeData(
        textButtonStyle: ButtonStyle(spacing: 9),
      );
      final GlobalKey<_PersistentCounterState> counter =
          GlobalKey<_PersistentCounterState>();
      late BuildContext contentContext;
      Widget app(ThemeData theme, String label) => NeutralApp.builder(
        color: const Color(0xFFFFFFFF),
        theme: theme,
        builder: (BuildContext context) {
          contentContext = context;
          return Column(
            children: <Widget>[
              Text(label),
              _PersistentCounter(key: counter),
            ],
          );
        },
      );
      await tester.pumpWidget(app(firstTheme, 'First'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Count 0'));
      await tester.pumpAndSettle();
      final _PersistentCounterState originalState = counter.currentState!;
      final OverlayState originalOverlay = Overlay.of(contentContext);
      final List<ThemeData> overlayThemes = <ThemeData>[];
      final OverlayEntry extra = OverlayEntry(
        builder: (BuildContext context) {
          overlayThemes.add(NeutralTheme.of(context));
          return const Positioned(
            left: 20,
            top: 200,
            child: Text('Inserted entry'),
          );
        },
      );
      originalOverlay.insert(extra);
      await tester.pumpAndSettle();
      expect(overlayThemes.last, firstTheme);

      await tester.pumpWidget(app(secondTheme, 'Second'));
      await tester.pumpAndSettle();
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Count 1'), findsOneWidget);
      expect(counter.currentState, same(originalState));
      expect(Overlay.of(contentContext), same(originalOverlay));
      expect(find.text('Inserted entry'), findsOneWidget);
      expect(overlayThemes.last, secondTheme);
      extra.remove();
      extra.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'changing between Navigator and builder modes disposes owned overlays',
    (WidgetTester tester) async {
      const Key appKey = ValueKey<String>('app');
      Widget app(bool navigator) => navigator
          ? const NeutralApp(
              key: appKey,
              color: Color(0xFFFFFFFF),
              home: Text('Navigator home'),
            )
          : NeutralApp.builder(
              key: appKey,
              color: const Color(0xFFFFFFFF),
              builder: (BuildContext context) => const Text('Builder home'),
            );
      await tester.pumpWidget(app(false));
      await tester.pumpAndSettle();
      expect(find.text('Builder home'), findsOneWidget);
      await tester.pumpWidget(app(true));
      await tester.pumpAndSettle();
      expect(find.text('Navigator home'), findsOneWidget);
      await tester.pumpWidget(app(false));
      await tester.pumpAndSettle();
      expect(find.text('Builder home'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Navigator uses the app HeroController for flights', (
    WidgetTester tester,
  ) async {
    final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
    int flights = 0;
    Widget hero(Alignment alignment) => Align(
      alignment: alignment,
      child: Hero(
        tag: 'shared-hero',
        flightShuttleBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              HeroFlightDirection direction,
              BuildContext fromContext,
              BuildContext toContext,
            ) {
              flights += 1;
              return const SizedBox(width: 40, height: 40);
            },
        child: const SizedBox(width: 40, height: 40),
      ),
    );
    await tester.pumpWidget(
      NeutralApp(
        color: const Color(0xFFFFFFFF),
        navigatorKey: navigator,
        home: hero(Alignment.topLeft),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => hero(Alignment.bottomRight),
        },
      ),
    );
    await tester.pumpAndSettle();
    navigator.currentState!.pushNamed('/details');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(flights, 1);
    await tester.pumpAndSettle();
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(flights, 2);
    expect(tester.takeException(), isNull);
  });
}
