# PureUI

PureUI is a zero-dependency headless Flutter design system. It supplies controlled values, pointer and keyboard interaction, semantics, layout slots, and composable themes. Your application supplies its visual language. The library imports only Flutter's `widgets.dart`, local code, and `dart:math`.

Requires Flutter 3.47 or newer and Dart 3.13.4 or newer. Version 0.3.0 is tested with Flutter 3.47.5.

## Get started

```yaml
dependencies:
  pure_ui:
    path: ../pure_ui
```

```dart
import 'package:flutter/widgets.dart';
import 'package:pure_ui/pure_ui.dart';

PureTheme(
  data: const ThemeData(
    elevatedButtonStyle: ButtonStyle(
      padding: StateProperty.all(EdgeInsets.all(16)),
      decoration: StateProperty.all(
        BoxDecoration(color: Color(0xFF087F6D)),
      ),
      textStyle: StateProperty.all(TextStyle(color: Color(0xFFFFFFFF))),
    ),
  ),
  child: ElevatedButton(onPressed: save, child: const Text('Save')),
)
```

PureUI uses Material's familiar names: `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Checkbox`, `Switch`, `Radio`, `ListTile`, `Slider`, `DropdownButton`, `DropdownMenu`, `PopupMenuButton`, `ButtonStyle`, `ThemeData`, and the component theme names. When importing `material.dart` as well, use a prefix for PureUI (`import 'package:pure_ui/pure_ui.dart' as pure;`) or hide conflicting names. `widgets.dart` can be imported unprefixed alongside PureUI.

## State and styling

A `StateProperty<T>` resolves a token from an immutable `InteractionState`. States expose `isPressed`, `isHovered`, `isFocused`, `isSelected`, `isDisabled`, and `isDragged`. `isFocused` represents visible focus; `onFocusChange` reports raw focus. Constant tokens use `const StateProperty.all(value)`.

```dart
ButtonStyle(
  decoration: StateProperty.resolveWith((InteractionState state) {
    if (state.isDisabled) return const BoxDecoration(color: Color(0xFFCCCCCC));
    if (state.isPressed) return const BoxDecoration(color: Color(0xFF065F53));
    return const BoxDecoration(color: Color(0xFF087F6D));
  }),
)
```

Visual tokens are unset by default: your application supplies colors, radii, borders, shadows, margins, glyphs, track sizes and text styles. Editable cursors use the required fallback described below. An unstyled control can be invisible. Supply content and tokens to render it. Visual null values fall through to the next style layer for the current state. Padding and gaps default to zero.

The structural defaults are 200 ms animation with `Curves.easeInOut`, enabled feedback, click/basic cursors, centered button content with start-aligned icons, `threeLine` tile alignment, and slider width 144 when unbounded, keyboard step 0.05 and `tapAndSlide` interaction. Checkbox, Switch, Radio and IconButton have a 48 by 48 minimum hit target; Slider has a 48 minimum height. Buttons and ListTile size to content and style. Compact targets can be overridden with `tapTargetSize`.

## Decorations

Pass a `BoxDecoration` directly to a widget when a painted part should keep the same decoration in every interaction state, including hover, focus, pressed, selected and disabled. The parameter overrides that part's inline style, component theme, PureTheme slot and defaults. Other tokens, such as text styles, indicators and sizes, continue to resolve normally.

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

`PureTheme.of(context)` returns the nearest `ThemeData`, or `const ThemeData()`. `PureTheme.maybeOf(context)` returns null if absent. ThemeData owns twelve style slots: `elevatedButtonStyle`, `outlinedButtonStyle`, `textButtonStyle`, `iconButtonStyle`, `checkboxStyle`, `switchStyle`, `radioStyle`, `listTileStyle`, `sliderStyle`, `dropdownButtonStyle`, `dropdownMenuStyle`, and `popupMenuStyle`.

1. Set app-wide tokens with `PureTheme(data: ThemeData(...), child: ...)`.
2. Inherit app-wide tokens and override some in a subtree with `PureTheme.merge(data: ThemeData(...), child: ...)`.
3. Override one component using `ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`, `IconButtonTheme`, `CheckboxTheme`, `SwitchTheme`, `RadioTheme`, `ListTileTheme`, `SliderTheme`, `DropdownButtonTheme`, `DropdownMenuTheme`, or `PopupMenuTheme`.
4. Set `style:` on a control, including `style: ElevatedButtonTheme.of(context).copyWith(...)`.

