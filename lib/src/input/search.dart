import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/motion.dart';
import '../localizations/pure_localizations.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_host.dart';
import '../overlay/overlay_placement.dart';
import '../styles/search_style.dart';
import '../styles/button_style.dart';
import '../theme/input_themes.dart';
import '../theme/button_themes.dart';
import '../menus/key_activators.dart';
import 'text_field.dart';

/// Builds search suggestions, returning an Iterable of widgets or its Future.
typedef SearchSuggestionsBuilder = Object Function(
  BuildContext context,
  SearchController controller,
);

/// Builds a search anchor that opens the controller's suggestion view.
typedef SearchAnchorBuilder = Widget Function(
  BuildContext context,
  SearchController controller,
);

/// A text controller that also controls its attached search view.
class SearchController extends TextEditingController {
  /// Creates a search controller with optional initial text.
  SearchController({super.text});
  _SearchAnchorState? _anchor;

  /// Whether an anchor currently owns this controller.
  bool get isAttached => _anchor != null;

  /// Whether the attached suggestion view is visible.
  bool get isOpen => _anchor?._open ?? false;

  /// Opens the attached suggestion view.
  void openView() {
    assert(isAttached, 'SearchController must be attached to a SearchAnchor.');
    _anchor?._show();
  }

  /// Closes the attached view, optionally replacing the query.
  void closeView(String? selectedText) {
    if (selectedText != null) {
      value = TextEditingValue(
        text: selectedText,
        selection: TextSelection.collapsed(offset: selectedText.length),
      );
    }
    _anchor?._close();
  }
}

/// A styled editable search bar with leading and trailing content.
class SearchBar extends StatelessWidget {
  /// Creates a search bar.
  const SearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autoFocus = false,
    this.style,
    this.decoration,
  });

  /// The bar's text controller.
  final TextEditingController? controller;

  /// The bar's editable focus node.
  final FocusNode? focusNode;

  /// The empty query prompt.
  final String? hintText;

  /// The leading icon or content.
  final Widget? leading;

  /// The trailing actions.
  final Iterable<Widget>? trailing;

  /// Reports taps on the bar.
  final VoidCallback? onTap;

  /// Reports user changes to the query.
  final ValueChanged<String>? onChanged;

  /// Reports keyboard submission.
  final ValueChanged<String>? onSubmitted;

  /// Whether the bar accepts interaction.
  final bool enabled;

  /// Whether the bar requests initial focus.
  final bool autoFocus;

  /// Inline search appearance tokens.
  final SearchStyle? style;

  /// An unconditional bar decoration.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final SearchStyle tokens =
        style?.merge(SearchTheme.of(context)) ?? SearchTheme.of(context);
    return ConstrainedBox(
      constraints: tokens.constraints ?? const BoxConstraints(),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        hintText: hintText ?? PureLocalizations.of(context).searchFieldLabel,
        prefixIcon: leading ?? const SearchGlyph(),
        suffix: trailing == null
            ? null
            : Row(mainAxisSize: MainAxisSize.min, children: trailing!.toList()),
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        autofocus: autoFocus,
        style: tokens.fieldStyle,
        decoration: decoration,
      ),
    );
  }
}

/// Opens docked or full-screen search suggestions from a customizable anchor.
class SearchAnchor extends StatefulWidget {
  /// Creates a search view controlled by a custom anchor builder.
  const SearchAnchor({
    super.key,
    required this.builder,
    required this.suggestionsBuilder,
    this.searchController,
    this.isFullScreen = false,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.viewOnClose,
    this.viewOnOpen,
    this.viewBuilder,
    this.style,
    this.decoration,
  }) : barLeading = null,
       barTrailing = null,
       barHintText = null,
       barOnTap = null,
       barOnChanged = null,
       barOnSubmitted = null,
       barAutoFocus = false,
       barEnabled = true;

  /// Creates an anchor with a ready-to-use SearchBar.
  const SearchAnchor.bar({
    super.key,
    required this.suggestionsBuilder,
    this.searchController,
    this.isFullScreen = false,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.viewOnClose,
    this.viewOnOpen,
    this.viewBuilder,
    this.style,
    this.decoration,
    this.barLeading,
    this.barTrailing,
    this.barHintText,
    this.barOnTap,
    this.barOnChanged,
    this.barOnSubmitted,
    this.barAutoFocus = false,
    this.barEnabled = true,
  }) : builder = null;

  /// Builds the anchor and receives its attached controller.
  final SearchAnchorBuilder? builder;

  /// Builds synchronous or asynchronous suggestion widgets.
  final SearchSuggestionsBuilder suggestionsBuilder;

