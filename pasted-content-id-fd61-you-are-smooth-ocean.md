# PureUI: headless Flutter design system (implementation plan)

## Context

The user wants **PureUI**, a zero-dependency, fully headless design-system package. It provides structure, touch targets, state and interaction handling, but no visual style. The target is `/Users/misomenze/Documents/Work/pure_ui`, a fresh `flutter create --template=package` scaffold on Flutter 3.47.5 / Dart 3.13.4. Today `lib/pure_ui.dart` holds only the template `Calculator`, and `test/pure_ui_test.dart` tests it.

The spec's mandates:
- `lib/` imports ONLY `package:flutter/widgets.dart`.
- Classes use the exact Material names: `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Checkbox`, `Switch`, `ListTile`, `Slider`, `Radio`.
- No colors, corners, shadows or forced margins.
- Every token comes from a global `PureTheme` InheritedWidget and can be overridden inline with `.copyWith()`.
- Style classes `ButtonStyle`, `ToggleStyle`, `ListTileStyle`, `SliderStyle` resolve values from a state object with `isPressed`, `isHovered`, `isFocused`, `isSelected`, `isDisabled`.
- Code is production-ready, with no TODOs, explicit types and full null-safety.

The deliverable is real package files (lib, tests, example app), not code pasted into chat.

**User decisions (asked during planning):**
1. Include a runnable example gallery (`example/`: `WidgetsApp` + `PureTheme` + a sample visual theme; macOS + Chrome).
2. Default a 48x48 minimum touch target only on compact controls: Checkbox, Switch, Radio, IconButton and the Slider's height. ElevatedButton, OutlinedButton, TextButton and ListTile size exactly to their content and style. The `tapTargetSize` token can always override this.
3. The central theme data class uses Material's exact name, **`ThemeData`**: `PureTheme(data: ThemeData(...))`, and `PureTheme.of(context)` returns a `ThemeData`.
4. Add Material-style **per-component theme widgets**: `ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`, `IconButtonTheme`, `CheckboxTheme`, `SwitchTheme`, `RadioTheme`, `ListTileTheme` and `SliderTheme`. Each re-styles one component for a subtree and is inherited the way Material's themes are.

   Declined, and therefore out of scope: app-wide base tokens (global text style, icon theme, motion), typed theme extensions, and animated theme switching (lerp, AnimatedPureTheme).

## Verified SDK constraints (Flutter 3.47.5 recon)

- **No name collisions.** None of our public names are exported by `widgets.dart`. That covers:
  - the helper names `InteractionState`, `StateProperty`, `StateResolver`, `InteractionDetector`, `IconAlignment`, `ListTileTitleAlignment`, `SliderInteraction`, `SemanticFormatterCallback`, `ButtonStyleButton` and `TapTarget`
  - `ThemeData` and the nine component theme names, which exist only in `src/material/`

  Material still declares the same names, so an app importing both needs `hide` or a prefix; README documents this.
- **`InheritedTheme` is exported** by `widgets.dart` (`inherited_theme.dart`: abstract `wrap(BuildContext, Widget)`, plus `InheritedTheme.capture` and `captureAll`). All PureUI theme widgets extend it, so themes carry into routes and overlays exactly like Material's.
- **Not reachable from `widgets.dart`, with replacements:**

  | Missing | Replacement |
  |---|---|
  | `LogicalKeyboardKey` | Keyboard input goes through intents: `ActivateIntent` + `ButtonActivateIntent`, and for the slider `DirectionalFocusIntent` (native) / `ScrollIntent` (web) overrides. |
  | `RenderShiftedBox`, `BoxParentData`, `BoxHitTestResult` | No custom render objects; layout is composed from widgets. |
  | `Diagnosticable` | No `debugFillProperties`; classes implement `toString` instead. |
  | `lerpDouble`, `clampDouble`, `kMinInteractiveDimension` | Local arithmetic and a private `48.0`. |
  | `DragStartBehavior` | Not exposed as a parameter. |

- **Reachable from `widgets.dart`, and used:**
  - State: `WidgetState`, `WidgetStatesController`.
  - Focus and keyboard: `Focus`, `FocusManager` highlight-mode listeners, `MediaQuery.maybeNavigationModeOf`.
  - Feedback: `Feedback.forTap` and `Feedback.forLongPress`.
  - Semantics flags: `checked`/`mixed`/`toggled`/`slider`/`inMutuallyExclusiveGroup`/`onIncrease`/`onDecrease`. `focusable` is deprecated and not used.
  - Animation and layout: `AnimationController`, `AnimatedContainer`, `AnimatedDefaultTextStyle`, `ImplicitlyAnimatedWidget`, `Row.spacing`.
  - Radio groups: `RadioGroup<T>`, `RadioGroupRegistry<T>`, and the `RadioClient<T>` mixin. The client implements `tristate`, `radioValue`, `enabled` and `focusNode`; its `registry` setter registers it and must be nulled in `dispose`. The group owns arrows and Space while one of its radios has focus.
- **Behaviors the design must handle:**
  - `onTapDown` arrives about 100ms late when recognizers compete, and quick taps fire down, up and tap back to back.
  - When a horizontal drag wins, the tap's `onTapCancel` fires before `onHorizontalDragStart`.
  - Drag handlers leak `scrollLeft`/`scrollRight` semantics unless `excludeFromSemantics: true` is set.
  - A disabled `Action` does not fall through to an ancestor's action.
  - `FocusableActionDetector` hides hover in touch highlight mode, so hover comes from `MouseRegion` directly (InkWell does the same).
  - `Container(alignment:)` expands under bounded constraints, so alignment always uses `Align(widthFactor: 1, heightFactor: 1)`.
  - `Container(clipBehavior:)` asserts that a decoration is present.

## Architecture

### Ground rules
- `lib/` imports only:
  - `package:flutter/widgets.dart`
  - `dart:math` (if needed)
  - package-local files