Each component theme has `of`, `maybeOf`, and `merge`. A regular component theme replaces the entire enclosing component style. Its `merge` constructor helper inherits unset tokens from the enclosing component theme or the PureTheme slot. Inline styles resolve over the nearest component theme. Explicit behavioral widget parameters, such as slider `allowedInteraction`, take precedence over style tokens.

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

Style `merge` is receiver-first: `overrides.merge(base)` fills only unset fields from `base`. `copyWith` preserves fields when its argument is null. All styles and ThemeData support value equality. PureTheme and every component theme extend `InheritedTheme`; use `InheritedTheme.capture` or `captureAll` when inserting a route or overlay into a different subtree.

## Tokens

Stateful fields are nullable `StateProperty<T?>` values. Plain fields are nullable structural configuration. All seven styles have `copyWith` and `merge`.

| Style | Stateful tokens | Plain tokens |
| --- | --- | --- |
| `ButtonStyle` | `decoration`, `foregroundDecoration`, `padding`, `minimumSize`, `fixedSize`, `maximumSize`, `textStyle`, `iconTheme`, `mouseCursor`, `loadingIndicator` | `alignment`, `spacing`, `iconAlignment`, `tapTargetSize`, `clipBehavior`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `ToggleStyle` | `size`, `decoration`, `thumbSize`, `thumbDecoration`, `indicator`, `indeterminateIndicator`, `mouseCursor` | `padding`, `tapTargetSize`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `ListTileStyle` | `decoration`, `foregroundDecoration`, `titleTextStyle`, `subtitleTextStyle`, `leadingAndTrailingTextStyle`, `iconTheme`, `mouseCursor` | `contentPadding`, `minVerticalPadding`, `horizontalTitleGap`, `minLeadingWidth`, `subtitleSpacing`, `minTileHeight`, `minTwoLineTileHeight`, `minThreeLineTileHeight`, `titleAlignment`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `MenuStyle` | None | `decoration`, `padding`, `minimumSize`, `maximumSize`, `matchAnchorWidth`, `offset`, `edgePadding`, `clipBehavior`, `transitionDuration`, `transitionCurve`, `transitionBuilder` |
| `DropdownStyle` | `icon`, `selectedIndicator`, `textStyle`, `hintStyle` | `buttonStyle`, `menuStyle`, `itemStyle`, `cursorColor`, `selectionColor`, `cursorWidth` |
| `PopupMenuStyle` | `checkIndicator` | `buttonStyle`, `menuStyle`, `itemStyle`, `dividerDecoration`, `dividerHeight`, `position` |
| `SliderStyle` | `trackHeight`, `trackDecoration`, `activeTrackDecoration`, `secondaryActiveTrackDecoration`, `thumbSize`, `thumbDecoration`, `tickMarkSize`, `tickMarkDecoration`, `activeTickMarkDecoration`, `mouseCursor` | `valueIndicatorBuilder`, `padding`, `tapTargetSize`, `preferredWidth`, `keyboardStep`, `allowedInteraction`, `animationDuration`, `animationCurve` |

Toggle `size` describes the checkbox box, switch track or radio ring. `thumbSize` and `thumbDecoration` describe the switch thumb or radio dot. Indicators are application-provided widgets. Switch track size can be inferred from its thumb size and padding. Checkbox supports an indeterminate indicator and tristate cycling. Selection animations interpolate resolved on/off tokens.

## Controls

Buttons support callbacks, focus, hover, external `WidgetStatesController`, loading, and leading/trailing slots. `ElevatedButton`, `OutlinedButton`, and `TextButton` have `.icon` constructors with `IconAlignment.start` or `end`. Loading disables activation and preserves content size. IconButton supports `isSelected`, `selectedIcon`, and a semantic `tooltip`. Wrap in Flutter's `RawTooltip` to show a visible tooltip.

Every button accepts direct `decoration` and `foregroundDecoration` parameters for a fixed surface or overlay.

Checkbox, Switch, Radio and Slider are controlled: store the value in your parent and rebuild after `onChanged`. Switch supports dragging with RTL-aware thumb movement. Radio supports explicit `groupValue`/`onChanged`, a `RadioGroup<T>` ancestor, or an explicit `RadioGroupRegistry<T>`. The registry parameter takes precedence, followed by explicit mode, then the ancestor group. RadioGroup supplies arrow and Space navigation.

Checkbox accepts a direct box `decoration`; Switch and Radio also accept `thumbDecoration` for their moving thumb or selection dot.

