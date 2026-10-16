import 'package:flutter/widgets.dart';

import '../buttons/selection_button.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../localizations/pure_localizations.dart';
import '../styles/tab_bar_style.dart';
import '../theme/navigation_themes.dart';

/// Coordinates a tab strip and its swipable pages.
class TabController extends ChangeNotifier {
  /// Creates tab controller.
  TabController({
    int initialIndex = 0,
    Duration? animationDuration,
    required this.length,
    required TickerProvider vsync,
  }) : assert(length >= 0),
       assert(initialIndex >= 0 && (length == 0 || initialIndex < length)),
       _index = initialIndex,
       _previousIndex = initialIndex,
       animationDuration =
           animationDuration ?? const Duration(milliseconds: 300),
       _controller = AnimationController.unbounded(
         value: initialIndex.toDouble(),
         vsync: vsync,
       ) {
    _controller.addListener(notifyListeners);
  }

  /// The number of coordinated tabs.
  final int length;

  /// The animation duration for this component.
  final Duration animationDuration;
  final AnimationController _controller;
  bool _disableAnimations = false;
  int _index;
  int _previousIndex;
  int _generation = 0;
  bool _changing = false;

  /// The continuous tab position, including page drags.
  Animation<double> get animation => _controller.view;

  /// The selected tab index.
  int get index => _index;

  /// The selected tab index.
  set index(int value) {
    assert(value >= 0 && (value < length || length == 0));
    _generation++;
    _changing = false;
    _previousIndex = _index;
    _index = value;
    _controller.value = value.toDouble();
    notifyListeners();
  }

  /// The previously selected tab index.
  int get previousIndex => _previousIndex;

  /// Whether a requested tab transition is still settling.
  bool get indexIsChanging => _changing;

  /// The current page displacement from the selected index.
  double get offset => _controller.value - _index;

  /// The current page displacement from the selected index.
  set offset(double value) {
    assert(value >= -1 && value <= 1);
    assert(!indexIsChanging);
    _controller.value = _index + value;
  }

  /// Animates to the requested index from the current position and velocity.
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    assert(value >= 0 && value < length);
    if (length < 2 ||
        (_index == value &&
            !_controller.isAnimating &&
            (_controller.value - value).abs() < 0.000001)) {
      return;
    }
    _previousIndex = _index;
    _index = value;
    final Duration effective = _disableAnimations
        ? Duration.zero
        : (duration ?? animationDuration);
    final int generation = ++_generation;
    if (effective == Duration.zero) {
      _changing = false;
      _controller.value = value.toDouble();
      notifyListeners();
      return;
    }
    _changing = true;
    notifyListeners();
    // A spring preserves the position and velocity during rapid retargeting.
    _controller
        .animateWith(
          ScrollSpringSimulation(
            SpringDescription.withDurationAndBounce(duration: effective),
            _controller.value,
            value.toDouble(),
            _controller.velocity,
          ),
        )
        .whenCompleteOrCancel(() {
          if (generation != _generation) return;
          _changing = false;
          notifyListeners();
        });
  }

  void _beginDrag() {
    _generation++;
    _controller.stop();
    _changing = false;
  }

  void _setPage(double value) {
    if (length == 0) return;
    final double position = value.clamp(0.0, (length - 1).toDouble());
    final int next = position.round();
    if (next != _index) {
      _previousIndex = _index;
      _index = next;
    }
    _controller.value = position;
  }

  @override
  void dispose() {
    _generation++;
    _controller.removeListener(notifyListeners);
    _controller.dispose();
    super.dispose();
  }
}

/// Supplies a tab controller to descendant tab strips and views.
class DefaultTabController extends StatefulWidget {
  /// Creates default tab controller.
  const DefaultTabController({
    super.key,
    required this.length,
    this.initialIndex = 0,
    this.animationDuration,
    required this.child,
  }) : assert(length >= 0);

  /// The number of coordinated tabs.
  final int length;

  /// The initial index for this component.
  final int initialIndex;

  /// The animation duration for this component.
  final Duration? animationDuration;

  /// The child for this component.
  final Widget child;

  /// Returns the nearest controller when present.
  static TabController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TabScope>()?.notifier;

  /// Returns the nearest controller, asserting when none is present.
  static TabController of(BuildContext context) {
    final TabController? controller = maybeOf(context);
    assert(controller != null, 'No DefaultTabController ancestor was found.');
    return controller!;
  }

  @override
  State<DefaultTabController> createState() => _DefaultTabControllerState();
}

class _DefaultTabControllerState extends State<DefaultTabController>
    with TickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.length,
      initialIndex: widget.initialIndex,
      animationDuration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(DefaultTabController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length ||
        oldWidget.animationDuration != widget.animationDuration) {
      final int index = widget.length == 0
          ? 0
          : _controller.index.clamp(0, widget.length - 1);
      _controller.dispose();
      _controller = TabController(
        length: widget.length,
        initialIndex: index,
        animationDuration: widget.animationDuration,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller._disableAnimations = MediaQuery.disableAnimationsOf(context);
    return _TabScope(notifier: _controller, child: widget.child);
  }
}

