import 'package:flutter/widgets.dart';

import '../foundation/decoration_override.dart';
import '../foundation/interaction_state.dart';
import '../foundation/style_resolution.dart';
import '../styles/button_style.dart';
import '../styles/menu_style.dart';
import '../styles/popup_menu_style.dart';
import '../theme/menu_themes.dart';
import 'menu_host.dart';
import 'menu_item_button.dart';
import 'menu_panel.dart';
import 'selection_indicator.dart';

/// Builds the entries each time a popup opens.
typedef PopupMenuItemBuilder<T> = List<PopupMenuEntry<T>> Function(
  BuildContext context,
);

/// Reports a selected non-null action value.
typedef PopupMenuItemSelected<T> = void Function(T value);

/// Reports a menu dismissed without choosing an action.
typedef PopupMenuCanceled = void Function();

/// An entry in a headless popup menu.
///
/// Unlike Material, entries need no fixed height: content and tokens size them.
abstract class PopupMenuEntry<T> extends StatefulWidget {
  /// Creates an entry.
  const PopupMenuEntry({super.key});

  /// Whether this entry corresponds to [value].
  bool represents(T? value);
}

/// An action row whose appearance comes from popup menu tokens.
class PopupMenuItem<T> extends PopupMenuEntry<T> {
  /// Creates a popup action.
  const PopupMenuItem({
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.style,
    this.decoration,
    required this.child,
  });

  /// The value reported when chosen; null runs only [onTap].
  final T? value;

  /// Called after closing the menu and before the button's selection callback.
  final VoidCallback? onTap;

  /// Whether this action can be chosen.
  final bool enabled;

  /// Optional content before the label.
  final Widget? leading;

  /// Optional content after the label.
  final Widget? trailing;

  /// Tokens overriding the menu's item styles.
  final ButtonStyle? style;

  /// The row decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.decoration` on this widget's inline style.
  final BoxDecoration? decoration;

  /// The action label or custom content.
  final Widget? child;
  @override
  bool represents(T? value) => value == this.value;
  @override
  State<PopupMenuItem<T>> createState() => _PopupMenuItemState<T>();
}

/// An action with a controlled checked state and a themed check indicator.
class CheckedPopupMenuItem<T> extends PopupMenuItem<T> {
  /// Creates a checked popup action; choosing it does not mutate [checked].
  const CheckedPopupMenuItem({
    super.key,
    super.value,
    this.checked = false,
    super.onTap,
    super.enabled,
    super.style,
    super.decoration,
    super.child,
  });

  /// Whether the action is checked.
  final bool checked;
}

class _PopupMenuItemState<T> extends State<PopupMenuItem<T>> {
  final WidgetStatesController _states = WidgetStatesController();
  bool _updateScheduled = false;

  @override
  void initState() {
    super.initState();
    _states.addListener(_interactionChanged);
  }

