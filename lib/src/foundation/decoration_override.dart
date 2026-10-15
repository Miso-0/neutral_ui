import 'package:flutter/widgets.dart';

import 'state_property.dart';

/// Validates mutually exclusive widget and inline style decoration inputs.
///
/// Call inside an assert so release builds incur no validation cost.
bool debugCheckDecorationOverride({
  required String widget,
  required String parameter,
  required String styleToken,
  required BoxDecoration? value,
  required Object? styleValue,
}) {
  if (value != null && styleValue != null) {
    throw FlutterError(
      '$widget received both `$parameter` and `$styleToken`. '
      'The `$parameter` parameter replaces the decoration in every interaction '
      'state, so `$styleToken` would never be used. '
      'Pass a single BoxDecoration through `$parameter`, or configure '
      '`$styleToken` on its own.',
    );
  }
  return true;
}

/// Creates the highest-precedence decoration token for a widget shortcut.
StateProperty<Decoration?>? decorationLayer(BoxDecoration? value) =>
    value == null ? null : StateProperty<Decoration?>.all(value);
