import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

void main() {
  testWidgets('PureTheme provides empty fallback and nullable lookup', (
    WidgetTester tester,
  ) async {
    ThemeData? found;
    ThemeData? maybe;
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          found = PureTheme.of(context);
          maybe = PureTheme.maybeOf(context);
          return const SizedBox();
        },
      ),
    );
    expect(found, const ThemeData());
    expect(maybe, isNull);
  });

  testWidgets('PureTheme nearest data replaces enclosing data', (
    WidgetTester tester,
  ) async {
    const ThemeData outer = ThemeData(
      elevatedButtonStyle: ButtonStyle(spacing: 4),
    );
    const ThemeData inner = ThemeData(
      sliderStyle: SliderStyle(preferredWidth: 200),
    );
    ThemeData? found;
    await tester.pumpWidget(
      PureTheme(
        data: outer,
        child: PureTheme(
          data: inner,
          child: Builder(
            builder: (BuildContext context) {
              found = PureTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(found, inner);
    expect(found!.elevatedButtonStyle.spacing, isNull);
  });

  testWidgets('PureTheme.merge inherits every unset component token', (
    WidgetTester tester,
  ) async {
    const ThemeData outer = ThemeData(
      elevatedButtonStyle: ButtonStyle(
        spacing: 4,
        alignment: Alignment.topLeft,
      ),
      sliderStyle: SliderStyle(preferredWidth: 200),
    );
    const ThemeData inner = ThemeData(
      elevatedButtonStyle: ButtonStyle(spacing: 9),
    );
    ThemeData? found;
    await tester.pumpWidget(
      PureTheme(
        data: outer,
        child: PureTheme.merge(
          data: inner,
          child: Builder(
            builder: (BuildContext context) {
              found = PureTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(found!.elevatedButtonStyle.spacing, 9);
    expect(found!.elevatedButtonStyle.alignment, Alignment.topLeft);
    expect(found!.sliderStyle.preferredWidth, 200);
  });

  testWidgets('PureTheme.wrap carries data to its child', (
    WidgetTester tester,
  ) async {
    const ThemeData data = ThemeData(
      checkboxStyle: ToggleStyle(padding: EdgeInsets.all(4)),
    );
    const PureTheme theme = PureTheme(data: data, child: SizedBox());
    ThemeData? found;
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          return theme.wrap(
            context,
            Builder(
              builder: (BuildContext innerContext) {
                found = PureTheme.of(innerContext);
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
    expect(found, data);
  });

  test('PureTheme only notifies when tokens change', () {
    const PureTheme first = PureTheme(data: ThemeData(), child: SizedBox());
    const PureTheme same = PureTheme(data: ThemeData(), child: SizedBox());
    const PureTheme changed = PureTheme(
      data: ThemeData(sliderStyle: SliderStyle(keyboardStep: 0.2)),
      child: SizedBox(),
    );
    expect(first.updateShouldNotify(same), isFalse);
    expect(changed.updateShouldNotify(first), isTrue);
  });

  testWidgets('PureTheme changes rebuild dependents', (
    WidgetTester tester,
  ) async {
    int builds = 0;
    double? found;
    final Widget child = Builder(
      builder: (BuildContext context) {
        builds += 1;
        found = PureTheme.of(context).sliderStyle.keyboardStep;
        return const SizedBox();
      },
    );
    await tester.pumpWidget(PureTheme(data: const ThemeData(), child: child));
    expect(builds, 1);
    await tester.pumpWidget(
      PureTheme(
        data: const ThemeData(sliderStyle: SliderStyle(keyboardStep: 0.2)),
        child: child,
      ),
    );
    expect(builds, 2);
    expect(found, 0.2);
  });
}
