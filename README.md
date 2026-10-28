# NeutralUI

NeutralUI is a headless Flutter design system with no third-party runtime dependencies. It supplies controlled values, pointer and keyboard interaction, semantics, layout slots, and composable themes. Your application supplies its visual language. The library uses Flutter's widgets layer without importing Material or Cupertino.

[Package](https://pub.dev/packages/neutral_ui) | [API reference](https://pub.dev/documentation/neutral_ui/latest/) | [Source](https://github.com/Miso-0/pure_ui) | [Issues](https://github.com/Miso-0/pure_ui/issues) | [Changelog](CHANGELOG.md)

Requires Flutter 3.47 or newer and Dart 3.13.4 or newer, below Dart 4.0.0. The release is validated with Flutter 3.47.5 and Dart 3.13.4.

- Buttons, toggles, chips, list tiles, sliders, and range sliders.
- Dropdowns, popup menus, text fields, autocomplete, and search.
- Dialogs, bottom sheets, snack bars, tooltips, badges, and progress indicators.
- Tabs, navigation controls, expansion tiles, and date, date range, and time pickers.
- Tables with sorting, selection, expandable rows, groups and footer rows.
- Shared interaction state, component themes, overlay placement, localization hooks, and reduced-motion behavior.

## Get started

Add the hosted package to your Flutter application's `pubspec.yaml`, then run `flutter pub get`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  neutral_ui: ^0.11.0
```

Replace `lib/main.dart` with this runnable example. `NeutralApp` supplies the theme, localization, navigation, and overlay foundations; the application supplies colors and other visual tokens.

```dart
import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => NeutralApp(
    color: const Color(0xFFF4F7F3),
    textStyle: const TextStyle(color: Color(0xFF142C2A), fontSize: 16),
    theme: ThemeData(
      elevatedButtonStyle: ButtonStyle(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(
          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        decoration: StateProperty<Decoration?>.resolveWith((
          InteractionState state,
        ) {
          return BoxDecoration(
            color: state.isPressed
                ? const Color(0xFF065F53)
                : const Color(0xFF087F6D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state.isFocused
                  ? const Color(0xFF142C2A)
                  : const Color(0x00000000),
              width: 2,
            ),
          );
        }),
        textStyle: const StateProperty<TextStyle?>.all(
          TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
    ),
    home: ColoredBox(
      color: const Color(0xFFF4F7F3),
      child: Center(
        child: ElevatedButton(
          onPressed: () => setState(() => _count += 1),
          child: Text('Pressed $_count times'),
        ),
      ),
    ),
  );
}
```

NeutralUI uses Material's familiar names: `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Checkbox`, `Switch`, `Radio`, `ListTile`, `DataTable`, `Slider`, `DropdownButton`, `DropdownMenu`, `PopupMenuButton`, `ButtonStyle`, `ThemeData`, and the component theme names. When importing `material.dart` as well, use a prefix for NeutralUI (`import 'package:neutral_ui/neutral_ui.dart' as neutral;`) or hide conflicting names. `widgets.dart` can be imported unprefixed alongside NeutralUI.

## State and styling

A `StateProperty<T>` resolves a token from an immutable `InteractionState`. States expose `isPressed`, `isHovered`, `isFocused`, `isSelected`, `isDisabled`, and `isDragged`. Constant tokens use `const StateProperty.all(value)`.

`isFocused` represents visible keyboard focus, like CSS `:focus-visible`. It is set only on the control that holds primary focus, and only after keyboard input, under directional navigation, or when the application selects `FocusHighlightStrategy.alwaysTraditional`. A pointer press hides it until the next key press, so focus moved in code while someone uses a mouse, such as a menu restoring focus to its anchor, draws no keyboard ring. Text fields show focus whenever they have it. `onFocusChange` reports raw focus, including focus held by a descendant.

Only the innermost interactive control shows hover and press. While the pointer is over a chip's delete button or a tile's trailing switch, the chip or tile reports neither, and a focused descendant never shows focus on its ancestor. `onHover` still reports that the pointer is over the outer control. Surfaces without an action, such as a `ListTile` without `onTap` or a `Chip` without callbacks, show no hover or press.

```dart
ButtonStyle(
  decoration: StateProperty.resolveWith((InteractionState state) {
    if (state.isDisabled) return const BoxDecoration(color: Color(0xFFCCCCCC));
    if (state.isPressed) return const BoxDecoration(color: Color(0xFF065F53));
    return const BoxDecoration(color: Color(0xFF087F6D));
  }),
)
```

Visual tokens are unset by default: your application supplies colors, radii, borders, shadows, margins, track sizes and text styles. Editable cursors use the required fallback described below. An unstyled control can be invisible, apart from the default glyphs below. Supply content and tokens to render it. Visual null values fall through to the next style layer for the current state. Padding and gaps default to zero.

A few indicator slots paint a default glyph instead of staying empty: the dropdown arrow (`ChevronGlyph`), the chosen dropdown row and checked popup item (`CheckGlyph`), and the button loading indicator (`DotsGlyph`). Glyphs are drawn with `CustomPainter`, never text characters, and take their color, opacity and size from the ambient `IconTheme` exactly like an `Icon`, so each control's `iconTheme` token styles them. A default applies only when no style layer provides the token: provide a token that resolves to null to show nothing, or any widget to replace it. The glyph widgets are public, so you can reuse them elsewhere.

The structural defaults are 200 ms animation with `Curves.easeInOut` for buttons, toggles, tiles, sliders and fields (picker cells use 150 ms and navigation indicators 250 ms, both with `Curves.easeOutCubic`), enabled feedback, click/basic cursors, centered button content with start-aligned icons, `threeLine` tile alignment, and slider width 144 when unbounded, keyboard step 0.05 and `tapAndSlide` interaction. Checkbox, Switch, Radio and IconButton have a 48 by 48 minimum hit target; Slider has a 48 minimum height. Buttons and ListTile size to content and style. Compact targets can be overridden with `tapTargetSize`.

Decoration transitions blend fill, border and shadow colors in premultiplied-alpha space, as CSS transitions do. Fading between `Color(0x00000000)` and a light color therefore never passes through gray, so transparent idle states are safe for hover effects. A decoration, border or shadow that is null in some states fades in and out while keeping its shape and radius. Other gradients and `ShapeDecoration` pairs use Flutter's standard interpolation. State transitions are immediate under reduced motion.

Borders count toward layout, as in `Container`, so a border whose width changes between states moves the content. Keep border widths constant and change only their color, or draw focus rings with `BorderSide.strokeAlignOutside` or a `foregroundDecoration`, neither of which affects layout. Rings drawn outside a control can be clipped by a clipping ancestor.

## Decorations

Pass a `BoxDecoration` directly to a widget when a painted part should keep the same decoration in every interaction state, including hover, focus, pressed, selected and disabled. The parameter overrides that part's inline style, component theme, NeutralTheme slot and defaults. Other tokens, such as text styles, indicators and sizes, continue to resolve normally.

```dart
ElevatedButton(
  onPressed: save,
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: <Color>[Color(0xFF087F6D), Color(0xFF20594F)],
    ),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  child: const Text('Save'),
)
```

Use the matching style token with `StateProperty` when the decoration should change by state, as in the earlier `ButtonStyle` example. Do not set a widget parameter and its matching token in the widget's own inline `style`: debug builds throw a `FlutterError` at build time. This includes a supplied state resolver that returns null. For example, `decoration` conflicts with `style.decoration` on a button, and `menuDecoration` conflicts with `style.menuStyle.decoration` on a dropdown. Theme decorations are defaults and can be overridden without a conflict. A menu row's own `decoration` also overrides the parent menu's `style.itemStyle` without a conflict.

| Control | Direct `BoxDecoration?` parameters |
| --- | --- |
| ElevatedButton, OutlinedButton, TextButton, IconButton, including icon constructors | `decoration`, `foregroundDecoration` |
| ListTile | `decoration`, `foregroundDecoration` |
| Checkbox | `decoration` for its box |
| Switch | `decoration` for its track, `thumbDecoration` |
| Radio | `decoration` for its ring, `thumbDecoration` for its dot |
| Slider | `trackDecoration`, `activeTrackDecoration`, `secondaryActiveTrackDecoration`, `thumbDecoration`, `tickMarkDecoration`, `activeTickMarkDecoration` |
| DropdownButton, DropdownMenu, DropdownMenu.multiple, PopupMenuButton | `decoration` for the trigger or field, `menuDecoration` for the panel |
| DropdownMenuItem, DropdownMenuEntry, PopupMenuItem, CheckedPopupMenuItem | `decoration` for the row |

Slider tick decorations require non-null `divisions`; `secondaryActiveTrackDecoration` requires non-null `secondaryTrackValue`. These dependencies are checked by constructor asserts. Toggle decorations supplied directly are identical in the on and off resolutions, so selection animation leaves the decoration unchanged. PopupMenuDivider paints a line and has no direct decoration parameter.

Image backgrounds use `DecorationImage` with an `ImageProvider`, including `AssetImage`, `NetworkImage` or `MemoryImage`. These are available through `widgets.dart`. Declare the asset in your app's `pubspec.yaml` before using it:

```dart
const ImageProvider background = AssetImage('assets/background.png');

ListTile(
  decoration: const BoxDecoration(
    image: DecorationImage(image: background, fit: BoxFit.cover),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  title: const Text('Your workspace'),
  onTap: openWorkspace,
)
```

## Four ways to override a theme

`NeutralTheme.of(context)` returns the nearest `ThemeData`, or `const ThemeData()`. `NeutralTheme.maybeOf(context)` returns null if absent. ThemeData owns 31 style slots: `elevatedButtonStyle`, `outlinedButtonStyle`, `textButtonStyle`, `iconButtonStyle`, `checkboxStyle`, `switchStyle`, `radioStyle`, `listTileStyle`, `sliderStyle`, `dropdownButtonStyle`, `dropdownMenuStyle`, `popupMenuStyle`, `tooltipStyle`, `dialogStyle`, `bottomSheetStyle`, `snackBarStyle`, `textFieldStyle`, `autocompleteStyle`, `searchStyle`, `datePickerStyle`, `timePickerStyle`, `filledButtonStyle`, `floatingActionButtonStyle`, `segmentedButtonStyle`, `toggleButtonsStyle`, `chipStyle`, `tabBarStyle`, `navigationStyle`, `expansionTileStyle`, `progressIndicatorStyle`, `badgeStyle`.

1. Set app-wide tokens with `NeutralTheme(data: ThemeData(...), child: ...)`.
2. Inherit app-wide tokens and override some in a subtree with `NeutralTheme.merge(data: ThemeData(...), child: ...)`.
3. Override one component using `ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`, `IconButtonTheme`, `CheckboxTheme`, `SwitchTheme`, `RadioTheme`, `ListTileTheme`, `SliderTheme`, `DropdownButtonTheme`, `DropdownMenuTheme`, or `PopupMenuTheme`.
4. Set `style:` on a control, including `style: ElevatedButtonTheme.of(context).copyWith(...)`.

Each component theme has `of`, `maybeOf`, and `merge`. A regular component theme replaces the entire enclosing component style. Its `merge` constructor helper inherits unset tokens from the enclosing component theme or the NeutralTheme slot. Inline styles resolve over the nearest component theme. Explicit behavioral widget parameters, such as slider `allowedInteraction`, take precedence over style tokens.

```dart
ElevatedButtonTheme.merge(
  data: const ButtonStyle(spacing: 12),
  child: Builder(
    builder: (BuildContext context) => ElevatedButton(
      onPressed: save,
      style: ElevatedButtonTheme.of(context).copyWith(
        padding: const StateProperty.all(EdgeInsets.all(20)),
      ),
      child: const Text('Save'),
    ),
  ),
)
```

Style `merge` is receiver-first: `overrides.merge(base)` fills only unset fields from `base`. `copyWith` preserves fields when its argument is null. All styles and ThemeData support value equality. NeutralTheme and every component theme extend `InheritedTheme`; use `InheritedTheme.capture` or `captureAll` when inserting a route or overlay into a different subtree.

## Tokens

Stateful fields are nullable `StateProperty<T?>` values. Plain fields are nullable structural configuration. Every style has `copyWith` and `merge`.

| Style | Stateful tokens | Plain tokens |
| --- | --- | --- |
| `ButtonStyle` | `decoration`, `foregroundDecoration`, `padding`, `minimumSize`, `fixedSize`, `maximumSize`, `textStyle`, `iconTheme`, `mouseCursor`, `loadingIndicator` | `alignment`, `spacing`, `iconAlignment`, `tapTargetSize`, `clipBehavior`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `ToggleStyle` | `size`, `decoration`, `thumbSize`, `thumbDecoration`, `indicator`, `indeterminateIndicator`, `mouseCursor` | `padding`, `tapTargetSize`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `ListTileStyle` | `decoration`, `foregroundDecoration`, `titleTextStyle`, `subtitleTextStyle`, `leadingAndTrailingTextStyle`, `iconTheme`, `mouseCursor` | `contentPadding`, `minVerticalPadding`, `horizontalTitleGap`, `minLeadingWidth`, `subtitleSpacing`, `minTileHeight`, `minTwoLineTileHeight`, `minThreeLineTileHeight`, `titleAlignment`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `MenuStyle` | None | `decoration`, `padding`, `minimumSize`, `maximumSize`, `matchAnchorWidth`, `offset`, `edgePadding`, `clipBehavior`, `placement`, `overlayLocation`, `outsideTapBehavior`, `transitionDuration`, `reverseTransitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `transitionBuilder` |
| `DropdownStyle` | `selectedIndicator`, `textStyle`, `hintStyle` | `buttonStyle`, `menuStyle`, `itemStyle`, `iconTurns`, `cursorColor`, `selectionColor`, `cursorWidth` |
| `PopupMenuStyle` | `checkIndicator` | `buttonStyle`, `menuStyle`, `itemStyle`, `dividerDecoration`, `dividerHeight`, `position` |
| `TooltipStyle` | None | `decoration`, `padding`, `margin`, `constraints`, `textStyle`, `textAlign`, `placement`, `overlayLocation`, `verticalOffset`, `preferBelow`, `transitionDuration`, `reverseTransitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `transitionBuilder` |
| `DialogStyle` | None | `decoration`, `padding`, `insetPadding`, `constraints`, `alignment`, `barrierColor`, `barrierBlur`, `clipBehavior`, `titleTextStyle`, `contentTextStyle`, `titlePadding`, `contentPadding`, `actionsPadding`, `actionsAlignment`, `actionsOverflowAlignment`, `actionsOverflowDirection`, `actionsOverflowButtonSpacing`, `buttonPadding`, `iconPadding`, `iconTheme`, `optionStyle`, `insetAnimationDuration`, `insetAnimationCurve`, `transitionDuration`, `reverseTransitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `transitionBuilder` |
| `BottomSheetStyle` | None | `decoration`, `padding`, `constraints`, `clipBehavior`, `barrierColor`, `dragHandleColor`, `dragHandleSize`, `dragHandleDecoration`, `transitionDuration`, `reverseTransitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `snapPoints`, `spring`, `transitionBuilder` |
| `SnackBarStyle` | None | `decoration`, `padding`, `margin`, `constraints`, `textStyle`, `actionStyle`, `closeButtonStyle`, `spacing`, `alignment`, `clipBehavior`, `transitionDuration`, `reverseTransitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `transitionBuilder` |
| `TextFieldStyle` | `decoration`, `foregroundDecoration`, `textStyle`, `hintStyle`, `labelStyle`, `helperStyle`, `errorStyle`, `counterStyle`, `contentPadding`, `minimumSize`, `fixedSize`, `maximumSize`, `cursorColor`, `selectionColor`, `mouseCursor`, `iconTheme` | `actionStyle`, `labelBehavior`, `labelScale`, `spacing`, `cursorWidth`, `cursorHeight`, `cursorRadius`, `clipBehavior`, `scrollPadding`, `animationDuration`, `animationCurve` |
| `AutocompleteStyle` | None | `fieldStyle`, `menuStyle`, `itemStyle`, `optionsMaxHeight`, `optionsViewOpenDirection` |
| `SearchStyle` | None | `fieldStyle`, `viewDecoration`, `viewPadding`, `suggestionStyle`, `menuStyle`, `constraints`, `transitionDuration`, `reverseTransitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `transitionBuilder`, `outsideTapBehavior` |
| `DatePickerStyle` | None | `decoration`, `padding`, `headerTextStyle`, `weekdayTextStyle`, `dayStyle`, `todayStyle`, `selectedDayStyle`, `inRangeDayStyle`, `rangeStartStyle`, `rangeEndStyle`, `yearStyle`, `disabledDayStyle`, `navigationButtonStyle`, `entryModeButtonStyle`, `rangeBandDecoration`, `dayExtent`, `yearExtent`, `monthWidth`, `animationDuration`, `animationCurve`, `placement`, `outsideTapBehavior`, `transitionDuration`, `transitionCurve`, `reverseTransitionCurve`, `reverseTransitionDuration`, `transitionBuilder` |
| `TimePickerStyle` | None | `decoration`, `padding`, `headerTextStyle`, `dialTextStyle`, `inputTextStyle`, `segmentStyle`, `selectedSegmentStyle`, `periodStyle`, `selectedPeriodStyle`, `entryModeButtonStyle`, `dialDecoration`, `handDecoration`, `handColor`, `dialBackgroundColor`, `dialSize`, `handWidth`, `handRadius`, `animationDuration`, `animationCurve`, `spring` |
| `ChipStyle` | `selectedIcon`, `deleteIcon` | `buttonStyle`, `deleteButtonStyle`, `avatarSize`, `spacing`, `animationDuration`, `animationCurve` |
| `TabBarStyle` | `indicatorDecoration` | `tabStyle`, `indicatorBuilder`, `labelPadding`, `padding`, `indicatorPadding`, `indicatorWeight`, `spacing`, `animationDuration`, `animationCurve` |
| `NavigationStyle` | `indicatorDecoration`, `labelStyle`, `iconTheme` | `destinationStyle`, `padding`, `indicatorPadding`, `indicatorSize`, `spacing`, `animationDuration`, `animationCurve` |
| `ExpansionTileStyle` | `decoration` | `tileStyle`, `padding`, `childrenPadding`, `expandedAlignment`, `expandedCrossAxisAlignment`, `animationDuration`, `animationCurve` |
| `BadgeStyle` | `decoration`, `textStyle` | `padding`, `smallSize`, `largeSize`, `alignment`, `offset`, `animationDuration`, `animationCurve` |
| `ProgressIndicatorStyle` | `color`, `backgroundColor` | `strokeWidth`, `strokeCap`, `minHeight`, `size`, `borderRadius`, `animationDuration`, `animationCurve`, `indeterminateDuration` |
| `SliderStyle` | `trackHeight`, `trackDecoration`, `activeTrackDecoration`, `secondaryActiveTrackDecoration`, `thumbSize`, `thumbDecoration`, `tickMarkSize`, `tickMarkDecoration`, `activeTickMarkDecoration`, `mouseCursor` | `valueIndicatorBuilder`, `padding`, `tapTargetSize`, `preferredWidth`, `keyboardStep`, `allowedInteraction`, `animationDuration`, `animationCurve` |

Toggle `size` describes the checkbox box, switch track or radio ring. `thumbSize` and `thumbDecoration` describe the switch thumb or radio dot. Indicators are application-provided widgets. Switch track size can be inferred from its thumb size and padding. Checkbox supports an indeterminate indicator and tristate cycling. Selection animations interpolate resolved on/off tokens.

## Controls

Buttons support callbacks, focus, hover, external `WidgetStatesController`, loading, and leading/trailing slots. `ElevatedButton`, `OutlinedButton`, and `TextButton` have `.icon` constructors with `IconAlignment.start` or `end`. Loading disables activation and preserves content size, painting a `DotsGlyph` over the hidden content unless the loading token resolves to null. IconButton supports `isSelected`, `selectedIcon`, and a semantic `tooltip`. Wrap in `Tooltip` to show a visible tooltip.

Every button accepts direct `decoration` and `foregroundDecoration` parameters for a fixed surface or overlay.

Checkbox, Switch, Radio and Slider are controlled: store the value in your parent and rebuild after `onChanged`. Switch supports dragging with RTL-aware thumb movement. Radio supports explicit `groupValue`/`onChanged`, a `RadioGroup<T>` ancestor, or an explicit `RadioGroupRegistry<T>`. The registry parameter takes precedence, followed by explicit mode, then the ancestor group. RadioGroup supplies arrow and Space navigation.

Checkbox accepts a direct box `decoration`; Switch and Radio also accept `thumbDecoration` for their moving thumb or selection dot.

ListTile supports one, two and three-line content, directional slot order and padding, independent text styles, selection, and callbacks. A three-line tile requires a subtitle. Height tokens fall back from three-line to two-line to one-line. Layout avoids intrinsic measurement, so a Slider can be placed in its subtitle.

ListTile accepts direct `decoration` and `foregroundDecoration`, including image backgrounds.

Slider supports arbitrary min/max ranges, divisions, a secondary track, ticks, a value indicator builder and semantic value formatting. `SliderInteraction` provides `tapAndSlide`, `tapOnly`, `slideOnly`, and `slideThumb`; the latter two preserve the drag grab offset. Arrow keys adjust the value in traditional navigation. RTL mirrors horizontal keys and track geometry. Under directional navigation, up/down move focus. A zero-length range disables interaction.

Each painted slider part has a matching direct decoration parameter; secondary tracks and ticks require the corresponding part to be enabled.

`InteractionDetector` is public for custom controls. It combines focus, hover, press and drag state with keyboard activation, feedback and optional external state-controller synchronization, and follows the visible focus and nesting rules above. A custom control that keeps focus on a descendant, such as an editable field, passes `isFocused` explicitly. Use its builder to size the full hit target. `InteractionState` can round-trip Flutter `WidgetState` sets.

## Menus and selection

Menus need an `Overlay` ancestor. `NeutralApp` supplies one, including its navigator-free `.builder` constructor. When setting up the widgets layer yourself, use `WidgetsApp` with `home`/`routes`, or wrap content in `Overlay`. All menus use `RawMenuAnchor` and require no Navigator or route. For an app that uses only the `WidgetsApp.builder`, add the overlay inside your theme:

```dart
WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (BuildContext context, Widget? child) => NeutralTheme(
    data: const ThemeData(),
    child: Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(builder: (BuildContext context) => const MyAppContent()),
      ],
    ),
  ),
)
```

`DropdownButton<T>` is a controlled classic select with `DropdownMenuItem<T>` entries, a hint, a disabled hint and an optional `selectedItemBuilder`. It sizes to the widest item; `isExpanded` fills the available width. Its menu opens below the anchor and flips above when needed, with the selected item scrolled into view. This placement intentionally differs from Material, which aligns the selected row over the button. Selecting the current value still calls `onChanged`.

`DropdownMenu<T>` provides an editable selection field with `DropdownMenuEntry<T>` entries. `enableFilter` narrows the list with a case-insensitive contains match; `enableSearch` highlights a match while keeping all entries visible. Supply `filterCallback` or `searchCallback` to customize either behavior. `selectOnly` uses a button trigger. Desktop fields request focus by default; use `requestFocusOnTap` to choose the behavior explicitly. `initialSelection` initializes the text and updates it when that parameter changes. A `TextEditingController`, `FocusNode` and `MenuController` can be supplied externally.

For custom search, supply `searchBuilder(context, query)` to return the matching entries yourself. Its results bypass `filterCallback` and label filtering and matching. With `enableSearch`, typing highlights an enabled result for Enter; `searchCallback` can choose the highlighted result. The builder receives an empty query when opening the menu and after a multiple selection. `dropdownMenuEntries` is optional with a builder and can supply initial selections outside the results.

Entries accept either `label`, `labelWidget`, or both. The `label` property is nullable. With only `labelWidget`, `label` remains null, the selected field displays that widget, and the text controller stays empty. Search your own data in the builder without extracting text from the widgets:

```dart
DropdownMenu<String>(
  searchBuilder: (BuildContext context, String query) => <String>[
    'Cape Town',
    'Johannesburg',
    'Durban',
  ]
      .where((String city) => city.toLowerCase().contains(query.toLowerCase()))
      .map((String city) => DropdownMenuEntry<String>(
            value: city,
            labelWidget: Text(city),
          ))
      .toList(),
  onSelected: (String? city) {},
)
```

`DropdownMenu.multiple` is controlled by `selected: Set<T>` and `onSelectionChanged`. The menu stays open by default, clears the search query after a toggle, and rejects removal of the last value when `emptySelectionAllowed` is false. Use `selectionBuilder` to render chips; otherwise selected labels appear as a joined summary. `DropdownMenuCloseBehavior.all` and `self` close the current menu after selection, while `none` keeps it open.

`PopupMenuButton<T>` builds its entries each time it opens. Use `PopupMenuItem`, `CheckedPopupMenuItem` and `PopupMenuDivider`. Its `position` is `PopupMenuPosition.over` by default, with `under` placing it below the trigger. `PopupMenuButtonState.showButtonMenu()` opens it programmatically. Checked entries display the supplied checked state; update that state in your callback. Selection closes the menu, calls the item's `onTap`, then calls `onSelected` for a non-null value. A null-value item calls only `onTap`; dismissing calls `onCanceled`. `PopupMenuEntry.height` is omitted because panel layout measures the actual entry widgets.

All three menu controls accept direct trigger or field `decoration` and panel `menuDecoration` parameters. Dropdown entries and popup items accept their own row `decoration`.

Both dropdowns paint a `ChevronGlyph` arrow by default. Pass `DropdownButton.icon` or `DropdownMenu.trailingIcon` to replace it with one icon drawn pointing down. While the menu is open the arrow turns by `DropdownStyle.iconTurns`, half a turn by default so it flips to point up, using the trigger's `animationDuration` and `animationCurve`. Set `iconTurns: 0` to keep it still. To hide it, pass `SizedBox.shrink()` as the DropdownButton icon or set `showTrailingIcon: false` on DropdownMenu.

All menus support keyboard activation, arrow navigation that skips disabled options, Escape and outside-tap dismissal. Moving the pointer over a row makes it the active row, so hover, arrow keys and Enter always agree on one row. A pointer resting where a row appears does not take over until it moves, and after keyboard navigation row hover stays hidden until the pointer moves. Arrow keys scroll only as far as needed to show the active row, and the chosen row keeps its appearance while the panel exits. An open trigger hands its focus indication to the active row. Panels follow their anchor and close when an ancestor scrolls, the window resizes, another route covers their route, or their anchor becomes inactive through `TickerMode`. Start-edge alignment respects RTL, and panels flip and clamp inside `edgePadding`, safe-area padding and keyboard insets. Dropdown panels are at least as wide as their anchor by default, subject to `maximumSize` and available overlay space. Popup panels size to their content by default. `MenuStyle` defaults to a fade and scale entrance over 150 ms and an exit over 100 ms. Set `transitionDuration: Duration.zero` for immediate transitions, or provide a `MenuTransitionBuilder`. `reverseTransitionDuration`, `transitionCurve` and `reverseTransitionCurve` control each direction. Reduced motion makes transitions immediate. Closing completes the reverse transition before removing the panel.

Option rows resolve each token per state in this order: entry style, inline `style.itemStyle`, nearest component theme, structural defaults. Trigger and panel tokens follow the same order without the entry style. `DropdownStyle` and `PopupMenuStyle` deep-merge their nested button and menu styles. Open triggers resolve `isSelected`; selected dropdown rows and checked popup indicators resolve it for their chosen or checked state. Search highlights resolve visible focus while real focus stays in the editable field.

No panel visuals are supplied, and menu glyphs follow the default glyph rules above. An editable field must have a cursor color: `DropdownStyle.cursorColor` falls back to the ambient text color, then opaque black. Text fields have the same final cursor fallback. Glyphs use the icon theme's color. Trigger and option semantics expose button, text field, expanded, selected, checked and enabled states as appropriate. Menu-specific `SemanticsRole` values are omitted because Flutter's widgets layer does not export those types.

## Run the component library

The repository includes a runnable [component library](https://github.com/Miso-0/pure_ui/tree/main/example) with macOS and web runners. From a checkout of the repository:

```sh
cd example
flutter pub get
flutter run -d chrome
# On macOS with Xcode installed:
flutter run -d macos
```

The example offers shareable category URLs such as `/#/pickers`, live search, RTL and reduced-motion controls. Each preview runs with an empty NeutralUI theme. The Copy button copies the exact Dart source file that renders it, including its styles and local state, so it can be pasted into a fresh `NeutralApp`. Its green palette belongs to the example snippets; the package does not impose it.

