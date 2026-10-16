import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

void main() {
  testWidgets(
    'navigation variants inherit shared tokens and permit local overrides',
    (WidgetTester tester) async {
      const NavigationStyle shared = NavigationStyle(spacing: 6);
      const NavigationStyle local = NavigationStyle(spacing: 10);
      await tester.pumpWidget(
        NavigationTheme(
          data: shared,
          child: Builder(
            builder: (BuildContext context) {
              expect(NavigationBarTheme.of(context), shared);
              expect(NavigationRailTheme.of(context), shared);
              expect(NavigationDrawerTheme.of(context), shared);
              return NavigationBarTheme(
                data: local,
                child: Builder(
                  builder: (BuildContext context) {
                    expect(NavigationBarTheme.of(context), local);
                    expect(NavigationRailTheme.of(context), shared);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    },
  );

  _componentThemeTests<TooltipStyle, TooltipTheme>(
    name: 'TooltipTheme',
    base: TooltipStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
    ),
    partial: TooltipStyle(padding: const EdgeInsets.all(4)),
    combined: TooltipStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
      padding: const EdgeInsets.all(4),
    ),
    global: ({required TooltipStyle data}) => ThemeData(tooltipStyle: data),
    create: ({required TooltipStyle data, required Widget child}) =>
        TooltipTheme(data: data, child: child),
    merge: ({required TooltipStyle data, required Widget child}) =>
        TooltipTheme.merge(data: data, child: child),
    of: TooltipTheme.of,
    maybeOf: TooltipTheme.maybeOf,
    shouldNotify: (TooltipTheme current, TooltipTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<DialogStyle, DialogTheme>(
    name: 'DialogTheme',
    base: DialogStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
    ),
    partial: DialogStyle(padding: const EdgeInsets.all(4)),
    combined: DialogStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
      padding: const EdgeInsets.all(4),
    ),
    global: ({required DialogStyle data}) => ThemeData(dialogStyle: data),
    create: ({required DialogStyle data, required Widget child}) =>
        DialogTheme(data: data, child: child),
    merge: ({required DialogStyle data, required Widget child}) =>
        DialogTheme.merge(data: data, child: child),
    of: DialogTheme.of,
    maybeOf: DialogTheme.maybeOf,
    shouldNotify: (DialogTheme current, DialogTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<BottomSheetStyle, BottomSheetTheme>(
    name: 'BottomSheetTheme',
    base: BottomSheetStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
    ),
    partial: BottomSheetStyle(padding: const EdgeInsets.all(4)),
    combined: BottomSheetStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
      padding: const EdgeInsets.all(4),
    ),
    global: ({required BottomSheetStyle data}) =>
        ThemeData(bottomSheetStyle: data),
    create: ({required BottomSheetStyle data, required Widget child}) =>
        BottomSheetTheme(data: data, child: child),
    merge: ({required BottomSheetStyle data, required Widget child}) =>
        BottomSheetTheme.merge(data: data, child: child),
    of: BottomSheetTheme.of,
    maybeOf: BottomSheetTheme.maybeOf,
    shouldNotify: (BottomSheetTheme current, BottomSheetTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<SnackBarStyle, SnackBarTheme>(
    name: 'SnackBarTheme',
    base: SnackBarStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
    ),
    partial: SnackBarStyle(padding: const EdgeInsets.all(4)),
    combined: SnackBarStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
      padding: const EdgeInsets.all(4),
    ),
    global: ({required SnackBarStyle data}) => ThemeData(snackBarStyle: data),
    create: ({required SnackBarStyle data, required Widget child}) =>
        SnackBarTheme(data: data, child: child),
    merge: ({required SnackBarStyle data, required Widget child}) =>
        SnackBarTheme.merge(data: data, child: child),
    of: SnackBarTheme.of,
    maybeOf: SnackBarTheme.maybeOf,
    shouldNotify: (SnackBarTheme current, SnackBarTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<TextFieldStyle, TextFieldTheme>(
    name: 'TextFieldTheme',
    base: TextFieldStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    ),
    partial: TextFieldStyle(
      foregroundDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    combined: TextFieldStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
      foregroundDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    global: ({required TextFieldStyle data}) => ThemeData(textFieldStyle: data),
    create: ({required TextFieldStyle data, required Widget child}) =>
        TextFieldTheme(data: data, child: child),
    merge: ({required TextFieldStyle data, required Widget child}) =>
        TextFieldTheme.merge(data: data, child: child),
    of: TextFieldTheme.of,
    maybeOf: TextFieldTheme.maybeOf,
    shouldNotify: (TextFieldTheme current, TextFieldTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<AutocompleteStyle, AutocompleteTheme>(
    name: 'AutocompleteTheme',
    base: AutocompleteStyle(fieldStyle: const TextFieldStyle(spacing: 2)),
    partial: AutocompleteStyle(
      menuStyle: const MenuStyle(offset: Offset(3, 4)),
    ),
    combined: AutocompleteStyle(
      fieldStyle: const TextFieldStyle(spacing: 2),
      menuStyle: const MenuStyle(offset: Offset(3, 4)),
    ),
    global: ({required AutocompleteStyle data}) =>
        ThemeData(autocompleteStyle: data),
    create: ({required AutocompleteStyle data, required Widget child}) =>
        AutocompleteTheme(data: data, child: child),
    merge: ({required AutocompleteStyle data, required Widget child}) =>
        AutocompleteTheme.merge(data: data, child: child),
    of: AutocompleteTheme.of,
    maybeOf: AutocompleteTheme.maybeOf,
    shouldNotify: (AutocompleteTheme current, AutocompleteTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<SearchStyle, SearchTheme>(
    name: 'SearchTheme',
    base: SearchStyle(fieldStyle: const TextFieldStyle(spacing: 2)),
    partial: SearchStyle(
      viewDecoration: const BoxDecoration(color: Color(0xFF445566)),
    ),
    combined: SearchStyle(
      fieldStyle: const TextFieldStyle(spacing: 2),
      viewDecoration: const BoxDecoration(color: Color(0xFF445566)),
    ),
    global: ({required SearchStyle data}) => ThemeData(searchStyle: data),
    create: ({required SearchStyle data, required Widget child}) =>
        SearchTheme(data: data, child: child),
    merge: ({required SearchStyle data, required Widget child}) =>
        SearchTheme.merge(data: data, child: child),
    of: SearchTheme.of,
    maybeOf: SearchTheme.maybeOf,
    shouldNotify: (SearchTheme current, SearchTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<DatePickerStyle, DatePickerTheme>(
    name: 'DatePickerTheme',
    base: DatePickerStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
    ),
    partial: DatePickerStyle(padding: const EdgeInsets.all(4)),
    combined: DatePickerStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
      padding: const EdgeInsets.all(4),
    ),
    global: ({required DatePickerStyle data}) =>
        ThemeData(datePickerStyle: data),
    create: ({required DatePickerStyle data, required Widget child}) =>
        DatePickerTheme(data: data, child: child),
    merge: ({required DatePickerStyle data, required Widget child}) =>
        DatePickerTheme.merge(data: data, child: child),
    of: DatePickerTheme.of,
    maybeOf: DatePickerTheme.maybeOf,
    shouldNotify: (DatePickerTheme current, DatePickerTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<TimePickerStyle, TimePickerTheme>(
    name: 'TimePickerTheme',
    base: TimePickerStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
    ),
    partial: TimePickerStyle(padding: const EdgeInsets.all(4)),
    combined: TimePickerStyle(
      decoration: const BoxDecoration(color: Color(0xFF112233)),
      padding: const EdgeInsets.all(4),
    ),
    global: ({required TimePickerStyle data}) =>
        ThemeData(timePickerStyle: data),
    create: ({required TimePickerStyle data, required Widget child}) =>
        TimePickerTheme(data: data, child: child),
    merge: ({required TimePickerStyle data, required Widget child}) =>
        TimePickerTheme.merge(data: data, child: child),
    of: TimePickerTheme.of,
    maybeOf: TimePickerTheme.maybeOf,
    shouldNotify: (TimePickerTheme current, TimePickerTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, FilledButtonTheme>(
    name: 'FilledButtonTheme',
    base: ButtonStyle(spacing: 2.0),
    partial: ButtonStyle(alignment: AlignmentDirectional.bottomEnd),
    combined: ButtonStyle(
      spacing: 2.0,
      alignment: AlignmentDirectional.bottomEnd,
    ),
    global: ({required ButtonStyle data}) => ThemeData(filledButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        FilledButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        FilledButtonTheme.merge(data: data, child: child),
    of: FilledButtonTheme.of,
    maybeOf: FilledButtonTheme.maybeOf,
    shouldNotify: (FilledButtonTheme current, FilledButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, FloatingActionButtonTheme>(
    name: 'FloatingActionButtonTheme',
    base: ButtonStyle(spacing: 2.0),
    partial: ButtonStyle(alignment: AlignmentDirectional.bottomEnd),
    combined: ButtonStyle(
      spacing: 2.0,
      alignment: AlignmentDirectional.bottomEnd,
    ),
    global: ({required ButtonStyle data}) =>
        ThemeData(floatingActionButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        FloatingActionButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        FloatingActionButtonTheme.merge(data: data, child: child),
    of: FloatingActionButtonTheme.of,
    maybeOf: FloatingActionButtonTheme.maybeOf,
    shouldNotify: (
      FloatingActionButtonTheme current,
      FloatingActionButtonTheme old,
    ) => current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, SegmentedButtonTheme>(
    name: 'SegmentedButtonTheme',
    base: ButtonStyle(spacing: 2.0),
    partial: ButtonStyle(alignment: AlignmentDirectional.bottomEnd),
    combined: ButtonStyle(
      spacing: 2.0,
      alignment: AlignmentDirectional.bottomEnd,
    ),
    global: ({required ButtonStyle data}) =>
        ThemeData(segmentedButtonStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        SegmentedButtonTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        SegmentedButtonTheme.merge(data: data, child: child),
    of: SegmentedButtonTheme.of,
    maybeOf: SegmentedButtonTheme.maybeOf,
    shouldNotify: (SegmentedButtonTheme current, SegmentedButtonTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ButtonStyle, ToggleButtonsTheme>(
    name: 'ToggleButtonsTheme',
    base: ButtonStyle(spacing: 2.0),
    partial: ButtonStyle(alignment: AlignmentDirectional.bottomEnd),
    combined: ButtonStyle(
      spacing: 2.0,
      alignment: AlignmentDirectional.bottomEnd,
    ),
    global: ({required ButtonStyle data}) =>
        ThemeData(toggleButtonsStyle: data),
    create: ({required ButtonStyle data, required Widget child}) =>
        ToggleButtonsTheme(data: data, child: child),
    merge: ({required ButtonStyle data, required Widget child}) =>
        ToggleButtonsTheme.merge(data: data, child: child),
    of: ToggleButtonsTheme.of,
    maybeOf: ToggleButtonsTheme.maybeOf,
    shouldNotify: (ToggleButtonsTheme current, ToggleButtonsTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ChipStyle, ChipTheme>(
    name: 'ChipTheme',
    base: ChipStyle(buttonStyle: const ButtonStyle(spacing: 2)),
    partial: ChipStyle(deleteButtonStyle: const ButtonStyle(spacing: 4)),
    combined: ChipStyle(
      buttonStyle: const ButtonStyle(spacing: 2),
      deleteButtonStyle: const ButtonStyle(spacing: 4),
    ),
    global: ({required ChipStyle data}) => ThemeData(chipStyle: data),
    create: ({required ChipStyle data, required Widget child}) =>
        ChipTheme(data: data, child: child),
    merge: ({required ChipStyle data, required Widget child}) =>
        ChipTheme.merge(data: data, child: child),
    of: ChipTheme.of,
    maybeOf: ChipTheme.maybeOf,
    shouldNotify: (ChipTheme current, ChipTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<TabBarStyle, TabBarTheme>(
    name: 'TabBarTheme',
    base: TabBarStyle(tabStyle: const ButtonStyle(spacing: 2)),
    partial: TabBarStyle(
      indicatorDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    combined: TabBarStyle(
      tabStyle: const ButtonStyle(spacing: 2),
      indicatorDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    global: ({required TabBarStyle data}) => ThemeData(tabBarStyle: data),
    create: ({required TabBarStyle data, required Widget child}) =>
        TabBarTheme(data: data, child: child),
    merge: ({required TabBarStyle data, required Widget child}) =>
        TabBarTheme.merge(data: data, child: child),
    of: TabBarTheme.of,
    maybeOf: TabBarTheme.maybeOf,
    shouldNotify: (TabBarTheme current, TabBarTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<NavigationStyle, NavigationTheme>(
    name: 'NavigationTheme',
    base: NavigationStyle(destinationStyle: const ButtonStyle(spacing: 2)),
    partial: NavigationStyle(
      indicatorDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    combined: NavigationStyle(
      destinationStyle: const ButtonStyle(spacing: 2),
      indicatorDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    global: ({required NavigationStyle data}) =>
        ThemeData(navigationStyle: data),
    create: ({required NavigationStyle data, required Widget child}) =>
        NavigationTheme(data: data, child: child),
    merge: ({required NavigationStyle data, required Widget child}) =>
        NavigationTheme.merge(data: data, child: child),
    of: NavigationTheme.of,
    maybeOf: NavigationTheme.maybeOf,
    shouldNotify: (NavigationTheme current, NavigationTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ExpansionTileStyle, ExpansionTileTheme>(
    name: 'ExpansionTileTheme',
    base: ExpansionTileStyle(
      tileStyle: const ListTileStyle(horizontalTitleGap: 2),
    ),
    partial: ExpansionTileStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    combined: ExpansionTileStyle(
      tileStyle: const ListTileStyle(horizontalTitleGap: 2),
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    ),
    global: ({required ExpansionTileStyle data}) =>
        ThemeData(expansionTileStyle: data),
    create: ({required ExpansionTileStyle data, required Widget child}) =>
        ExpansionTileTheme(data: data, child: child),
    merge: ({required ExpansionTileStyle data, required Widget child}) =>
        ExpansionTileTheme.merge(data: data, child: child),
    of: ExpansionTileTheme.of,
    maybeOf: ExpansionTileTheme.maybeOf,
    shouldNotify: (ExpansionTileTheme current, ExpansionTileTheme old) =>
        current.updateShouldNotify(old),
  );
  _componentThemeTests<ProgressIndicatorStyle, ProgressIndicatorTheme>(
    name: 'ProgressIndicatorTheme',
    base: ProgressIndicatorStyle(
      color: const StateProperty<Color?>.all(Color(0xFF112233)),
    ),
    partial: ProgressIndicatorStyle(
      backgroundColor: const StateProperty<Color?>.all(Color(0xFF445566)),
    ),
    combined: ProgressIndicatorStyle(
      color: const StateProperty<Color?>.all(Color(0xFF112233)),
      backgroundColor: const StateProperty<Color?>.all(Color(0xFF445566)),
    ),
    global: ({required ProgressIndicatorStyle data}) =>
        ThemeData(progressIndicatorStyle: data),
    create: ({required ProgressIndicatorStyle data, required Widget child}) =>
        ProgressIndicatorTheme(data: data, child: child),
    merge: ({required ProgressIndicatorStyle data, required Widget child}) =>
        ProgressIndicatorTheme.merge(data: data, child: child),
    of: ProgressIndicatorTheme.of,
    maybeOf: ProgressIndicatorTheme.maybeOf,
    shouldNotify: (
      ProgressIndicatorTheme current,
      ProgressIndicatorTheme old,
    ) => current.updateShouldNotify(old),
  );
  _componentThemeTests<BadgeStyle, BadgeTheme>(
    name: 'BadgeTheme',
    base: BadgeStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    ),
    partial: BadgeStyle(
      textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18)),
    ),
    combined: BadgeStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
      textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18)),
    ),
    global: ({required BadgeStyle data}) => ThemeData(badgeStyle: data),
    create: ({required BadgeStyle data, required Widget child}) =>
        BadgeTheme(data: data, child: child),
    merge: ({required BadgeStyle data, required Widget child}) =>
        BadgeTheme.merge(data: data, child: child),
    of: BadgeTheme.of,
    maybeOf: BadgeTheme.maybeOf,
    shouldNotify: (BadgeTheme current, BadgeTheme old) =>
        current.updateShouldNotify(old),
  );

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