- Tests may import `flutter_test`, `services`, `gestures` and `rendering`. `example/` imports only `widgets.dart` + `pure_ui`.
- `pubspec.yaml`:
  - real description
  - `version: 0.1.0`
  - drop the empty `homepage`
  - `flutter: ">=3.47.0"` (the only tested SDK)
  - no new dependencies
- `analysis_options.yaml`: flutter_lints, plus:
  - `analyzer.language`: `strict-casts`, `strict-inference`, `strict-raw-types`
  - lints: `always_specify_types`, `always_declare_return_types`, `public_member_api_docs`, `prefer_final_locals`, `avoid_dynamic_calls`

  Recon confirmed none of these conflict with flutter_lints 6.
- Every public member is documented. No TODOs and no `// ignore`. No em-dash characters anywhere; an architecture test enforces this.
- Constructors mirror Material's **behavioral** parameters (names, types, defaults). Material's **visual** parameters become style tokens.
- Controls are controlled: the parent owns the value, callbacks request changes, and `didUpdateWidget` animates.
- **Structural defaults are the ONLY built-in values:**
  - mouse cursor: click when interactive, basic otherwise
  - the 48x48 compact-control tap targets
  - `animationDuration` 200ms, `animationCurve` `Curves.easeInOut`
  - `enableFeedback` true
  - button content `Alignment.center`, `IconAlignment.start`
  - ListTile `titleAlignment` `threeLine`
  - Slider: `preferredWidth` 144 when unbounded, `keyboardStep` 0.05, `allowedInteraction` `tapAndSlide`

  Every visual token (decorations, sizes, paddings, gaps, text styles, icon themes, indicators) defaults to null, which means nothing painted and zero space.

### File layout
```
lib/pure_ui.dart                          barrel: public API only
lib/src/foundation/interaction_state.dart InteractionState
lib/src/foundation/state_property.dart    StateProperty<T>, StateResolver<T>
lib/src/foundation/interaction_detector.dart  InteractionDetector, InteractionWidgetBuilder
lib/src/foundation/tap_target.dart        internal TapTarget
lib/src/foundation/style_resolution.dart  internal precedence helpers
lib/src/foundation/animated_icon_theme.dart  internal implicitly animated IconTheme
lib/src/theme/theme_data.dart             ThemeData
lib/src/theme/pure_theme.dart             PureTheme
lib/src/theme/button_themes.dart          ElevatedButtonTheme, OutlinedButtonTheme, TextButtonTheme, IconButtonTheme
lib/src/theme/toggle_themes.dart          CheckboxTheme, SwitchTheme, RadioTheme
lib/src/theme/list_tile_theme.dart        ListTileTheme
lib/src/theme/slider_theme.dart           SliderTheme
lib/src/styles/button_style.dart          ButtonStyle, IconAlignment
lib/src/styles/toggle_style.dart          ToggleStyle
lib/src/styles/list_tile_style.dart       ListTileStyle, ListTileTitleAlignment
lib/src/styles/slider_style.dart          SliderStyle, SliderInteraction, SemanticFormatterCallback, SliderValueIndicatorBuilder
lib/src/buttons/  (buttons.dart area barrel) button_style_button.dart, elevated_button.dart, outlined_button.dart, text_button.dart, icon_button.dart
lib/src/toggles/  (toggles.dart)  toggle_engine.dart (internal), checkbox.dart, switch.dart, radio.dart
lib/src/list_tile/ (list_tile.dart area barrel exports list_tile_widget.dart)
lib/src/slider/   (slider.dart area barrel exports slider_widget.dart)
test/helpers/pump.dart, test/foundation/, test/theme/, test/styles/, test/buttons/, test/toggles/, test/list_tile/, test/slider/, test/architecture_test.dart, test/public_api_test.dart
example/                                  WidgetsApp gallery (macOS + web)
```
`test/pure_ui_test.dart` (the Calculator test) is deleted. The area barrels let the four component agents work in parallel; the integration step adds them to `lib/pure_ui.dart`.

### Foundation
- **`InteractionState`** (`@immutable`):
  - `const InteractionState({bool isPressed = false, bool isHovered = false, bool isFocused = false, bool isSelected = false, bool isDisabled = false, bool isDragged = false})`
  - `factory InteractionState.fromWidgetStates(Set<WidgetState>)`
  - `Set<WidgetState> toWidgetStates()`
  - `bool get isEnabled`
  - `copyWith`, `==`/`hashCode`, `toString`

  `isFocused` means focus is *visible*: the control has focus, AND either navigation is directional OR (highlight mode is traditional AND the control is enabled). Raw focus is reported by `onFocusChange`.
- **`StateProperty<T>`** (the callback-builder pattern):
  - `typedef StateResolver<T> = T Function(InteractionState state);`
  - `abstract class StateProperty<T>` with `T resolve(InteractionState state)`, `const factory StateProperty.all(T value)` (value equality, toString) and `const factory StateProperty.resolveWith(StateResolver<T> resolver)` (resolver equality).
  - Visual tokens are `StateProperty<X?>?`; structural tokens are plain nullable values.
