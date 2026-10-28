# NeutralUI Components

A Flutter web component library with 64 live examples across 12 categories. Each example owns its appearance and local state. The Copy button copies its complete Dart file, loaded directly from the asset bundle, including all of its style declarations. No code generation is required.

## Run locally

Use Flutter 3.47 or newer with Dart 3.13.4 or newer, below Dart 4.0.0. From this repository:

```sh
cd example
flutter pub get
flutter run -d chrome
```

Open `/#/pickers`, `/#/tables`, or any other category path to link directly to that family. Search matches example titles, descriptions and categories. Press `/`, Cmd+K or Ctrl+K to focus search. RTL and reduced-motion controls also apply to modal routes. At narrow widths, use Categories to open navigation in a sheet.

The repository also includes a macOS runner. With Xcode installed, run `flutter run -d macos`.

The example uses `neutral_ui` through `path: ../` so local package changes are reflected immediately. For your own app, use `flutter pub add neutral_ui`.

## Use a copied example

Copy an example into a Dart file in your app, then place its public example widget below `NeutralApp`. Start with `theme: const ThemeData()`; every example includes its own styles and state. The direct-decoration example additionally needs `assets/decoration_pattern.png`, declared in your application's `pubspec.yaml`, as explained on its card.

The library root has an empty NeutralUI theme. The shell has a separate chrome theme, and each preview resets NeutralTheme to empty again. Modal examples include their own dialog, action and input styles. The application's copy notifications use an explicit style on a messenger above the chrome theme.

## Source layout

- `lib/main.dart` starts `LibraryApp`.
- `lib/library/app.dart` owns category routes and application preferences.
- `lib/library/catalog.dart` is the single list of categories, example metadata, source paths and widget builders.
- `lib/library/shell.dart` provides responsive navigation, search and preferences.
- `lib/library/example_card.dart` displays the live widget and its bundled source, with cached loading, clipboard feedback and selectable fallback code.
- `lib/library/code_view.dart` and `dart_highlighter.dart` provide selectable, numbered, highlighted Dart code using the bundled JetBrains Mono font.
- `lib/examples/<category>/<name>_example.dart` is both the running demo and its exact source asset.
- `test/` covers source contracts, theme isolation, clipboard success/failure, highlighting, routes and component interactions.

## Add an example

1. Add `lib/examples/<category>/<name>_example.dart` with one public widget. Import only `package:flutter/widgets.dart` and `package:neutral_ui/neutral_ui.dart`. Keep its state and private style builders in the same file. Include explicit typography and styles for every visible control, including any overlays. Avoid gallery callbacks, shared style imports and test keys.
2. Register an `ExampleEntry` in `lib/library/catalog.dart` with a unique id, title, description, exact asset path and builder. Mention any required external assets in its description.
3. For a new category, add its `ComponentCategory` to the catalog and its `lib/examples/<category>/` directory to `flutter.assets` in `pubspec.yaml`.
4. Run the checks below. Catalog tests verify the source asset and builder agree and pump each example under an empty theme at phone preview width. Add meaningful interaction coverage for new behavior.

## Verify and deploy

From `example`:

```sh
flutter analyze
flutter test
flutter build web --release
```

Publish the contents of `build/web/` to any static web host. For hosting below a subpath, build with its leading and trailing slashes:

```sh
flutter build web --release --base-href /components/
```

Share hash routes such as `/components/#/pickers`. Hash navigation needs no server-side route rewrites. Preserve the generated assets directory: it contains the example source files and fonts.

### Firebase Hosting

The repository root contains `firebase.json` and `.firebaserc` for the `flutter-neutral-ui` Firebase project and Hosting site. The public URL is [flutter-neutral-ui.web.app](https://flutter-neutral-ui.web.app/), with shareable category links such as [Dates and time](https://flutter-neutral-ui.web.app/#/pickers).

Install the [Firebase CLI](https://firebase.google.com/docs/cli) and run `firebase login` once if your profile is not already signed in. From the repository root, build the app and deploy only Hosting:

```sh
(cd example && flutter pub get && flutter build web --release)
firebase deploy --only hosting --project flutter-neutral-ui
```

Hosting publishes `example/build/web/`. The configuration revalidates cached files, including the app scripts and copied Dart sources, so a new release keeps previews and snippets in sync. Category links use hash routes and need no rewrite rules. For a local Hosting preview after building, run `firebase emulators:start --only hosting --project flutter-neutral-ui` from the repository root.

Also run `flutter analyze` and `flutter test` at the repository root. For a manual fidelity check, copy the calendar example into a fresh `NeutralApp` with an empty theme, compare the result, and check phone width, RTL, reduced motion, search and clipboard behavior in Chrome.

JetBrains Mono Regular comes from [JetBrains/JetBrainsMono](https://github.com/JetBrains/JetBrainsMono) under the bundled [SIL Open Font License](assets/fonts/OFL.txt).
