# PureUI roadmap: overlays, dialogs, text input, pickers, chips and navigation (plan 5)

## Context

PureUI (`/Users/misomenze/Documents/Work/pure_ui`, v0.4.0) is a headless Flutter design system. Its rules:
- Library code imports only `package:flutter/widgets.dart`.
- Classes use exact Material names, with tokens in style classes, `ThemeData` + `PureTheme` + per-component themes, and painted default glyphs.

It ships buttons, toggles, ListTile, Slider, DropdownButton, DropdownMenu and PopupMenuButton. Analyze is clean and 568 + 5 tests pass. One stray formatting diff remains in `example/lib/main.dart` around line 443.

The user wants Material's remaining interactive components, "highly customisable and very smooth".

**Decisions made with the user:**
- **Scope:**
  - tooltips;
  - all date and time pickers: inline calendar + anchored date field, modal picker, range, time;
  - dialogs and sheets;
  - text input and search;
  - chips and button variants;
  - navigation and feedback.
- **Date and time text:** English defaults behind an overridable localizations class. Zero-dependency, so no `package:intl`.
- **Outside taps:** keep today's pass-through (dismiss *and* activate what is underneath), but make it a style token, so `consume` is one setting away.

**Research findings that shape the plan** (3.47.5 sources + PureUI audit):
- **Tooltip:** `RawTooltip` exists in the widgets layer. It has no keyboard-focus trigger, no Escape, no per-instance hide, ignores later `animationStyle` changes, and drops `reverseCurve`.
- **Date and time:** pickers, `DateUtils`, `CalendarDelegate`, `DateTimeRange`, `TimeOfDay` and all picker strings are Material-only. Only `SelectableDayPredicate` is in widgets.
- **Dialogs:** dialogs can use `showGeneralDialog`/`RawDialogRoute`, which require a Navigator.
- **No widgets-layer equivalents:** there is no widgets-layer sheet route, `TabController`, chip, progress indicator, badge, `TextField`, `SnackBar` or `RangeSlider`.
- **Available widgets-layer pieces:** `Expansible`, `RawAutocomplete`, `EditableText`, `Form`, `PageView`, `DraggableScrollableSheet`, `Dismissible`, `ListWheelScrollView`, `RepeatingAnimationBuilder`, `ScrollSpringSimulation` and `SpringDescription`.
- **Menu overlay defects to fix first:**
  1. Panels are always placed in the nearest `Overlay`. Inside a nested Overlay they get squeezed and clipped.
  2. Each menu registers a global pointer route for its whole lifetime (`lib/src/menus/menu_host.dart:73`).
  3. That route's outside check ignores nested anchors, so month/year dropdowns inside a date popover would close their parent.
  4. Focus restore is decided at close-request time, so focus can be stolen back after the user moved on.
  5. A flipped panel turns its gap into an overlap (`menu_layout.dart:58,106`).
  6. Pushed routes and offstage anchors leave menus open.

## Rules every new component follows (same contract as today)

1. **Material parity:** the exact Material class name, Material's behavioral constructor parameters, and visual parameters moved into a style class. New non-Material names are kept minimal: `DatePickerField`, `CalendarDateRangePicker`, `TimePicker`, `PureApp`, `PureLocalizations`, `OverlayPlacement`, `OutsideTapBehavior`. A collision check against `widgets.dart` came back clean for all planned names.
2. **Style class conventions** (copy `lib/src/styles/menu_style.dart`):
   - const constructor, all-nullable fields
   - `copyWith`, receiver-first `merge` with nested deep-merge, `==`, `Object.hashAll`, full `toString`
   - stateful tokens as `StateProperty<T?>?`; structure and motion tokens as plain values
3. **Theme integration:**
   - one `ThemeData` slot per style (`lib/src/theme/theme_data.dart`)
   - a component theme copied from `lib/src/theme/menu_themes.dart`
   - exports in `lib/pure_ui.dart`
   - registration in `test/public_api_test.dart`, `test/theme/component_themes_test.dart` and `test/theme/theme_data_test.dart`
4. **Shared foundation, reused not reinvented:**
   - resolution: `resolveStateful`, `resolvePlain`, `resolveStatefulOrDefault` (painted defaults with null opt-out) in `lib/src/foundation/style_resolution.dart`
   - state: `InteractionDetector`
   - surfaces: `AnimatedSurface`, with premultiplied fades
   - glyphs: `lib/src/foundation/glyphs.dart`
   - widget-level `BoxDecoration` parameters with `debugCheckDecorationOverride`
   - `TapTarget` for compact controls
