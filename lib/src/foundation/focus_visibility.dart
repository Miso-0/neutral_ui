import 'package:flutter/widgets.dart';

/// Decides whether keyboard focus indication is drawn, like CSS
/// `:focus-visible`.
///
/// Flutter keeps the traditional highlight mode while a mouse is used on
/// desktop, so focus moved in code during pointer use would otherwise draw
/// keyboard rings. Here a pointer press hides focus indication until the next
/// non-modifier key press. An application that selects
/// [FocusHighlightStrategy.alwaysTraditional] always sees focus, and touch
/// highlight mode never does. Directional navigation is handled by callers.
abstract final class FocusVisibility {
  static final Set<VoidCallback> _listeners = <VoidCallback>{};
  static FocusManager? _manager;
  static bool _routed = false;
  static bool _keyboard = true;

  /// Whether focus indication should currently be visible.
  static bool get isVisible {
    _attach();
    final FocusManager manager = FocusManager.instance;
    if (manager.highlightStrategy == FocusHighlightStrategy.alwaysTraditional) {
      return true;
    }
    return manager.highlightMode == FocusHighlightMode.traditional && _keyboard;
  }

  /// Starts recording input for the current focus manager.
  ///
  /// Controls call this when they mount, so pointer input that happens before
  /// anything is focused is still observed.
  static void ensureInitialized() => _attach();

  /// Calls [listener] whenever [isVisible] may have changed.
  static void addListener(VoidCallback listener) {
    _attach();
    _listeners.add(listener);
  }

  /// Stops calling [listener].
  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Tests replace the focus manager between cases, so registration and the
  // recorded input follow the current instance.
  static void _attach() {
    final FocusManager manager = FocusManager.instance;
    if (identical(_manager, manager)) return;
    _manager?.removeEarlyKeyEventHandler(_handleKey);
    _manager?.removeHighlightModeListener(_handleMode);
    _manager = manager;
    _keyboard = true;
    manager.addEarlyKeyEventHandler(_handleKey);
    manager.addHighlightModeListener(_handleMode);
    if (!_routed) {
      _routed = true;
      WidgetsBinding.instance.pointerRouter.addGlobalRoute(_handlePointer);
    }
  }

  static void _handlePointer(PointerEvent event) {
    if (event is PointerDownEvent) _setKeyboard(false);
  }

  static KeyEventResult _handleKey(KeyEvent event) {
    // Shift, Control, Alt and Meta on either side do not reveal focus.
    final int usage = event.physicalKey.usbHidUsage;
    if (usage < 0x700E0 || usage > 0x700E7) _setKeyboard(true);
    return KeyEventResult.ignored;
  }

  static void _handleMode(FocusHighlightMode mode) => _notify();

  static void _setKeyboard(bool keyboard) {
    if (_keyboard == keyboard) return;
    _keyboard = keyboard;
    _notify();
  }

  static void _notify() {
    for (final VoidCallback listener in List<VoidCallback>.of(_listeners)) {
      if (_listeners.contains(listener)) listener();
    }
  }
}