class _TabScope extends InheritedNotifier<TabController> {
  const _TabScope({required super.notifier, required super.child});
}

/// An icon and/or text label in a tab strip.
class Tab extends StatelessWidget implements PreferredSizeWidget {
  /// Creates tab.
  const Tab({
    super.key,
    this.text,
    this.icon,
    this.iconMargin,
    this.height,
    this.child,
  }) : assert(text == null || child == null);

  /// The text for this component.
  final String? text;

  /// The icon for this component.
  final Widget? icon;

  /// The icon margin for this component.
  final EdgeInsetsGeometry? iconMargin;

  /// The height for this component.
  final double? height;

  /// The child for this component.
  final Widget? child;
  @override
  Size get preferredSize => Size.fromHeight(
    height ?? (icon != null && (text != null || child != null) ? 72 : 48),
  );
  @override
  Widget build(BuildContext context) => SizedBox(
    height: preferredSize.height,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null)
            Padding(padding: iconMargin ?? EdgeInsets.zero, child: icon!),
          if (text != null) Text(text!),
          ?child,
        ],
      ),
    ),
  );
}

/// A selectable tab strip with a continuously positioned indicator.
class TabBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates tab bar.
  const TabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
    this.style,
    this.physics,
  });

  /// The tabs for this component.
  final List<Widget> tabs;

  /// The controller for this component.
  final TabController? controller;

  /// The is scrollable for this component.
  final bool isScrollable;

  /// The on tap for this component.
  final ValueChanged<int>? onTap;

  /// The style for this component.
  final TabBarStyle? style;

  /// The physics for this component.
  final ScrollPhysics? physics;
  @override
  Size get preferredSize => Size.fromHeight(
    tabs.fold<double>(
      48,
      (double height, Widget tab) =>
          tab is PreferredSizeWidget && tab.preferredSize.height > height
          ? tab.preferredSize.height
          : height,
    ),
  );
  @override
  State<TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  final ScrollController _scroll = ScrollController();
  final GlobalKey _stack = GlobalKey();
  final List<GlobalKey> _keys = <GlobalKey>[];
  final List<FocusNode> _nodes = <FocusNode>[];
  TabController? _controller;
  int? _scrolledIndex;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }

  @override
  void didUpdateWidget(TabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateController();
  }

  void _updateController() {
    final TabController next =
        widget.controller ?? DefaultTabController.of(context);
    assert(
      next.length == widget.tabs.length,
      'TabController length must match tabs.',
    );
    if (_controller != next) {
      _controller?.removeListener(_changed);
      _controller = next;
      next.addListener(_changed);
    }
    next._disableAnimations = MediaQuery.disableAnimationsOf(context);
    while (_keys.length < widget.tabs.length) {
      _keys.add(GlobalKey());
      _nodes.add(FocusNode());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
        _scrollSelected();
      }
    });
  }

  void _changed() {
    if (mounted) {
      setState(() {});
      _scrollSelected();
    }
  }

  void _scrollSelected() {
    if (!widget.isScrollable || _scrolledIndex == _controller!.index) return;
    final BuildContext? target = _keys[_controller!.index].currentContext;
    if (target == null) return;
    _scrolledIndex = _controller!.index;
    Scrollable.ensureVisible(
      target,
      alignment: 0.5,
      duration: reducedMotionDuration(
        context,
        widget.style?.animationDuration ?? _controller!.animationDuration,
      ),
      curve: widget.style?.animationCurve ?? Curves.easeOutCubic,
    );
  }

  Rect? _rect(int index) {
    final RenderObject? object = _keys[index].currentContext
        ?.findRenderObject();
    final RenderObject? parent = _stack.currentContext?.findRenderObject();
    if (object is! RenderBox ||
        parent is! RenderBox ||
        !object.hasSize ||
        !parent.hasSize) {
      return null;
    }
    return object.localToGlobal(Offset.zero, ancestor: parent) & object.size;
  }

  @override
  void dispose() {
    _controller?.removeListener(_changed);
    _scroll.dispose();
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  Object? _move(TraversalDirection direction) {
    if (direction != TraversalDirection.left &&
        direction != TraversalDirection.right) {
      return null;
    }
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final int step = (direction == TraversalDirection.right) != rtl ? 1 : -1;
    final int focused = _nodes.indexWhere((FocusNode node) => node.hasFocus);
    final int next =
        ((focused < 0 ? _controller!.index : focused) + step) %
        widget.tabs.length;
    _nodes[next].requestFocus();
    _controller!.animateTo(next);
    widget.onTap?.call(next);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final TabBarStyle effective =
        widget.style?.merge(TabBarTheme.of(context)) ?? TabBarTheme.of(context);
    if (widget.tabs.isEmpty) return const SizedBox.shrink();
    final TabController controller = _controller!;
    final double position = controller.animation.value.clamp(
      0.0,
      (widget.tabs.length - 1).toDouble(),
    );
    final int from = position.floor(), to = position.ceil();
    final Rect? a = _rect(from), b = _rect(to);
    final Rect? indicator = a == null || b == null
        ? null
        : Rect.lerp(a, b, position - from);
    final Decoration? decoration =
        resolveStatefulOrDefault<TabBarStyle, Decoration>(
          const InteractionState(isSelected: true),
          <TabBarStyle?>[widget.style, TabBarTheme.of(context)],
          (TabBarStyle style) => style.indicatorDecoration,
          () => BoxDecoration(color: IconTheme.of(context).color),
        );
    Widget content = Stack(
      key: _stack,
      clipBehavior: Clip.none,
      children: <Widget>[
        if (indicator != null)
          Positioned.fromRect(
            rect: (effective.indicatorPadding ?? EdgeInsets.zero)
                .resolve(Directionality.of(context))
                .deflateRect(indicator),
            child: IgnorePointer(
              child:
                  effective.indicatorBuilder?.call(context, position) ??
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: effective.indicatorWeight ?? 2,
                      decoration: decoration,
                    ),
                  ),
            ),
          ),
        Row(
          mainAxisSize: widget.isScrollable
              ? MainAxisSize.min
              : MainAxisSize.max,
          spacing: effective.spacing ?? 0,
          children: <Widget>[
            for (int i = 0; i < widget.tabs.length; i++)
              if (widget.isScrollable)
                _button(i, effective)
              else
                Expanded(child: _button(i, effective)),
          ],
        ),
      ],
    );
    if (widget.isScrollable) {
      content = SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        physics: widget.physics,
        child: content,
      );
    }
    return Padding(
      padding: effective.padding ?? EdgeInsets.zero,
      child: FocusTraversalGroup(
        child: Actions(
          actions: <Type, Action<Intent>>{
            DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
              onInvoke: (DirectionalFocusIntent intent) =>
                  _move(intent.direction),
            ),
          },
          child: content,
        ),
      ),
    );
  }

  Widget _button(int index, TabBarStyle style) => Semantics(
    label: PureLocalizations.of(context)
        .tabLabel(tabIndex: index + 1, tabCount: widget.tabs.length),
    child: SelectionButton(
      key: _keys[index],
      isSelected: _controller!.index == index,
      focusNode: _nodes[index],
      style: style.tabStyle,
      onPressed: () {
        _nodes[index].requestFocus();
        _controller!.animateTo(index);
        widget.onTap?.call(index);
      },
      child: Padding(
        padding: style.labelPadding ?? EdgeInsets.zero,
        child: widget.tabs[index],
      ),
    ),
  );
}