5. **Defaults:** no colors, radii or margins. Painted glyphs and indicators use the ambient `IconTheme`, like `Icon`. Text comes from `PureLocalizations` (English).
6. **Platform behavior:**
   - keyboard: intents only, plus `lib/src/menus/key_activators.dart` for text fields
   - RTL mirroring
   - Semantics flags and labels
   - `MediaQuery.disableAnimationsOf` respected everywhere, including springs
7. **Per-component deliverables:**
   - style tests for each token
   - behavior, keyboard, RTL and semantics tests
   - smoothness tests (see the motion contract)
   - a gallery section
   - README tokens table rows
   - a CHANGELOG entry
   - no em-dash characters (the architecture test enforces this)

## Motion contract ("very smooth")

- **Interaction states:** every visual state change animates through `AnimatedSurface` or explicit controllers with premultiplied color lerps. No state snaps unless its duration token is zero.
- **Overlays:** enter and exit transitions are on by default; the motion tokens and `transitionBuilder` override them.

  | Element | Enter | Exit |
  |---|---|---|
  | Popovers and menus | fade + scale 0.96 to 1 from the anchor side, 150ms `easeOutCubic` | 100ms |
  | Tooltips | 150ms | 75ms |
  | Dialogs | fade + scale, 200ms | 200ms |

  - Sheets and snack bars slide.
  - Exit always finishes before removal.
  - Interrupting a transition reverses from the current value with no jump.
  - **This changes menus' current zero-duration default** and is noted in the CHANGELOG.
- **Gestures follow the finger 1:1.** This covers sheet drag, the snack bar swipe, the tab indicator during page swipes, the time dial, and range slider thumbs. On release, a velocity-aware spring settles them: `controller.animateWith(ScrollSpringSimulation(spring, value, target, velocity))`, on unbounded controllers when overshoot is allowed.
- **Retargeting** (for example, the tab indicator jumping two tabs, or calendar month changes in quick succession) continues from the current position and velocity rather than restarting.
- **Reduced motion:** `MediaQuery.disableAnimationsOf` makes durations zero and springs settle immediately. This goes through one internal helper (`lib/src/foundation/motion.dart`).
- **Performance:**
  - a `RepaintBoundary` under every animated transform in overlays
  - no `IntrinsicWidth`/`IntrinsicHeight` on animated paths; `MenuPanel`'s `IntrinsicWidth` is replaced by a single measured width
  - lazy calendars (`PageView.builder` months, builder-based year grid)
  - per-cell `ValueListenableBuilder`s, so hover never rebuilds a whole grid
- **Smoothness tests:** extend the `sampleBrightness`/`expectNoDip` helpers in `test/helpers/pump.dart` with `sampleValues` for opacity, offset and scale. Assert that transitions are monotonic, have no jump on retarget, and that drags track the pointer.

## Milestones

Each milestone ends green: analyze, format, the package and example tests, the macOS and web example builds, a gallery section, README and CHANGELOG, and a version bump. Work stops after each one with a short report.

### M0: Foundations (v0.5.0)
1. **Anchored overlay engine**, `lib/src/overlay/`:
   - **`OverlayPlacement`** (public token type):
     - `preferredSide` (`AxisDirection`), `alignment` (start / center / end, directional), `coverAnchor`
     - `gap`, mirrored when the panel flips, and a directional `crossOffset`
     - `flip` (none / ifNeeded / toLargerSide), `overflow` (shrink / shift / keepSize)
     - `margin`, plus MediaQuery padding and insets
     - `constraints`, `anchorWidth` (none / min / exact)
   - **`resolvePlacement(...)`**: a pure, unit-tested function returning the rect and the chosen side, so transitions and arrows can follow the side. `MenuPositionDelegate` is rewritten on top of it.
   - **`OutsideTapBehavior { passThrough, consume }`** (public). Default `passThrough`; `consume` wires `TapRegion.consumeOutsideTaps`.
   - **MenuHost fixes:**
     - the global route is registered only while open, and its outside check counts every open panel in the root tap group (nested anchors)
     - focus is restored only if focus is still inside the panel when the close finishes
     - the menu closes when its route stops being current or its anchor's `TickerMode` turns off
     - an `overlayLocation` token chooses nearest or root (root default for tooltips and popovers)
     - `offset.dx` becomes directional (breaking; `test/menus/menu_layout_test.dart` is updated)
   - **`OverlayHost`**: a lightweight host on `OverlayPortal.overlayChildLayoutBuilder` for non-menu overlays (tooltips). It does not use `RawMenuAnchor`, because that steals focus and installs arrow shortcuts.
