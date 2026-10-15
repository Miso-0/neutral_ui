# PureUI verification

Verified on 15 October 2026 with Flutter 3.47.5 and Dart 3.13.4.

- `flutter analyze`: no issues, including the example application.
- `flutter test`: all 532 package tests pass, including 73 decoration tests.
- `flutter test` in `example`: all 5 gallery tests pass, including menu interactions in LTR and RTL, smooth hover-to-focus transitions with stable field bounds, and decoration image loading and interaction.
- `dart format --output=none --set-exit-if-changed lib test example/lib example/test`: all 80 Dart files are formatted.
- `flutter build macos` in `example`: release build succeeds.
- `flutter build web` in `example`: release build succeeds; the WebAssembly compatibility dry run also succeeds.
- The final macOS release application was launched successfully.
- Independent implementation review found no confirmed remaining defects.

The tests cover pointer and keyboard activation, visible and virtual focus, hover, drag cancellation, controller synchronization, controlled selection and animation, RadioGroup keyboard navigation, RTL geometry, all slider interaction modes, semantic actions, stateful theme precedence, inherited theme capture, public API compatibility and import restrictions. Menu coverage includes filtering, search highlighting, multi-select chips and summaries, keyboard wrapping and disabled-option skipping, caret movement, callback order, focus restoration, scrolling selected rows without moving the page, placement and edge constraints, outside taps that still activate underlying controls, checked popup entries, custom popup entries, transitions and externally owned controller replacement. Lifecycle regressions include disabling during gestures, disabling open menus, disposing during reverse transitions, changing slider interaction modes, retaining button child state through loading, and disposing keyboard activation timeouts.

Direct decoration tests cover all button constructors, ListTile, toggle and slider parts, menu triggers, panels and entries. They verify state-independent painting above component and app themes, stable toggle decorations during selection animation, own inline-style conflicts even for null-returning resolvers, and slider part dependencies. The example resolves its packaged 64 by 64 texture through AssetImage and verifies the decorated controls remain interactive. Debug FlutterError conflict messages are checked by widget tests.

Native window capture returned `could not create image from window`. The gallery previews were instead rendered by Flutter's widget test engine using the application widgets and an installed Arial font, and visually inspected. The new menu previews use Arial Unicode to include the arrow and check glyphs. Native desktop interactions were not manually verified; gesture and keyboard behaviors were verified with Flutter widget tests. No `run` skill was available in this session; the native application was built and launched using Flutter and the macOS application launcher.

- [Gallery preview](gallery-preview.png)
- [Lower gallery preview](gallery-preview-lower.png)
- [Menu gallery preview](menus-gallery-preview.png)
- [Multiple selection preview](menus-multiple-preview.png)
- [Popup menu preview](menus-popup-preview.png)
- [Decorations gallery preview](decorations-gallery-preview.png)
