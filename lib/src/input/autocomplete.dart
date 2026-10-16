import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../menus/menu_item_button.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_host.dart';
import '../overlay/overlay_placement.dart';
import '../styles/autocomplete_style.dart';
import '../styles/menu_style.dart';
import '../theme/input_themes.dart';
import 'text_field.dart';

/// A styled RawAutocomplete with an independently animated options overlay.
class Autocomplete<T extends Object> extends StatefulWidget {
  /// Creates an autocomplete field with synchronous or asynchronous options.
  const Autocomplete({
    super.key,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.onSelected,
    this.optionsViewBuilder,
    this.optionsViewOpenDirection,
    this.initialValue,
    this.focusNode,
    this.textEditingController,
    this.style,
    this.decoration,
  });

  /// Builds the matching options, synchronously or asynchronously.
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// Converts an option to field text.
  final AutocompleteOptionToString<T> displayStringForOption;

  /// Overrides the default PureUI text field.
  final AutocompleteFieldViewBuilder? fieldViewBuilder;

  /// Reports selection after the options exit finishes.
  final AutocompleteOnSelected<T>? onSelected;

  /// Overrides the default options panel.
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  /// The preferred vertical direction for options.
  final OptionsViewOpenDirection? optionsViewOpenDirection;

  /// Initial text and selection when no text controller is supplied.
  final TextEditingValue? initialValue;

  /// An externally owned editable focus node.
  final FocusNode? focusNode;

  /// An externally owned editable text controller.
  final TextEditingController? textEditingController;

  /// Inline field and options appearance tokens.
  final AutocompleteStyle? style;

  /// An unconditional field decoration.
  final BoxDecoration? decoration;

  @override
  State<Autocomplete<T>> createState() => _AutocompleteState<T>();
}

