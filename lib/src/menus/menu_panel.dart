import 'package:flutter/widgets.dart';

import '../foundation/interaction_detector.dart';
import '../overlay/overlay_behavior.dart';
import '../styles/menu_style.dart';

/// Scrolls an option within its menu without moving an enclosing page.
///
/// With [minimal], an option that is already visible stays put and one outside
/// the viewport scrolls only far enough to show it, as keyboard navigation
/// expects. Otherwise the option is aligned to the top of the viewport.
void ensureMenuItemVisible(GlobalKey key, {bool minimal = false}) {
  WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
    final BuildContext? context = key.currentContext;
    if (context == null || !context.mounted) return;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;
    final ScrollPosition? position = Scrollable.maybeOf(context)?.position;
    if (position == null) return;
    if (!minimal) {
      position.ensureVisible(renderObject);
      return;
    }
    scrollMenuItemIntoView(position, renderObject);
  });
  WidgetsBinding.instance.scheduleFrame();
}

/// Scrolls [position] only as far as needed to show [item].
void scrollMenuItemIntoView(ScrollPosition position, RenderObject item) {
  position.ensureVisible(
    item,
    alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
  );
  position.ensureVisible(
    item,
    alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
  );
}

/// Reports pointer movement over a menu row.
///
/// A pointer resting where a row appears, after the menu opens, scrolls or is
/// navigated by keyboard, is not reported, so only real movement moves the
/// active row.
class MenuRowHover extends StatelessWidget {
  /// Creates a movement listener around [child].
  const MenuRowHover({
    super.key,
    required this.onPointerMove,
    required this.child,
  });

  /// Called for each pointer movement over [child].
  final VoidCallback? onPointerMove;

  /// The row.
  final Widget child;

  @override
  Widget build(BuildContext context) => MouseRegion(
    opaque: false,
    onHover: onPointerMove == null
        ? null
        : (PointerEvent event) => onPointerMove!(),
    child: child,
  );
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
    this.closing = false,
    this.pointerIdle,
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

  /// Whether interaction is suspended while the panel finishes its exit.
  final bool closing;

  /// Whether the pointer has not moved since the panel opened or was last
  /// navigated by keyboard, which hides row hover so only one row looks active.
  final ValueNotifier<bool>? pointerIdle;

  Object? _move(int direction) {
    if (!closing) {
      pointerIdle?.value = true;
      onNavigate?.call(direction);
    }
    return null;
  }

  Widget _hoverScope(Widget content) {
    final ValueNotifier<bool>? idle = pointerIdle;
    if (idle == null) return content;
    return MouseRegion(
      opaque: false,
      onHover: (PointerEvent event) => idle.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: idle,
        builder: (BuildContext context, bool masked, Widget? child) =>
            InteractionBoundary(hoverMasked: masked, child: child!),
        child: content,
      ),
    );
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
        descendantsAreTraversable: !closing,
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
            child: _hoverScope(
              _MeasuredMenuContent(closing: closing, children: children),
            ),
          ),
        ),
      ),
    );
    if (textField) panel = TextFieldTapRegion(child: panel);
    return TapRegion(
      groupId: info.tapRegionGroupId,
      consumeOutsideTaps:
          style.outsideTapBehavior == OutsideTapBehavior.consume,
      onTapOutside: (PointerDownEvent event) => onClose(),
      child: panel,
    );
  }
}

// Bounded layout supports flexible rows and content that depends on constraints.
// One width measurement sizes all rows; transition ticks reuse the cached panel.
class _MeasuredMenuContent extends StatefulWidget {
  const _MeasuredMenuContent({required this.children, required this.closing});

  final List<Widget> children;
  final bool closing;

  @override
  State<_MeasuredMenuContent> createState() => _MeasuredMenuContentState();
}

