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
}
