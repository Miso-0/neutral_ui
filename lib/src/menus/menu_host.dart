import 'package:flutter/widgets.dart';

import '../styles/menu_style.dart';
import '../styles/popup_menu_style.dart';
import 'menu_layout.dart';
import 'menu_panel.dart';

/// Shared overlay, transition and focus ownership for PureUI menus.
mixin MenuHost<W extends StatefulWidget> on State<W>, TickerProvider {
  late MenuController _menuController;
  bool _ownsController = true;
  late FocusNode _anchorFocusNode;
  bool _ownsFocus = false;
  late final AnimationController _transition;
  final FocusScopeNode _menuScope = FocusScopeNode(debugLabel: 'PureUI menu');
  MenuStyle _panelStyle = const MenuStyle();
  bool _closing = false;
  int _generation = 0;
  ScrollPosition? _ancestorPosition;
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _panelKey = GlobalKey();

  bool _containsPointer(GlobalKey key, Offset position) {
    final RenderObject? object = key.currentContext?.findRenderObject();
    return object is RenderBox &&
        object.attached &&
        (Offset.zero & object.size).contains(object.globalToLocal(position));
  }

  void _pointerEvent(PointerEvent event) {
    if (event is PointerDownEvent &&
        menuOpen &&
        !_closing &&
        !_containsPointer(_anchorKey, event.position) &&
        !_containsPointer(_panelKey, event.position)) {
      closeMenu();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ScrollPosition? position = Scrollable.maybeOf(context)?.position;
    if (_ancestorPosition != position) {
      _ancestorPosition?.removeListener(_ancestorScrolled);
      _ancestorPosition = position;
      position?.addListener(_ancestorScrolled);
    }
  }

  void _ancestorScrolled() {
    if (mounted && menuOpen) closeMenu();
  }

  /// The attached menu controller.
  MenuController get menuController => _menuController;

  /// The owned or supplied anchor focus node.
  FocusNode get anchorFocusNode => _anchorFocusNode;

  /// Whether the menu overlay is visible.
  bool get menuOpen => _menuController.isOpen;

  /// Initializes resources from the consumer's initState.
  void initMenuHost({MenuController? controller, FocusNode? focusNode}) {
    _menuController = controller ?? MenuController();
    _ownsController = controller == null;
    _ownsFocus = focusNode == null;
    _anchorFocusNode = focusNode ?? FocusNode(debugLabel: 'PureUI menu anchor');
    _transition = AnimationController(vsync: this, duration: Duration.zero);
    // Blank parts of an Overlay need not participate in hit testing. A global
    // route observes those taps too, without intercepting underlying controls.
    WidgetsBinding.instance.pointerRouter.addGlobalRoute(_pointerEvent);
  }

  /// Replaces externally supplied resources after a widget update.
  void updateMenuHost({MenuController? controller, FocusNode? focusNode}) {
    if (controller != _menuController &&
        (controller != null || !_ownsController)) {
      closeMenu();
      _menuController = controller ?? MenuController();
      _ownsController = controller == null;
    }
    if (focusNode != _anchorFocusNode && (focusNode != null || !_ownsFocus)) {
      if (_ownsFocus) _anchorFocusNode.dispose();
      _ownsFocus = focusNode == null;
      _anchorFocusNode =
          focusNode ?? FocusNode(debugLabel: 'PureUI menu anchor');
    }
  }

  /// Opens this menu.
  void openMenu() => _menuController.open();

  /// Dismisses this menu.
  void closeMenu() => _menuController.close();

  /// Toggles this menu's visibility.
  void toggleMenu() => menuOpen ? closeMenu() : openMenu();

  /// Called after the overlay opens, before the next frame.
  void onMenuOpened() {}

  /// Called after the overlay closes.
  void onMenuClosed() {}

  void _openRequested(Offset? position, VoidCallback showOverlay) {
    _generation++;
    _closing = false;
    _transition.duration = _panelStyle.transitionDuration ?? Duration.zero;
    showOverlay();
    if (_transition.duration == Duration.zero) {
      _transition.value = 1;
    } else {
      _transition.forward();
    }
  }

  void _closeRequested(VoidCallback hideOverlay) {
    if (!menuOpen) return;
    final bool restoreFocus = _menuScope.hasFocus;
    final int generation = ++_generation;
    void finish() {
      if (!mounted || generation != _generation) return;
      if (restoreFocus && _anchorFocusNode.canRequestFocus) {
        _anchorFocusNode.requestFocus();
      }
      hideOverlay();
    }

    if ((_panelStyle.transitionDuration ?? Duration.zero) == Duration.zero) {
      finish();
    } else {
      setState(() {
        _closing = true;
      });
      _transition.reverse().whenCompleteOrCancel(finish);
    }
  }

  /// Builds an anchor and a menu panel within the nearest Overlay.
  Widget buildMenuHost({
    required MenuStyle style,
    required Widget child,
    required List<Widget> children,
    bool matchAnchorWidth = true,
    PopupMenuPosition position = PopupMenuPosition.under,
    Offset? offset,
    double? maxHeight,
    String? semanticLabel,
    bool textField = false,
    ValueChanged<int>? onNavigate,
  }) {
    _panelStyle = style;
    return RawMenuAnchor(
      controller: _menuController,
      childFocusNode: _anchorFocusNode,
      onOpenRequested: _openRequested,
      onCloseRequested: _closeRequested,
      onOpen: () {
        if (mounted) setState(() {});
        onMenuOpened();
      },
      onClose: () {
        if (mounted) {
          setState(() {
            _closing = false;
          });
        }
        onMenuClosed();
      },
      overlayBuilder: (BuildContext context, RawMenuOverlayInfo info) {
        return Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: MenuPositionDelegate(
              anchorRect: info.anchorRect,
              textDirection: Directionality.of(context),
              style: style,
              matchAnchorWidth: matchAnchorWidth,
              position: position,
              offset: offset ?? style.offset ?? Offset.zero,
              maxHeight: maxHeight,
            ),
            child: IgnorePointer(
              ignoring: _closing,
              child: ExcludeFocus(
                excluding: _closing,
                child: AnimatedBuilder(
                  animation: _transition,
                  builder: (BuildContext context, Widget? panel) =>
                      style.transitionBuilder?.call(
                        context,
                        _transition.drive(
                          CurveTween(
                            curve: style.transitionCurve ?? Curves.linear,
                          ),
                        ),
                        panel!,
                      ) ??
                      panel!,
                  child: MenuPanel(
                    key: _panelKey,
                    info: info,
                    style: style,
                    focusScopeNode: _menuScope,
                    onClose: closeMenu,
                    semanticLabel: semanticLabel,
                    textField: textField,
                    onNavigate: onNavigate,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: KeyedSubtree(key: _anchorKey, child: child),
    );
  }

  @override
  void dispose() {
    _generation++;
    _ancestorPosition?.removeListener(_ancestorScrolled);
    WidgetsBinding.instance.pointerRouter.removeGlobalRoute(_pointerEvent);
    _transition.dispose();
    _menuScope.dispose();
    if (_ownsFocus) _anchorFocusNode.dispose();
    super.dispose();
  }
}