  void _interactionChanged() {
    if (_updateScheduled) return;
    _updateScheduled = true;
    // The detector synchronizes its state while building. Resolve the optional
    // slot after that synchronization so a null indicator adds no spacing.
    Future<void>.microtask(() {
      _updateScheduled = false;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: widget is CheckedPopupMenuItem<T>
            ? 'CheckedPopupMenuItem'
            : 'PopupMenuItem',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    final _PopupEntryScope? scope = context
        .dependOnInheritedWidgetOfExactType<_PopupEntryScope>();
    final PopupMenuStyle theme = PopupMenuTheme.of(context);
    final CheckedPopupMenuItem<T>? checked = widget is CheckedPopupMenuItem<T>
        ? widget as CheckedPopupMenuItem<T>
        : null;
    Widget? leading = widget.leading;
    if (checked != null) {
      leading = resolveStatefulOrDefault<PopupMenuStyle, Widget>(
        InteractionState.fromWidgetStates(_states.value)
            .copyWith(isSelected: checked.checked, isDisabled: !widget.enabled),
        <PopupMenuStyle?>[scope?.style, theme],
        (PopupMenuStyle style) => style.checkIndicator,
        () => defaultSelectionIndicator(selected: checked.checked),
      );
    }
    return MenuItemButton(
      style: layeredButtonStyle(<ButtonStyle?>[
        ButtonStyle(decoration: decorationLayer(widget.decoration)),
        widget.style,
        scope?.style?.itemStyle,
        theme.itemStyle,
      ]),
      focusNode: scope?.focusNode,
      statesController: _states,
      isSelected: scope?.selected,
      isChecked: checked?.checked,
      leading: leading,
      trailing: widget.trailing,
      onPressed: widget.enabled
          ? () => scope?.choose(widget.value, widget.onTap)
          : null,
      child: widget.child,
    );
  }
}

/// A separator whose dimensions and decoration are entirely theme supplied.
class PopupMenuDivider extends PopupMenuEntry<Never> {
  /// Creates a separator.
  const PopupMenuDivider({super.key});
  @override
  bool represents(Object? value) => false;
  @override
  State<PopupMenuDivider> createState() => _PopupMenuDividerState();
}

class _PopupMenuDividerState extends State<PopupMenuDivider> {
  @override
  Widget build(BuildContext context) {
    final _PopupEntryScope? scope = context
        .dependOnInheritedWidgetOfExactType<_PopupEntryScope>();
    final PopupMenuStyle theme = PopupMenuTheme.of(context);
    return ExcludeSemantics(
      child: Container(
        height: scope?.style?.dividerHeight ?? theme.dividerHeight ?? 0,
        decoration: scope?.style?.dividerDecoration ?? theme.dividerDecoration,
      ),
    );
  }
}

class _PopupEntryScope extends InheritedWidget {
  const _PopupEntryScope({
    super.key,
    required this.style,
    required this.focusNode,
    required this.selected,
    required this.choose,
    required super.child,
  });
  final PopupMenuStyle? style;
  final FocusNode? focusNode;
  final bool selected;
  final void Function(Object?, VoidCallback?) choose;
  @override
  bool updateShouldNotify(_PopupEntryScope oldWidget) => true;
}

/// An unpainted trigger for an overlay action menu, requiring an Overlay.
class PopupMenuButton<T> extends StatefulWidget {
  /// Creates a popup menu whose entries are rebuilt on each open.
  const PopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.enabled = true,
    this.offset,
    this.position,
    this.child,
    this.icon,
    this.requestFocus = true,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.menuDecoration,
  }) : assert(child == null || icon == null);

  /// Builds the actions when the trigger is activated.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The action initially selected and focused.
  final T? initialValue;

  /// Called before showing a non-empty menu.
  final VoidCallback? onOpened;

  /// Called with a chosen non-null value after the item's callback.
  final PopupMenuItemSelected<T>? onSelected;

  /// Called when the menu is dismissed without a choice.
  final PopupMenuCanceled? onCanceled;

  /// The trigger's accessible tooltip.
  final String? tooltip;

  /// Whether the trigger and programmatic opening are enabled.
  final bool enabled;

  /// Overrides the menu style's displacement.
  final Offset? offset;

  /// Overrides the preferred vertical placement.
  final PopupMenuPosition? position;

  /// Custom trigger content.
  final Widget? child;

  /// A compact trigger with a default 48 by 48 hit target.
  final Widget? icon;

  /// Whether opening should focus an enabled action.
  final bool requestFocus;

  /// The accessible label of the menu panel.
  final String? semanticLabel;

  /// Inline tokens overriding the component theme.
  final PopupMenuStyle? style;

  /// The trigger decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.buttonStyle.decoration` on this widget's inline style.
  final BoxDecoration? decoration;

  /// The menu panel decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.menuStyle.decoration` on this widget's inline style.
  final BoxDecoration? menuDecoration;

  @override
  PopupMenuButtonState<T> createState() => PopupMenuButtonState<T>();
}

