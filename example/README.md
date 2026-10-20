# NeutralUI gallery

A runnable Flutter gallery for [neutral_ui](https://pub.dev/packages/neutral_ui), built with `NeutralApp` and Flutter's widgets layer. The application supplies its green palette, typography, dimensions, and decorations through shared theme tokens and local overrides.

## Run locally

Use Flutter 3.47 or newer with Dart 3.13.4 or newer, below Dart 4.0.0. From a checkout of [the repository](https://github.com/Miso-0/pure_ui), run:

```sh
cd example
flutter pub get
flutter run -d chrome
```

The repository also includes a macOS runner. On macOS with Xcode installed:

```sh
flutter run -d macos
```

Use `flutter devices` to see available targets. The bundled runners cover web and macOS; add other platform runners to the example if you need them.

The example intentionally depends on `neutral_ui` through `path: ../` so edits to the package are reflected locally. To use NeutralUI in your own application, follow the [hosted installation and quick-start instructions](https://github.com/Miso-0/pure_ui#get-started).

## Explore the gallery

- Buttons, loading states, toggles, RadioGroup, list tiles, sliders, and range controls.
- Searchable and multi-select dropdowns, popup menus, overlay placement, and outside-tap behavior.
- Direct decorations, including an image declared in the example's assets.
- Dialogs, bottom sheets, snack bars, tooltips, text input, autocomplete, and search.
- Date, date range, and time pickers; chips and button variants; tabs and navigation.
- Badges, progress indicators, a live interaction-state readout, RTL, and reduced-motion controls.

`lib/main.dart` contains the application, base theme, and core control demos. `lib/sections/roadmap_sections.dart` extends the theme and builds the additional component sections. `test/widget_test.dart` exercises gallery interactions, menu selection, image loading, RTL, and reduced motion.

## Check changes

From `example`:

```sh
flutter analyze
flutter test
flutter build web
# On macOS with Xcode installed:
flutter build macos
```

Also run `flutter analyze` and `flutter test` from the repository root when changing package code.

See the [package README](https://github.com/Miso-0/pure_ui#readme), [API reference](https://pub.dev/documentation/neutral_ui/latest/), and [issue tracker](https://github.com/Miso-0/pure_ui/issues) for more information.
