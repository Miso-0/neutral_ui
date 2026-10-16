import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

void main() {
  test('public API coexists with widgets without import prefixes', () {
    final List<Type> types = <Type>[
      InteractionState,
      StateProperty<int>,
      InteractionDetector,
      ChevronGlyph,
      CheckGlyph,
      DotsGlyph,
      ThemeData,
      PureTheme,
      ButtonStyle,
      ToggleStyle,
      ListTileStyle,
      SliderStyle,
      MenuStyle,
      DropdownStyle,
      PopupMenuStyle,
      ElevatedButtonTheme,
      OutlinedButtonTheme,
      TextButtonTheme,
      IconButtonTheme,
      CheckboxTheme,
      SwitchTheme,
      RadioTheme,
      ListTileTheme,
      SliderTheme,
      DropdownButtonTheme,
      DropdownMenuTheme,
      PopupMenuTheme,
      IconAlignment,
      ListTileTitleAlignment,
      SliderInteraction,
      DropdownMenuCloseBehavior,
      PopupMenuPosition,
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
      DropdownButton<int>,
      DropdownMenuItem<int>,
      DropdownMenu<int>,
      DropdownMenuEntry<int>,
      PopupMenuButton<int>,
      PopupMenuButtonState<int>,
      PopupMenuEntry<int>,
      PopupMenuItem<int>,
      CheckedPopupMenuItem<int>,
      PopupMenuDivider,
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
    List<Widget> selectedItems(BuildContext context) => const <Widget>[];
    Widget transition(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    ) => child;
    List<DropdownMenuEntry<int>> filter(
      List<DropdownMenuEntry<int>> entries,
      String query,
    ) => entries;
    int? search(List<DropdownMenuEntry<int>> entries, String query) => null;
    Widget selection(
      BuildContext context,
      List<DropdownMenuEntry<int>> entries,
    ) => const SizedBox();
    List<PopupMenuEntry<int>> popupItems(BuildContext context) =>
        const <PopupMenuEntry<int>>[];
    void itemSelected(int value) {}
    void canceled() {}
    expect(types, isNotEmpty);
    expect(<StateResolver<int>>[resolver].single(const InteractionState()), 0);
    expect(<InteractionWidgetBuilder>[builder], hasLength(1));
    expect(<SemanticFormatterCallback>[formatter].single(0.5), '0.5');
    expect(<SliderValueIndicatorBuilder>[indicator], hasLength(1));
    expect(<DropdownButtonBuilder>[selectedItems], hasLength(1));
    expect(<MenuTransitionBuilder>[transition], hasLength(1));
    expect(<FilterCallback<int>>[filter], hasLength(1));
    expect(<SearchCallback<int>>[search], hasLength(1));
    expect(<DropdownSelectionBuilder<int>>[selection], hasLength(1));
    expect(<PopupMenuItemBuilder<int>>[popupItems], hasLength(1));
    expect(<PopupMenuItemSelected<int>>[itemSelected], hasLength(1));
    expect(<PopupMenuCanceled>[canceled], hasLength(1));
  });
}
