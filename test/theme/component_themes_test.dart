import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

void main() {
  _componentThemeTests<ButtonStyle, ElevatedButtonTheme>(
    name: 'ElevatedButtonTheme',
    base: const ButtonStyle(spacing: 4),
    partial: const ButtonStyle(alignment: Alignment.bottomRight),
    combined: const ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
    global: ({required ButtonStyle data}) =>
        ThemeData(elevatedButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        ElevatedButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        ElevatedButtonTheme.merge(data: data, child: child),
    of: ElevatedButtonTheme.of,
    maybeOf: ElevatedButtonTheme.maybeOf,
    shouldNotify: (ElevatedButtonTheme current, ElevatedButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, OutlinedButtonTheme>(
    name: 'OutlinedButtonTheme',
    base: const ButtonStyle(spacing: 4),
    partial: const ButtonStyle(alignment: Alignment.bottomRight),
    combined: const ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
    global: ({required ButtonStyle data}) =>
        ThemeData(outlinedButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        OutlinedButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        OutlinedButtonTheme.merge(data: data, child: child),
    of: OutlinedButtonTheme.of,
    maybeOf: OutlinedButtonTheme.maybeOf,
    shouldNotify: (OutlinedButtonTheme current, OutlinedButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, TextButtonTheme>(
    name: 'TextButtonTheme',
    base: const ButtonStyle(spacing: 4),
    partial: const ButtonStyle(alignment: Alignment.bottomRight),
    combined: const ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
    global: ({required ButtonStyle data}) => ThemeData(textButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        TextButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        TextButtonTheme.merge(data: data, child: child),
    of: TextButtonTheme.of,
    maybeOf: TextButtonTheme.maybeOf,
    shouldNotify: (TextButtonTheme current, TextButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, IconButtonTheme>(
    name: 'IconButtonTheme',
    base: const ButtonStyle(spacing: 4),
    partial: const ButtonStyle(alignment: Alignment.bottomRight),
    combined: const ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
    global: ({required ButtonStyle data}) => ThemeData(iconButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        IconButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        IconButtonTheme.merge(data: data, child: child),
    of: IconButtonTheme.of,
    maybeOf: IconButtonTheme.maybeOf,
    shouldNotify: (IconButtonTheme current, IconButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ToggleStyle, CheckboxTheme>(
    name: 'CheckboxTheme',
    base: const ToggleStyle(padding: EdgeInsets.all(4)),
    partial: const ToggleStyle(animationDuration: Duration(milliseconds: 10)),
    combined: const ToggleStyle(
      padding: EdgeInsets.all(4),
      animationDuration: Duration(milliseconds: 10),
    ),
    global: ({required ToggleStyle data}) => ThemeData(checkboxStyle: data),
    create: ({required ToggleStyle data, required Widget child}) =>
        CheckboxTheme(data: data, child: child),
    merge: ({required ToggleStyle data, required Widget child}) =>
        CheckboxTheme.merge(data: data, child: child),
    of: CheckboxTheme.of,
    maybeOf: CheckboxTheme.maybeOf,
    shouldNotify: (CheckboxTheme current, CheckboxTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ToggleStyle, SwitchTheme>(
    name: 'SwitchTheme',
    base: const ToggleStyle(padding: EdgeInsets.all(4)),
    partial: const ToggleStyle(animationDuration: Duration(milliseconds: 10)),
    combined: const ToggleStyle(
      padding: EdgeInsets.all(4),
      animationDuration: Duration(milliseconds: 10),
    ),
    global: ({required ToggleStyle data}) => ThemeData(switchStyle: data),
    create: ({required ToggleStyle data, required Widget child}) =>
        SwitchTheme(data: data, child: child),
    merge: ({required ToggleStyle data, required Widget child}) =>
        SwitchTheme.merge(data: data, child: child),
    of: SwitchTheme.of,
    maybeOf: SwitchTheme.maybeOf,
    shouldNotify: (SwitchTheme current, SwitchTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ToggleStyle, RadioTheme>(
    name: 'RadioTheme',
    base: const ToggleStyle(padding: EdgeInsets.all(4)),
    partial: const ToggleStyle(animationDuration: Duration(milliseconds: 10)),
    combined: const ToggleStyle(
      padding: EdgeInsets.all(4),
      animationDuration: Duration(milliseconds: 10),
    ),
    global: ({required ToggleStyle data}) => ThemeData(radioStyle: data),
    create: ({required ToggleStyle data, required Widget child}) =>
        RadioTheme(data: data, child: child),
    merge: ({required ToggleStyle data, required Widget child}) =>
        RadioTheme.merge(data: data, child: child),
    of: RadioTheme.of,
    maybeOf: RadioTheme.maybeOf,
    shouldNotify: (RadioTheme current, RadioTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ListTileStyle, ListTileTheme>(
    name: 'ListTileTheme',
    base: const ListTileStyle(minLeadingWidth: 4),
    partial: const ListTileStyle(contentPadding: EdgeInsets.all(3)),
    combined: const ListTileStyle(
      minLeadingWidth: 4,
      contentPadding: EdgeInsets.all(3),
    ),
    global: ({required ListTileStyle data}) => ThemeData(listTileStyle: data),
    create: ({required ListTileStyle data, required Widget child}) =>
        ListTileTheme(data: data, child: child),
    merge: ({required ListTileStyle data, required Widget child}) =>
        ListTileTheme.merge(data: data, child: child),
    of: ListTileTheme.of,
    maybeOf: ListTileTheme.maybeOf,
    shouldNotify: (ListTileTheme current, ListTileTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<SliderStyle, SliderTheme>(
    name: 'SliderTheme',
    base: const SliderStyle(preferredWidth: 144),
    partial: const SliderStyle(keyboardStep: 0.1),
    combined: const SliderStyle(preferredWidth: 144, keyboardStep: 0.1),
    global: ({required SliderStyle data}) => ThemeData(sliderStyle: data),
    create: ({required SliderStyle data, required Widget child}) =>
        SliderTheme(data: data, child: child),
    merge: ({required SliderStyle data, required Widget child}) =>
        SliderTheme.merge(data: data, child: child),
    of: SliderTheme.of,
    maybeOf: SliderTheme.maybeOf,
    shouldNotify: (SliderTheme current, SliderTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<DropdownStyle, DropdownButtonTheme>(
    name: 'DropdownButtonTheme',
    base: const DropdownStyle(buttonStyle: ButtonStyle(spacing: 4)),
    partial: const DropdownStyle(
      buttonStyle: ButtonStyle(alignment: Alignment.bottomRight),
      menuStyle: MenuStyle(padding: EdgeInsets.all(3)),
    ),
    combined: const DropdownStyle(
      buttonStyle: ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
      menuStyle: MenuStyle(padding: EdgeInsets.all(3)),
    ),
    global: ({required DropdownStyle data}) =>
        ThemeData(dropdownButtonStyle: data),
    create: ({required DropdownStyle data, required Widget child}) =>
        DropdownButtonTheme(data: data, child: child),
    merge: ({required DropdownStyle data, required Widget child}) =>
        DropdownButtonTheme.merge(data: data, child: child),
    of: DropdownButtonTheme.of,
    maybeOf: DropdownButtonTheme.maybeOf,
    shouldNotify: (DropdownButtonTheme current, DropdownButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<DropdownStyle, DropdownMenuTheme>(
    name: 'DropdownMenuTheme',
    base: const DropdownStyle(buttonStyle: ButtonStyle(spacing: 4)),
    partial: const DropdownStyle(
      buttonStyle: ButtonStyle(alignment: Alignment.bottomRight),
      menuStyle: MenuStyle(padding: EdgeInsets.all(3)),
    ),
    combined: const DropdownStyle(
      buttonStyle: ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
      menuStyle: MenuStyle(padding: EdgeInsets.all(3)),
    ),
    global: ({required DropdownStyle data}) =>
        ThemeData(dropdownMenuStyle: data),
    create: ({required DropdownStyle data, required Widget child}) =>
        DropdownMenuTheme(data: data, child: child),
    merge: ({required DropdownStyle data, required Widget child}) =>
        DropdownMenuTheme.merge(data: data, child: child),
    of: DropdownMenuTheme.of,
    maybeOf: DropdownMenuTheme.maybeOf,
    shouldNotify: (DropdownMenuTheme current, DropdownMenuTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<PopupMenuStyle, PopupMenuTheme>(
    name: 'PopupMenuTheme',
    base: const PopupMenuStyle(buttonStyle: ButtonStyle(spacing: 4)),
    partial: const PopupMenuStyle(
      buttonStyle: ButtonStyle(alignment: Alignment.bottomRight),
      menuStyle: MenuStyle(padding: EdgeInsets.all(3)),
    ),
    combined: const PopupMenuStyle(
      buttonStyle: ButtonStyle(spacing: 4, alignment: Alignment.bottomRight),
      menuStyle: MenuStyle(padding: EdgeInsets.all(3)),
    ),
    global: ({required PopupMenuStyle data}) => ThemeData(popupMenuStyle: data),
    create: ({required PopupMenuStyle data, required Widget child}) =>
        PopupMenuTheme(data: data, child: child),
    merge: ({required PopupMenuStyle data, required Widget child}) =>
        PopupMenuTheme.merge(data: data, child: child),
    of: PopupMenuTheme.of,
    maybeOf: PopupMenuTheme.maybeOf,
    shouldNotify: (PopupMenuTheme current, PopupMenuTheme old) =>
        current.updateShouldNotify(old),
  );
}

void _componentThemeTests<S, W extends InheritedTheme>({
  required String name,
  required S base,
  required S partial,
  required S combined,
  required ThemeData Function({required S data}) global,
  required W Function({required S data, required Widget child}) create,
  required Widget Function({required S data, required Widget child}) merge,
  required S Function(BuildContext context) of,
  required S? Function(BuildContext context) maybeOf,
  required bool Function(W current, W old) shouldNotify,
}) {
  group(name, () {
    testWidgets('of falls back to PureTheme and maybeOf stays local', (
      WidgetTester tester,
    ) async {
      S? found;
      S? local;
      await tester.pumpWidget(
        PureTheme(
          data: global(data: base),
          child: Builder(
            builder: (BuildContext context) {
              found = of(context);
              local = maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found, base);
      expect(local, isNull);
    });

    testWidgets('nearest component theme replaces its parent', (
      WidgetTester tester,
    ) async {
      S? found;
      S? local;
      await tester.pumpWidget(
        PureTheme(
          data: global(data: base),
          child: create(
            data: base,
            child: create(
              data: partial,
              child: Builder(
                builder: (BuildContext context) {
                  found = of(context);
                  local = maybeOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(found, partial);
      expect(local, partial);
      expect(found, isNot(combined));
    });

    testWidgets('merge inherits from PureTheme', (WidgetTester tester) async {
      S? found;
      await tester.pumpWidget(
        PureTheme(
          data: global(data: base),
          child: merge(
            data: partial,
            child: Builder(
              builder: (BuildContext context) {
                found = of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(found, combined);
    });

    testWidgets('merge inherits from enclosing component theme', (
      WidgetTester tester,
    ) async {
      S? found;
      await tester.pumpWidget(
        create(
          data: base,
          child: merge(
            data: partial,
            child: Builder(
              builder: (BuildContext context) {
                found = of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(found, combined);
    });

    testWidgets('wrap carries the component data', (WidgetTester tester) async {
      S? found;
      final W theme = create(data: base, child: const SizedBox());
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            return theme.wrap(
              context,
              Builder(
                builder: (BuildContext innerContext) {
                  found = of(innerContext);
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      );
      expect(found, base);
    });

    test('updateShouldNotify compares styles', () {
      final W first = create(data: base, child: const SizedBox());
      expect(
        shouldNotify(first, create(data: base, child: const SizedBox())),
        isFalse,
      );
      expect(
        shouldNotify(first, create(data: partial, child: const SizedBox())),
        isTrue,
      );
    });

    testWidgets('InheritedTheme.capture preserves component and PureTheme', (
      WidgetTester tester,
    ) async {
      late CapturedThemes captured;
      final ThemeData themeData = global(data: partial);
      await tester.pumpWidget(
        PureTheme(
          data: themeData,
          child: create(
            data: base,
            child: Builder(
              builder: (BuildContext context) {
                captured = InheritedTheme.capture(from: context, to: null);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      S? found;
      ThemeData? foundGlobal;
      await tester.pumpWidget(
        captured.wrap(
          Builder(
            builder: (BuildContext context) {
              found = of(context);
              foundGlobal = PureTheme.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found, base);
      expect(foundGlobal, themeData);
    });
  });
}