- **Style classes** (all four): `@immutable`, const constructor with all-nullable fields, `copyWith` (every field), `merge(other)` (receiver wins, other fills nulls; `merge(null)` returns this), `==`/`hashCode` (`Object.hashAll`), `toString`.
- **`InteractionDetector`** is public (custom controls reuse it):
  ```dart
  typedef InteractionWidgetBuilder = Widget Function(BuildContext context, InteractionState state);
  const InteractionDetector({super.key, required InteractionWidgetBuilder builder, bool enabled = true, bool? isSelected,
    VoidCallback? onTap, VoidCallback? onLongPress, GestureTapDownCallback? onTapDown, GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel, GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate, GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onHorizontalDragCancel, ValueChanged<bool>? onHover, ValueChanged<bool>? onFocusChange,
    FocusNode? focusNode, bool autofocus = false, bool canRequestFocus = true, StateProperty<MouseCursor?>? mouseCursor,
    WidgetStatesController? statesController, bool enableFeedback = true, Map<Type, Action<Intent>>? actions,
    bool excludeFromSemantics = false})
  ```
  - **Tree:**
    1. `Actions`: a private generic `Action<T extends Intent>` subclass. One instance for `ActivateIntent` and one for `ButtonActivateIntent` are created once in `initState`. Typed instances are needed because `Actions.invoke<T>` casts to `Action<T>`, and InkWell maps them the same way. `isEnabled` delegates to `enabled && onTap != null`. The map is merged with `actions`; caller entries win.
    2. `Focus`: `canRequestFocus: canRequestFocus && (enabled || directional navigation)`; `onFocusChange` is forwarded.
    3. `MouseRegion`: cursor resolved against the current state, default click/basic.
    4. `Semantics`: `onTap`/`onLongPress` only when enabled, set, and not `excludeFromSemantics`.
    5. `GestureDetector`: `behavior: opaque`, `excludeFromSemantics: true`. Tap handlers are attached when enabled. Long-press handlers are attached only when `onLongPress != null`, and drag handlers only when any drag callback is given.
  - **Pressed:**
    - true on tap down, false on tap up/cancel
    - true on long-press start, false on long-press end/cancel
    - keyboard activation sets it true, then a 100ms `Timer` clears it; re-activation replaces the timer and dispose cancels it
  - **Dragged:** true on drag start, false on end/cancel.
  - **Hover:** raw hover is tracked always; `isHovered = enabled && hovering`. `onHover` fires only when that value changes.
  - **Focus-visible:** recomputed on focus change, on the highlight-mode listener (added in `initState`, removed in `dispose`), and on navigation mode (read in build).
  - **Disabling** (`enabled` true to false): synchronously clears pressed and dragged and cancels the timer.
  - **`statesController`:** after every change, the detector writes hovered/focused/pressed/dragged/disabled, plus selected when `isSelected != null`. It listens for external changes, and on swap moves its listener and resyncs. `InteractionState.isSelected = isSelected ?? controller?.value.contains(selected) ?? false`.
  - **Feedback:** `Feedback.forTap` on tap and keyboard activation, `Feedback.forLongPress` on long press, both gated on `enableFeedback`. Every timer and post-frame callback checks `mounted`.
- **Internal helpers:**
  - `TapTarget(minSize: Size?, child)`: null passes the child through; otherwise `ConstrainedBox(min w/h) > Align(center, widthFactor: 1, heightFactor: 1) > child`, built inside the detector's builder so the whole padded area hits and hovers.
  - `style_resolution.dart`:
    - `T? resolveStateful<S, T>(InteractionState state, List<S?> layers, StateProperty<T?>? Function(S) select)`
    - `T? resolvePlain<S, T>(List<S?> layers, T? Function(S) select)`
  - `AnimatedIconTheme(data, duration, curve, child)`: an `ImplicitlyAnimatedWidget` using an `IconThemeData.lerp` tween that applies `IconTheme.merge`.