To verify a checkout, run `flutter analyze` and `flutter test` at the repository root. In `example`, run `flutter analyze` and `flutter test`; `flutter build web` and `flutter build macos` validate the bundled runners on supported development hosts. See the [example README](https://github.com/Miso-0/pure_ui/blob/main/example/README.md) for its source layout.


## Application, overlays and calendar foundations

`NeutralApp` supplies a Navigator, `NeutralTheme`, a `HeroControllerScope` and the default NeutralUI localization delegate. It accepts `home`, `routes`, `onGenerateRoute`, `navigatorKey` and a `builder` for wrapping routes. Like `WidgetsApp`, it requires an application `color`. Custom localization delegates precede the English default.

```dart
NeutralApp(
  color: const Color(0xFFF4F7F3),
  theme: const ThemeData(),
  home: const Center(child: Text('Hello')),
)
```

For an application without navigation, `NeutralApp.builder(color: ..., builder: ...)` provides an Overlay and keeps its content mounted when the app rebuilds. Route-based components require the regular constructor.

Menus use the root overlay by default. Set `MenuStyle(overlayLocation: OverlayLocation.nearest)` to select the closest overlay. Outside taps dismiss and activate underlying controls by default; `outsideTapBehavior: OutsideTapBehavior.consume` consumes that gesture. Nested menu panels share a tap group, so interacting with a nested panel keeps its parent open. Focus returns to the anchor at the end of dismissal only while focus still belongs to the closing panel.

`MenuStyle.placement` accepts `OverlayPlacement` for panels on any side of an anchor. The public `resolvePlacement` function returns both the panel rectangle and chosen side. `OverlayHost` uses the same engine for non-menu overlays without menu focus or keyboard behavior.

| OverlayPlacement token | Behavior |
| --- | --- |
| `preferredSide`, `alignment`, `coverAnchor` | Attachment side, directional cross-axis alignment and overlap |
| `gap`, `crossOffset` | Space from the anchor, mirrored on a flip, and directional cross-axis displacement |
| `flip` | Keep the side, flip if needed, or choose the larger side |
| `overflow` | Shrink, shift, or keep the panel size and attachment |
| `margin` | Additional safe-area and keyboard-edge clearance |
| `constraints`, `anchorWidth` | Explicit size constraints and no, minimum or exact anchor-width matching |

`MenuStyle.offset.dx` is directional: positive values move toward the reading direction's end. A positive vertical gap stays outside the anchor when the panel flips upward.

`NeutralLocalizations.of(context)` returns English strings even without a localization delegate. Override `DefaultNeutralLocalizations` and install a delegate to customize text, month and weekday names, compact date parsing, date/time formatting and accessibility labels. No `intl` dependency is required. `GregorianCalendarDelegate` implements `CalendarDelegate<DateTime>`; custom calendars can replace its date arithmetic and formatting. `DateUtils`, `DateTimeRange`, `TimeOfDay`, picker modes and `DayPeriod` supply widgets-only date and time value types.

The painted `CloseGlyph`, `SearchGlyph`, `CalendarGlyph`, `ClockGlyph`, `EditGlyph` and `ArrowGlyph` follow the ambient `IconTheme`. `ChevronGlyph` and `ArrowGlyph` accept `GlyphDirection`; `start` and `end` mirror with text direction, while `left` and `right` stay physical. Glyphs are decorative and excluded from semantics.


## Feedback and modal surfaces

`Tooltip` supports hover, long press, tap and visible keyboard focus. It accepts plain `message` or `richMessage`, the framework trigger/delay/feedback parameters, and a `TooltipStyle`. A `GlobalKey<TooltipState>` exposes `ensureTooltipVisible()` and `dismiss()`. `TooltipVisibility` controls a subtree. Escape dismisses the current tooltip, and reaches an enclosing dialog or sheet when none is shown; inline motion tokens can be changed while it is shown. Focus opens a tooltip only while focus is visible, and dismissing one keeps its child mounted.

`Dialog`, `AlertDialog`, `SimpleDialog` and `SimpleDialogOption` use `DialogStyle` and `DialogTheme`. `showDialog<T>` requires a Navigator such as the regular `NeutralApp`, captures inherited themes, closes on Escape or a dismissible barrier, traps Tab focus and returns the value passed to `Navigator.pop`. DialogStyle controls surface decoration, layout, the optional barrier blur, and independent entrance/exit motion.

```dart
final bool? accepted = await showDialog<bool>(
  context: context,
  builder: (BuildContext context) => AlertDialog(
    title: const Text('Save changes?'),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Save'),
      ),
    ],
  ),
);
```

`BottomSheet` and `showModalBottomSheet` share drag and route motion. Dragging follows the pointer, then a velocity-aware spring settles or dismisses the sheet. `isScrollControlled`, `enableDrag`, `isDismissible`, `showDragHandle`, snap points and the bottom-sheet theme configure the behavior. Reduced motion settles immediately.

Wrap content in `ScaffoldMessenger` to show queued `SnackBar`s. `ScaffoldMessenger.of(context)` provides `showSnackBar`, `hideCurrentSnackBar`, `removeCurrentSnackBar` and `clearSnackBars`. A feature controller exposes the eventual `SnackBarClosedReason`. Messages support actions, a close icon, swipe dismissal, `duration`, `persist` and `onVisible`; accessible navigation prevents automatic hiding. The messenger needs an Overlay but no Material Scaffold.

## Text input, autocomplete and search

`TextField` is built on `EditableText`; `TextFormField` adds `Form` validation, saving and reset. Both expose text/focus controllers, keyboard type, multiline behavior, submission, disabled/read-only states, autofocus and prefix/suffix slots. `labelText`, `hintText`, `helperText`, `errorText` and counters describe the field. `showClearButton` adds a clear action; `showObscureTextToggle` adds a painted eye for password reveal.

`TextFieldStyle` moves the visual parameters into stateful tokens. Error resolvers receive `InteractionState.isError`, alongside focus, hover and disabled flags. Label behavior is above, floating or none; the floating animation retargets from its current value. Direct `decoration` and `foregroundDecoration` parameters override all states and reject matching inline tokens. The widgets-only public API omits services-only `inputFormatters` and `textInputAction` types.

Set `width` and `height` on `TextField` or `TextFormField` for exact dimensions, or use the style's size tokens. Height describes the input box; labels and supporting text remain outside it. Compact boxes reduce content padding first, then fit text, the cursor, icons and actions to the remaining space. Narrow boxes reduce horizontal padding and spacing and fit side content while entered text keeps its normal scrolling. Larger boxes retain the configured typography. `textAlignVertical` positions the contents, and `actionStyle` customizes the clear and password reveal buttons.

```dart
TextFormField(
  labelText: 'Email',
  hintText: 'you@example.com',
  validator: (String? value) =>
      value != null && value.contains('@') ? null : 'Enter an email address',
  onSaved: (String? value) => saveEmail(value),
)
```

`Autocomplete<T>` accepts the framework options/field/view builders, including asynchronous options. The default field uses TextFieldStyle and the options use MenuStyle plus an item ButtonStyle. Arrow selection, submission, highlighted-row scrolling and outside dismissal preserve the editable focus model; exit animation finishes before the visual panel is removed.

`SearchBar` is the editable bar. `SearchAnchor` builds a custom trigger, while `SearchAnchor.bar` supplies one. The attached `SearchController` opens and closes the view and owns the query. `suggestionsBuilder` accepts a widget iterable or its Future; obsolete asynchronous results cannot replace newer results. Docked views use the anchored overlay engine. `isFullScreen: true` expands the anchor rectangle into a route with `viewLeading`, `viewTrailing` and customizable suggestion content. `SearchStyle` and `SearchTheme` cover both surfaces.

## Dates and times

`CalendarDatePicker` displays a lazy, swipable month calendar and a builder-based `YearPicker`. Arrow keys move by day or week, skip disabled dates and cross month boundaries; Tab leaves the calendar grid. `currentDate`, `selectableDayPredicate` and `calendarDelegate` control availability and date interpretation. Day cells update interaction state independently and expose localized full-date semantics.

`DatePickerField` opens the same calendar in an anchored popover. `InputDatePickerFormField` parses and validates text through the selected calendar delegate. `DatePickerDialog` and `showDatePicker` support calendar, input, calendar-only and input-only entry modes. A range uses `CalendarDateRangePicker`, `DateRangePickerDialog` or `showDateRangePicker`, with RTL-aware band caps and validated range input.

```dart
final DateTime? date = await showDatePicker(
  context: context,
  initialDate: selectedDate,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030, 12, 31),
);
```

`TimePicker`, `TimePickerDialog` and `showTimePicker` provide dial or validated text entry. The hand follows pointer drags before spring snapping. Tap selection snaps minutes by five. The 24-hour layout includes an inner hour ring, and hour/minute segments expose semantic increase/decrease actions. `DatePickerStyle` and `TimePickerStyle`, their component themes and ThemeData slots configure every surface and control without fixed palette defaults.

## Button variants and chips

`FilledButton` has `.icon`, `.tonal` and `.tonalIcon` constructors; `FloatingActionButton` has `.small`, `.large` and `.extended`. All reuse ButtonStyleButton, direct decorations and their own theme slots. Floating actions have at least a 48 by 48 hit target.

`SegmentedButton<T>` uses `ButtonSegment<T>`, a controlled selected set and `onSelectionChanged`. It supports multiple selection, an optional empty set, animated selected indicators and directional group navigation that skips disabled segments. `ToggleButtons` offers index-based selection over a list of children. Both use ButtonStyle and their component themes.

`Chip`, `InputChip`, `FilterChip`, `ChoiceChip` and `ActionChip` share ChipStyle and ChipTheme. Chips support avatar/label slots, controlled selection, independent deletion and localized delete tooltips. Selected marks animate their occupied width, including on disabled selected chips. Direct decoration overrides the inherited chip decoration in every state.

## Navigation, range controls and progress

`DefaultTabController` supplies a `TabController` to `TabBar` and `TabBarView`. The indicator follows page swipes continuously; programmatic retargeting preserves position and velocity. Scrollable strips keep the selected tab visible. `TabBarStyle` supplies tab ButtonStyle, indicator decoration/builder and layout/motion tokens.

`NavigationBar`, `NavigationRail` and `NavigationDrawer` expose destinations, selected indices and selection callbacks. They support directional keyboard navigation, selected semantics and animated indicators through NavigationStyle. `NavigationTheme` supplies shared subtree tokens; a specific bar/rail/drawer theme can override it. `ExpansionTile` reuses ListTile and Expansible, supports maintained child state and animates its directional chevron.

`RangeSlider` uses SliderStyle with `RangeValues` and two independently focusable thumbs. Arrow keys adjust the focused thumb, and a stop or push policy keeps the endpoints ordered. Continuous visual drag positions settle to controlled or discrete values with a velocity-aware spring. It accepts direct track, active track, thumb and tick decorations with the same validation rules as Slider.

`Badge` and `Badge.count` support compact marks or localized capped counts such as `99+`. `CircularProgressIndicator` and `LinearProgressIndicator` animate determinate changes; a null value selects indeterminate motion. Their default paint follows IconTheme, and progress exposes accessible labels and values. All respect reduced motion. BadgeStyle and ProgressIndicatorStyle provide themeable tokens.

## Tables

`DataTable` uses the widgets layer and NeutralUI controls. The example gallery includes a tables section with sorting, selection, row details and collapsible groups. `DataTableColumn` defines headers, widths, visibility and sorting; `DataTableRow.cells` corresponds to all columns, including hidden columns. `onSort` reports the original column index so the application can reorder its data.

```dart
DataTable(
  columns: const [
    DataTableColumn(header: Text('Name'), sortable: true),
    DataTableColumn(header: Text('Age'), width: FixedColumnWidth(80)),
  ],
  rows: const [
    DataTableRow(cells: [Text('Alice'), Text('28')]),
    DataTableRow(cells: [Text('Bob'), Text('34')]),
  ],
  style: const DataTableStyle(
    headerCellPadding: EdgeInsets.all(12),
    cellPadding: EdgeInsets.all(12),
    headerTextStyle: TextStyle(fontWeight: FontWeight.w600),
  ),
)
```

Set table tokens through `ThemeData.dataTableStyle`, a local `DataTableTheme`, or inline `style`. As with other component themes, a local theme replaces the central component style; `DataTableTheme.merge` retains enclosing tokens. Colors, borders, padding and typography come from the application. Stateful `decoration` and `textStyle` tokens receive row hover, press, keyboard focus and selection. Inline `DataTableThemeData` is also supported below `style` in precedence.

`showCheckboxes` enables selection of top-level rows. `expandedRowChildBuilder` and group headers span the table; `rowBuilder` wraps each data row. Nested expansion uses paths such as `0.1`. Selection, expansion and collapsed groups update internally and resynchronize when their supplied sets change. Wrap the table in an appropriate scroll view when its content can overflow; flex columns need a bounded width.

## Issues and contributions

Report bugs or request components in the [GitHub issue tracker](https://github.com/Miso-0/pure_ui/issues). For a rendering or interaction bug, include a minimal example, your Flutter version, the target platform, and any relevant theme tokens. Contributions should include the relevant analyzer and test checks described above.

## License

NeutralUI is available under the [MIT license](LICENSE).
