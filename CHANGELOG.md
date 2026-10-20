## Unreleased

- Rename the package to `neutral_ui` and its entrypoint to `package:neutral_ui/neutral_ui.dart`.
- Rename the application, theme and localization APIs to `NeutralApp`, `NeutralTheme`, `NeutralLocalizations`, `DefaultNeutralLocalizations` and `NeutralLocalizationsDelegate`.

## 0.10.0

- Fit text-field padding, typography, cursors and side controls to explicit dimensions and parent bounds, with matching sizing on TextFormField.
- Fix text-field focus and tap ordering by using Flutter's selection gesture handling across the decorated surface; suffix actions and canceled drags no longer activate the field callback.
- Add TabController, DefaultTabController, Tab, TabBar and TabBarView with retargetable motion and an indicator that follows page drags.
- Add navigation bars, rails and drawers, maintained-state expansion tiles, two independently focusable range thumbs, capped badges and determinate/indeterminate progress indicators.
- Extend the themed gallery with navigation, range, progress, RTL and reduced-motion examples.

## 0.9.0

- Add FilledButton and FloatingActionButton variants, SegmentedButton and ToggleButtons with accessible group navigation.
- Add Chip, InputChip, FilterChip, ChoiceChip and ActionChip, animated selected indicators and independently activated delete buttons.
- Add component themes, nullable tokens and direct decoration overrides.

## 0.8.0

- Add inline, anchored and modal date pickers, validated date entry and calendar/input modes.
- Add scrolling date-range calendars and range dialogs, and inline/modal time pickers with 12/24-hour dial and input modes.
- Use lazy calendar pages, cell-local interaction updates, disabled-day keyboard navigation and a dial that follows pointer drags before spring settling.

## 0.7.0

- Add TextField and TextFormField on EditableText with validation, supporting slots, floating labels, clear/reveal actions and error-state tokens.
- Add Autocomplete with asynchronous options and animated menu-style panels.
- Add SearchController, SearchBar and SearchAnchor with docked or expanding route views and stale-result protection.
- Keep the widgets-only API: services-only input formatter and text input action types are omitted.

## 0.6.0

- Add Tooltip and TooltipVisibility with hover, touch and keyboard triggers, Escape dismissal and per-instance animated hide.
- Add Dialog, AlertDialog, SimpleDialog and showDialog with localized semantics, barriers, focus trapping and configurable transitions.
- Add draggable modal bottom sheets with shared drag/route motion and spring settling.
- Add an overlay-based ScaffoldMessenger queue, SnackBar and SnackBarAction with accessible timing, swipe dismissal and persistent messages.

## 0.5.0

- Add the shared anchored overlay engine, public placement policies and non-menu OverlayHost.
- Fix nested-overlay clipping, nested menu tap groups, focus restoration timing, covered routes, inactive anchors and flipped-panel gaps.
- Keep editable dropdown anchors stable when focused in route-based applications, and deliver selection callbacks after their exit completes.
- Add configurable outside-tap consumption and nearest/root overlay selection; pass-through remains the default.
- Breaking: MenuStyle.offset.dx is directional in RTL, and menus now fade and scale over 150 ms on entry and 100 ms on exit by default. Set transitionDuration to Duration.zero for immediate transitions.
- Add reverse motion tokens, reduced-motion and spring helpers, repaint isolation and cached menu widths measured outside transition frames.
- Add NeutralLocalizations with overridable English strings, calendar delegates, date utilities and date/time value types without intl.
- Add NeutralApp for themed navigation and NeutralApp.builder for navigator-free overlays; migrate the gallery.
- Add directional chevrons and arrows plus close, search, calendar, clock and edit glyphs, with a foundations gallery section.

## 0.4.0

- Add painted default glyphs, `ChevronGlyph`, `CheckGlyph` and `DotsGlyph`, drawn with `CustomPainter` in the ambient icon theme.
- Dropdowns default to a chevron arrow that flips while the menu is open, turning by the new `DropdownStyle.iconTurns` (half a turn by default) with the trigger's duration and curve.
- Chosen dropdown rows and checked popup items default to a check that keeps its space when hidden; loading buttons default to dots.
- Defaults apply only when no style layer provides the token; a provided token that resolves to null opts out.
- Breaking: remove `DropdownMenu.selectedTrailingIcon` and the `DropdownStyle.icon` token in favor of one flipping arrow.
- Editable DropdownMenu fields now open on taps anywhere on the field, including unpainted padding, gaps and icons.
- The gallery uses painted glyphs throughout instead of keyboard characters.

## 0.3.1

- Fix the dark flash in hover, focus and selection fades that start or end at a transparent color, most visible when sweeping across menu rows. Decoration colors now interpolate in premultiplied-alpha space.

## 0.3.0

- Add direct BoxDecoration parameters to buttons, ListTile, toggles, sliders and menu triggers, panels and rows.
- Apply widget decorations in every interaction state, overriding component and app theme defaults.
- Validate conflicts with matching inline style tokens and slider decorations whose parts are unavailable.
- Add decoration documentation and a gallery with an asset image, gradient button, decorated slider and switch thumb.

## 0.2.0

- Add DropdownButton, searchable DropdownMenu, and controlled DropdownMenu.multiple.
- Add PopupMenuButton with action items, checked items, dividers and programmatic opening.
- Add MenuStyle, DropdownStyle, PopupMenuStyle and three component themes and ThemeData slots.
- Use widgets-layer menu overlays with keyboard navigation, focus restoration, RTL positioning and configurable transitions.
- Match editable dropdown hover transitions to button timing and distinguish hover from focused or open gallery fields.
- Add menu examples, an Overlay-backed gallery and menu styling documentation.

## 0.1.0

- Introduce nine headless Flutter controls with accessible pointer and keyboard interaction.
- Add immutable interaction states, state properties and composable style tokens.
- Add NeutralTheme, ThemeData and nine component themes with inherited theme capture.
- Support controlled selection, loading, RTL, radio groups and slider interaction modes.
- Include a themed WidgetsApp gallery with macOS and web runners.
