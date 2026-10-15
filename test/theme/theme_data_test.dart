import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

void main() {
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
