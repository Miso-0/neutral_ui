import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/foundation/motion.dart';

void main() {
  testWidgets('durations and springs respect reduced motion', (
    WidgetTester tester,
  ) async {
    final AnimationController controller = AnimationController.unbounded(
      vsync: tester,
    );
    addTearDown(controller.dispose);
    late BuildContext motionContext;
    Future<void> pump(bool disabled) => tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: disabled),
        child: Builder(
          builder: (BuildContext context) {
            motionContext = context;
            return const SizedBox();
          },
        ),
      ),
    );
    const Duration duration = Duration(milliseconds: 200);
    await pump(false);
    expect(reducedMotionDuration(motionContext, duration), duration);
    await pump(true);
    expect(reducedMotionDuration(motionContext, duration), Duration.zero);
    animateWithSpring(motionContext, controller, 10, velocity: 50);
    expect(controller.value, 10);
    expect(controller.isAnimating, isFalse);
  });

  testWidgets('spring retargeting preserves current value and velocity', (
    WidgetTester tester,
  ) async {
    final AnimationController controller = AnimationController.unbounded(
      vsync: tester,
    );
    addTearDown(controller.dispose);
    late BuildContext motionContext;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Builder(
          builder: (BuildContext context) {
            motionContext = context;
            return const SizedBox();
          },
        ),
      ),
    );
    animateWithSpring(motionContext, controller, 10, velocity: 4);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    final double value = controller.value;
    final double velocity = controller.velocity;
    expect(value, inExclusiveRange(0, 10));
    expect(velocity, greaterThan(0));
    animateWithSpring(motionContext, controller, -5);
    expect(controller.value, value);
    expect(controller.velocity, closeTo(velocity, 1e-8));
    await tester.pumpAndSettle();
    expect(controller.value, -5);
    expect(controller.isAnimating, isFalse);
  });

  testWidgets('all spring presets settle exactly at the requested value', (
    WidgetTester tester,
  ) async {
    final AnimationController controller = AnimationController.unbounded(
      vsync: tester,
    );
    addTearDown(controller.dispose);
    late BuildContext motionContext;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Builder(
          builder: (BuildContext context) {
            motionContext = context;
            return const SizedBox();
          },
        ),
      ),
    );
    for (final MotionSpring spring in MotionSpring.values) {
      controller.value = 0;
      animateWithSpring(motionContext, controller, 1, spring: spring);
      await tester.pumpAndSettle();
      expect(controller.value, 1);
    }
  });
}
