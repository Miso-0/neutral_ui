import 'package:flutter/widgets.dart';

import '../styles/menu_style.dart';

/// Scrolls an option within its menu without moving an enclosing page.
void ensureMenuItemVisible(GlobalKey key) {
  WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
    final BuildContext? context = key.currentContext;
    if (context == null || !context.mounted) return;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;
    Scrollable.maybeOf(context)?.position.ensureVisible(renderObject);
  });
  WidgetsBinding.instance.scheduleFrame();
}

/// A panel with menu-local navigation and scrolling.
class MenuPanel extends StatelessWidget {
  /// Creates a panel whose appearance comes entirely from [style].
  const MenuPanel({
    super.key,
    required this.info,
    required this.style,
    required this.focusScopeNode,
    required this.onClose,
    required this.children,
    this.semanticLabel,
    this.textField = false,
    this.onNavigate,
  });

  /// The anchor's overlay geometry and tap region.
  final RawMenuOverlayInfo info;

  /// Optional visual tokens.
  final MenuStyle style;

  /// The menu's private focus scope.
  final FocusScopeNode focusScopeNode;

  /// Dismisses this panel.
  final VoidCallback onClose;

  /// The complete, non-lazy option list.
  final List<Widget> children;

  /// The accessible panel label.
  final String? semanticLabel;

  /// Whether the panel participates in the field's tap region.
  final bool textField;

  /// Moves to the next or previous enabled option.
  final ValueChanged<int>? onNavigate;

  Object? _move(int direction) {
    onNavigate?.call(direction);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget panel = Actions(
      actions: <Type, Action<Intent>>{
        DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: (DirectionalFocusIntent intent) {
            if (intent.direction == TraversalDirection.up) return _move(-1);
            if (intent.direction == TraversalDirection.down) return _move(1);
            return null;
          },
        ),
        ScrollIntent: CallbackAction<ScrollIntent>(
          onInvoke: (ScrollIntent intent) {
            if (intent.direction == AxisDirection.up) return _move(-1);
            if (intent.direction == AxisDirection.down) return _move(1);
            return null;
          },
        ),
        NextFocusIntent: CallbackAction<NextFocusIntent>(
          onInvoke: (NextFocusIntent intent) => _move(1),
        ),
        PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: (PreviousFocusIntent intent) => _move(-1),
        ),
      },
      child: FocusScope(
        node: focusScopeNode,
        child: Semantics(
          scopesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: Container(
            decoration: style.decoration,
            padding: style.padding,
            clipBehavior: style.decoration == null
                ? Clip.none
                : style.clipBehavior ?? Clip.none,
            child: IntrinsicWidth(
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (textField) panel = TextFieldTapRegion(child: panel);
    return TapRegion(
      groupId: info.tapRegionGroupId,
      onTapOutside: (PointerDownEvent event) => onClose(),
      child: panel,
    );
  }
}