2. **Motion helpers** (`lib/src/foundation/motion.dart`):
   - reduced-motion duration helper
   - spring helper on `ScrollSpringSimulation` with presets via `SpringDescription.withDurationAndBounce`
   - an overlay transition builder with the default fade + scale
   - motion tokens added to `MenuStyle` (`transitionDuration` default changes from 0 to 150/100ms)
3. **Localizations and dates** (`lib/src/localizations/`, `lib/src/dates/`):
   - `PureLocalizations` (abstract, exact parallel of the needed `MaterialLocalizations` members), `DefaultPureLocalizations` (English) and a `LocalizationsDelegate`. `PureLocalizations.of(context)` falls back to English when no delegate is installed.
   - Members cover:
     - month and weekday names
     - `firstDayOfWeekIndex`
     - date formats (`formatMonthYear`, `formatYear`, `formatMediumDate`, `formatFullDate`, `formatShortDate`, `formatShortMonthDay`, `formatCompactDate`), `parseCompactDate`, `formatDecimal`
     - every picker, time, dialog, sheet, search, chip, tab, snack bar, badge and expansion label the components below need
   - `CalendarDelegate<T extends DateTime>` + `GregorianCalendarDelegate`, using the `PureLocalizations` signatures, for custom calendars.
   - Value types: `DateUtils`, `DateTimeRange`, `DatePickerMode`, `DatePickerEntryMode`, `SelectableDayForRangePredicate`, `TimeOfDay`, `DayPeriod`, `TimePickerEntryMode`.
4. **`PureApp`:**
   - a `WidgetsApp` wrapper with Navigator (`home`/`routes`/`onGenerateRoute`), `PureTheme`, the `PureLocalizations` delegate and a `HeroControllerScope`
   - a `PureApp.builder` variant that inserts an `Overlay` for navigator-free apps
   - the gallery moves to `PureApp`
5. **New glyphs:**
   - `ChevronGlyph(direction)`, with directional start/end support
   - `CloseGlyph`, `SearchGlyph`, `CalendarGlyph`, `ClockGlyph`, `EditGlyph`, `ArrowGlyph(direction)`
6. **Test harness:** `pumpPureApp` (Navigator + `PureLocalizations`) for route-based components, and the motion sampling helpers.

### M1: Overlays and feedback (v0.6.0)
- **`Tooltip`** + `TooltipVisibility`, with `TooltipStyle` / `TooltipTheme` / `ThemeData.tooltipStyle`:
  - **Built on:** `RawTooltip`, for hover, touch and tap triggers, the delays, exclusivity and feedback.
  - **Positioned by:** `resolvePlacement` through a `positionDelegate`.
  - **Added on top:**
    - showing on keyboard focus-visible
    - an Escape `DismissIntent` and a per-instance dismiss through a key (`TooltipState.ensureTooltipVisible` / `dismiss`)
    - default `verticalOffset` and side tokens
    - motion tokens with the reverse curve applied by PureUI
    - a fade + slide-from-side default
    - `richMessage`
  - **Behavioral parameters:** `message`, `richMessage`, `waitDuration`, `showDuration`, `exitDuration`, `triggerMode`, `enableTapToDismiss`, `enableFeedback`, `onTriggered`, `excludeFromSemantics`, `ignorePointer`, `preferBelow`, `verticalOffset`, `positionDelegate`, `mouseCursor`.
- **`Dialog`, `AlertDialog`, `SimpleDialog` (+ `SimpleDialogOption`), and `showDialog`** (on `showGeneralDialog`):
  - `DialogStyle` covers the barrier color and blur (`BackdropFilter` + `ImageFilterConfig.blur`), insets, alignment and motion.
  - Semantics: `namesRoute` with the localized `dialogLabel` / `alertDialogLabel`.
  - Escape and barrier dismissal; focus trap and restore come from the route.
- **`BottomSheet` + `showModalBottomSheet`:**
  - a custom `PopupRoute` whose controller is shared with drag: 1:1 drag, spring settle, snap points, `isScrollControlled`, `enableDrag`, `showDragHandle` (painted handle glyph), `isDismissible`
  - `DraggableScrollableSheet` interop
  - `BottomSheetStyle`
- **`SnackBar` + `SnackBarAction` + `ScaffoldMessenger`:**
  - `ScaffoldMessenger` is an overlay-based queue host: `showSnackBar`, `hideCurrentSnackBar`, `removeCurrentSnackBar`, `clearSnackBars`
  - `duration`, `persist`, `onVisible`; swipe to dismiss with `Dismissible`; `accessibleNavigation` disables auto-hide
  - `SnackBarStyle`