/// Pages synchronized with a [TabController], including finger tracking.
class TabBarView extends StatefulWidget {
  /// Creates tab bar view.
  const TabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
    this.viewportFraction = 1,
    this.clipBehavior = Clip.hardEdge,
  });

  /// The children for this component.
  final List<Widget> children;

  /// The controller for this component.
  final TabController? controller;

  /// The physics for this component.
  final ScrollPhysics? physics;

  /// The viewport fraction for this component.
  final double viewportFraction;

  /// The clip behavior for this component.
  final Clip clipBehavior;
  @override
  State<TabBarView> createState() => _TabBarViewState();
}

class _TabBarViewState extends State<TabBarView> {
  TabController? _controller;
  PageController? _pages;
  bool _dragging = false;
  bool _syncing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }

  @override
  void didUpdateWidget(TabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewportFraction != widget.viewportFraction) {
      _pages?.dispose();
      _pages = null;
    }
    _updateController();
  }

  void _updateController() {
    final TabController next =
        widget.controller ?? DefaultTabController.of(context);
    assert(
      next.length == widget.children.length,
      'TabController length must match pages.',
    );
    if (next != _controller) {
      _controller?.removeListener(_changed);
      _controller = next;
      next.addListener(_changed);
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) _changed();
      });
    }
    next._disableAnimations = MediaQuery.disableAnimationsOf(context);
    _pages ??= PageController(
      initialPage: next.index,
      viewportFraction: widget.viewportFraction,
    );
  }

  void _changed() {
    if (_dragging ||
        _syncing ||
        !_pages!.hasClients ||
        !_pages!.position.hasViewportDimension) {
      return;
    }
    final double target =
        _controller!.animation.value *
        _pages!.position.viewportDimension *
        widget.viewportFraction;
    if ((_pages!.position.pixels - target).abs() < 0.01) return;
    _syncing = true;
    _pages!.jumpTo(target);
    _syncing = false;
  }

  @override
  void dispose() {
    _controller?.removeListener(_changed);
    _pages?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.depth != 0 || _syncing) return false;
          if (notification is ScrollStartNotification &&
              notification.dragDetails != null) {
            _dragging = true;
            _controller!._beginDrag();
          }
          if (_dragging && notification.metrics is PageMetrics) {
            _syncing = true;
            _controller!._setPage(
              (notification.metrics as PageMetrics).page ?? 0,
            );
            _syncing = false;
          }
          if (notification is ScrollEndNotification) _dragging = false;
          return false;
        },
        child: PageView(
          controller: _pages,
          physics: widget.physics,
          clipBehavior: widget.clipBehavior,
          children: widget.children,
        ),
      );
}
