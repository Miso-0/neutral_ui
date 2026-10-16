# PureUI verification

Verified M0 (v0.5.0) on 16 October 2026 with Flutter 3.47.5 and Dart 3.13.4.

- `flutter analyze --no-pub`: no issues in the package or example.
- `flutter test`: all 649 package tests pass.
- `flutter test` in `example`: all 6 gallery tests pass.
- `dart format --output=none --set-exit-if-changed lib test example/lib example/test`: all 112 Dart files are formatted.
- `git diff --check`: clean.
- `flutter build macos` in `example`: release build succeeds.
- `flutter build web` in `example`: release build and WebAssembly compatibility dry run succeed.
- The final macOS release application was launched successfully and its process was confirmed running.

New coverage includes pure overlay placement policies, flipped gaps, directional offsets, horizontal sides, safe-area and keyboard bounds, root versus nearest overlays, nested panel tap groups, outside-tap consumption, pointer-route lifetime, focus ownership at close completion, route pushes and inactive anchors. Nested exit transitions wait for the longest child exit. Measured menu widths support dividers, flexible rows, wrapped text and constraint-driven builders, including release-compatible sizing without intrinsic queries for layout-dependent content. Motion tests sample monotonic opacity, interrupted reversals, independent reverse curves, reduced motion and spring retargeting. Selection callbacks remain ordered after complete dismissal; repeated keyboard activation during an exit delivers one selection.

Application coverage checks navigation, custom localization delegates, theme inheritance, persistent navigator-free content and inserted overlay entries, constructor changes, disposal and actual Hero flights. Calendar coverage checks date arithmetic, leap centuries, custom week starts and delegates, compact parsing, localized formatting and time values. Glyph coverage checks icon-theme inheritance, physical and directional edges, RTL and contexts without Directionality. The gallery tests exercise stable focus geometry, LTR/RTL menu selection, decorations and the new localized foundations section with consumed outside taps.

The foundations preview was rendered from the gallery widgets using the Flutter test engine and the installed Arial font, then visually inspected. Native pointer and keyboard interactions were verified through widget tests; the native application was launched, but its window was not manually exercised. M1 through M5 remain for later milestones, following the plan's instruction to stop after each milestone.

- [Foundations gallery preview](foundations-gallery-preview.png)
- [Earlier gallery preview](gallery-preview.png)
- [Earlier lower gallery preview](gallery-preview-lower.png)
- [Earlier menu gallery preview](menus-gallery-preview.png)
- [Earlier multiple selection preview](menus-multiple-preview.png)
- [Earlier popup menu preview](menus-popup-preview.png)
- [Earlier decorations gallery preview](decorations-gallery-preview.png)
