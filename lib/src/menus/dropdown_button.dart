import 'package:flutter/widgets.dart';

import '../buttons/button_style_button.dart';
import '../foundation/decoration_override.dart';
import '../foundation/interaction_state.dart';
import '../foundation/style_resolution.dart';
import '../styles/button_style.dart';
import '../styles/dropdown_style.dart';
import '../styles/menu_style.dart';
import '../theme/menu_themes.dart';
import 'menu_host.dart';
import 'menu_item_button.dart';
import 'menu_panel.dart';

/// Builds the content displayed for each selected dropdown item.
typedef DropdownButtonBuilder = List<Widget> Function(BuildContext context);

/// An option in a [DropdownButton].
class DropdownMenuItem<T> extends StatelessWidget {
  /// Creates an option whose appearance comes from dropdown and item tokens.
  const DropdownMenuItem({
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.alignment = AlignmentDirectional.centerStart,
    this.style,
    this.decoration,
    required this.child,
  });

  /// The value passed to [DropdownButton.onChanged] when selected.
  final T? value;

  /// Called before the dropdown closes and reports this value.
  final VoidCallback? onTap;

  /// Whether this option can be selected or focused.
  final bool enabled;

  /// The alignment of [child] within the option.
  final AlignmentGeometry alignment;

  /// Tokens that take precedence over the dropdown's option style.
  final ButtonStyle? style;

  /// The row decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.decoration` on this widget's inline style.
  final BoxDecoration? decoration;

  /// The content of the option.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownMenuItem',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: decoration,
        styleValue: style?.decoration,
      ),
    );
    return Align(
      alignment: alignment,
      widthFactor: 1,
      heightFactor: 1,
      child: child,
    );
  }
}

/// A headless selection button that opens a menu beneath its anchor.
///
/// An [Overlay] ancestor is required. The trigger measures all its options so
/// changing the selection does not change its width.
class DropdownButton<T> extends StatefulWidget {
  /// Creates a dropdown using tokens from [DropdownButtonTheme].
  DropdownButton({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onTap,
    this.icon,
    this.isExpanded = false,
    this.menuMaxHeight,
    this.focusNode,
    this.autofocus = false,
    this.alignment = AlignmentDirectional.centerStart,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.menuDecoration,
  }) : assert(
         items == null ||
             items.isEmpty ||
             value == null ||
             items
                     .where((DropdownMenuItem<T> item) => item.value == value)
                     .length ==
                 1,
         'A non-null value must match exactly one dropdown item.',
       ),
       assert(menuMaxHeight == null || menuMaxHeight >= 0);

  /// The available options. Null or empty lists disable the button.
  final List<DropdownMenuItem<T>>? items;

  /// Builds alternative trigger content, with one widget per option.
  final DropdownButtonBuilder? selectedItemBuilder;

  /// The selected value.
  final T? value;

  /// Content displayed when there is no selected option.
  final Widget? hint;

  /// Content displayed while disabled without a selected option.
  final Widget? disabledHint;

  /// Called for every selection, including selecting the current value again.
  ///
  /// A null callback disables the button.
  final ValueChanged<T?>? onChanged;

  /// Called immediately before opening the menu.
  final VoidCallback? onTap;

  /// Overrides the style's trailing indicator.
  final Widget? icon;

  /// Whether the trigger content fills the available horizontal space.
  final bool isExpanded;

  /// Overrides the menu panel's maximum height.
  final double? menuMaxHeight;

  /// An externally owned focus node for the trigger.
  final FocusNode? focusNode;

  /// Whether the trigger requests focus when first mounted.
  final bool autofocus;

  /// The alignment of selected content within the trigger.
  final AlignmentGeometry alignment;

  /// An additional accessibility label for the trigger and menu.
  final String? semanticLabel;

  /// Tokens that take precedence over the component theme.
  final DropdownStyle? style;

  /// The trigger decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.buttonStyle.decoration` on this widget's inline style.
  final BoxDecoration? decoration;

  /// The menu panel decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.menuStyle.decoration` on this widget's inline style.
  final BoxDecoration? menuDecoration;

  @override
  State<DropdownButton<T>> createState() => _DropdownButtonState<T>();
}