### Theme, component themes and precedence
- **`ThemeData`** (`@immutable`, Material's name) is the one place to centralize every component's style:
  - `const ThemeData({ButtonStyle elevatedButtonStyle = const ButtonStyle(), ..., SliderStyle sliderStyle = const SliderStyle()})`
  - fields:
    - `ButtonStyle`: `elevatedButtonStyle`, `outlinedButtonStyle`, `textButtonStyle`, `iconButtonStyle`
    - `ToggleStyle`: `checkboxStyle`, `switchStyle`, `radioStyle`
    - `ListTileStyle listTileStyle`
    - `SliderStyle sliderStyle`
  - `copyWith`, `merge(ThemeData? other)` (per-style receiver-wins merge), `==`/`hashCode`, `toString`

  Field names say "Style" because their types are the spec's style classes. There are no extra `*ThemeData` wrapper classes, since our style classes already are the token containers.
- **`PureTheme extends InheritedTheme`** (`required ThemeData data`):
  - `static ThemeData of(BuildContext)`, falling back to `const ThemeData()`
  - `static ThemeData? maybeOf(BuildContext)`
  - `static Widget merge({Key? key, required ThemeData data, required Widget child})`, which nests `PureTheme(data: data.merge(PureTheme.of(context)))`; the subtree inherits every token it does not set
  - `wrap(context, child) => PureTheme(data: data, child: child)`
  - `updateShouldNotify: data != old.data`
- **Per-component themes** all `extend InheritedTheme` and share one shape; `data` is the component's style class:

  | Widget | `data` type | Fallback when no ancestor |
  |---|---|---|
  | `ElevatedButtonTheme` / `OutlinedButtonTheme` / `TextButtonTheme` / `IconButtonTheme` | `ButtonStyle` | `PureTheme.of(context).elevatedButtonStyle` / `outlinedButtonStyle` / `textButtonStyle` / `iconButtonStyle` |
  | `CheckboxTheme` / `SwitchTheme` / `RadioTheme` | `ToggleStyle` | `checkboxStyle` / `switchStyle` / `radioStyle` |
  | `ListTileTheme` | `ListTileStyle` | `listTileStyle` |
  | `SliderTheme` | `SliderStyle` | `sliderStyle` |

  Members of each:
  - `const XTheme({super.key, required S data, required super.child})`
  - `static S of(BuildContext)`: the nearest `XTheme`'s data, else the PureTheme slot. These are Material's replace semantics: the nearest theme wins entirely.
  - `static S? maybeOf(BuildContext)`: the nearest local theme only
  - `static Widget merge({Key? key, required S data, required Widget child})`, which nests `XTheme(data: data.merge(XTheme.of(context)))` and inherits unset tokens from the enclosing component theme or PureTheme
  - `wrap`, and `updateShouldNotify: data != old.data`
- **Resolution order** (every widget, per token, per state): `widget param (where Material has one) ?? inline style ?? XTheme.of(context) (the widget's own component theme, which falls back to its PureTheme slot) ?? structural default`. Null results fall through.
- **Override patterns** (all supported and all tested):
  1. App-wide: `PureTheme(data: ThemeData(elevatedButtonStyle: ButtonStyle(...)))`
  2. Subtree, whole theme: `PureTheme.merge(data: ThemeData(...), child: ...)`
  3. Subtree, one component: `ElevatedButtonTheme(data: ButtonStyle(...))` (replace) or `ElevatedButtonTheme.merge(data: ..., child: ...)` (inherit)
  4. One instance: `style: ButtonStyle(...)` (merges over the theme) or `style: ElevatedButtonTheme.of(context).copyWith(...)` (explicit copyWith)
- **Routes and overlays:** because every theme is an `InheritedTheme`, `InheritedTheme.capture(from:, to:)` and `captureAll` carry PureTheme and the component themes into routes and overlays, as Material's themes do.

### ButtonStyle and buttons (ElevatedButton, OutlinedButton, TextButton, IconButton)

**`ButtonStyle` tokens:**

| Kind | Tokens |
|---|---|
| `StateProperty<X?>?` | `decoration`, `foregroundDecoration`, `padding` (EdgeInsetsGeometry), `minimumSize`, `fixedSize`, `maximumSize` (Size), `textStyle`, `iconTheme`, `mouseCursor`, `loadingIndicator` (Widget) |
| plain | `alignment`, `spacing`, `iconAlignment`, `tapTargetSize`, `clipBehavior`, `animationDuration`, `animationCurve`, `enableFeedback` |

`enum IconAlignment { start, end }`.

**`abstract class ButtonStyleButton extends StatefulWidget`** (public, as in Material, for custom variants):
- Fields:
  - callbacks: `onPressed`, `onLongPress`, `onHover`, `onFocusChange`
  - `style`, `focusNode`, `autofocus`, `clipBehavior`, `statesController`, `isSemanticButton = true`
  - slots: `leading`, `trailing`, `icon`, `iconAlignment`, `child`
  - loading: `isLoading = false`, `loadingIndicator`
- `bool get enabled => !isLoading && (onPressed != null || onLongPress != null)`
- Protected hooks:
  - `ButtonStyle? themeStyleOf(BuildContext)`: the component theme, e.g. `ElevatedButtonTheme.of(context)`. A custom subclass can return its own InheritedTheme here.
  - `ButtonStyle defaultStyleOf(BuildContext)`: structural defaults only
  - `bool? get selected => null`
  - `Widget? get selectedChild => null`
  - `String? get semanticTooltip => null`

**Concrete buttons:**
- ElevatedButton, OutlinedButton and TextButton each have a const main constructor (super params, `autofocus = false`) and `const X.icon({..., Widget? icon, required Widget label, IconAlignment? iconAlignment})`. They differ only in which component theme they read (`ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`): they are structurally identical by design, and the theme gives each its look.
- `IconButton({..., required Widget icon, Widget? selectedIcon, bool? isSelected, String? tooltip})`:
  - overrides `selected`/`selectedChild`/`semanticTooltip`
  - `tooltip` is semantics-only, documented; wrap the button in `RawTooltip` for a visual tooltip
  - default `tapTargetSize: Size(48, 48)`
  - reads `IconButtonTheme`

**Tree:**
1. `Semantics(container: true, button: isSemanticButton, enabled, selected, tooltip)`
2. `InteractionDetector(onTap: onPressed, ...)`
3. builder:
   1. `TapTarget(tapTargetSize)`
   2. `AnimatedContainer(duration, curve, constraints, padding, decoration, foregroundDecoration, clipBehavior: decoration != null ? clip : Clip.none)`
   3. `Align(alignment, widthFactor: 1, heightFactor: 1)`
   4. `AnimatedIconTheme(iconTheme)`
   5. `AnimatedDefaultTextStyle(ambient.merge(textStyle), keeping the ambient textAlign/softWrap/overflow/maxLines)`
   6. content

**Constraints:** min = `minimumSize ?? Size.zero`, max = `maximumSize ?? Size.infinite`. A `fixedSize` is constrained into those bounds and tightens each finite dimension (Material parity).

**Content:**
- Starts with `[leading, icon if start]`, then the child, then `[icon if end, trailing]`.
- With any slot present: `Row(mainAxisSize: min, spacing: spacing ?? 0, [...start, Flexible(child), ...end])`. Otherwise the child alone.
- `iconAlignment` resolves as widget param ?? style layers ?? start.

**Loading** (MUI precedent):
- The button behaves as disabled (`isDisabled`, `enabled: false` in semantics, no callbacks).
- The indicator is `loadingIndicator` param ?? resolved token. If present: `Stack(center, [Visibility(visible: false, maintainSize/Animation/State: true, content), indicator])`, so the size is preserved. If absent, the content stays visible.

### ToggleStyle and toggles (Checkbox, Switch, Radio)

**`ToggleStyle` tokens:**

| Token | Type | Checkbox | Switch | Radio |
|---|---|---|---|---|
| `size` | `StateProperty<Size?>?` | box | track (null falls back to `2*thumb.width + padding.horizontal` x `thumb.height + padding.vertical`) | ring |
| `decoration` | `StateProperty<Decoration?>?` | box | track | ring |
| `thumbSize`, `thumbDecoration` | `StateProperty<...>?` | unused | thumb | inner dot |
| `indicator` | `StateProperty<Widget?>?` | check glyph | icon inside thumb | content over dot |
| `indeterminateIndicator` | `StateProperty<Widget?>?` | glyph for `null` value | unused | unused |
| `padding` | `EdgeInsetsGeometry?` | inset around indicator | thumb travel inset | inset |
| `tapTargetSize` | `Size?` | default 48x48 | default 48x48 | default 48x48 |
| `mouseCursor`, `animationDuration`, `animationCurve`, `enableFeedback` | as in ButtonStyle | | | |

**Theme lookup:** Checkbox, Switch and Radio resolve through `CheckboxTheme.of`, `SwitchTheme.of` and `RadioTheme.of` respectively, in the standard resolution order.

**Internal toggle engine** (`toggle_engine.dart`, a mixin on State with `SingleTickerProviderStateMixin`):
- **Position controller:** an `AnimationController` (0..1), initialized to selected ? 1 : 0, with duration = resolved `animationDuration`; disposed in `dispose`.
- **Rendered t:** `curve.transform(controller.value)`, or the raw value while in linear mode. Linear mode is set at drag start and cleared when the controller completes or dismisses, so the thumb tracks the finger 1:1 (Material Switch parity).
- **Lerping:** each visual token is resolved twice, `off = resolve(state.copyWith(isSelected: false))` and `on = resolve(state.copyWith(isSelected: true))`, then rendered as `lerp(off, on, t)` (`Decoration.lerp`, `Size.lerp`).
- **Indicators** cross-fade: the off indicator at opacity `1 - t`, the on indicator at `t`; each `Opacity` is skipped when it reaches 0.
- **Interaction transitions:** box and thumb are `AnimatedContainer`s whose duration is `Duration.zero` while the controller animates or a drag is active, and `animationDuration` otherwise. Hover, press and focus then animate smoothly without fighting the selection animation.
- **Selection change:** `didUpdateWidget` sees the selected-ness change and calls `animateTo(target)`. Duration and curve are refreshed from the resolved style each build.
- **Tree:**
  1. `Semantics(container: true, flags, label: semanticLabel, enabled: interactive)`
  2. `InteractionDetector(enabled: interactive, isSelected, onTap: handleTap, drag callbacks (Switch only), focusNode, autofocus, onFocusChange, mouseCursor, enableFeedback)`
  3. builder: `TapTarget(tapTargetSize)` > `AnimatedBuilder(controller)` > visual

**Checkbox:**
```dart
const Checkbox({super.key, required bool? value, bool tristate = false, required ValueChanged<bool?>? onChanged, FocusNode? focusNode, bool autofocus = false, ValueChanged<bool>? onFocusChange, String? semanticLabel, ToggleStyle? style}) : assert(tristate || value != null)
```
- **Tap cycle:** false to true; true to (tristate ? null : false); null to false.
- **Selected-ness:** `value != false`.
- **Indicator kind:** `null` means indeterminate. The last non-false kind is remembered so a fading indicator keeps its glyph. Moving true to null resets the controller to 0 and animates to 1 (Material parity).
- **Semantics:** `checked: value ?? false`, `mixed: tristate ? value == null : null`.
- **Visual:** box `AnimatedContainer(size, decoration, padding)` > `Align(center, widthFactor: 1, heightFactor: 1)` > indicator cross-fade.

**Switch:**
```dart
const Switch({super.key, required bool value, required ValueChanged<bool>? onChanged, FocusNode? focusNode, bool autofocus = false, ValueChanged<bool>? onFocusChange, String? semanticLabel, ToggleStyle? style})
```
- **Tap:** `onChanged(!value)`.
- **Drag:**
  - `travel = trackWidth - padding.horizontal - thumb.width`.
  - Each update with `travel > 0` does `controller.value += primaryDelta / travel * (rtl ? -1 : 1)`.
  - On end, if `(controller.value >= 0.5) != value` it calls `onChanged(!value)` (the parent's rebuild animates the rest). Otherwise it animates back. Cancel animates back.
- **Semantics:** `toggled: value`. Drag semantics are excluded by the detector.
- **Visual:** track `AnimatedContainer(size, decoration, padding)` > `Align(AlignmentDirectional(-1 + 2t, 0))` > thumb `AnimatedContainer(thumbSize, thumbDecoration)` > `Align(center)` > indicator cross-fade.

**Radio\<T\>:**
```dart
const Radio({super.key, required T value, T? groupValue, ValueChanged<T?>? onChanged, bool toggleable = false, bool? enabled, RadioGroupRegistry<T>? groupRegistry, FocusNode? focusNode, bool autofocus = false, ValueChanged<bool>? onFocusChange, String? semanticLabel, ToggleStyle? style})
```
- **Selection source**, first match wins:
  1. the `groupRegistry` param
  2. explicit mode, when `onChanged != null || groupValue != null` (the spec's `groupValue` mapping)
  3. `RadioGroup.maybeOf<T>(context)` (exact `T`)
  4. none
- **Derived values:**
  - `isSelected = value == effectiveGroupValue`
  - `enabled = widget.enabled ?? (source != none && (explicit ? onChanged != null : true))`
- **RadioClient<T>:**
  - The State mixes in `RadioClient<T>`: `tristate => toggleable`, `radioValue => value`, `enabled`, and `focusNode => widget.focusNode ?? an owned FocusNode` (disposed).
  - `registry` is assigned in `didChangeDependencies`/`didUpdateWidget`. It is null in explicit mode or when there is no source, and set to null in `dispose`.
  - Inside a `RadioGroup`, arrows and Space belong to the group; Enter activates through our `ActivateIntent`.
- **Tap/activate:** if not selected, `onChanged(value)`; else if `toggleable`, `onChanged(null)`.
- **Semantics:** `checked: isSelected`, `inMutuallyExclusiveGroup: true`.
- **Visual:** ring `AnimatedContainer(size, decoration, padding)` > `Align(center)` > `Stack(center, [dot AnimatedContainer(thumbSize, thumbDecoration lerped), indicator cross-fade])`.

### ListTileStyle and ListTile
ListTile resolves through `ListTileTheme.of(context)`.

**`ListTileStyle` tokens:**

| Kind | Tokens |
|---|---|
| `StateProperty<X?>?` | `decoration`, `foregroundDecoration`, `titleTextStyle`, `subtitleTextStyle`, `leadingAndTrailingTextStyle`, `iconTheme`, `mouseCursor` |
| plain | `contentPadding`, `minVerticalPadding`, `horizontalTitleGap`, `minLeadingWidth`, `subtitleSpacing`, `minTileHeight`, `minTwoLineTileHeight` (falls back to `minTileHeight`), `minThreeLineTileHeight` (falls back to two-line), `titleAlignment`, `animationDuration`, `animationCurve`, `enableFeedback` |

`enum ListTileTitleAlignment { threeLine, top, center, bottom }`.

**Constructor:**
```dart
const ListTile({super.key, Widget? leading, Widget? title, Widget? subtitle, Widget? trailing, bool isThreeLine = false, bool enabled = true, bool selected = false, GestureTapCallback? onTap, GestureLongPressCallback? onLongPress, ValueChanged<bool>? onHover, ValueChanged<bool>? onFocusChange, FocusNode? focusNode, bool autofocus = false, WidgetStatesController? statesController, ListTileStyle? style}) : assert(!isThreeLine || subtitle != null)
```

**Layout** (pure widgets, no intrinsics, so LayoutBuilder-based children such as Slider are safe):
1. `Semantics(container: true, button: hasAction, selected, enabled)`
2. `InteractionDetector(enabled: enabled, canRequestFocus: hasAction, isSelected: selected, onTap/onLongPress only when enabled)`
3. `AnimatedContainer(decoration, foregroundDecoration, padding: contentPadding)`
4. `AnimatedIconTheme`
5. `Row(crossAxisAlignment)`, with children:
   - **leading**, if present: `Padding(vertical: minVerticalPadding)` > `ConstrainedBox(minWidth: minLeadingWidth)` > `Align(centerStart, widthFactor: 1, heightFactor: 1)` > leading/trailing text style > leading
   - `SizedBox(width: horizontalTitleGap)`, only if leading is present
   - **text block:** `Expanded` > `ConstrainedBox(minHeight: max(0, lineModeMinHeight - contentPadding.vertical))` > `Align(centerStart, heightFactor: 1)` > `Padding(vertical: minVerticalPadding)` > `Column(min, start, [title, if subtitle: SizedBox(height: subtitleSpacing), subtitle])`
   - gap + **trailing**, mirroring leading, only if present

**Automatic content adjustments:**
- The line mode is detected automatically: three-line if `isThreeLine`, two-line if a subtitle exists, otherwise one-line. It picks the min-height token.
- Gaps exist only for slots that are present.
- Every slot keeps `minVerticalPadding`.
- Directional padding flips in RTL.

**`crossAxisAlignment`:** `top` maps to start, `center` to center, `bottom` to end, and `threeLine` to `isThreeLine ? start : center`. Because the text block carries the minimum height and centers itself, leading/trailing alignment works against the full content height.

**Cursor default:** click only when `hasAction && enabled`.

### SliderStyle and Slider
Slider resolves through `SliderTheme.of(context)`.

**Types:**
```dart
enum SliderInteraction { tapAndSlide, tapOnly, slideOnly, slideThumb }
typedef SemanticFormatterCallback = String Function(double value);
typedef SliderValueIndicatorBuilder = Widget Function(BuildContext context, InteractionState state, double value, String? label);
```

**`SliderStyle` tokens:**

| Kind | Tokens |
|---|---|
| `StateProperty<X?>?` | `trackHeight` (double), `trackDecoration`, `activeTrackDecoration`, `secondaryActiveTrackDecoration`, `thumbSize`, `thumbDecoration`, `tickMarkSize`, `tickMarkDecoration`, `activeTickMarkDecoration`, `mouseCursor` |
| plain | `valueIndicatorBuilder`, `padding`, `tapTargetSize` (default 48x48: min height 48), `preferredWidth` (144, unbounded only), `keyboardStep` (0.05, used when `divisions` is null), `allowedInteraction`, `animationDuration`, `animationCurve` (decoration/size only; the thumb follows the value immediately) |

**Constructor:**
```dart
const Slider({super.key, required double value, double? secondaryTrackValue, required ValueChanged<double>? onChanged, ValueChanged<double>? onChangeStart, ValueChanged<double>? onChangeEnd, double min = 0.0, double max = 1.0, int? divisions, String? label, SemanticFormatterCallback? semanticFormatterCallback, FocusNode? focusNode, bool autofocus = false, ValueChanged<bool>? onFocusChange, ValueChanged<bool>? onHover, SliderInteraction? allowedInteraction, SliderStyle? style})
```
It asserts `min <= max`, `value` in range, `secondaryTrackValue` in range, and `divisions > 0`. Interactive = `onChanged != null && max > min`.

**Geometry** (`LayoutBuilder`, LTR coordinates):
- `W = bounded ? maxWidth : preferredWidth`; `p = padding.resolve(dir)`; `thumb = thumbSize ?? Size.zero`.
- `H = max(tapTarget.height, thumb.height, trackHeight, tick.height)`.
- `trackLeft = p.left + thumb.width/2`; `trackRight = W - p.right - thumb.width/2`; `trackWidth = max(0, trackRight - trackLeft)`.
- `t = (value-min)/(max-min)`; `v = rtl ? 1-t : t`; `thumbX = trackLeft + v*trackWidth`.
- `Stack(clipBehavior: Clip.none)` children, from the bottom up:
  - track
  - secondary track
  - active track (`trackLeft..thumbX` in LTR, `thumbX..trackRight` in RTL)
  - tick marks at each `i/divisions`; a mark is active when `i/divisions <= t`
  - thumb via `Positioned(left: thumbX, top: H/2) > FractionalTranslation(-0.5, -0.5) > AnimatedContainer(size, decoration)`, so it stays centered while its size animates
  - indicator via `Positioned(left: thumbX, top: H/2 - thumb.height/2) > FractionalTranslation(-0.5, -1)`

  Track pieces use `Positioned` geometry and animate only their decoration.

**Value from a local x:**
- `f = trackWidth > 0 ? ((x - grabOffset - trackLeft) / trackWidth).clamp(0, 1) : 0`; logical `= rtl ? 1-f : f`.
- With divisions: `round(logical*d)/d`.
- `value = min + logical*(max-min)`.

**Interaction state machine** (InteractionDetector callbacks):
- **begin(x, jump):**
  - sets `active`
  - calls `onChangeStart(widget.value)`
  - if jumping, emits the value for x
  - for non-jump modes, sets `grabOffset = x - thumbX`
- **emit(v):** calls `onChanged(v)` only if `v` differs from both the last emitted value and `widget.value`.
- **end():** if active, calls `onChangeEnd(last computed value)` and resets. Losing interactivity mid-gesture also calls end().
- **Per mode:**

  | Mode | Behavior |
  |---|---|
  | `tapAndSlide` | tapDown begins with a jump; tapUp ends. tapCancel defers end to a post-frame check that skips it if a drag started, since a winning drag cancels the tap first. dragStart continues the active interaction or begins one with a jump; dragUpdate moves; dragEnd/dragCancel end. |
  | `tapOnly` | Tap callbacks only: down begins with a jump, up or cancel ends. |
  | `slideOnly` | Drag callbacks only; begins without a jump. |
  | `slideThumb` | Like `slideOnly`, but the drag is ignored unless it starts within `max(thumb.width, tapTarget.width)/2` of `thumbX`. |

- **State flags:** `isPressed` follows the tap; `isDragged` follows the drag.
- **Keyboard:** detector `actions` handle `DirectionalFocusIntent` (native) and `ScrollIntent` (web).
  - Left/right decrease or increase, mirrored in RTL.
  - Up/down increase or decrease under traditional navigation. Under directional navigation, or when the slider is not interactive, the action calls `primaryFocus?.focusInDirection(direction)`.
  - Step = `divisions != null ? 1/divisions : keyboardStep`.
  - Each key press fires `onChangeStart`, `onChanged`, `onChangeEnd`.
- **Semantics:**
  - `Semantics(container: true, slider: true, enabled: interactive, label, value: format(v), increasedValue, decreasedValue, onIncrease/onDecrease when interactive, textDirection)`
  - `format = semanticFormatterCallback ?? '${(t*100).round()}%'`
  - The increase/decrease actions use the keyboard step logic.

## Tests (flutter_test; the harness lives in `test/helpers/pump.dart`)

**Harness:** `pumpPure(tester, Widget child, {ThemeData? theme, TextDirection textDirection = ltr})`.
- It wraps the child in `WidgetsApp(color: ..., builder: ...)`, which supplies the default Shortcuts/Actions, MediaQuery and Localizations, then in `Directionality` and `PureTheme`.
- Helpers:
  - `hover(tester, Finder)`: a mouse `TestGesture` with `addPointer` + `moveTo`
  - `useTraditionalFocus()`: `FocusManager.instance.highlightStrategy = alwaysTraditional`, with teardown restore
  - keyboard: `tester.sendKeyEvent(LogicalKeyboardKey.*)`
  - semantics: `tester.ensureSemantics()` + `matchesSemantics`

**Test files:**
- `foundation/`:
  - InteractionState: copyWith, equality, WidgetState round-trip.
  - StateProperty: `all`/`resolveWith` resolve and equality.
  - InteractionDetector:
    - tap down/up/cancel flags
    - drag-away cancel
    - long press keeps pressed
    - drag sets isDragged
    - hover only when enabled, and onHover dedupe
    - focus-visible in traditional vs touch mode
    - Enter/Space activation plus the 100ms pressed flash
    - disable mid-press clears state
    - statesController two-way sync and swap
    - cursor resolution
    - feedback calls do not throw
    - no setState after dispose
  - TapTarget: 48x48 hit and hover at the corners, no growth when null.
  - Resolution helpers: precedence order and null fall-through.
- `styles/` and `theme/`:
  - every style's `copyWith` (each field), `merge` precedence, `==`/`hashCode`
  - ThemeData `copyWith`/`merge`/`==`
  - PureTheme: `of` fallback to `const ThemeData()`, `maybeOf`, `merge` nesting inherits unset tokens, `updateShouldNotify`, `wrap`
  - all nine component themes, through one shared table-driven test:
    - `of` falls back to the PureTheme slot
    - the nearest theme wins (replace)
    - `maybeOf` returns null without a local theme
    - `merge` inherits from the enclosing component theme and from PureTheme
    - `updateShouldNotify`, `wrap`
  - `InheritedTheme.capture`: PureTheme and component themes reach a widget built in a different subtree, as in an overlay
- `buttons/` (each of the four types where relevant):
  - `onPressed`/`onLongPress`; disabled when both are null
  - pressed/hovered/focused flags reach the resolvers
  - full precedence chain per state and per token: inline style > the nearest component theme (`ElevatedButtonTheme` etc.) > PureTheme slot > defaults; null falls through
  - each button reads only its own component theme (an `ElevatedButtonTheme` does not affect a `TextButton`)
  - constraints from min/fixed/max size
  - padding, alignment, spacing
  - leading/trailing and `.icon` start/end order, including RTL
  - loading: size preserved, no callbacks, semantics disabled
  - `isSemanticButton`
  - IconButton: 48x48 default, `isSelected`/`selectedIcon`, semantics selected and tooltip
  - clipBehavior without a decoration does not assert
- `toggles/`:
  - Checkbox: tap cycle including tristate; disabled when `onChanged` is null; 48x48 hit area; decoration lerp at mid-animation; indicator cross-fade; true to null re-animation; semantics checked/mixed.
  - Switch: tap; drag past half toggles, short of half reverts; RTL drag; cancel; semantics toggled; size fallback.
  - Radio:
    - explicit `groupValue` mapping, `toggleable`
    - disabled
    - `RadioGroup<T>` ancestor selection, arrow-key navigation and Space
    - `groupRegistry` precedence
    - focus node ownership, unregister on dispose
    - semantics
  - All three: the precedence chain inline > `CheckboxTheme`/`SwitchTheme`/`RadioTheme` > PureTheme slot > defaults, and each toggle ignores the other toggles' themes.
- `list_tile/`:
  - precedence chain inline > `ListTileTheme` (including `ListTileTheme.merge` nesting) > PureTheme slot > defaults
  - slot order LTR/RTL; gaps only when slots exist; `minLeadingWidth`
  - min heights for each line mode with fallback chain; `minVerticalPadding`
  - each `titleAlignment` mode positions leading/trailing (top/center/bottom/threeLine)
  - text styles and icon theme per slot
  - `onTap`/`onLongPress`/disabled/selected flags; not focusable without an action
  - `isThreeLine` assert
  - a Slider in the subtitle lays out
  - semantics
- `slider/`:
  - precedence chain inline > `SliderTheme` > PureTheme slot > defaults; `allowedInteraction` widget param beats every style layer
  - tap jump; drag math incl. min/max offset, clamping beyond the ends, divisions snapping, RTL, padding and thumb width
  - each `SliderInteraction` mode, incl. no jump for slideOnly/slideThumb
  - callback order: start, changed..., end; dedupe; no spurious end/start when a drag wins over a tap
  - disabled when `max == min`; unbounded width uses `preferredWidth`
  - arrows with and without divisions, RTL, up/down under directional navigation
  - semantics value/increase/decrease/formatter
  - secondary track and tick-mark activity
  - value indicator builder receives value and label
- `architecture_test.dart`:
  - every `lib/**` import/export directive is `package:flutter/widgets.dart`, `dart:math`, `package:pure_ui/...` or relative
  - no U+2014 (em-dash) characters in `lib/`, `test/`, `example/lib`, README or CHANGELOG; the test builds the character from its code point rather than writing it literally
- `public_api_test.dart`: imports `widgets.dart` and `pure_ui.dart` unprefixed and references every exported symbol, a compile-time check against ambiguity.

## Example app
`flutter create --template=app --platforms=macos,web --project-name pure_ui_example example`, then:
- **pubspec:** `pure_ui: {path: ../}`; remove `cupertino_icons` and `uses-material-design`.
- **lib/main.dart** is replaced by a `WidgetsApp`-based gallery importing only `widgets.dart` + `pure_ui`. It has:
  - a sample visual theme supplied entirely through one central `ThemeData` passed to `PureTheme` (palette, radii, check glyphs drawn with `CustomPaint`, since there is no icon font)
  - a "local theme" section: an `ElevatedButtonTheme.merge` subtree and a `ListTileTheme` subtree that re-style only those components, next to untouched siblings
  - Buttons: all four, `.icon`, leading/trailing, loading, disabled, selected IconButton
  - Toggles: tristate checkbox, switch, radios with explicit `groupValue` and with `RadioGroup`
  - ListTiles: one/two/three-line, selected, disabled, with trailing switch
  - Sliders: continuous, discrete with ticks and value indicator, disabled
  - an inline `copyWith` override demo
  - an RTL toggle
  - a live InteractionState readout
- **test/widget_test.dart** is replaced by a smoke test of the gallery.

## Execution approach (after approval)
The work runs as Workflow orchestration (ultracode). The directory is not a git repo, so agents own disjoint files instead of using worktrees. Every agent gets this plan file path as its contract. Any deviation must be justified in its report.

**Workflow A (build, about 7 agents):**
1. **Foundation agent** writes:
   - pubspec and analysis_options
   - `lib/src/foundation/**`
   - `lib/src/theme/**`: `ThemeData`, `PureTheme` and all nine component theme widgets, so every component agent can call its `XTheme.of(context)` from the start
   - all four `lib/src/styles/**`, including their enums and typedefs
   - a barrel exporting only those
   - `test/helpers/**`, plus foundation/styles/theme tests
   - deletes the Calculator code and test

   Gate: `flutter analyze` and `flutter test` are clean.
2. **Four component agents in parallel:**
   - Buttons (`lib/src/buttons/**`)
   - Toggles (`lib/src/toggles/**`)
   - ListTile (`lib/src/list_tile/**`)
   - Slider (`lib/src/slider/**`)

   Each writes its area barrel and `test/<area>/**`, and may add tokens only to its own style file, updating copyWith/merge/==/tests. Tests import the main barrel plus their own area barrel. Each gates on `dart analyze` of its own paths and `flutter test test/<area>`, retrying on tooling or lock errors, which are not test failures.
3. **Integration agent:**
   - adds the area barrels to `lib/pure_ui.dart`
   - collapses test imports to the main barrel, avoiding `unnecessary_import`
   - writes `architecture_test.dart` + `public_api_test.dart`, README and CHANGELOG
     - the README theming guide covers `ThemeData` + `PureTheme`, the nine component themes, the four override patterns and the token tables
     - it also notes that `ThemeData`, the component theme names and all widget names clash with Material, so apps importing both need `hide` or a prefix

   Gate: full `flutter analyze` and `flutter test`.
4. **Example agent:** creates and writes `example/`; gates on `flutter analyze`, `flutter test`, `flutter build macos` and `flutter build web`.

**Workflow B (review loop, about 9 agents per round):**
1. Four reviewers with distinct lenses:
   - spec and plan compliance
   - Flutter correctness and lifecycle
   - accessibility, keyboard and semantics
   - theming and API consistency
2. One verifier per lens tries to refute each finding.
3. A fixer applies the confirmed findings, then reruns analyze and test.
4. A second round runs only if the first one changed code.

**Final, by me:**
- Rerun analyze, test and both builds.
- Launch the example on macOS through the `run` skill and screenshot the gallery.
- Report the results faithfully.

## Verification
- `flutter analyze` reports 0 issues (package root, which covers `example/`).
- `flutter test` passes in the root and in `example/`.
- `architecture_test.dart` fails on any non-widgets import or em-dash; `public_api_test.dart` fails on any ambiguous export.
- `flutter build macos` and `flutter build web` succeed for `example/`.
- On a manual run of the example (macOS, via the `run` skill + screenshot), these all work:
  - hover, press, Tab focus rings and Enter/Space activation
  - Switch and Slider drags
  - Slider arrow keys
  - RadioGroup arrows
  - the RTL toggle
  - the theme override demo
