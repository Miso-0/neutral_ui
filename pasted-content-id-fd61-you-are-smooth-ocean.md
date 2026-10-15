# PureUI: widget-level BoxDecoration parameters with validation (plan 3)

## Context

Every PureUI decoration is currently a style token typed `StateProperty<Decoration?>?` (for example `ButtonStyle.decoration`, `ToggleStyle.thumbDecoration`, `SliderStyle.trackDecoration`, `MenuStyle.decoration`). Giving one button a background therefore means building a whole style object and wrapping the decoration in `StateProperty.all`.

The user wants the simpler, Container-like path. Container-based widgets expose a plain `BoxDecoration` directly on the widget. If a caller supplies it, any styling input that the decoration makes redundant must **fail validation** rather than be silently ignored, mirroring Flutter's `Container` (which asserts on `color` + `decoration`). Only parts where a decoration makes sense get a parameter.

**User decisions:**
1. Expose a widget parameter: `BoxDecoration?`, applied in every interaction state, no style or `StateProperty` needed.
2. When it is provided, the inline style's matching decoration token must not also be set. That is a debug validation failure.
3. Cover buttons, ListTile, the menu widgets, and the toggle and slider parts.

Plan 1 is implemented. Plan 2 (menus) is in progress:
- `lib/src/menus/` has `dropdown_button.dart` plus the shared infrastructure, and `menu_style.dart`, `dropdown_style.dart`, `popup_menu_style.dart` exist.
- `DropdownMenu` and `PopupMenuButton` are not in `lib/` yet.

## The rule (applies to every widget below)

1. **One parameter per painted part:** each part's widget parameter is named exactly like the style token it replaces (`decoration`, `foregroundDecoration`, `thumbDecoration`, `trackDecoration`, ...) and typed `BoxDecoration?`, not `Decoration?`. Parts that a widget never paints get no parameter. For example, Checkbox has no `thumbDecoration`.
2. **Precedence:** a non-null widget parameter replaces that part's decoration in **every** state. It beats the inline style, the component theme, the `PureTheme` slot and the defaults. For toggles the off and on resolutions are identical, so the selection lerp leaves it unchanged. On/off differences still come from size and indicator tokens or from style decorations.
3. **Validation, conflict with the inline style:** if the widget parameter is set **and** the widget's own inline `style` sets the same token, the widget throws a `FlutterError` in debug.
   - Example message: "ElevatedButton received both `decoration` and `style.decoration`. The `decoration` parameter replaces the decoration in every interaction state, so `style.decoration` would never be used. Pass a single BoxDecoration through `decoration`, or per-state decorations through `style: ButtonStyle(decoration: StateProperty...)`."
   - This check runs through an `assert` at build time. A const-constructor assert cannot read `style?.decoration`, because property access is not a potentially-constant expression, and the constructors must stay `const`.
   - Theme and component-theme decorations are defaults, not inputs on the widget, so they are overridden without error.
4. **Validation, parameters that cannot apply:** a parameter for a part that the widget's other arguments make impossible fails a **constructor** assert, since comparing parameters to null is allowed in const asserts:
   - Slider `tickMarkDecoration`/`activeTickMarkDecoration` need `divisions != null`.
   - Slider `secondaryActiveTrackDecoration` needs `secondaryTrackValue != null`.
5. **Docs:** each parameter's doc states rules 2 and 3. README gains a "Decorations" section (widget parameter vs per-state style token, and the validation rule). Image backgrounds work through `BoxDecoration(image: DecorationImage(image: AssetImage(...)))`, since `AssetImage` is reachable from `widgets.dart`.

## Parameters per widget

| Widget | New `BoxDecoration?` parameters | Conflicts with inline |
|---|---|---|
| `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton` (incl. `.icon`) | `decoration`, `foregroundDecoration` | `style.decoration`, `style.foregroundDecoration` |
| `ListTile` | `decoration`, `foregroundDecoration` | `style.decoration`, `style.foregroundDecoration` |
| `Checkbox` | `decoration` (box) | `style.decoration` |
| `Switch` | `decoration` (track), `thumbDecoration` | `style.decoration`, `style.thumbDecoration` |
| `Radio` | `decoration` (ring), `thumbDecoration` (dot) | `style.decoration`, `style.thumbDecoration` |
| `Slider` | `trackDecoration`, `activeTrackDecoration`, `secondaryActiveTrackDecoration`*, `thumbDecoration`, `tickMarkDecoration`*, `activeTickMarkDecoration`* | the same-named `style.*` tokens |
| `DropdownButton` | `decoration` (trigger), `menuDecoration` (panel) | `style.buttonStyle.decoration`, `style.menuStyle.decoration` |
| `DropdownMenuItem` | `decoration` (row) | its own `style.decoration` |
| `DropdownMenu` (and `.multiple`) | `decoration` (field), `menuDecoration` (panel) | `style.buttonStyle.decoration`, `style.menuStyle.decoration` |
| `DropdownMenuEntry` | `decoration` (row) | its own `style.decoration` |
| `PopupMenuButton` | `decoration` (trigger), `menuDecoration` (panel) | `style.buttonStyle.decoration`, `style.menuStyle.decoration` |
| `PopupMenuItem`, `CheckedPopupMenuItem` | `decoration` (row) | their own `style.decoration` |