class _DropdownButtonState<T> extends State<DropdownButton<T>>
    with TickerProviderStateMixin, MenuHost<DropdownButton<T>> {
  final WidgetStatesController _triggerStates = WidgetStatesController();
  final List<FocusNode> _itemFocusNodes = <FocusNode>[];
  final List<GlobalKey> _itemKeys = <GlobalKey>[];
  final List<WidgetStatesController> _itemStates = <WidgetStatesController>[];
  int? _focusedIndex;

  List<DropdownMenuItem<T>> get _items =>
      widget.items ?? <DropdownMenuItem<T>>[];

  bool get _enabled => _items.isNotEmpty && widget.onChanged != null;

  int? get _selectedIndex {
    final int index = _items.indexWhere(
      (DropdownMenuItem<T> item) =>
          item.value == widget.value && (widget.value != null || item.enabled),
    );
    return index < 0 ? null : index;
  }

  @override
  void initState() {
    super.initState();
    initMenuHost(focusNode: widget.focusNode);
    _syncItems();
  }

  @override
  void didUpdateWidget(DropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateMenuHost(focusNode: widget.focusNode);
    _syncItems();
    if (!_enabled && menuOpen) closeMenu();
  }

  void _syncItems() {
    while (_itemFocusNodes.length > _items.length) {
      _itemFocusNodes.removeLast().dispose();
      _itemStates.removeLast().dispose();
      _itemKeys.removeLast();
    }
    while (_itemFocusNodes.length < _items.length) {
      _itemFocusNodes.add(FocusNode(debugLabel: 'DropdownButton option'));
      _itemKeys.add(GlobalKey());
      _itemStates.add(WidgetStatesController());
    }
    if (_focusedIndex != null && _focusedIndex! >= _items.length) {
      _focusedIndex = null;
    }
  }

  void _open() {
    if (!_enabled || menuOpen) return;
    widget.onTap?.call();
    if (mounted) openMenu();
  }

  void _toggle() => menuOpen ? closeMenu() : _open();

  @override
  void onMenuOpened() {
    final int? selected = _selectedIndex;
    final int index = selected != null && _items[selected].enabled
        ? selected
        : _items.indexWhere((DropdownMenuItem<T> item) => item.enabled);
    if (index >= 0) _focusItem(index);
  }

  void _focusItem(int index) {
    _focusedIndex = index;
    void focus() {
      if (!mounted || !menuOpen || index >= _itemFocusNodes.length) return;
      _itemFocusNodes[index].requestFocus();
      ensureMenuItemVisible(_itemKeys[index]);
    }

    if (_itemKeys[index].currentContext != null) {
      focus();
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) => focus(),
      );
    }
    WidgetsBinding.instance.scheduleFrame();
  }

  void _navigate(int direction) {
    if (!menuOpen || _items.isEmpty) return;
    final int focused = _itemFocusNodes.indexWhere(
      (FocusNode node) => node.hasFocus,
    );
    int index = focused >= 0
        ? focused
        : _focusedIndex ?? (direction > 0 ? -1 : 0);
    for (int count = 0; count < _items.length; count++) {
      index = (index + direction) % _items.length;
      if (_items[index].enabled) {
        _focusItem(index);
        return;
      }
    }
  }

  void _select(int index) {
    final DropdownMenuItem<T> item = _items[index];
    if (!_enabled || !item.enabled) return;
    final ValueChanged<T?>? onChanged = widget.onChanged;
    item.onTap?.call();
    if (mounted) closeMenu();
    onChanged?.call(item.value);
  }

  @override
  void dispose() {
    _triggerStates.dispose();
    for (final FocusNode node in _itemFocusNodes) {
      node.dispose();
    }
    for (final WidgetStatesController controller in _itemStates) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _triggerContent(List<DropdownStyle?> layers) {
    final List<Widget> content =
        widget.selectedItemBuilder?.call(context) ??
        _items.map((DropdownMenuItem<T> item) => item.child).toList();
    assert(
      content.length == _items.length,
      'selectedItemBuilder must return one widget for each dropdown item.',
    );
    final Widget? hint = !_enabled
        ? widget.disabledHint ?? widget.hint
        : widget.hint;
    final int? selectedIndex = _selectedIndex;
    final int? index = selectedIndex ?? (hint == null ? null : content.length);
    final Widget stack = IndexedStack(
      index: index,
      alignment: widget.alignment,
      children: <Widget>[...content, ?hint],
    );
    final double spacing =
        resolvePlain<ButtonStyle, double>(
          layers.map((DropdownStyle? style) => style?.buttonStyle).toList(),
          (ButtonStyle style) => style.spacing,
        ) ??
        0;
    return ValueListenableBuilder<Set<WidgetState>>(
      valueListenable: _triggerStates,
      builder: (BuildContext context, Set<WidgetState> states, Widget? child) {
        final Widget? icon =
            widget.icon ??
            resolveStateful<DropdownStyle, Widget>(
              InteractionState.fromWidgetStates(states),
              layers,
              (DropdownStyle style) => style.icon,
            );
        return Row(
          mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
          children: <Widget>[
            if (widget.isExpanded)
              Expanded(child: stack)
            else
              Flexible(child: stack),
            if (icon != null) ...<Widget>[
              if (spacing != 0) SizedBox(width: spacing),
              icon,
            ],
          ],
        );
      },
    );
  }

  Widget _item(int index, List<DropdownStyle?> layers) {
    final DropdownMenuItem<T> item = _items[index];
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownMenuItem',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: item.decoration,
        styleValue: item.style?.decoration,
      ),
    );
    final List<ButtonStyle?> itemLayers = <ButtonStyle?>[
      ButtonStyle(decoration: decorationLayer(item.decoration)),
      item.style,
      ...layers.map((DropdownStyle? style) => style?.itemStyle),
    ];
    final double spacing =
        resolvePlain<ButtonStyle, double>(
          itemLayers,
          (ButtonStyle style) => style.spacing,
        ) ??
        0;
    return MenuItemButton(
      key: _itemKeys[index],
      onPressed: item.enabled ? () => _select(index) : null,
      focusNode: _itemFocusNodes[index],
      statesController: _itemStates[index],
      isSelected: index == _selectedIndex,
      style: layeredButtonStyle(itemLayers),
      child: ValueListenableBuilder<Set<WidgetState>>(
        valueListenable: _itemStates[index],
        builder:
            (BuildContext context, Set<WidgetState> states, Widget? child) {
              final Widget? indicator = resolveStateful<DropdownStyle, Widget>(
                InteractionState.fromWidgetStates(states),
                layers,
                (DropdownStyle style) => style.selectedIndicator,
              );
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (indicator != null) ...<Widget>[
                    indicator,
                    if (spacing != 0) SizedBox(width: spacing),
                  ],
                  Flexible(child: item),
                ],
              );
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownButton',
        parameter: 'decoration',
        styleToken: 'style.buttonStyle.decoration',
        value: widget.decoration,
        styleValue: widget.style?.buttonStyle?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownButton',
        parameter: 'menuDecoration',
        styleToken: 'style.menuStyle.decoration',
        value: widget.menuDecoration,
        styleValue: widget.style?.menuStyle?.decoration,
      ),
    );
    final DropdownStyle theme = DropdownButtonTheme.of(context);
    final List<DropdownStyle?> layers = <DropdownStyle?>[widget.style, theme];
    final MenuStyle menuStyle = (widget.style?.menuStyle ?? const MenuStyle())
        .merge(theme.menuStyle)
        .copyWith(decoration: widget.menuDecoration);
    return buildMenuHost(
      style: menuStyle,
      maxHeight: widget.menuMaxHeight,
      semanticLabel: widget.semanticLabel,
      onNavigate: _navigate,
      children: List<Widget>.generate(
        _items.length,
        (int index) => _item(index, layers),
      ),
      child: MergeSemantics(
        child: Semantics(
          label: widget.semanticLabel,
          child: _DropdownTrigger(
            onPressed: _enabled ? _toggle : null,
            isExpanded: menuOpen,
            focusNode: anchorFocusNode,
            autofocus: widget.autofocus,
            statesController: _triggerStates,
            decoration: widget.decoration,
            style: widget.style?.buttonStyle,
            themeStyle: theme.buttonStyle,
            child: _triggerContent(layers),
          ),
        ),
      ),
    );
  }
}

class _DropdownTrigger extends ButtonStyleButton {
  const _DropdownTrigger({
    required super.onPressed,
    required super.child,
    required this.isExpanded,
    required this.themeStyle,
    super.focusNode,
    super.autofocus,
    super.style,
    super.decoration,
    super.statesController,
  });

  final bool isExpanded;
  final ButtonStyle? themeStyle;

  @override
  bool get expanded => isExpanded;

  @override
  ButtonStyle? themeStyleOf(BuildContext context) => themeStyle;
}