/// The state exposing Material's programmatic popup opening API.
class PopupMenuButtonState<T> extends State<PopupMenuButton<T>>
    with TickerProviderStateMixin, MenuHost<PopupMenuButton<T>> {
  List<PopupMenuEntry<T>> _entries = <PopupMenuEntry<T>>[];
  final List<FocusNode> _nodes = <FocusNode>[];
  final List<GlobalKey> _keys = <GlobalKey>[];
  bool _choosing = false;

  @override
  void initState() {
    super.initState();
    initMenuHost();
  }

  @override
  void didUpdateWidget(PopupMenuButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && menuOpen) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted) closeMenu();
      });
    }
  }

  bool _enabled(int index) {
    final PopupMenuEntry<T> entry = _entries[index];
    return entry is PopupMenuItem<T>
        ? entry.enabled
        : entry is! PopupMenuDivider;
  }

  /// Builds and shows the menu when enabled; empty menus do nothing.
  void showButtonMenu() {
    if (!widget.enabled || menuOpen) return;
    final List<PopupMenuEntry<T>> entries = widget.itemBuilder(context);
    if (entries.isEmpty) return;
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    _nodes.clear();
    _keys.clear();
    _entries = entries;
    for (int i = 0; i < entries.length; i++) {
      _nodes.add(FocusNode(debugLabel: 'Popup option $i'));
      _keys.add(GlobalKey());
    }
    _choosing = false;
    widget.onOpened?.call();
    if (mounted) {
      setState(() {});
      openMenu();
    }
  }

  @override
  void onMenuOpened() {
    if (!widget.requestFocus) return;
    int index = _entries.indexWhere(
      (PopupMenuEntry<T> entry) =>
          widget.initialValue != null && entry.represents(widget.initialValue),
    );
    if (index < 0 || !_enabled(index)) {
      index = _entries.indexWhere(
        (PopupMenuEntry<T> entry) => entry is PopupMenuItem<T>
            ? entry.enabled
            : entry is! PopupMenuDivider,
      );
    }
    if (index >= 0) _focus(index);
  }

  void _focus(int index) {
    void focus() {
      if (mounted && menuOpen && index < _nodes.length) {
        _nodes[index].requestFocus();
      }
    }

    if (_keys[index].currentContext != null) {
      focus();
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) => focus(),
      );
    }
    ensureMenuItemVisible(_keys[index]);
  }

  void _navigate(int direction) {
    if (!menuOpen || _entries.isEmpty) return;
    int current = _nodes.indexWhere((FocusNode node) => node.hasFocus);
    if (current < 0) current = direction > 0 ? -1 : 0;
    for (int step = 1; step <= _entries.length; step++) {
      final int index = (current + direction * step) % _entries.length;
      if (_enabled(index)) {
        _focus(index);
        return;
      }
    }
  }

  void _choose(Object? value, VoidCallback? onTap) {
    if (_choosing) return;
    _choosing = true;
    final PopupMenuItemSelected<T>? onSelected = widget.onSelected;
    closeMenuThen(() {
      onTap?.call();
      if (value != null) onSelected?.call(value as T);
    });
  }

  @override
  void onMenuCloseRequested() {
    if (!_choosing) widget.onCanceled?.call();
  }

  @override
  void dispose() {
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'PopupMenuButton',
        parameter: 'decoration',
        styleToken: 'style.buttonStyle.decoration',
        value: widget.decoration,
        styleValue: widget.style?.buttonStyle?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'PopupMenuButton',
        parameter: 'menuDecoration',
        styleToken: 'style.menuStyle.decoration',
        value: widget.menuDecoration,
        styleValue: widget.style?.menuStyle?.decoration,
      ),
    );
    final PopupMenuStyle theme = PopupMenuTheme.of(context);
    final MenuStyle panelStyle =
        (widget.style?.menuStyle?.merge(theme.menuStyle) ??
                theme.menuStyle ??
                const MenuStyle())
            .copyWith(decoration: widget.menuDecoration);
    return buildMenuHost(
      style: panelStyle,
      matchAnchorWidth: false,
      position:
          widget.position ??
          widget.style?.position ??
          theme.position ??
          PopupMenuPosition.over,
      offset: widget.offset,
      semanticLabel: widget.semanticLabel,
      onNavigate: _navigate,
      child: MenuItemButton(
        decoration: widget.decoration,
        style: widget.style?.buttonStyle,
        themeStyle: theme.buttonStyle,
        focusNode: anchorFocusNode,
        isExpanded: menuOpen,
        tooltip: widget.tooltip,
        defaultTapTarget: widget.icon == null ? null : const Size(48, 48),
        onPressed: widget.enabled
            ? (menuOpen ? closeMenu : showButtonMenu)
            : null,
        child: widget.child ?? widget.icon,
      ),
      children: <Widget>[
        for (int index = 0; index < _entries.length; index++)
          _PopupEntryScope(
            key: _keys[index],
            style: widget.style,
            focusNode: _nodes[index],
            selected:
                widget.initialValue != null &&
                _entries[index].represents(widget.initialValue),
            choose: _choose,
            child:
                _entries[index] is PopupMenuItem<T> ||
                    _entries[index] is PopupMenuDivider
                ? _entries[index]
                : Focus(focusNode: _nodes[index], child: _entries[index]),
          ),
      ],
    );
  }
}