  /// An externally owned search controller.
  final SearchController? searchController;

  /// Whether suggestions expand into a route.
  final bool isFullScreen;

  /// The search view leading action.
  final Widget? viewLeading;

  /// The search view trailing actions.
  final Iterable<Widget>? viewTrailing;

  /// The search view empty query hint.
  final String? viewHintText;

  /// Reports user edits in the search view.
  final ValueChanged<String>? viewOnChanged;

  /// Reports search view submission.
  final ValueChanged<String>? viewOnSubmitted;

  /// Reports completion of the closing transition.
  final VoidCallback? viewOnClose;

  /// Reports opening of the search view.
  final VoidCallback? viewOnOpen;

  /// Overrides layout of the resolved suggestions.
  final Widget Function(Iterable<Widget>)? viewBuilder;

  /// Inline search appearance tokens.
  final SearchStyle? style;

  /// An unconditional search view decoration.
  final BoxDecoration? decoration;

  /// The default bar leading slot.
  final Widget? barLeading;

  /// The default bar trailing actions.
  final Iterable<Widget>? barTrailing;

  /// The default bar hint.
  final String? barHintText;

  /// Reports taps on the default bar.
  final VoidCallback? barOnTap;

  /// Reports default bar query edits.
  final ValueChanged<String>? barOnChanged;

  /// Reports default bar submission.
  final ValueChanged<String>? barOnSubmitted;

  /// Whether the default bar requests initial focus.
  final bool barAutoFocus;

  /// Whether the default bar is enabled.
  final bool barEnabled;

  @override
  State<SearchAnchor> createState() => _SearchAnchorState();
}

