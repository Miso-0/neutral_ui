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
- Add PureTheme, ThemeData and nine component themes with inherited theme capture.
- Support controlled selection, loading, RTL, radio groups and slider interaction modes.
- Include a themed WidgetsApp gallery with macOS and web runners.