### M2: Text input and search (v0.7.0)
- **`TextField` + `TextFormField`:**
  - Built on `EditableText` + `Form`/`FormField`.
  - `TextFieldStyle` covers:
    - container decoration per state (focused, hovered, error, disabled via `InteractionState`, plus an `isError` flag passed to resolvers through `StateProperty`)
    - text, hint, label, helper, error and counter styles
    - cursor and selection colors, content padding, label behavior (above / floating / none)
  - Slots: `prefix`, `suffix`, `prefixIcon`, `suffixIcon`.
  - An obscure-text reveal toggle with a painted eye glyph, plus a clear button with `CloseGlyph`.
  - Smooth label float, using the explicit animation rather than an implicit restart.
  - Parameter parity with Material's behavioral set: `controller`, `focusNode`, `keyboardType`, `obscureText`, `readOnly`, `maxLines`, `minLines`, `maxLength`, `onChanged`, `onSubmitted`, `onTap`, `enabled`, `autofocus`, and so on. `inputFormatters` and `textInputAction` are dropped because widgets.dart cannot name those types; this is documented.
- **`Autocomplete<T>`:** on `RawAutocomplete`, with an options panel that reuses `MenuPanel` styling (`MenuStyle` + item `ButtonStyle`) and `AutocompleteStyle`.
- **`SearchBar`, `SearchAnchor` (+ `SearchAnchor.bar`), `SearchController`:**
  - Docked view through the anchored overlay engine.
  - A full-screen view through a route, with the bar-to-view rect expand animation.
  - Suggestions builder, `viewLeading`/`viewTrailing`, `SearchStyle`.

### M3: Date and time (v0.8.0)
- **`CalendarDatePicker`** (inline):
  - Month `PageView.builder` (swipe + 200ms animated prev/next), header month and year with a crossfade, a mode toggle with a flipping chevron, and a `YearPicker` grid (scroll to selected).
  - Day cells use per-cell state and RTL.
  - Keyboard: arrows ±1 day / ±7 days, skipping disabled days and crossing months with animation. Tab moves out of the grid.
  - Semantics: day labels "N, full date[, today]" and live announcements via `Semantics(liveRegion)`.
  - `selectableDayPredicate`, `currentDate`, `calendarDelegate`.