class _AutocompleteState<T extends Object> extends State<Autocomplete<T>>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: Duration.zero,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _motion,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  late TextEditingController _text;
  late FocusNode _focus;
  List<T> _options = <T>[];
  int _highlighted = 0;
  final ValueNotifier<int> _highlight = ValueNotifier<int>(0);
  Object? _bridge;
  bool _active = true;
  int _query = 0;
  int _closingQuery = 0;
  String _lastText = '';
  int _generation = 0;
  bool _closing = false;
  AutocompleteOnSelected<T>? _select;
  final List<VoidCallback> _afterClose = <VoidCallback>[];

  AutocompleteStyle get _tokens =>
      widget.style?.merge(AutocompleteTheme.of(context)) ??
      AutocompleteTheme.of(context);

  @override
  void initState() {
    super.initState();
    _text =
        widget.textEditingController ??
        TextEditingController.fromValue(widget.initialValue);
    _focus = widget.focusNode ?? FocusNode(debugLabel: 'PureUI autocomplete');
    _lastText = _text.text;
    _text.addListener(_textChanged);
  }

  void _textChanged() {
    if (_lastText != _text.text) {
      _lastText = _text.text;
      _query++;
    }
  }

  @override
  void didUpdateWidget(Autocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textEditingController != widget.textEditingController) {
      final TextEditingValue value = _text.value;
      _text.removeListener(_textChanged);
      if (oldWidget.textEditingController == null) _text.dispose();
      _text =
          widget.textEditingController ??
          TextEditingController.fromValue(value);
      _lastText = _text.text;
      _query++;
      _text.addListener(_textChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) _focus.dispose();
      _focus = widget.focusNode ?? FocusNode(debugLabel: 'PureUI autocomplete');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _active =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    if (!_active && _portal.isShowing) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
        if (mounted && !_active) _close(immediate: true);
      });
    }
  }

  void _show(
    Object bridge,
    List<T> options,
    int highlighted,
    AutocompleteOnSelected<T> select,
  ) {
    if (!mounted || !_active) return;
    _bridge = bridge;
    if (_closing && _query == _closingQuery) return;
    if (_closing) _afterClose.clear();
    final bool unchanged =
        _options.length == options.length &&
        List<int>.generate(
          options.length,
          (int i) => i,
        ).every((int i) => _options[i] == options[i]) &&
        _highlighted == highlighted;
    _select = select;
    if (_portal.isShowing && !_closing && unchanged) return;
    final MenuStyle menu = _tokens.menuStyle ?? const MenuStyle();
    setState(() {
      _options = options;
      _highlighted = highlighted;
      _highlight.value = highlighted;
      _select = select;
      _closing = false;
    });
    _generation++;
    _motion.duration = reducedMotionDuration(
      context,
      menu.transitionDuration ?? const Duration(milliseconds: 150),
    );
    _motion.reverseDuration = reducedMotionDuration(
      context,
      menu.reverseTransitionDuration ?? const Duration(milliseconds: 100),
    );
    _curve.curve = menu.transitionCurve ?? Curves.easeOutCubic;
    _curve.reverseCurve = menu.reverseTransitionCurve ?? Curves.easeInCubic;
    _portal.show();
    _motion.forward();
  }

  void _close({VoidCallback? after, bool immediate = false}) {
    if (!_portal.isShowing) {
      after?.call();
      return;
    }
    if (after != null) _afterClose.add(after);
    if (_closing) return;
    _closingQuery = _query;
    setState(() => _closing = true);
    final int generation = ++_generation;
    void finish() {
      if (!mounted || generation != _generation) return;
      _portal.hide();
      _closing = false;
      final List<VoidCallback> callbacks = List<VoidCallback>.of(_afterClose);
      _afterClose.clear();
      for (final VoidCallback callback in callbacks) {
        callback();
      }
    }

    if (immediate ||
        !TickerMode.valuesOf(context).enabled ||
        MediaQuery.disableAnimationsOf(context)) {
      _motion.value = 0;
      finish();
    } else {
      _motion.reverse().whenCompleteOrCancel(finish);
    }
  }

  void _rawHidden(Object bridge) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (mounted && identical(_bridge, bridge)) _close();
    });
  }

  void _pointerSelected(T option) {
    if (_closing) return;
    final AutocompleteOnSelected<T>? select = _select;
    _close(after: () => select?.call(option));
  }

  void _selected(T option) {
    _close(after: () => widget.onSelected?.call(option));
  }

  @override
  Widget build(BuildContext context) {
    final AutocompleteStyle tokens = _tokens;
    final MenuStyle menu = tokens.menuStyle ?? const MenuStyle();
    final bool up =
        (widget.optionsViewOpenDirection ?? tokens.optionsViewOpenDirection) ==
        OptionsViewOpenDirection.up;
    return OverlayHost(
      controller: _portal,
      overlayLocation: menu.overlayLocation ?? OverlayLocation.root,
      outsideTapBehavior:
          menu.outsideTapBehavior ?? OutsideTapBehavior.passThrough,
      placement:
          menu.placement ??
          OverlayPlacement(
            preferredSide: up ? AxisDirection.up : AxisDirection.down,
            anchorWidth: OverlayAnchorWidth.min,
            margin: menu.edgePadding ?? EdgeInsets.zero,
            gap: menu.offset?.dy ?? 0,
            crossOffset: menu.offset?.dx ?? 0,
            constraints: BoxConstraints(
              maxHeight:
                  tokens.optionsMaxHeight ?? menu.maximumSize?.height ?? 200,
              maxWidth: menu.maximumSize?.width ?? double.infinity,
            ),
          ),
      onTapOutside: (_) => _close(),
      overlayBuilder: (BuildContext context) {
        final Widget panel = AutocompleteHighlightedOption(
          highlightIndexNotifier: _highlight,
          child: Builder(
            builder: (BuildContext context) =>
                widget.optionsViewBuilder?.call(
                  context,
                  _pointerSelected,
                  _options,
                ) ??
                _AutocompletePanel<T>(
                  options: _options,
                  select: _pointerSelected,
                  display: widget.displayStringForOption,
                  tokens: tokens,
                  menu: menu,
                  highlighted: _highlighted,
                ),
          ),
        );
        return IgnorePointer(
          ignoring: _closing,
          child: AnimatedBuilder(
            animation: _curve,
            child: RepaintBoundary(child: TextFieldTapRegion(child: panel)),
            builder: (BuildContext context, Widget? child) =>
                menu.transitionBuilder?.call(context, _curve, child!) ??
                overlayTransition(
                  context,
                  _curve,
                  child!,
                  alignment: up ? Alignment.bottomCenter : Alignment.topCenter,
                ),
          ),
        );
      },
      child: RawAutocomplete<T>(
        optionsBuilder: widget.optionsBuilder,
        displayStringForOption: widget.displayStringForOption,
        focusNode: _focus,
        textEditingController: _text,
        onSelected: _selected,
        optionsViewOpenDirection: up
            ? OptionsViewOpenDirection.up
            : OptionsViewOpenDirection.down,
        fieldViewBuilder:
            widget.fieldViewBuilder ??
            (
              BuildContext context,
              TextEditingController text,
              FocusNode node,
              VoidCallback submit,
            ) => TextField(
              controller: text,
              focusNode: node,
              style: tokens.fieldStyle,
              decoration: widget.decoration,
              onSubmitted: (String text) => submit(),
            ),
        optionsViewBuilder:
            (
              BuildContext context,
              AutocompleteOnSelected<T> select,
              Iterable<T> options,
            ) => _OptionsBridge<T>(
              owner: this,
              options: options.toList(),
              select: select,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _generation++;
    _text.removeListener(_textChanged);
    _afterClose.clear();
    _highlight.dispose();
    _curve.dispose();
    _motion.dispose();
    if (widget.focusNode == null) _focus.dispose();
    if (widget.textEditingController == null) _text.dispose();
    super.dispose();
  }
}

class _OptionsBridge<T extends Object> extends StatefulWidget {
  const _OptionsBridge({
    required this.owner,
    required this.options,
    required this.select,
  });
  final _AutocompleteState<T> owner;
  final List<T> options;
  final AutocompleteOnSelected<T> select;
  @override
  State<_OptionsBridge<T>> createState() => _OptionsBridgeState<T>();
}

class _OptionsBridgeState<T extends Object> extends State<_OptionsBridge<T>> {
  int _generation = 0;
  @override
  Widget build(BuildContext context) {
    final int highlighted = AutocompleteHighlightedOption.of(context);
    final int generation = ++_generation;
    WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (mounted && generation == _generation) {
        widget.owner._show(this, widget.options, highlighted, widget.select);
      }
    });
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    widget.owner._rawHidden(this);
    super.dispose();
  }
}