class _MeasuredMenuContentState extends State<_MeasuredMenuContent> {
  final GlobalKey _contentKey = GlobalKey();
  // Keeps the scroll view and rows mounted when the width wrapper changes.
  final GlobalKey _scrollKey = GlobalKey();
  double? _width;
  BoxConstraints? _constraints;
  bool _measurementPending = false;
  bool _supportsIntrinsicWidth = true;
  // Whether rows lay out at their intrinsic width until the next measurement.
  bool _layoutIntrinsic = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _width = null;
  }

  @override
  void didUpdateWidget(_MeasuredMenuContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children &&
        !widget.closing &&
        !oldWidget.closing) {
      // Hover rebuilds the same rows with new state on every change. When
      // their intrinsic width has proven reliable, lay them out at it in this
      // frame so they never show unstretched before the next measurement.
      // New rows, as from filtering, are measured from scratch.
      _layoutIntrinsic =
          _supportsIntrinsicWidth &&
          _width != null &&
          _sameRows(oldWidget.children, widget.children);
      _width = null;
      _supportsIntrinsicWidth = true;
    }
  }

  static bool _sameRows(List<Widget> a, List<Widget> b) {
    if (a.length != b.length) return false;
    for (int index = 0; index < a.length; index++) {
      if (!Widget.canUpdate(a[index], b[index])) return false;
    }
    return true;
  }

  bool _hasLayoutDependentContent(Element root, RenderBox contentBox) {
    bool found = false;
    bool belongsToContent(RenderObject? object) {
      while (object != null) {
        if (identical(object, contentBox)) return true;
        object = object.parent;
      }
      return false;
    }

    void visit(Element element) {
      if (found) return;
      final Widget child = element.widget;
      if (child is LayoutBuilder ||
          child is SliverLayoutBuilder ||
          child is Scrollable ||
          child is Viewport ||
          child is ShrinkWrappingViewport ||
          child is CustomMultiChildLayout ||
          child is CustomSingleChildLayout) {
        // OverlayPortal children share element ancestry but paint outside the
        // measured content, so their layout policy does not affect this width.
        found = belongsToContent(element.findRenderObject());
        return;
      }
      element.visitChildren(visit);
    }

    visit(root);
    return found;
  }

  void _measure() {
    if (_measurementPending) return;
    _measurementPending = true;
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _measurementPending = false;
      if (!mounted) return;
      final BuildContext? content = _contentKey.currentContext;
      final RenderObject? object = content?.findRenderObject();
      if (object is RenderBox && object.hasSize && object.attached) {
        // These widgets return zero intrinsic dimensions in release builds.
        // Detect them before querying so bounded sizing works in every mode.
        if (_supportsIntrinsicWidth &&
            content is Element &&
            _hasLayoutDependentContent(content, object)) {
          _supportsIntrinsicWidth = false;
          // An intrinsic layout of such content is not a useful measurement;
          // lay it out unstretched and measure again.
          if (_layoutIntrinsic) {
            setState(() => _layoutIntrinsic = false);
            return;
          }
        }
        double measuredWidth = object.size.width;
        try {
          if (_supportsIntrinsicWidth) {
            measuredWidth = object.getMaxIntrinsicWidth(double.infinity);
          }
        } on FlutterError catch (error) {
          // LayoutBuilder and viewports determine their size during layout.
          // Their bounded layout is the useful width when no intrinsic size
          // can be requested.
          if (!error.toString().contains(
            'does not support returning intrinsic dimensions',
          )) {
            rethrow;
          }
          _supportsIntrinsicWidth = false;
        }
        final double width = measuredWidth.isFinite
            ? measuredWidth
            : object.size.width;
        if (width != _width || _layoutIntrinsic) {
          setState(() {
            _width = width;
            _layoutIntrinsic = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      if (_constraints != constraints) {
        _constraints = constraints;
        if (!_supportsIntrinsicWidth) _width = null;
      }
      if (_width == null) _measure();
      final Widget content = SingleChildScrollView(
        key: _scrollKey,
        primary: false,
        child: Column(
          key: _contentKey,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _width == null && !_layoutIntrinsic
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.stretch,
          children: widget.children,
        ),
      );
      if (_layoutIntrinsic) return IntrinsicWidth(child: content);
      return SizedBox(
        width: _width == null ? null : constraints.constrainWidth(_width!),
        child: content,
      );
    },
  );
}