- **`DatePickerField`** (PureUI name): a field showing the formatted date that opens the calendar in an anchored popover. Root overlay, keepSize placement, consume-free per the user decision, focus trap and restore.
- **`InputDatePickerFormField`:** a typed date built on M2's `TextFormField`, with parse and validate through `CalendarDelegate.parseCompactDate` and localized errors.
- **`DatePickerDialog` + `showDatePicker`:** calendar / input / calendarOnly / inputOnly modes, an entry-mode toggle with `EditGlyph`/`CalendarGlyph`, and form validation on OK.
- **`CalendarDateRangePicker`** (PureUI name, inline) + `DateRangePickerDialog` + `showDateRangePicker`:
  - Start/end selection with the band highlight animating between dates and RTL-aware half caps.
  - Scrolling month list.
  - Keyboard skips disabled days (fixing Material's gap).
  - Range input mode.
- **`TimePicker`** (PureUI name, inline) + `TimePickerDialog` + `showTimePicker`:
  - Dial with the hand following the drag 1:1 and a spring snap to the nearest hour or minute (5-minute snapping on tap).
  - 12h/24h (`MediaQuery.alwaysUse24HourFormatOf`) with an inner ring for 24h.
  - Hour/minute segments with semantics increase/decrease.
  - AM/PM toggle.
  - Input mode with validation.
- **Styles and themes:** `DatePickerStyle` and `TimePickerStyle`.
  - Cell `ButtonStyle`s for day, today, selected, in-range, range-start/end, year and disabled.
  - Header and weekday text, navigation button style, motion tokens.
  - Dial and hand decorations, segment and period styles.
  - With `DatePickerTheme`, `TimePickerTheme` and `ThemeData` slots.

### M4: Chips and button variants (v0.9.0)
- **`FilledButton`** (+ `.icon`, `.tonal`, `.tonalIcon`) and **`FloatingActionButton`** (+ `.small`, `.large`, `.extended`) as new `ButtonStyleButton` subclasses with their own theme slots. FAB defaults to a 48x48 tap target.
- **`SegmentedButton<T>` + `ButtonSegment<T>`:**
  - `selected` set, `onSelectionChanged`, `multiSelectionEnabled`, `emptySelectionAllowed`, `showSelectedIcon` (`CheckGlyph`, animated width), `direction`
  - keyboard and semantics as a group
- **`ToggleButtons`.**
- **The chip family:** `Chip`, `InputChip`, `FilterChip`, `ChoiceChip`, `ActionChip` with `ChipStyle`.
  - `avatar` and `label`.
  - Delete button with a `CloseGlyph` default and a localized delete tooltip.
  - The FilterChip check mark animates its width in smoothly.
  - Selected and disabled states.

### M5: Navigation and feedback (v0.10.0)
- **`TabBar`, `TabBarView`, `TabController`, `DefaultTabController`** (Material-only upstream, so implemented here):
  - The indicator tracks `PageView` drag 1:1 and settles with retargeting.
  - Scrollable tabs auto-scroll to the selected tab.
  - `indicatorDecoration` / `indicatorBuilder` tokens and `TabBarStyle`.
- **`NavigationBar` (+ `NavigationDestination`), `NavigationRail` (+ destination), `NavigationDrawer` (+ destination):** selected index, an animated indicator between destinations, labels behavior, keyboard and semantics, `NavigationStyle`.
- **`ExpansionTile`:** on `Expansible`, reusing `ListTile` layout. The trailing `ChevronGlyph` flips; `maintainState`; expanded/collapsed semantics announcements; `ExpansionTileStyle`.
- **`RangeSlider` + `RangeValues`:**
  - Reuses the Slider engine and `SliderStyle`, with two thumbs and their focus nodes.
  - Arrow keys per thumb, fixing Material's missing shortcuts.
  - Thumbs never cross, using a push or stop policy.
- **`Badge` (+ `Badge.count`, `maxCount` "99+" via localizations)** and **`CircularProgressIndicator` / `LinearProgressIndicator`:**
  - Determinate values animate between updates; indeterminate uses `RepeatingAnimationBuilder` + `CustomPaint`.
  - The default paint uses `IconTheme`.
  - `ProgressIndicatorStyle`, plus semantics label and value.

### Candidates for a later plan (not in scope)
- `MenuBar` / `SubmenuButton` (cascading menus)
- `Stepper`, `DataTable` / `PaginatedDataTable`, `CarouselView`
- `RefreshIndicator`, `Scrollbar` styling, `MaterialBanner`
- `Card` / `Divider` (purely visual, little behavior)

## Critical files
- **New directories:** `lib/src/overlay/`, `lib/src/localizations/`, `lib/src/dates/`, `lib/src/feedback/`, `lib/src/input/`, `lib/src/pickers/`, `lib/src/chips/`, `lib/src/navigation/`, `lib/src/app/`.
- **Edits:**
  - menus: `lib/src/menus/menu_host.dart`, `menu_layout.dart`, `menu_panel.dart`
  - styles and theme: `lib/src/styles/menu_style.dart`, `lib/src/theme/theme_data.dart`
  - glyphs and resolution: `lib/src/foundation/glyphs.dart`, `style_resolution.dart`
  - buttons and slider: `lib/src/buttons/button_style_button.dart` (FilledButton/FAB subclasses), `lib/src/slider/slider_widget.dart` (shared engine for RangeSlider)
  - barrel: `lib/pure_ui.dart`
  - tests: `test/helpers/pump.dart`, `test/public_api_test.dart`
  - docs: `README.md`, `CHANGELOG.md`, `pubspec.yaml`
- **Gallery:** `example/lib/main.dart` moves to `PureApp`, with new sections for each milestone. It may be split into files under `example/lib/sections/` to stay manageable.

## Verification (per milestone and at the end)
- `flutter analyze` reports 0 issues (root and `example/`); `dart format --set-exit-if-changed` is clean.
- `flutter test` passes in the root and `example/`, including:
  - new behavior, keyboard, RTL, semantics, style, theme and public-API tests
  - the motion-contract sampling tests
  - regression tests for the overlay fixes (nested overlay, nested anchors, focus-restore timing, route push, offstage anchor, gap on flip)
- `flutter build macos` and `flutter build web` succeed for `example/`.
- A rendered golden preview of new glyphs and key components goes to the scratchpad and is checked by eye. Then a manual macOS run of the gallery covers:
  - tooltips on hover, long press and focus
  - every picker by mouse, keyboard and touch drag
  - sheet drag and the snack bar swipe
  - the tab swipe indicator
  - RTL
  - reduced motion
