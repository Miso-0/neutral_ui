import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets(
    'snack action cannot close the successor promoted by its callback',
    (WidgetTester tester) async {
      final GlobalKey<ScaffoldMessengerState> key =
          GlobalKey<ScaffoldMessengerState>();
      await pumpNeutralApp(
        tester,
        ScaffoldMessenger(key: key, child: const Text('Host')),
      );
      key.currentState!.showSnackBar(
        SnackBar(
          content: const Text('First'),
          action: SnackBarAction(
            label: 'Promote',
            onPressed: () => key.currentState!.removeCurrentSnackBar(),
          ),
        ),
      );
      key.currentState!.showSnackBar(
        const SnackBar(content: Text('Successor'), persist: true),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Promote'));
      await tester.pumpAndSettle();
      expect(find.text('Successor'), findsOneWidget);
    },
  );

  testWidgets(
    'onVisible cannot install a predecessor timeout on its successor',
    (WidgetTester tester) async {
      final GlobalKey<ScaffoldMessengerState> key =
          GlobalKey<ScaffoldMessengerState>();
      await pumpNeutralApp(
        tester,
        ScaffoldMessenger(key: key, child: const Text('Host')),
      );
      key.currentState!.showSnackBar(
        SnackBar(
          content: const Text('First'),
          duration: const Duration(milliseconds: 50),
          onVisible: () => key.currentState!.removeCurrentSnackBar(),
        ),
      );
      key.currentState!.showSnackBar(
        const SnackBar(content: Text('Persistent successor'), persist: true),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Persistent successor'), findsOneWidget);
    },
  );

  testWidgets('stored snack handle is harmless after its host unmounts', (
    WidgetTester tester,
  ) async {
    final GlobalKey<ScaffoldMessengerState> key =
        GlobalKey<ScaffoldMessengerState>();
    await pumpNeutralApp(
      tester,
      ScaffoldMessenger(key: key, child: const Text('Host')),
    );
    final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> handle = key
        .currentState!
        .showSnackBar(const SnackBar(content: Text('Notice'), persist: true));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    expect(handle.close, returnsNormally);
    expect(await handle.closed, SnackBarClosedReason.remove);
  });

  testWidgets(
    'bottom sheet can switch owned and external controllers repeatedly',
    (WidgetTester tester) async {
      final AnimationController external = AnimationController(
        vsync: tester,
        value: 0.5,
        duration: const Duration(milliseconds: 200),
      );
      addTearDown(external.dispose);
      AnimationController? current;
      late StateSetter update;
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              update = setState;
              return BottomSheet(
                animationController: current,
                onClosing: () {},
                builder: (BuildContext context) =>
                    const SizedBox(height: 200, child: Text('Sheet')),
              );
            },
          ),
        ),
      );
      update(() => current = external);
      await tester.pump();
      expect(tester.takeException(), isNull);
      update(() => current = null);
      await tester.pump();
      expect(tester.takeException(), isNull);
      external.value = 0.7;
      expect(external.value, 0.7);
    },
  );

  testWidgets('tooltip can reopen synchronously while starting its exit', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();
    await pumpNeutralApp(
      tester,
      Tooltip(key: key, message: 'Hint', child: const Text('Anchor')),
    );
    key.currentState!.ensureTooltipVisible();
    await tester.pumpAndSettle();
    key.currentState!.dismiss();
    expect(key.currentState!.ensureTooltipVisible(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Hint'), findsOneWidget);
  });

  testWidgets(
    'scroll controlled sheet lets its child grow and close at minimum extent',
    (WidgetTester tester) async {
      late BuildContext launch;
      await pumpNeutralApp(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      final Future<void> closed = showModalBottomSheet<void>(
        context: launch,
        isScrollControlled: true,
        builder: (BuildContext context) => DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (BuildContext context, ScrollController controller) =>
              ListView(
                controller: controller,
                children: <Widget>[
                  for (int i = 0; i < 30; i++)
                    SizedBox(height: 40, child: Text('Row$i')),
                ],
              ),
        ),
      );
      await tester.pumpAndSettle();
      final double before = tester.getTopLeft(find.byType(BottomSheet)).dy;
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byType(BottomSheet)).dy, lessThan(before));
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      await closed;
    },
  );
}
