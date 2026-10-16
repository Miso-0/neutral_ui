import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_insets.dart';
import '../styles/menu_style.dart';
import '../styles/popup_menu_style.dart';
import 'menu_layout.dart';
import 'menu_panel.dart';

// RawMenuAnchor gives all nested anchors the root controller's tap group.
// The global route also checks panels outside the anchor's render subtree.
final Map<Object, Set<_MenuPointerRegion>> _tapGroups =
    <Object, Set<_MenuPointerRegion>>{};

class _MenuPointerRegion {
  _MenuPointerRegion(
    this.anchorKey,
    this.panelKey,
    this.isExiting,
    this.groupChanged,
    this.overlayLocation,
  );

  final GlobalKey anchorKey;
  final GlobalKey panelKey;
  final bool Function() isExiting;
  final VoidCallback groupChanged;
  final OverlayLocation Function() overlayLocation;

  bool contains(Offset position) {
    bool containsKey(GlobalKey key) {
      final RenderObject? object = key.currentContext?.findRenderObject();
      return object is RenderBox &&
          object.attached &&
          object.hasSize &&
          (Offset.zero & object.size).contains(object.globalToLocal(position));
    }

    return containsKey(anchorKey) || containsKey(panelKey);
  }
}

/// Shared overlay, transition and focus ownership for PureUI menus.
mixin MenuHost<W extends StatefulWidget> on State<W>, TickerProvider {
  late MenuController _menuController;
  bool _ownsController = true;
  late FocusNode _anchorFocusNode;
  bool _ownsFocus = false;
  late final AnimationController _transition;
  late final CurvedAnimation _curvedTransition;
  final FocusScopeNode _menuScope = FocusScopeNode(debugLabel: 'PureUI menu');
  MenuStyle _panelStyle = const MenuStyle();
  bool _closing = false;
  bool _opening = false;
  int _generation = 0;
  ScrollPosition? _ancestorPosition;
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _panelKey = GlobalKey();
  late final _MenuPointerRegion _pointerRegion = _MenuPointerRegion(
    _anchorKey,
    _panelKey,
    () => _closing && _transition.value > 0,
    () => _pendingFinish?.call(),
    () => _panelStyle.overlayLocation ?? OverlayLocation.root,
  );
  Object? _tapGroup;
  bool _pointerRouteRegistered = false;
  bool _anchorActive = true;
  AxisDirection _panelSide = AxisDirection.down;
  VoidCallback? _hideOverlay;
  final List<VoidCallback> _afterClose = <VoidCallback>[];
  VoidCallback? _pendingFinish;

  void _setTapGroup(Object group) {
    if (_tapGroup == group) return;
    _removeTapGroup();
    _tapGroup = group;
    (_tapGroups[group] ??= <_MenuPointerRegion>{}).add(_pointerRegion);
  }

  void _removeTapGroup() {
    final Object? group = _tapGroup;
    if (group == null) return;
    final Set<_MenuPointerRegion>? regions = _tapGroups[group];
    regions?.remove(_pointerRegion);
    if (regions?.isEmpty ?? false) _tapGroups.remove(group);
    _tapGroup = null;
    for (final _MenuPointerRegion region in List<_MenuPointerRegion>.of(
      regions ?? <_MenuPointerRegion>{},
    )) {
      region.groupChanged();
    }
  }

  void _registerPointerRoute() {
    if (_pointerRouteRegistered) return;
    _pointerRouteRegistered = true;
    WidgetsBinding.instance.pointerRouter.addGlobalRoute(_pointerEvent);
    _setTapGroup(_menuController);
  }

  void _removePointerRoute() {
    if (_pointerRouteRegistered) {
      WidgetsBinding.instance.pointerRouter.removeGlobalRoute(_pointerEvent);
      _pointerRouteRegistered = false;
    }
    _removeTapGroup();
  }

  void _pointerEvent(PointerEvent event) {
    if (event is PointerDownEvent &&
        menuOpen &&
        !_closing &&
        !(_tapGroups[_tapGroup]?.any(
              (_MenuPointerRegion region) => region.contains(event.position),
            ) ??
            false)) {
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
    _anchorActive =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    if (!_anchorActive && menuOpen) {
      // Dependencies change during build. Dismiss after layout, and finish
      // immediately because the anchor's ticker can already be muted.
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (!mounted || _anchorActive || !menuOpen) return;
        if (_hideOverlay case final VoidCallback hideOverlay) {
          _generation++;
          _transition.stop();
          hideOverlay();
        } else {
          closeMenu();
        }
      });
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

  /// Whether the panel is finishing its closing transition.
  bool get menuClosing => _closing;

  /// Initializes resources from the consumer's initState.
  void initMenuHost({MenuController? controller, FocusNode? focusNode}) {
    _menuController = controller ?? MenuController();
    _ownsController = controller == null;
    _ownsFocus = focusNode == null;
    _anchorFocusNode = focusNode ?? FocusNode(debugLabel: 'PureUI menu anchor');
    _transition = AnimationController(vsync: this, duration: Duration.zero);
    _curvedTransition = CurvedAnimation(
      parent: _transition,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
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

  /// Closes the panel before delivering a committed selection callback.
  void closeMenuThen(VoidCallback callback) {
    if (!menuOpen) {
      callback();
      return;
    }
    _afterClose.add(callback);
    closeMenu();
  }

  /// Toggles this menu's visibility.
  void toggleMenu() => menuOpen ? closeMenu() : openMenu();

  /// Called after the overlay opens, before the next frame.
  void onMenuOpened() {}

  /// Called after the overlay closes.
  void onMenuClosed() {}

  /// Called once when dismissal starts, before the closing transition.
  void onMenuCloseRequested() {}

  void _openRequested(Offset? position, VoidCallback showOverlay) {
    if (!_anchorActive) return;
    _generation++;
    _pendingFinish = null;
    _closing = false;
    _transition.duration = reducedMotionDuration(
      context,
      _panelStyle.transitionDuration ?? const Duration(milliseconds: 150),
    );
    _transition.reverseDuration = reducedMotionDuration(
      context,
      _panelStyle.reverseTransitionDuration ??
          (_panelStyle.transitionDuration == Duration.zero
              ? Duration.zero
              : const Duration(milliseconds: 100)),
    );
    _opening = true;
    try {
      showOverlay();
    } finally {
      _opening = false;
    }
    if (_transition.duration == Duration.zero) {
      _transition.value = 1;
    } else {
      _transition.forward();
    }
  }

  void _closeRequested(VoidCallback hideOverlay) {
    if (!menuOpen || _closing) return;
    final int generation = ++_generation;
    _hideOverlay = hideOverlay;
    setState(() => _closing = true);
    onMenuCloseRequested();
    if (!mounted || generation != _generation || !menuOpen) return;
    _transition.reverseDuration = reducedMotionDuration(
      context,
      _panelStyle.reverseTransitionDuration ??
          (_panelStyle.transitionDuration == Duration.zero
              ? Duration.zero
              : const Duration(milliseconds: 100)),
    );
    void finish() {
      if (!mounted || generation != _generation) return;
      if (_anchorActive &&
          (_tapGroups[_tapGroup]?.any(
                (_MenuPointerRegion region) =>
                    region != _pointerRegion && region.isExiting(),
              ) ??
              false)) {
        _pendingFinish = finish;
        return;
      }
      _pendingFinish = null;
      if (_anchorActive &&
          _menuScope.hasFocus &&
          _anchorFocusNode.canRequestFocus) {
        _anchorFocusNode.requestFocus();
      }
      hideOverlay();
    }

    if (!_anchorActive ||
        reducedMotionDuration(
              context,
              _transition.reverseDuration ?? Duration.zero,
            ) ==
            Duration.zero) {
      _transition.value = 0;
      finish();
    } else {
      _transition.reverse().whenCompleteOrCancel(finish);
    }
  }

  /// Builds an anchor and a menu panel within the selected overlay.
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
    _curvedTransition
      ..curve = style.transitionCurve ?? Curves.easeOutCubic
      ..reverseCurve = style.reverseTransitionCurve ?? Curves.easeInCubic;
    return RawMenuAnchor(
      controller: _menuController,
      useRootOverlay: style.overlayLocation != OverlayLocation.nearest,
      consumeOutsideTaps:
          style.outsideTapBehavior == OutsideTapBehavior.consume,
      childFocusNode: _anchorFocusNode,
      onOpenRequested: _openRequested,
      onCloseRequested: _closeRequested,
      onOpen: () {
        _registerPointerRoute();
        if (mounted) setState(() {});
        onMenuOpened();
      },
      onClose: () {
        _generation++;
        _pendingFinish = null;
        _transition.stop();
        if (!_opening) _transition.value = 0;
        _removePointerRoute();
        _hideOverlay = null;
        if (mounted) {
          setState(() {
            _closing = false;
          });
        }
        final List<VoidCallback> callbacks = List<VoidCallback>.of(_afterClose);
        _afterClose.clear();
        onMenuClosed();
        for (final VoidCallback callback in callbacks) {
          callback();
        }
      },
      overlayBuilder: (BuildContext context, RawMenuOverlayInfo info) {
        _setTapGroup(info.tapRegionGroupId);
        // RawMenuAnchor submenus inherit the root anchor's overlay.
        final OverlayLocation overlayLocation =
            _tapGroups[info.tapRegionGroupId]!.first.overlayLocation();
        final ({EdgeInsets padding, EdgeInsets viewInsets}) insets =
            overlayInsetsFor(
              context,
              overlaySize: info.overlaySize,
              overlayLocation: overlayLocation,
            );
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
              padding: insets.padding,
              viewInsets: insets.viewInsets,
              onSideResolved: (AxisDirection side) => _panelSide = side,
            ),
            child: IgnorePointer(
              ignoring: _closing,
              child: ExcludeSemantics(
                excluding: _closing,
                child: AnimatedBuilder(
                  animation: _transition,
                  builder: (BuildContext context, Widget? panel) =>
                      style.transitionBuilder?.call(
                        context,
                        _curvedTransition,
                        panel!,
                      ) ??
                      overlayTransition(
                        context,
                        _curvedTransition,
                        panel!,
                        alignment: switch (_panelSide) {
                          AxisDirection.down => Alignment.topCenter,
                          AxisDirection.up => Alignment.bottomCenter,
                          AxisDirection.right => Alignment.centerLeft,
                          AxisDirection.left => Alignment.centerRight,
                        },
                      ),
                  child: RepaintBoundary(
                    child: MenuPanel(
                      key: _panelKey,
                      info: info,
                      style: style,
                      focusScopeNode: _menuScope,
                      onClose: closeMenu,
                      semanticLabel: semanticLabel,
                      textField: textField,
                      onNavigate: onNavigate,
                      closing: _closing,
                      children: children,
                    ),
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
    _pendingFinish = null;
    _afterClose.clear();
    _ancestorPosition?.removeListener(_ancestorScrolled);
    _removePointerRoute();
    _curvedTransition.dispose();
    _transition.dispose();
    _menuScope.dispose();
    if (_ownsFocus) _anchorFocusNode.dispose();
    super.dispose();
  }
}