class _AutocompletePanel<T extends Object> extends StatefulWidget {
  const _AutocompletePanel({
    required this.options,
    required this.select,
    required this.display,
    required this.tokens,
    required this.menu,
    required this.highlighted,
  });
  final List<T> options;
  final AutocompleteOnSelected<T> select;
  final AutocompleteOptionToString<T> display;
  final AutocompleteStyle tokens;
  final MenuStyle menu;
  final int highlighted;
  @override
  State<_AutocompletePanel<T>> createState() => _AutocompletePanelState<T>();
}

class _AutocompletePanelState<T extends Object>
    extends State<_AutocompletePanel<T>> {
  final ScrollController _scroll = ScrollController();
  final Map<int, GlobalKey> _keys = <int, GlobalKey>{};
  @override
  void didUpdateWidget(_AutocompletePanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlighted != widget.highlighted) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
        final BuildContext? item = _keys[widget.highlighted]?.currentContext;
        final RenderObject? object = item?.findRenderObject();
        if (mounted && object != null && _scroll.hasClients) {
          _scroll.position.ensureVisible(object);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: widget.menu.decoration,
    padding: widget.menu.padding,
    child: SingleChildScrollView(
      controller: _scroll,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < widget.options.length; i++)
            MenuItemButton(
              key: _keys.putIfAbsent(i, GlobalKey.new),
              onPressed: () => widget.select(widget.options[i]),
              isFocused: widget.highlighted == i,
              style: widget.tokens.itemStyle,
              child: Text(widget.display(widget.options[i])),
            ),
        ],
      ),
    ),
  );
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}
