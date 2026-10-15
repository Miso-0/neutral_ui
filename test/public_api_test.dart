import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

void main() {
  test('public API coexists with widgets without import prefixes', () {
    final List<Type> types = <Type>[
      InteractionState,
      StateProperty<int>,
      InteractionDetector,
      ThemeData,
      PureTheme,
      ButtonStyle,
      ToggleStyle,
      ListTileStyle,
      SliderStyle,
      ElevatedButtonTheme,
      OutlinedButtonTheme,
      TextButtonTheme,
      IconButtonTheme,
      CheckboxTheme,
      SwitchTheme,
      RadioTheme,
      ListTileTheme,
      SliderTheme,
      IconAlignment,
      ListTileTitleAlignment,
      SliderInteraction,
      ButtonStyleButton,
      ElevatedButton,
      OutlinedButton,
      TextButton,
      IconButton,
      Checkbox,
      Switch,
      Radio<int>,
      ListTile,
      Slider,
    ];
    int resolver(InteractionState state) => state.isPressed ? 1 : 0;
    Widget builder(BuildContext context, InteractionState state) =>
        const SizedBox();
    String formatter(double value) => '$value';
    Widget indicator(
      BuildContext context,
      InteractionState state,
      double value,
      String? label,
    ) => Text(label ?? formatter(value));
    expect(types, isNotEmpty);
    expect(<StateResolver<int>>[resolver].single(const InteractionState()), 0);
    expect(<InteractionWidgetBuilder>[builder], hasLength(1));
    expect(<SemanticFormatterCallback>[formatter].single(0.5), '0.5');
    expect(<SliderValueIndicatorBuilder>[indicator], hasLength(1));
  });
}
