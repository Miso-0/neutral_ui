import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

void main() {
  test('ThemeData tooltipStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      tooltipStyle: TooltipStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ThemeData inherited = ThemeData(
      tooltipStyle: TooltipStyle(padding: const EdgeInsets.all(4)),
    );
    expect(
      const ThemeData().copyWith(
        tooltipStyle: TooltipStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).tooltipStyle,
      TooltipStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
        padding: const EdgeInsets.all(4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        tooltipStyle: TooltipStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('tooltipStyle:'));
  });
  test('ThemeData dialogStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      dialogStyle: DialogStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ThemeData inherited = ThemeData(
      dialogStyle: DialogStyle(padding: const EdgeInsets.all(4)),
    );
    expect(
      const ThemeData().copyWith(
        dialogStyle: DialogStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).dialogStyle,
      DialogStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
        padding: const EdgeInsets.all(4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        dialogStyle: DialogStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('dialogStyle:'));
  });
  test('ThemeData bottomSheetStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      bottomSheetStyle: BottomSheetStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ThemeData inherited = ThemeData(
      bottomSheetStyle: BottomSheetStyle(padding: const EdgeInsets.all(4)),
    );
    expect(
      const ThemeData().copyWith(
        bottomSheetStyle: BottomSheetStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).bottomSheetStyle,
      BottomSheetStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
        padding: const EdgeInsets.all(4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        bottomSheetStyle: BottomSheetStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('bottomSheetStyle:'));
  });
  test('ThemeData snackBarStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      snackBarStyle: SnackBarStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ThemeData inherited = ThemeData(
      snackBarStyle: SnackBarStyle(padding: const EdgeInsets.all(4)),
    );
    expect(
      const ThemeData().copyWith(
        snackBarStyle: SnackBarStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).snackBarStyle,
      SnackBarStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
        padding: const EdgeInsets.all(4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        snackBarStyle: SnackBarStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('snackBarStyle:'));
  });
  test('ThemeData textFieldStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      textFieldStyle: TextFieldStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
    );
    final ThemeData inherited = ThemeData(
      textFieldStyle: TextFieldStyle(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      const ThemeData().copyWith(
        textFieldStyle: TextFieldStyle(
          decoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).textFieldStyle,
      TextFieldStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        textFieldStyle: TextFieldStyle(
          decoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('textFieldStyle:'));
  });
  test('ThemeData autocompleteStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      autocompleteStyle: AutocompleteStyle(
        fieldStyle: const TextFieldStyle(spacing: 2),
      ),
    );
    final ThemeData inherited = ThemeData(
      autocompleteStyle: AutocompleteStyle(
        menuStyle: const MenuStyle(offset: Offset(3, 4)),
      ),
    );
    expect(
      const ThemeData().copyWith(
        autocompleteStyle: AutocompleteStyle(
          fieldStyle: const TextFieldStyle(spacing: 2),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).autocompleteStyle,
      AutocompleteStyle(
        fieldStyle: const TextFieldStyle(spacing: 2),
        menuStyle: const MenuStyle(offset: Offset(3, 4)),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        autocompleteStyle: AutocompleteStyle(
          fieldStyle: const TextFieldStyle(spacing: 2),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('autocompleteStyle:'));
  });
  test('ThemeData searchStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      searchStyle: SearchStyle(fieldStyle: const TextFieldStyle(spacing: 2)),
    );
    final ThemeData inherited = ThemeData(
      searchStyle: SearchStyle(
        viewDecoration: const BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    expect(
      const ThemeData().copyWith(
        searchStyle: SearchStyle(fieldStyle: const TextFieldStyle(spacing: 2)),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).searchStyle,
      SearchStyle(
        fieldStyle: const TextFieldStyle(spacing: 2),
        viewDecoration: const BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        searchStyle: SearchStyle(fieldStyle: const TextFieldStyle(spacing: 2)),
      ).hashCode,
    );
    expect(first.toString(), contains('searchStyle:'));
  });
  test('ThemeData datePickerStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      datePickerStyle: DatePickerStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ThemeData inherited = ThemeData(
      datePickerStyle: DatePickerStyle(padding: const EdgeInsets.all(4)),
    );
    expect(
      const ThemeData().copyWith(
        datePickerStyle: DatePickerStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).datePickerStyle,
      DatePickerStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
        padding: const EdgeInsets.all(4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        datePickerStyle: DatePickerStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('datePickerStyle:'));
  });
  test('ThemeData timePickerStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      timePickerStyle: TimePickerStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ThemeData inherited = ThemeData(
      timePickerStyle: TimePickerStyle(padding: const EdgeInsets.all(4)),
    );
    expect(
      const ThemeData().copyWith(
        timePickerStyle: TimePickerStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).timePickerStyle,
      TimePickerStyle(
        decoration: const BoxDecoration(color: Color(0xFF112233)),
        padding: const EdgeInsets.all(4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        timePickerStyle: TimePickerStyle(
          decoration: const BoxDecoration(color: Color(0xFF112233)),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('timePickerStyle:'));
  });
  test('ThemeData filledButtonStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      filledButtonStyle: ButtonStyle(spacing: 2.0),
    );
    final ThemeData inherited = ThemeData(
      filledButtonStyle: ButtonStyle(alignment: AlignmentDirectional.bottomEnd),
    );
    expect(
      const ThemeData().copyWith(filledButtonStyle: ButtonStyle(spacing: 2.0)),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).filledButtonStyle,
      ButtonStyle(spacing: 2.0, alignment: AlignmentDirectional.bottomEnd),
    );
    expect(
      first.hashCode,
      ThemeData(filledButtonStyle: ButtonStyle(spacing: 2.0)).hashCode,
    );
    expect(first.toString(), contains('filledButtonStyle:'));
  });
  test(
    'ThemeData floatingActionButtonStyle copies and deeply inherits tokens',
    () {
      final ThemeData first = ThemeData(
        floatingActionButtonStyle: ButtonStyle(spacing: 2.0),
      );
      final ThemeData inherited = ThemeData(
        floatingActionButtonStyle: ButtonStyle(
          alignment: AlignmentDirectional.bottomEnd,
        ),
      );
      expect(
        const ThemeData().copyWith(
          floatingActionButtonStyle: ButtonStyle(spacing: 2.0),
        ),
        first,
      );
      expect(first.copyWith(), first);
      expect(
        first.merge(inherited).floatingActionButtonStyle,
        ButtonStyle(spacing: 2.0, alignment: AlignmentDirectional.bottomEnd),
      );
      expect(
        first.hashCode,
        ThemeData(floatingActionButtonStyle: ButtonStyle(spacing: 2.0))
            .hashCode,
      );
      expect(first.toString(), contains('floatingActionButtonStyle:'));
    },
  );
  test('ThemeData segmentedButtonStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      segmentedButtonStyle: ButtonStyle(spacing: 2.0),
    );
    final ThemeData inherited = ThemeData(
      segmentedButtonStyle: ButtonStyle(
        alignment: AlignmentDirectional.bottomEnd,
      ),
    );
    expect(
      const ThemeData().copyWith(
        segmentedButtonStyle: ButtonStyle(spacing: 2.0),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).segmentedButtonStyle,
      ButtonStyle(spacing: 2.0, alignment: AlignmentDirectional.bottomEnd),
    );
    expect(
      first.hashCode,
      ThemeData(segmentedButtonStyle: ButtonStyle(spacing: 2.0)).hashCode,
    );
    expect(first.toString(), contains('segmentedButtonStyle:'));
  });
  test('ThemeData toggleButtonsStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      toggleButtonsStyle: ButtonStyle(spacing: 2.0),
    );
    final ThemeData inherited = ThemeData(
      toggleButtonsStyle: ButtonStyle(
        alignment: AlignmentDirectional.bottomEnd,
      ),
    );
    expect(
      const ThemeData().copyWith(toggleButtonsStyle: ButtonStyle(spacing: 2.0)),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).toggleButtonsStyle,
      ButtonStyle(spacing: 2.0, alignment: AlignmentDirectional.bottomEnd),
    );
    expect(
      first.hashCode,
      ThemeData(toggleButtonsStyle: ButtonStyle(spacing: 2.0)).hashCode,
    );
    expect(first.toString(), contains('toggleButtonsStyle:'));
  });
  test('ThemeData chipStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      chipStyle: ChipStyle(buttonStyle: const ButtonStyle(spacing: 2)),
    );
    final ThemeData inherited = ThemeData(
      chipStyle: ChipStyle(deleteButtonStyle: const ButtonStyle(spacing: 4)),
    );
    expect(
      const ThemeData().copyWith(
        chipStyle: ChipStyle(buttonStyle: const ButtonStyle(spacing: 2)),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).chipStyle,
      ChipStyle(
        buttonStyle: const ButtonStyle(spacing: 2),
        deleteButtonStyle: const ButtonStyle(spacing: 4),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        chipStyle: ChipStyle(buttonStyle: const ButtonStyle(spacing: 2)),
      ).hashCode,
    );
    expect(first.toString(), contains('chipStyle:'));
  });
  test('ThemeData tabBarStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      tabBarStyle: TabBarStyle(tabStyle: const ButtonStyle(spacing: 2)),
    );
    final ThemeData inherited = ThemeData(
      tabBarStyle: TabBarStyle(
        indicatorDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      const ThemeData().copyWith(
        tabBarStyle: TabBarStyle(tabStyle: const ButtonStyle(spacing: 2)),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).tabBarStyle,
      TabBarStyle(
        tabStyle: const ButtonStyle(spacing: 2),
        indicatorDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        tabBarStyle: TabBarStyle(tabStyle: const ButtonStyle(spacing: 2)),
      ).hashCode,
    );
    expect(first.toString(), contains('tabBarStyle:'));
  });
  test('ThemeData navigationStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      navigationStyle: NavigationStyle(
        destinationStyle: const ButtonStyle(spacing: 2),
      ),
    );
    final ThemeData inherited = ThemeData(
      navigationStyle: NavigationStyle(
        indicatorDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      const ThemeData().copyWith(
        navigationStyle: NavigationStyle(
          destinationStyle: const ButtonStyle(spacing: 2),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).navigationStyle,
      NavigationStyle(
        destinationStyle: const ButtonStyle(spacing: 2),
        indicatorDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        navigationStyle: NavigationStyle(
          destinationStyle: const ButtonStyle(spacing: 2),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('navigationStyle:'));
  });
  test('ThemeData expansionTileStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      expansionTileStyle: ExpansionTileStyle(
        tileStyle: const ListTileStyle(horizontalTitleGap: 2),
      ),
    );
    final ThemeData inherited = ThemeData(
      expansionTileStyle: ExpansionTileStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      const ThemeData().copyWith(
        expansionTileStyle: ExpansionTileStyle(
          tileStyle: const ListTileStyle(horizontalTitleGap: 2),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).expansionTileStyle,
      ExpansionTileStyle(
        tileStyle: const ListTileStyle(horizontalTitleGap: 2),
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        expansionTileStyle: ExpansionTileStyle(
          tileStyle: const ListTileStyle(horizontalTitleGap: 2),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('expansionTileStyle:'));
  });
  test(
    'ThemeData progressIndicatorStyle copies and deeply inherits tokens',
    () {
      final ThemeData first = ThemeData(
        progressIndicatorStyle: ProgressIndicatorStyle(
          color: const StateProperty<Color?>.all(Color(0xFF112233)),
        ),
      );
      final ThemeData inherited = ThemeData(
        progressIndicatorStyle: ProgressIndicatorStyle(
          backgroundColor: const StateProperty<Color?>.all(Color(0xFF445566)),
        ),
      );
      expect(
        const ThemeData().copyWith(
          progressIndicatorStyle: ProgressIndicatorStyle(
            color: const StateProperty<Color?>.all(Color(0xFF112233)),
          ),
        ),
        first,
      );
      expect(first.copyWith(), first);
      expect(
        first.merge(inherited).progressIndicatorStyle,
        ProgressIndicatorStyle(
          color: const StateProperty<Color?>.all(Color(0xFF112233)),
          backgroundColor: const StateProperty<Color?>.all(Color(0xFF445566)),
        ),
      );
      expect(
        first.hashCode,
        ThemeData(
          progressIndicatorStyle: ProgressIndicatorStyle(
            color: const StateProperty<Color?>.all(Color(0xFF112233)),
          ),
        ).hashCode,
      );
      expect(first.toString(), contains('progressIndicatorStyle:'));
    },
  );
  test('ThemeData badgeStyle copies and deeply inherits tokens', () {
    final ThemeData first = ThemeData(
      badgeStyle: BadgeStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      ),
    );
    final ThemeData inherited = ThemeData(
      badgeStyle: BadgeStyle(
        textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18)),
      ),
    );
    expect(
      const ThemeData().copyWith(
        badgeStyle: BadgeStyle(
          decoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        ),
      ),
      first,
    );
    expect(first.copyWith(), first);
    expect(
      first.merge(inherited).badgeStyle,
      BadgeStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18)),
      ),
    );
    expect(
      first.hashCode,
      ThemeData(
        badgeStyle: BadgeStyle(
          decoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        ),
      ).hashCode,
    );
    expect(first.toString(), contains('badgeStyle:'));
  });

  test('ThemeData copies and merges elevatedButtonStyle', () {
    final ButtonStyle first = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ButtonStyle second = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    final ThemeData theme = ThemeData(elevatedButtonStyle: first);
    final ThemeData copied = const ThemeData().copyWith(
      elevatedButtonStyle: first,
    );
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(
      theme.copyWith(elevatedButtonStyle: second).elevatedButtonStyle,
      second,
    );
    expect(theme.copyWith(), theme);
    expect(
      theme.merge(ThemeData(elevatedButtonStyle: second)).elevatedButtonStyle,
      first,
    );
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('elevatedButtonStyle:'));
  });
  test('ThemeData copies and merges outlinedButtonStyle', () {
    final ButtonStyle first = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ButtonStyle second = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    final ThemeData theme = ThemeData(outlinedButtonStyle: first);
    final ThemeData copied = const ThemeData().copyWith(
      outlinedButtonStyle: first,
    );
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(
      theme.copyWith(outlinedButtonStyle: second).outlinedButtonStyle,
      second,
    );
    expect(theme.copyWith(), theme);
    expect(
      theme.merge(ThemeData(outlinedButtonStyle: second)).outlinedButtonStyle,
      first,
    );
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('outlinedButtonStyle:'));
  });
  test('ThemeData copies and merges textButtonStyle', () {
    final ButtonStyle first = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ButtonStyle second = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    final ThemeData theme = ThemeData(textButtonStyle: first);
    final ThemeData copied = const ThemeData().copyWith(textButtonStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(textButtonStyle: second).textButtonStyle, second);
    expect(theme.copyWith(), theme);
    expect(
      theme.merge(ThemeData(textButtonStyle: second)).textButtonStyle,
      first,
    );
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('textButtonStyle:'));
  });
  test('ThemeData copies and merges iconButtonStyle', () {
    final ButtonStyle first = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ButtonStyle second = ButtonStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    final ThemeData theme = ThemeData(iconButtonStyle: first);
    final ThemeData copied = const ThemeData().copyWith(iconButtonStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(iconButtonStyle: second).iconButtonStyle, second);
    expect(theme.copyWith(), theme);
    expect(
      theme.merge(ThemeData(iconButtonStyle: second)).iconButtonStyle,
      first,
    );
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('iconButtonStyle:'));
  });
  test('ThemeData copies and merges checkboxStyle', () {
    final ToggleStyle first = ToggleStyle(
      size: const StateProperty<Size?>.all(Size(10, 20)),
    );
    final ToggleStyle second = ToggleStyle(
      size: const StateProperty<Size?>.all(Size(30, 40)),
    );
    final ThemeData theme = ThemeData(checkboxStyle: first);
    final ThemeData copied = const ThemeData().copyWith(checkboxStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(checkboxStyle: second).checkboxStyle, second);
    expect(theme.copyWith(), theme);
    expect(theme.merge(ThemeData(checkboxStyle: second)).checkboxStyle, first);
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('checkboxStyle:'));
  });
  test('ThemeData copies and merges switchStyle', () {
    final ToggleStyle first = ToggleStyle(
      size: const StateProperty<Size?>.all(Size(10, 20)),
    );
    final ToggleStyle second = ToggleStyle(
      size: const StateProperty<Size?>.all(Size(30, 40)),
    );
    final ThemeData theme = ThemeData(switchStyle: first);
    final ThemeData copied = const ThemeData().copyWith(switchStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(switchStyle: second).switchStyle, second);
    expect(theme.copyWith(), theme);
    expect(theme.merge(ThemeData(switchStyle: second)).switchStyle, first);
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('switchStyle:'));
  });
  test('ThemeData copies and merges radioStyle', () {
    final ToggleStyle first = ToggleStyle(
      size: const StateProperty<Size?>.all(Size(10, 20)),
    );
    final ToggleStyle second = ToggleStyle(
      size: const StateProperty<Size?>.all(Size(30, 40)),
    );
    final ThemeData theme = ThemeData(radioStyle: first);
    final ThemeData copied = const ThemeData().copyWith(radioStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(radioStyle: second).radioStyle, second);
    expect(theme.copyWith(), theme);
    expect(theme.merge(ThemeData(radioStyle: second)).radioStyle, first);
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('radioStyle:'));
  });
  test('ThemeData copies and merges listTileStyle', () {
    final ListTileStyle first = ListTileStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF112233)),
      ),
    );
    final ListTileStyle second = ListTileStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFF445566)),
      ),
    );
    final ThemeData theme = ThemeData(listTileStyle: first);
    final ThemeData copied = const ThemeData().copyWith(listTileStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(listTileStyle: second).listTileStyle, second);
    expect(theme.copyWith(), theme);
    expect(theme.merge(ThemeData(listTileStyle: second)).listTileStyle, first);
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('listTileStyle:'));
  });
  test('ThemeData copies and merges sliderStyle', () {
    final SliderStyle first = SliderStyle(
      trackHeight: const StateProperty<double?>.all(5),
    );
    final SliderStyle second = SliderStyle(
      trackHeight: const StateProperty<double?>.all(9),
    );
    final ThemeData theme = ThemeData(sliderStyle: first);
    final ThemeData copied = const ThemeData().copyWith(sliderStyle: first);
    expect(copied, theme);
    expect(copied.hashCode, theme.hashCode);
    expect(theme.copyWith(sliderStyle: second).sliderStyle, second);
    expect(theme.copyWith(), theme);
    expect(theme.merge(ThemeData(sliderStyle: second)).sliderStyle, first);
    expect(const ThemeData().merge(theme), theme);
    expect(theme.merge(null), same(theme));
    expect(theme.toString(), contains('sliderStyle:'));
  });
  test('ThemeData merge fills individual tokens within each component', () {
    const ThemeData local = ThemeData(
      elevatedButtonStyle: ButtonStyle(spacing: 4),
      switchStyle: ToggleStyle(animationDuration: Duration(milliseconds: 10)),
    );
    const ThemeData inherited = ThemeData(
      elevatedButtonStyle: ButtonStyle(
        spacing: 9,
        alignment: Alignment.topLeft,
      ),
      switchStyle: ToggleStyle(padding: EdgeInsets.all(3)),
      sliderStyle: SliderStyle(preferredWidth: 200),
    );
    final ThemeData merged = local.merge(inherited);
    expect(merged.elevatedButtonStyle.spacing, 4);
    expect(merged.elevatedButtonStyle.alignment, Alignment.topLeft);
    expect(merged.switchStyle.padding, const EdgeInsets.all(3));
    expect(
      merged.switchStyle.animationDuration,
      const Duration(milliseconds: 10),
    );
    expect(merged.sliderStyle.preferredWidth, 200);
  });
  test('ThemeData copies and merges dropdownButtonStyle', () {
    const DropdownStyle first = DropdownStyle(cursorWidth: 1);
    const DropdownStyle second = DropdownStyle(cursorWidth: 2);
    const ThemeData original = ThemeData(dropdownButtonStyle: first);
    final ThemeData copied = const ThemeData().copyWith(
      dropdownButtonStyle: first,
    );
    expect(const ThemeData().dropdownButtonStyle, const DropdownStyle());
    expect(copied, original);
    expect(copied.hashCode, original.hashCode);
    expect(
      copied.copyWith(dropdownButtonStyle: second).dropdownButtonStyle,
      second,
    );
    expect(copied.copyWith(), original);
    expect(
      original
          .merge(const ThemeData(dropdownButtonStyle: second))
          .dropdownButtonStyle,
      first,
    );
    expect(const ThemeData().merge(original), original);
    expect(original.merge(null), same(original));
    expect(original.toString(), contains('dropdownButtonStyle:'));
  });
  test('ThemeData copies and merges dropdownMenuStyle', () {
    const DropdownStyle first = DropdownStyle(cursorWidth: 1);
    const DropdownStyle second = DropdownStyle(cursorWidth: 2);
    const ThemeData original = ThemeData(dropdownMenuStyle: first);
    final ThemeData copied = const ThemeData().copyWith(
      dropdownMenuStyle: first,
    );
    expect(const ThemeData().dropdownMenuStyle, const DropdownStyle());
    expect(copied, original);
    expect(copied.hashCode, original.hashCode);
    expect(
      copied.copyWith(dropdownMenuStyle: second).dropdownMenuStyle,
      second,
    );
    expect(copied.copyWith(), original);
    expect(
      original
          .merge(const ThemeData(dropdownMenuStyle: second))
          .dropdownMenuStyle,
      first,
    );
    expect(const ThemeData().merge(original), original);
    expect(original.merge(null), same(original));
    expect(original.toString(), contains('dropdownMenuStyle:'));
  });
  test('ThemeData copies and merges popupMenuStyle', () {
    const PopupMenuStyle first = PopupMenuStyle(dividerHeight: 1);
    const PopupMenuStyle second = PopupMenuStyle(dividerHeight: 2);
    const ThemeData original = ThemeData(popupMenuStyle: first);
    final ThemeData copied = const ThemeData().copyWith(popupMenuStyle: first);
    expect(const ThemeData().popupMenuStyle, const PopupMenuStyle());
    expect(copied, original);
    expect(copied.hashCode, original.hashCode);
    expect(copied.copyWith(popupMenuStyle: second).popupMenuStyle, second);
    expect(copied.copyWith(), original);
    expect(
      original.merge(const ThemeData(popupMenuStyle: second)).popupMenuStyle,
      first,
    );
    expect(const ThemeData().merge(original), original);
    expect(original.merge(null), same(original));
    expect(original.toString(), contains('popupMenuStyle:'));
  });
  test('ThemeData deep-merges each menu component slot', () {
    const ThemeData local = ThemeData(
      dropdownButtonStyle: DropdownStyle(buttonStyle: ButtonStyle(spacing: 2)),
      dropdownMenuStyle: DropdownStyle(
        menuStyle: MenuStyle(offset: Offset(1, 2)),
      ),
      popupMenuStyle: PopupMenuStyle(itemStyle: ButtonStyle(spacing: 3)),
    );
    const ThemeData inherited = ThemeData(
      dropdownButtonStyle: DropdownStyle(
        buttonStyle: ButtonStyle(spacing: 9, alignment: Alignment.centerRight),
      ),
      dropdownMenuStyle: DropdownStyle(
        menuStyle: MenuStyle(offset: Offset(3, 4), maximumSize: Size(100, 200)),
      ),
      popupMenuStyle: PopupMenuStyle(
        itemStyle: ButtonStyle(spacing: 9, alignment: Alignment.topLeft),
      ),
    );
    final ThemeData merged = local.merge(inherited);
    expect(
      merged.dropdownButtonStyle.buttonStyle,
      const ButtonStyle(spacing: 2, alignment: Alignment.centerRight),
    );
    expect(
      merged.dropdownMenuStyle.menuStyle,
      const MenuStyle(offset: Offset(1, 2), maximumSize: Size(100, 200)),
    );
    expect(
      merged.popupMenuStyle.itemStyle,
      const ButtonStyle(spacing: 3, alignment: Alignment.topLeft),
    );
  });
}
