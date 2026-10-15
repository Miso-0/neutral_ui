import 'package:flutter/widgets.dart';

/// Finds a framework key without importing the services layer.
SingleActivator menuKeyActivator(int keyId) {
  for (final ShortcutActivator activator in WidgetsApp.defaultShortcuts.keys) {
    if (activator is SingleActivator && activator.trigger.keyId == keyId) {
      return SingleActivator(activator.trigger);
    }
  }
  throw StateError(
    'WidgetsApp.defaultShortcuts no longer exposes menu key '
    '0x${keyId.toRadixString(16)}. Update the PureUI key lookup for this SDK.',
  );
}