class _SearchAnchorState extends State<SearchAnchor>
    with SingleTickerProviderStateMixin {
  late SearchController _controller;
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: Duration.zero,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _motion,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  final OverlayPortalController _portal = OverlayPortalController();
  final FocusScopeNode _scope = FocusScopeNode(
    debugLabel: 'PureUI search',
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );
  final FocusNode _viewFocus = FocusNode(debugLabel: 'PureUI search field');
  final GlobalKey _anchorKey = GlobalKey();
  FocusNode? _previousFocus;
  _SearchViewRoute? _route;
  List<Widget> _suggestions = <Widget>[];
  bool _open = false;
  bool _closing = false;
  bool _active = true;
  int _request = 0;
  int _generation = 0;
  String _lastQuery = '';

  SearchStyle get _style =>
      widget.style?.merge(SearchTheme.of(context)) ?? SearchTheme.of(context);

  @override
  void initState() {
    super.initState();
    _attach(widget.searchController ?? SearchController());
  }

  void _attach(SearchController controller) {
    assert(
      controller._anchor == null || controller._anchor == this,
      'A SearchController can only be attached to one anchor.',
    );
    _controller = controller;
    _lastQuery = controller.text;
    controller._anchor = this;
    controller.addListener(_queryChanged);
  }

  @override
  void didUpdateWidget(SearchAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchController != oldWidget.searchController) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
        if (mounted) _close(immediate: true);
      });
      _controller.removeListener(_queryChanged);
      _controller._anchor = null;
      if (oldWidget.searchController == null) _controller.dispose();
      _attach(widget.searchController ?? SearchController());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _active =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    if (!_active && _open && _route == null) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
        if (mounted && !_active) _close(immediate: true);
      });
    }
  }

  void _queryChanged() {
    if (_lastQuery == _controller.text) return;
    _lastQuery = _controller.text;
    if (_open && !_closing) _load();
  }

  Future<void> _load() async {
    final int request = ++_request;
    final Object result = widget.suggestionsBuilder(context, _controller);
    final Iterable<Widget> values;
    if (result is Future<Iterable<Widget>>) {
      values = await result;
    } else {
      values = result as Iterable<Widget>;
    }
    if (!mounted || !_open || request != _request) return;
    setState(() => _suggestions = values.toList());
    _route?.changedContent();
  }

  void _show() {
    if (_open && _closing && _route != null) {
      _generation++;
      setState(() => _closing = false);
      _route!.reopen();
      widget.viewOnOpen?.call();
      _load();
      return;
    }
    if (!_active || (_open && !_closing)) return;
    final SearchStyle style = _style;
    if (!_open) _previousFocus = FocusManager.instance.primaryFocus;
    _generation++;
    setState(() {
      _open = true;
      _closing = false;
    });
    widget.viewOnOpen?.call();
    _load();
    if (widget.isFullScreen) {
      final RenderBox anchor =
          _anchorKey.currentContext!.findRenderObject()! as RenderBox;
      final Rect rect = anchor.localToGlobal(Offset.zero) & anchor.size;
      final _SearchViewRoute route = _SearchViewRoute(
        origin: rect,
        owner: this,
        style: style,
        duration: reducedMotionDuration(
          context,
          style.transitionDuration ?? const Duration(milliseconds: 200),
        ),
        reverseDuration: reducedMotionDuration(
          context,
          style.reverseTransitionDuration ?? const Duration(milliseconds: 200),
        ),
        dismissLabel: PureLocalizations.of(context).modalBarrierDismissLabel,
      );
      _route = route;
      Navigator.of(context, rootNavigator: true).push<void>(route);
      route.completed.then((_) {
        if (!mounted || _route != route) return;
        _route = null;
        _finished();
      });
    } else {
      _motion.duration = reducedMotionDuration(
        context,
        style.transitionDuration ?? const Duration(milliseconds: 150),
      );
      _motion.reverseDuration = reducedMotionDuration(
        context,
        style.reverseTransitionDuration ?? const Duration(milliseconds: 100),
      );
      _curve.curve = style.transitionCurve ?? Curves.easeOutCubic;
      _curve.reverseCurve = style.reverseTransitionCurve ?? Curves.easeInCubic;
      _portal.show();
      _motion.forward();
      WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
        if (mounted && _open && !_closing) _viewFocus.requestFocus();
      });
    }
  }

  void _close({bool immediate = false}) {
    if (!_open || _closing) return;
    _request++;
    setState(() => _closing = true);
    final int generation = ++_generation;
    final _SearchViewRoute? route = _route;
    if (route != null) {
      if (!route.isCurrent) {
        route.navigator?.removeRoute(route);
        return;
      }
      route.close(
        immediate: immediate || MediaQuery.disableAnimationsOf(context),
        onDismissed: () {
          if (!mounted || generation != _generation || !_closing) return;
          route.completePop();
        },
      );
      return;
    }
    void finish() {
      if (!mounted || generation != _generation) return;
      _portal.hide();
      _finished();
    }

    if (immediate || !_active || MediaQuery.disableAnimationsOf(context)) {
      _motion.value = 0;
      finish();
    } else {
      _motion.reverse().whenCompleteOrCancel(finish);
    }
  }

  void _finished() {
    if (!mounted) return;
    final bool restore = _scope.hasFocus || _viewFocus.hasFocus;
    setState(() {
      _open = false;
      _closing = false;
    });
    if (restore && (_previousFocus?.canRequestFocus ?? false)) {
      _previousFocus!.requestFocus();
    }
    widget.viewOnClose?.call();
  }

  Widget _view(BuildContext context) {
    final SearchStyle style = _style;
    final PureLocalizations strings = PureLocalizations.of(context);
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        menuKeyActivator(0x10000001b): const DismissIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              _close();
              return null;
            },
          ),
        },
        child: FocusScope(
          node: _scope,
          child: Semantics(
            namesRoute: true,
            label: strings.searchFieldLabel,
            child: Container(
              decoration:
                  widget.decoration ??
                  style.viewDecoration ??
                  style.menuStyle?.decoration,
              padding: style.viewPadding ?? style.menuStyle?.padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SearchBar(
                    controller: _controller,
                    focusNode: _viewFocus,
                    autoFocus: true,
                    leading:
                        widget.viewLeading ??
                        IconButton(
                          onPressed: () => _controller.closeView(null),
                          tooltip: strings.backButtonTooltip,
                          icon: const ArrowGlyph(
                            direction: GlyphDirection.start,
                          ),
                        ),
                    trailing: widget.viewTrailing,
                    hintText: widget.viewHintText,
                    onChanged: widget.viewOnChanged,
                    onSubmitted: widget.viewOnSubmitted,
                    style: style,
                  ),
                  Flexible(
                    child:
                        widget.viewBuilder?.call(_suggestions) ??
                        TextButtonTheme(
                          data: style.suggestionStyle ?? const ButtonStyle(),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: _suggestions,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'SearchAnchor',
        parameter: 'decoration',
        styleToken: 'style.viewDecoration',
        value: widget.decoration,
        styleValue: widget.style?.viewDecoration,
      ),
    );
    final SearchStyle style = _style;
    final Widget anchor = KeyedSubtree(
      key: _anchorKey,
      child:
          widget.builder?.call(context, _controller) ??
          SearchBar(
            controller: _controller,
            style: style,
            leading: widget.barLeading,
            trailing: widget.barTrailing,
            hintText: widget.barHintText,
            autoFocus: widget.barAutoFocus,
            enabled: widget.barEnabled,
            onTap: () {
              widget.barOnTap?.call();
              _show();
            },
            onChanged: widget.barOnChanged,
            onSubmitted: widget.barOnSubmitted,
          ),
    );
    return OverlayHost(
      controller: _portal,
      overlayLocation: style.menuStyle?.overlayLocation ?? OverlayLocation.root,
      placement:
          style.menuStyle?.placement ??
          OverlayPlacement(
            anchorWidth: OverlayAnchorWidth.exact,
            overflow: OverlayOverflow.shift,
            gap: style.menuStyle?.offset?.dy ?? 0,
            crossOffset: style.menuStyle?.offset?.dx ?? 0,
            margin: style.menuStyle?.edgePadding ?? EdgeInsets.zero,
            constraints: BoxConstraints(
              maxHeight: style.menuStyle?.maximumSize?.height ?? 400,
              maxWidth: style.menuStyle?.maximumSize?.width ?? double.infinity,
            ),
          ),
      outsideTapBehavior:
          style.outsideTapBehavior ??
          style.menuStyle?.outsideTapBehavior ??
          OutsideTapBehavior.passThrough,
      onTapOutside: (_) => _close(),
      overlayBuilder: (BuildContext context) => IgnorePointer(
        ignoring: _closing,
        child: AnimatedBuilder(
          animation: _curve,
          child: RepaintBoundary(child: _view(context)),
          builder: (BuildContext context, Widget? child) =>
              style.transitionBuilder?.call(context, _curve, child!) ??
              overlayTransition(context, _curve, child!),
        ),
      ),
      child: anchor,
    );
  }

  @override
  void dispose() {
    _generation++;
    _request++;
    final _SearchViewRoute? route = _route;
    _route = null;
    if (route != null) {
      route.detachOwner();
      WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
        if (route.isActive) route.navigator?.removeRoute(route);
      });
    }
    _controller.removeListener(_queryChanged);
    _controller._anchor = null;
    if (widget.searchController == null) _controller.dispose();
    _curve.dispose();
    _motion.dispose();
    _scope.dispose();
    _viewFocus.dispose();
    super.dispose();
  }
}