ListTile supports one, two and three-line content, directional slot order and padding, independent text styles, selection, and callbacks. A three-line tile requires a subtitle. Height tokens fall back from three-line to two-line to one-line. Layout avoids intrinsic measurement, so a Slider can be placed in its subtitle.

ListTile accepts direct `decoration` and `foregroundDecoration`, including image backgrounds.

Slider supports arbitrary min/max ranges, divisions, a secondary track, ticks, a value indicator builder and semantic value formatting. `SliderInteraction` provides `tapAndSlide`, `tapOnly`, `slideOnly`, and `slideThumb`; the latter two preserve the drag grab offset. Arrow keys adjust the value in traditional navigation. RTL mirrors horizontal keys and track geometry. Under directional navigation, up/down move focus. A zero-length range disables interaction.

Each painted slider part has a matching direct decoration parameter; secondary tracks and ticks require the corresponding part to be enabled.

`InteractionDetector` is public for custom controls. It combines focus, hover, press and drag state with keyboard activation, feedback and optional external state-controller synchronization. Use its builder to size the full hit target. `InteractionState` can round-trip Flutter `WidgetState` sets.

## Menus and selection

Menus need an `Overlay` ancestor: use `WidgetsApp` with `home`/`routes`, or wrap in `Overlay`. All menus use `RawMenuAnchor` and require no Navigator or route. For an app that uses only the `WidgetsApp.builder`, add the overlay inside your theme:

```dart
WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (BuildContext context, Widget? child) => PureTheme(
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

`DropdownMenu.multiple` is controlled by `selected: Set<T>` and `onSelectionChanged`. The menu stays open by default, clears the search query after a toggle, and rejects removal of the last value when `emptySelectionAllowed` is false. Use `selectionBuilder` to render chips; otherwise selected labels appear as a joined summary. `DropdownMenuCloseBehavior.all` and `self` close the current menu after selection, while `none` keeps it open.

`PopupMenuButton<T>` builds its entries each time it opens. Use `PopupMenuItem`, `CheckedPopupMenuItem` and `PopupMenuDivider`. Its `position` is `PopupMenuPosition.over` by default, with `under` placing it below the trigger. `PopupMenuButtonState.showButtonMenu()` opens it programmatically. Checked entries display the supplied checked state; update that state in your callback. Selection closes the menu, calls the item's `onTap`, then calls `onSelected` for a non-null value. A null-value item calls only `onTap`; dismissing calls `onCanceled`. `PopupMenuEntry.height` is omitted because panel layout measures the actual entry widgets.

All three menu controls accept direct trigger or field `decoration` and panel `menuDecoration` parameters. Dropdown entries and popup items accept their own row `decoration`.

All menus support keyboard activation, arrow navigation that skips disabled options, Escape and outside-tap dismissal. Panels follow their anchor and close when an ancestor scrolls or the window resizes. Start-edge alignment respects RTL, and panels flip and clamp inside `edgePadding`. Dropdown panels are at least as wide as their anchor by default, subject to `maximumSize` and available overlay space. Popup panels size to their content by default. `MenuStyle.transitionDuration` defaults to zero, and a `MenuTransitionBuilder` can opt into animation. Closing completes the reverse transition before removing the panel.

Option rows resolve each token per state in this order: entry style, inline `style.itemStyle`, nearest component theme, structural defaults. Trigger and panel tokens follow the same order without the entry style. `DropdownStyle` and `PopupMenuStyle` deep-merge their nested button and menu styles. Open triggers resolve `isSelected`; selected dropdown rows and checked popup indicators resolve it for their chosen or checked state. Search highlights resolve visible focus while real focus stays in the editable field.

No menu glyphs or panel visuals are supplied. An editable field must have a cursor color: `DropdownStyle.cursorColor` falls back to the ambient text color, then opaque black. This is the package's only color fallback. Trigger and option semantics expose button, text field, expanded, selected, checked and enabled states as appropriate. Menu-specific `SemanticsRole` values are omitted because Flutter's widgets layer does not export those types.

## Run the gallery

```sh
cd example
flutter run -d macos
# Or:
flutter run -d chrome
```

The WidgetsApp gallery demonstrates a central visual theme, local component themes, inline `copyWith`, direct decorations with an asset image, loading, selection, RadioGroup, RTL, sliders, searchable and multi-select dropdowns, popup menus and a live interaction-state readout. It has macOS and web runners and no Material dependency.

To verify the package, run `flutter analyze` and `flutter test`, followed by `flutter test`, `flutter build macos` and `flutter build web` inside `example`.
