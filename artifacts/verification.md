# PureUI verification

Verified the complete M0 through M5 roadmap (v0.10.0) on 16 October 2026 with Flutter 3.47.5 and Dart 3.13.4.

- `flutter analyze --no-pub` in the package and separately in `example`: no issues.
- `flutter test --reporter expanded`: all 1,167 package tests pass.
- `flutter test --reporter expanded` in `example`: all 8 gallery tests pass.
- `dart format --output=none --set-exit-if-changed lib test example/lib example/test`: all 173 Dart files are formatted.
- `git diff --check`: clean.
- `flutter build macos` in `example`: release build succeeds.
- `flutter build web` in `example`: release build and WebAssembly compatibility dry run succeed.
- The final macOS release application was launched successfully and its process was confirmed running.

The completed implementation includes all planned feedback surfaces, input and search controls, date/time pickers, button variants, chips, navigation controls, range sliders, badges and progress indicators. The public barrel exports the new APIs; all 31 ThemeData style slots have theme registration and contract coverage. README token tables, milestone changelog entries and interactive gallery sections are included. Library code retains its widgets-only Flutter imports and adds no package dependencies.

Automated coverage includes:

- Overlay placement, nested tap groups, outside-tap consumption, focus restoration, route and anchor lifetime, measured menu layout and completed exit transitions.
- Tooltip triggers and immediate reopening, modal dismissal and semantics, sheet dragging and controller replacement, scroll-controlled sheet interoperation, snack bar queues, swipe lifetime and callback/unmount safety.
- Text controller ownership, validation and reset, grapheme limits and IME composition, floating labels, autocomplete keyboard selection and interrupted exits, asynchronous search results and route/overlay lifecycle.
- Calendar/date normalization, custom calendars and localizations, dynamic bounds, disabled-day keyboard movement, range entry, 12/24-hour time input, localized digits, period changes and dial motion.
- Button and chip selection, deletion, semantics and keyboard navigation; tab page tracking and retargeting; navigation theme fallback; expansion state; independently focused range thumbs; badge and progress behavior.
- Nullable style tokens, deep merges, equality, public API compatibility, RTL, reduced motion, transition curves and pointer tracking. Gallery tests exercise the new families and confirm RTL/reduced-motion preferences reach modal routes.

The previews below were rendered from the gallery widgets using the Flutter test engine and the installed Arial font, then visually inspected. Pointer and keyboard behavior was exercised through automated widget tests. The macOS release application was launched and its process confirmed running; its native window was not manually exercised.

After a reported Chrome input assertion, TextField was changed to use a selection gesture builder across its decorated surface and dispatch onTap after an accepted tap. Seven regressions cover pointer-release timing, canceled drags, LTR/RTL padding taps, independent clear actions, and docked/full-screen search activation. Real Chrome 155 debug sessions exercised typing, focus and tab changes, hover, password reveal, and repeated search open/close cycles using browser input elements. The rebuilt gallery also passed typing/tab/hover checks with no browser errors. The exact original engine assertion was not reproduced, so its trigger remains unconfirmed. Stop and relaunch the running app to replace gesture builders retained by hot reload.

- [Foundations gallery preview](foundations-gallery-preview.png)
- [Feedback preview](roadmap-feedback-preview.png)
- [Text input and search preview](roadmap-input-preview.png)
- [Date and time pickers preview](roadmap-pickers-preview.png)
- [Button variants and chips preview](roadmap-chips-preview.png)
- [Navigation and progress preview](roadmap-navigation-preview.png)
- [Dialog preview](roadmap-dialog-preview.png)
- [Chrome text-input interaction preview](web-input-chrome-preview.png)