class _SearchViewRoute extends PopupRoute<void> {
  _SearchViewRoute({
    required this.origin,
    required this.owner,
    required this.style,
    required this.duration,
    required this.reverseDuration,
    required this.dismissLabel,
  });
  final Rect origin;
  _SearchAnchorState? owner;
  final String dismissLabel;
  CurvedAnimation? _curve;
  bool _allowPop = false;

  @override
  void install() {
    super.install();
    _curve = CurvedAnimation(
      parent: animation!,
      curve: style.transitionCurve ?? Curves.easeOutCubic,
      reverseCurve: style.reverseTransitionCurve ?? Curves.easeInCubic,
    );
  }

  void reopen() => controller?.forward();

  void close({required bool immediate, required VoidCallback onDismissed}) {
    if (immediate) {
      controller?.value = 0;
      onDismissed();
    } else {
      controller!.reverse().whenCompleteOrCancel(onDismissed);
    }
  }

  void completePop() {
    _allowPop = true;
    navigator?.pop();
  }

  void detachOwner() {
    owner = null;
    _allowPop = true;
  }

  @override
  bool didPop(void result) {
    if (!_allowPop && owner != null) {
      owner!._close();
      return false;
    }
    return super.didPop(result);
  }

  @override
  void dispose() {
    _curve?.dispose();
    super.dispose();
  }

  final SearchStyle style;
  final Duration duration;
  final Duration reverseDuration;
  @override
  Duration get transitionDuration => duration;
  @override
  Duration get reverseTransitionDuration => reverseDuration;
  @override
  bool get barrierDismissible => true;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => dismissLabel;
  void changedContent() => changedInternalState();
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final _SearchAnchorState? current = owner;
      if (current == null || !current.mounted) return const SizedBox.shrink();
      final Rect target = Offset.zero & constraints.biggest;
      return Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _curve!,
            child: RepaintBoundary(
              child: SafeArea(child: current._view(context)),
            ),
            builder: (BuildContext context, Widget? child) {
              return Positioned.fromRect(
                rect: Rect.lerp(origin, target, _curve!.value)!,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: AlignmentDirectional.topStart,
                    minWidth: target.width,
                    maxWidth: target.width,
                    minHeight: target.height,
                    maxHeight: target.height,
                    child: child!,
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => style.transitionBuilder?.call(context, _curve!, child) ?? child;
}
