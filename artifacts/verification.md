# PureUI verification

Verified on 15 October 2026 with Flutter 3.47.5 and Dart 3.13.4.

- `flutter analyze`: no issues, including the example application.
- `flutter test`: all 316 package tests pass.
- `flutter test` in `example`: the gallery smoke test passes.
- `dart format --output=none --set-exit-if-changed lib test example/lib example/test`: all 52 Dart files are formatted.
- `flutter build macos` in `example`: release build succeeds.
- `flutter build web` in `example`: release build succeeds; the WebAssembly compatibility dry run also succeeds.
- The final macOS release application was launched successfully.
- Independent implementation review found no confirmed remaining defects.

The tests cover pointer and keyboard activation, visible focus, hover, drag cancellation, controller synchronization, controlled selection and animation, RadioGroup keyboard navigation, RTL geometry, all slider interaction modes, semantic actions, stateful theme precedence, inherited theme capture, public API compatibility and import restrictions. Lifecycle regressions include disabling during gestures, changing slider interaction modes, retaining button child state through loading, and disposing keyboard activation timeouts.

Native window capture returned `could not create image from window`. The gallery previews were instead rendered by Flutter's widget test engine using the application widgets and an installed Arial font, and visually inspected. Native desktop interactions were not manually verified; gesture and keyboard behaviors were verified with Flutter widget tests. No `run` skill was available in this session; the native application was built and launched using Flutter and the macOS application launcher.

- [Gallery preview](gallery-preview.png)
- [Lower gallery preview](gallery-preview-lower.png)