\* These parameters also have the constructor-assert dependencies from rule 4.

**Excluded, and why:**
- `PopupMenuDivider` has no inline style and is a line, not a surface.
- A dropdown's `style.itemStyle` is an outer layer for all rows, like a theme. A row-level `decoration` simply wins over it.
- Style tokens keep their existing `StateProperty<Decoration?>` types. Only the widget shortcut is `BoxDecoration`, as chosen.

## Implementation

1. **Shared validation helper** (internal, not exported): `lib/src/foundation/decoration_override.dart`.
   - `bool debugCheckDecorationOverride({required String widget, required String parameter, required String styleToken, required BoxDecoration? value, required Object? styleValue})` returns true, or throws `FlutterError` with the message format above. It is used as `assert(debugCheckDecorationOverride(...))`.
   - `StateProperty<Decoration?>? decorationLayer(BoxDecoration? value)` wraps the parameter as `StateProperty.all(value)` when non-null. Resolvers then put it first in the existing `resolveStateful` layer list (`lib/src/foundation/style_resolution.dart`), so no resolution logic is duplicated.
2. **Buttons** (`lib/src/buttons/button_style_button.dart`):
   - Add `decoration`/`foregroundDecoration` fields to `ButtonStyleButton`, with super-parameter pass-through in the four subclasses and their `.icon` constructors.
   - In the state's build: run the asserts, then prepend the layers where `decoration` and `foregroundDecoration` are resolved (currently near line 209).
   - The internal trigger and menu-row subclasses in `lib/src/menus/` (`menu_item_button.dart`) inherit this automatically.
3. **ListTile** (`lib/src/list_tile/list_tile_widget.dart`): add the fields and the build-time asserts, and prepend layers in its local `token<T>` helper.
4. **Toggles:**
   - `lib/src/toggles/checkbox.dart`, `switch.dart`, `radio.dart`: add the fields and asserts.
   - `lib/src/toggles/toggle_engine.dart`: `decorationToken` accepts an optional override that it returns for both the off and on resolutions.
5. **Slider** (`lib/src/slider/slider_widget.dart`): add the six fields, the constructor asserts (rule 4), the build-time conflict asserts, and layer prepending in each decoration resolution.
6. **Menus:**
   - Now: `DropdownButton` (trigger/panel) and `DropdownMenuItem` in `lib/src/menus/dropdown_button.dart`. The panel parameter reaches `menu_panel.dart` through the resolved `MenuStyle` decoration.
   - `DropdownMenu`, `DropdownMenuEntry`, `PopupMenuButton` and the popup items get the same parameters when plan 2 builds them. If plan 2 is still running, this becomes an amendment to its remaining steps; otherwise it is a follow-up pass right after they land. Either way the same helper and tests apply.
7. **Docs and example:**
   - README "Decorations" section, plus a line under each control.
   - CHANGELOG entry under the next version.
   - Gallery: a small "Decorations" demo. It shows a button and a ListTile using the widget parameter, including an asset `DecorationImage` that needs a tiny image under `example/assets/` and a pubspec `assets:` entry. It also shows a Slider with `trackDecoration`/`thumbDecoration`, and a Switch with `thumbDecoration`.

## Tests

New file `test/foundation/decoration_override_test.dart`, plus additions to each widget's existing test file:
- **The parameter wins in every state:** pressed, hovered, focus-visible, selected/checked and disabled all paint the same BoxDecoration, read from the `AnimatedContainer`/`DecoratedBox` like the existing precedence tests. It beats both the component theme and the `PureTheme` slot.
- **Toggles:** with the parameter, the mid-animation decoration equals the parameter (no lerp drift). Without it, the behavior is unchanged.
- **Conflicts:** for every row of the table, setting the parameter plus the inline token yields a `FlutterError` via `tester.takeException()`, and the message names the widget, the parameter and the token. The same parameter with only a theme-level token raises no error.
- **Slider dependencies:** `tickMarkDecoration` without `divisions` and `secondaryActiveTrackDecoration` without `secondaryTrackValue` give `throwsAssertionError` at construction.
- **Menus:** the trigger, panel (open the menu) and row parameters apply, and their conflicts raise.
- **Regression:** the existing suite stays green, and `architecture_test.dart` (widgets-only imports, no em-dash) covers the new helper.
- **Example test:** the Decorations demo pumps without exceptions, and the asset image resolves.

## Verification
- `flutter analyze` reports 0 issues in the root and `example/`; `dart format --set-exit-if-changed` is clean.
- `flutter test` passes in the root and `example/`.
- `flutter build macos` and `flutter build web` succeed for `example/`.
- Manual check on macOS through the `run` skill:
  - the Decorations demo renders, including the asset image
  - deliberately passing both `decoration` and `style.decoration` shows the FlutterError message in the debug console
