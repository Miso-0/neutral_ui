# PureUI

PureUI is a zero-dependency headless Flutter design system. It supplies controlled values, pointer and keyboard interaction, semantics, layout slots, and composable themes. Your application supplies its visual language. The library imports only Flutter's `widgets.dart`, local code, and `dart:math`.

Requires Flutter 3.47 or newer and Dart 3.13.4 or newer. Version 0.1.0 is tested with Flutter 3.47.5.

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

PureUI uses Material's familiar names: `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Checkbox`, `Switch`, `Radio`, `ListTile`, `Slider`, `ButtonStyle`, `ThemeData`, and the component theme names. When importing `material.dart` as well, use a prefix for PureUI (`import 'package:pure_ui/pure_ui.dart' as pure;`) or hide conflicting names. `widgets.dart` can be imported unprefixed alongside PureUI.

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

No colors, radii, borders, shadows, margins, glyphs, track sizes, or text styles are built into the controls. An unstyled control can be invisible. Supply content and tokens to render it. Visual null values fall through to the next style layer for the current state. Padding and gaps default to zero.

The structural defaults are 200 ms animation with `Curves.easeInOut`, enabled feedback, click/basic cursors, centered button content with start-aligned icons, `threeLine` tile alignment, and slider width 144 when unbounded, keyboard step 0.05 and `tapAndSlide` interaction. Checkbox, Switch, Radio and IconButton have a 48 by 48 minimum hit target; Slider has a 48 minimum height. Buttons and ListTile size to content and style. Compact targets can be overridden with `tapTargetSize`.

## Four ways to override a theme

`PureTheme.of(context)` returns the nearest `ThemeData`, or `const ThemeData()`. `PureTheme.maybeOf(context)` returns null if absent. ThemeData owns nine style slots: `elevatedButtonStyle`, `outlinedButtonStyle`, `textButtonStyle`, `iconButtonStyle`, `checkboxStyle`, `switchStyle`, `radioStyle`, `listTileStyle`, and `sliderStyle`.

1. Set app-wide tokens with `PureTheme(data: ThemeData(...), child: ...)`.
2. Inherit app-wide tokens and override some in a subtree with `PureTheme.merge(data: ThemeData(...), child: ...)`.
3. Override one component using `ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`, `IconButtonTheme`, `CheckboxTheme`, `SwitchTheme`, `RadioTheme`, `ListTileTheme`, or `SliderTheme`.
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

Stateful fields are nullable `StateProperty<T?>` values. Plain fields are nullable structural configuration. All four styles have `copyWith` and `merge`.

| Style | Stateful tokens | Plain tokens |
| --- | --- | --- |
| `ButtonStyle` | `decoration`, `foregroundDecoration`, `padding`, `minimumSize`, `fixedSize`, `maximumSize`, `textStyle`, `iconTheme`, `mouseCursor`, `loadingIndicator` | `alignment`, `spacing`, `iconAlignment`, `tapTargetSize`, `clipBehavior`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `ToggleStyle` | `size`, `decoration`, `thumbSize`, `thumbDecoration`, `indicator`, `indeterminateIndicator`, `mouseCursor` | `padding`, `tapTargetSize`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `ListTileStyle` | `decoration`, `foregroundDecoration`, `titleTextStyle`, `subtitleTextStyle`, `leadingAndTrailingTextStyle`, `iconTheme`, `mouseCursor` | `contentPadding`, `minVerticalPadding`, `horizontalTitleGap`, `minLeadingWidth`, `subtitleSpacing`, `minTileHeight`, `minTwoLineTileHeight`, `minThreeLineTileHeight`, `titleAlignment`, `animationDuration`, `animationCurve`, `enableFeedback` |
| `SliderStyle` | `trackHeight`, `trackDecoration`, `activeTrackDecoration`, `secondaryActiveTrackDecoration`, `thumbSize`, `thumbDecoration`, `tickMarkSize`, `tickMarkDecoration`, `activeTickMarkDecoration`, `mouseCursor` | `valueIndicatorBuilder`, `padding`, `tapTargetSize`, `preferredWidth`, `keyboardStep`, `allowedInteraction`, `animationDuration`, `animationCurve` |

Toggle `size` describes the checkbox box, switch track or radio ring. `thumbSize` and `thumbDecoration` describe the switch thumb or radio dot. Indicators are application-provided widgets. Switch track size can be inferred from its thumb size and padding. Checkbox supports an indeterminate indicator and tristate cycling. Selection animations interpolate resolved on/off tokens.

## Controls

Buttons support callbacks, focus, hover, external `WidgetStatesController`, loading, and leading/trailing slots. `ElevatedButton`, `OutlinedButton`, and `TextButton` have `.icon` constructors with `IconAlignment.start` or `end`. Loading disables activation and preserves content size. IconButton supports `isSelected`, `selectedIcon`, and a semantic `tooltip`. Wrap in Flutter's `RawTooltip` to show a visible tooltip.

Checkbox, Switch, Radio and Slider are controlled: store the value in your parent and rebuild after `onChanged`. Switch supports dragging with RTL-aware thumb movement. Radio supports explicit `groupValue`/`onChanged`, a `RadioGroup<T>` ancestor, or an explicit `RadioGroupRegistry<T>`. The registry parameter takes precedence, followed by explicit mode, then the ancestor group. RadioGroup supplies arrow and Space navigation.

ListTile supports one, two and three-line content, directional slot order and padding, independent text styles, selection, and callbacks. A three-line tile requires a subtitle. Height tokens fall back from three-line to two-line to one-line. Layout avoids intrinsic measurement, so a Slider can be placed in its subtitle.

Slider supports arbitrary min/max ranges, divisions, a secondary track, ticks, a value indicator builder and semantic value formatting. `SliderInteraction` provides `tapAndSlide`, `tapOnly`, `slideOnly`, and `slideThumb`; the latter two preserve the drag grab offset. Arrow keys adjust the value in traditional navigation. RTL mirrors horizontal keys and track geometry. Under directional navigation, up/down move focus. A zero-length range disables interaction.

`InteractionDetector` is public for custom controls. It combines focus, hover, press and drag state with keyboard activation, feedback and optional external state-controller synchronization. Use its builder to size the full hit target. `InteractionState` can round-trip Flutter `WidgetState` sets.

## Run the gallery

```sh
cd example
flutter run -d macos
# Or:
flutter run -d chrome
```

The WidgetsApp gallery demonstrates a central visual theme, local component themes, inline `copyWith`, loading, selection, RadioGroup, RTL, sliders and a live interaction-state readout. It has macOS and web runners and no Material dependency.

To verify the package, run `flutter analyze` and `flutter test`, followed by `flutter test`, `flutter build macos` and `flutter build web` inside `example`.
