import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/style_resolution.dart';
import '../foundation/tap_target.dart';
import '../styles/button_style.dart';
import '../styles/dropdown_style.dart';
import '../styles/menu_style.dart';
import '../theme/menu_themes.dart';
import 'dropdown_icon.dart';
import 'key_activators.dart';
import 'menu_host.dart';
import 'menu_item_button.dart';
import 'menu_panel.dart';
import 'selection_indicator.dart';

/// Filters the available entries in response to an editable query.
typedef FilterCallback<T> = List<DropdownMenuEntry<T>> Function(
  List<DropdownMenuEntry<T>> entries,
  String filter,
);

/// Returns the index of the entry highlighted for a query, or no match.
typedef SearchCallback<T> = int? Function(
  List<DropdownMenuEntry<T>> entries,
  String query,
);

/// Builds matching dropdown entries for the current search query.
typedef DropdownSearchBuilder<T> = List<DropdownMenuEntry<T>> Function(
  BuildContext context,
  String query,
);

/// Builds a controlled multiple selection, for example as removable chips.
typedef DropdownSelectionBuilder<T> = Widget Function(
  BuildContext context,
  List<DropdownMenuEntry<T>> selectedEntries,
);

/// Whether selecting an entry closes its menu.
enum DropdownMenuCloseBehavior {
  /// Closes the menu after a selection.
  all,

  /// Closes this menu after a selection.
  self,

  /// Keeps the menu open after a selection.
  none,
}

/// An option in a [DropdownMenu].
@immutable
class DropdownMenuEntry<T> {
  /// Creates an option with a text [label], a [labelWidget], or both.
  const DropdownMenuEntry({
    required this.value,
    this.label,
    this.labelWidget,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style,
    this.decoration,
  }) : assert(
         label != null || labelWidget != null,
         'Provide a label or labelWidget.',
       );

  /// The value delivered when this option is selected.
  final T value;

  /// The text used for filtering, searching and the selected field value.
  ///
  /// May be null when [labelWidget] supplies the visual content.
  final String? label;

  /// Alternative visual content for the menu row.
  ///
  /// Also displays the selection when [label] is null or empty.
  final Widget? labelWidget;

  /// Content before the row label.
  final Widget? leadingIcon;

  /// Content after the row label.
  final Widget? trailingIcon;

  /// Whether this option can be selected or highlighted by the keyboard.
  final bool enabled;

  /// Row tokens that override the dropdown's item style.
  final ButtonStyle? style;

  /// The row decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.decoration` on this widget's inline style.
  final BoxDecoration? decoration;
}

/// An unpainted searchable selection field and its anchored option menu.
///
/// The single selection constructor manages its selected value internally.
/// [DropdownMenu.multiple] instead reads a controlled set on every build.
class DropdownMenu<T> extends StatefulWidget {
  /// Creates a single selection dropdown.
  const DropdownMenu({
    super.key,
    this.dropdownMenuEntries = const <Never>[],
    this.searchBuilder,
    this.initialSelection,
    this.onSelected,
    this.controller,
    this.focusNode,
    this.menuController,
    this.enabled = true,
    this.enableFilter = false,
    this.enableSearch = true,
    this.filterCallback,
    this.searchCallback,
    this.requestFocusOnTap,
    this.selectOnly = false,
    this.hintText,
    this.leadingIcon,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.width,
    this.menuHeight,
    this.expandedInsets,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.closeBehavior = DropdownMenuCloseBehavior.all,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.menuDecoration,
  }) : assert(filterCallback == null || enableFilter),
       assert(width == null || width >= 0),
       assert(menuHeight == null || menuHeight >= 0),
       selected = null,
       onSelectionChanged = null,
       emptySelectionAllowed = true,
       selectionBuilder = null,
       _multiple = false;

  /// Creates a dropdown whose selection is controlled by [selected].
  const DropdownMenu.multiple({
    super.key,
    this.dropdownMenuEntries = const <Never>[],
    this.searchBuilder,
    required Set<T> this.selected,
    required this.onSelectionChanged,
    this.emptySelectionAllowed = true,
    this.selectionBuilder,
    this.controller,
    this.focusNode,
    this.menuController,
    this.enabled = true,
    this.enableFilter = false,
    this.enableSearch = true,
    this.filterCallback,
    this.searchCallback,
    this.requestFocusOnTap,
    this.selectOnly = false,
    this.hintText,
    this.leadingIcon,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.width,
    this.menuHeight,
    this.expandedInsets,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.closeBehavior = DropdownMenuCloseBehavior.none,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.menuDecoration,
  }) : assert(filterCallback == null || enableFilter),
       assert(width == null || width >= 0),
       assert(menuHeight == null || menuHeight >= 0),
       initialSelection = null,
       onSelected = null,
       _multiple = true;

  /// All available options, including disabled options.
  ///
  /// Optional when [searchBuilder] supplies the options. Entries here can also
  /// describe selections that are absent from the current search results.
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  /// Builds the options to display for the search text.
  ///
  /// Called with an empty query when opening the menu and after a multiple
  /// selection. Its results replace [filterCallback] and the built-in label
  /// filtering and matching, regardless of [enableFilter]. When [enableSearch]
  /// is true, typing highlights an enabled result for keyboard selection.
  /// [searchCallback] can override the highlighted result.
  ///
  /// Without a builder, [dropdownMenuEntries] and the label-based callbacks apply.
  final DropdownSearchBuilder<T>? searchBuilder;

  /// The initial single selection; changing this value updates the field.
  final T? initialSelection;

  /// Receives the selected single value, or null when Enter has no match.
  final ValueChanged<T?>? onSelected;

  /// The externally owned field text controller.
  final TextEditingController? controller;

  /// The externally owned field or trigger focus node.
  final FocusNode? focusNode;

  /// The externally owned menu controller.
  final MenuController? menuController;

  /// Whether the field and its options accept interaction.
  final bool enabled;

  /// Whether typing filters the visible entries.
  final bool enableFilter;

  /// Whether typing highlights a matching entry.
  final bool enableSearch;

  /// Replaces the default case-insensitive substring filter.
  final FilterCallback<T>? filterCallback;

  /// Replaces the default case-insensitive substring search.
  final SearchCallback<T>? searchCallback;

  /// Overrides the platform's default editable-field mode.
  final bool? requestFocusOnTap;

  /// Uses a button trigger even on platforms that support an editable field.
  final bool selectOnly;

  /// Text shown when the field has no text or selected summary.
  final String? hintText;

  /// Content before the field text.
  final Widget? leadingIcon;

  /// The trailing indicator, drawn in its closed orientation.
  ///
  /// Defaults to a painted [ChevronGlyph] in the field's icon theme. It turns
  /// by [DropdownStyle.iconTurns] (a half turn by default) while the menu is
  /// open, so a single downward arrow flips to point up. Use
  /// [showTrailingIcon] to omit it.
  final Widget? trailingIcon;

  /// Whether the trailing slot is included.
  final bool showTrailingIcon;

  /// Overrides the width measured from the widest entry label.
  final double? width;

  /// The maximum menu height.
  final double? menuHeight;

  /// Fills the parent's width inside these insets when [width] is absent.
  final EdgeInsetsGeometry? expandedInsets;

  /// The keyboard configuration used by an editable field.
  final TextInputType? keyboardType;

  /// The alignment of the field text.
  final TextAlign textAlign;

  /// Whether choosing an option closes this menu.
  final DropdownMenuCloseBehavior closeBehavior;

  /// The accessible field and menu label.
  final String? semanticLabel;

  /// Per-instance tokens, overriding [DropdownMenuTheme].
  final DropdownStyle? style;

  /// The field decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.buttonStyle.decoration` on this widget's inline style.
  final BoxDecoration? decoration;

  /// The menu panel decoration, replacing style and theme decorations in every state.
  ///
  /// Must not be combined with `style.menuStyle.decoration` on this widget's inline style.
  final BoxDecoration? menuDecoration;

  /// The controlled multiple selection, or null for a single selection field.
  final Set<T>? selected;

  /// Receives a new set after toggling an option.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// Whether the last selected value may be removed.
  final bool emptySelectionAllowed;

  /// Content shown in the leading area for the current multiple selection.
  final DropdownSelectionBuilder<T>? selectionBuilder;

  final bool _multiple;

  @override
  State<DropdownMenu<T>> createState() => _DropdownMenuState<T>();
}

class _HighlightIntent extends Intent {
  const _HighlightIntent(this.delta);

  final int delta;
}

class _SubmitDropdownIntent extends Intent {
  const _SubmitDropdownIntent();
}

class _DropdownMenuState<T> extends State<DropdownMenu<T>>
    with TickerProviderStateMixin, MenuHost<DropdownMenu<T>> {
  late TextEditingController _textController;
  late T? _selectedValue;
  final Map<DropdownMenuEntry<T>, GlobalKey> _entryKeys =
      <DropdownMenuEntry<T>, GlobalKey>{};
  final Map<DropdownMenuEntry<T>, WidgetStatesController> _entryStates =
      <DropdownMenuEntry<T>, WidgetStatesController>{};
  final WidgetStatesController _fieldStates = WidgetStatesController();
  final GlobalKey _editableTapKey = GlobalKey();
  bool _stateUpdateScheduled = false;
  DropdownMenuEntry<T>? _highlighted;
  bool _filterActive = false;
  bool _searchActive = false;
  String _query = '';
  List<DropdownMenuEntry<T>> _searchEntries = <DropdownMenuEntry<T>>[];
  Map<T, DropdownMenuEntry<T>> _retainedEntries = <T, DropdownMenuEntry<T>>{};
  bool _entriesInitialized = false;

  @override
  void initState() {
    super.initState();
    initMenuHost(
      controller: widget.menuController,
      focusNode: widget.focusNode,
    );
    _textController = widget.controller ?? TextEditingController();
    _textController.addListener(_textChanged);
    _fieldStates.addListener(_interactionChanged);
    anchorFocusNode.addListener(_focusChanged);
    _selectedValue = widget.initialSelection;
    if (!widget._multiple && _selectedEntry != null) {
      _writeText(_selectedEntry!.label ?? '');
    }
    _query = _textController.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshSearchEntries();
    if (!_entriesInitialized && !widget._multiple && _selectedEntry != null) {
      _writeText(_selectedEntry!.label ?? '');
    }
    _entriesInitialized = true;
    if (_searchActive) _search();
  }

  @override
  void didUpdateWidget(DropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    anchorFocusNode.removeListener(_focusChanged);
    updateMenuHost(
      controller: widget.menuController,
      focusNode: widget.focusNode,
    );
    anchorFocusNode.addListener(_focusChanged);
    if (oldWidget.controller != widget.controller) {
      final String text = _textController.text;
      _textController.removeListener(_textChanged);
      if (oldWidget.controller == null) _textController.dispose();
      _textController = widget.controller ?? TextEditingController(text: text);
      _textController.addListener(_textChanged);
    }
    final bool selectionChanged =
        oldWidget.initialSelection != widget.initialSelection ||
        oldWidget._multiple != widget._multiple;
    if (selectionChanged) {
      _selectedValue = widget.initialSelection;
    }
    _refreshSearchEntries();
    if (selectionChanged) {
      _writeText(widget._multiple ? '' : _selectedEntry?.label ?? '');
    }
    if (_searchActive) _search();
    if (!widget.enabled && menuOpen) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted) closeMenu();
      });
    }
  }

  List<DropdownMenuEntry<T>> get _allEntries {
    if (widget.searchBuilder == null) return widget.dropdownMenuEntries;
    final Map<T, DropdownMenuEntry<T>> entries = <T, DropdownMenuEntry<T>>{
      for (final DropdownMenuEntry<T> entry in widget.dropdownMenuEntries)
        entry.value: entry,
      for (final DropdownMenuEntry<T> entry in _searchEntries)
        entry.value: entry,
    };
    for (final DropdownMenuEntry<T> entry in _retainedEntries.values) {
      entries.putIfAbsent(entry.value, () => entry);
    }
    return entries.values.toList();
  }

  bool _isSelectedEntry(DropdownMenuEntry<T> entry) => widget._multiple
      ? widget.selected!.contains(entry.value)
      : entry.value == _selectedValue;

  void _refreshSearchEntries({Set<T>? selectedValues}) {
    bool isSelected(DropdownMenuEntry<T> entry) =>
        selectedValues?.contains(entry.value) ?? _isSelectedEntry(entry);
    final Map<T, DropdownMenuEntry<T>> retained = <T, DropdownMenuEntry<T>>{
      for (final DropdownMenuEntry<T> entry in _allEntries)
        if (isSelected(entry)) entry.value: entry,
    };
    _searchEntries =
        widget.searchBuilder?.call(context, _query) ?? <DropdownMenuEntry<T>>[];
    for (final DropdownMenuEntry<T> entry in _searchEntries) {
      if (isSelected(entry)) retained[entry.value] = entry;
    }
    _retainedEntries = retained;
    _highlighted = _visibleMatch(_highlighted);
    final Set<DropdownMenuEntry<T>> entries = _allEntries.toSet();
    _entryKeys.removeWhere(
      (DropdownMenuEntry<T> entry, GlobalKey key) => !entries.contains(entry),
    );
    _entryStates.removeWhere((
      DropdownMenuEntry<T> entry,
      WidgetStatesController controller,
    ) {
      if (entries.contains(entry)) return false;
      controller.dispose();
      return true;
    });
  }

  void _textChanged() {
    if (mounted) setState(() {});
  }

  void _focusChanged() {
    if (mounted) setState(() {});
  }

  void _interactionChanged() {
    if (_stateUpdateScheduled) return;
    _stateUpdateScheduled = true;
    // A detector can synchronize its supplied state during a widget update.
    // Rebuild after that update, including when it happened inside build.
    Future<void>.microtask(() {
      _stateUpdateScheduled = false;
      if (mounted) setState(() {});
    });
  }

  WidgetStatesController _statesFor(DropdownMenuEntry<T> entry) =>
      _entryStates.putIfAbsent(entry, () {
        final WidgetStatesController controller = WidgetStatesController();
        controller.addListener(_interactionChanged);
        return controller;
      });

  @override
  void dispose() {
    anchorFocusNode.removeListener(_focusChanged);
    _textController.removeListener(_textChanged);
    if (widget.controller == null) _textController.dispose();
    _fieldStates.dispose();
    for (final WidgetStatesController controller in _entryStates.values) {
      controller.dispose();
    }
    super.dispose();
  }

  DropdownMenuEntry<T>? get _selectedEntry {
    for (final DropdownMenuEntry<T> entry in _allEntries) {
      if (entry.value == _selectedValue) return entry;
    }
    return null;
  }

  List<DropdownMenuEntry<T>> get _selectedEntries => _allEntries
      .where(
        (DropdownMenuEntry<T> entry) =>
            widget.selected?.contains(entry.value) ?? false,
      )
      .toList();

  String get _summary => widget._multiple
      ? _selectedEntries
            .map((DropdownMenuEntry<T> entry) => entry.label)
            .whereType<String>()
            .where((String label) => label.isNotEmpty)
            .join(', ')
      : _selectedEntry?.label ?? '';

  Widget? get _selectedLabelWidget {
    if (!widget._multiple) {
      final DropdownMenuEntry<T>? entry = _selectedEntry;
      return (entry?.label?.isEmpty ?? true) ? entry?.labelWidget : null;
    }
    if (widget.selectionBuilder != null) return null;
    final List<DropdownMenuEntry<T>> entries = _selectedEntries;
    if (!entries.any(
      (DropdownMenuEntry<T> entry) =>
          (entry.label?.isEmpty ?? true) && entry.labelWidget != null,
    )) {
      return null;
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (int index = 0; index < entries.length; index++) ...<Widget>[
          if (index > 0) const Text(', '),
          (entries[index].label?.isEmpty ?? true)
              ? entries[index].labelWidget ?? const SizedBox.shrink()
              : Text(entries[index].label ?? ''),
        ],
      ],
    );
  }

  List<DropdownMenuEntry<T>> get _visibleEntries {
    if (widget.searchBuilder != null) return _searchEntries;
    if (!_filterActive || !widget.enableFilter) {
      return widget.dropdownMenuEntries;
    }
    if (widget.filterCallback != null) {
      return widget.filterCallback!(widget.dropdownMenuEntries, _query);
    }
    final String query = _query.toLowerCase();
    return widget.dropdownMenuEntries
        .where(
          (DropdownMenuEntry<T> entry) =>
              (entry.label ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  DropdownMenuEntry<T>? _visibleMatch(DropdownMenuEntry<T>? entry) {
    if (entry == null) return null;
    for (final DropdownMenuEntry<T> candidate in _visibleEntries) {
      if (candidate.value == entry.value && candidate.enabled) return candidate;
    }
    return null;
  }

  bool get _isButton {
    final bool desktop = switch (ScrollConfiguration.of(context)
        .getPlatform(context)
        .name) {
      'android' || 'iOS' => false,
      _ => true,
    };
    final bool canRequestFocus =
        widget.focusNode?.canRequestFocus ??
        widget.requestFocusOnTap ??
        desktop;
    return widget.selectOnly || !canRequestFocus;
  }

  void _writeText(String text) {
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void onMenuOpened() {
    setState(() {
      _filterActive = false;
      _searchActive = false;
      if (widget.searchBuilder != null) {
        _query = '';
        _refreshSearchEntries();
      }
      final DropdownMenuEntry<T>? selected = widget._multiple
          ? (_selectedEntries.isEmpty ? null : _selectedEntries.first)
          : _selectedEntry;
      _highlighted = _visibleMatch(selected);
    });
    _scrollToHighlight();
  }

  void _toggle() {
    if (!widget.enabled) return;
    if (!_isButton && !menuOpen) anchorFocusNode.requestFocus();
    toggleMenu();
  }

  void _typed(String text) {
    if (!widget.enabled) return;
    if (!menuOpen) openMenu();
    setState(() {
      _query = text;
      _filterActive = widget.enableFilter;
      _searchActive = widget.enableSearch;
      if (widget.searchBuilder != null) _refreshSearchEntries();
      _search();
    });
    _scrollToHighlight();
  }

  void _search() {
    final List<DropdownMenuEntry<T>> entries = _visibleEntries;
    if (!_searchActive) {
      _highlighted = null;
      return;
    }
    if (widget.searchCallback != null) {
      final int? index = widget.searchCallback!(entries, _query);
      _highlighted =
          index != null &&
              index >= 0 &&
              index < entries.length &&
              entries[index].enabled
          ? entries[index]
          : null;
      return;
    }
    final String query = _query.toLowerCase();
    bool matches(DropdownMenuEntry<T> entry) =>
        entry.enabled &&
        (widget.searchBuilder != null ||
            (entry.label ?? '').toLowerCase().contains(query));
    if (_highlighted != null &&
        entries.contains(_highlighted) &&
        matches(_highlighted!)) {
      return;
    }
    _highlighted = null;
    for (final DropdownMenuEntry<T> entry in entries) {
      if (matches(entry)) {
        _highlighted = entry;
        break;
      }
    }
  }

  void _navigate(int delta) {
    if (!widget.enabled || !menuOpen) return;
    final List<DropdownMenuEntry<T>> entries = _visibleEntries
        .where((DropdownMenuEntry<T> entry) => entry.enabled)
        .toList();
    if (entries.isEmpty) return;
    final int previous = _highlighted == null
        ? -1
        : entries.indexOf(_highlighted!);
    final int next = previous < 0
        ? (delta > 0 ? 0 : entries.length - 1)
        : (previous + delta) % entries.length;
    setState(() {
      _highlighted = entries[next];
      _filterActive = false;
      _searchActive = false;
      if (!widget._multiple) _writeText(_highlighted!.label ?? '');
    });
    _scrollToHighlight();
  }

  void _scrollToHighlight() {
    final DropdownMenuEntry<T>? entry = _highlighted;
    if (entry != null) {
      ensureMenuItemVisible(_entryKeys.putIfAbsent(entry, GlobalKey.new));
    }
  }

  void _submit() {
    if (!widget.enabled || menuClosing) return;
    if (!menuOpen) {
      if (_isButton) _toggle();
      return;
    }
    final DropdownMenuEntry<T>? entry = _highlighted;
    if (entry != null && entry.enabled) {
      _select(entry);
    } else if (!widget._multiple) {
      final ValueChanged<T?>? onSelected = widget.onSelected;
      _notifySelection(() => onSelected?.call(null));
    }
  }

  void _notifySelection(VoidCallback callback) {
    if (widget.closeBehavior == DropdownMenuCloseBehavior.none) {
      callback();
    } else {
      closeMenuThen(callback);
    }
  }

  void _select(DropdownMenuEntry<T> entry) {
    if (!widget.enabled || !entry.enabled || menuClosing) return;
    if (widget._multiple) {
      if (widget.onSelectionChanged == null) return;
      final Set<T> selection = <T>{...widget.selected!};
      if (selection.contains(entry.value)) {
        if (!widget.emptySelectionAllowed && selection.length == 1) return;
        selection.remove(entry.value);
      } else {
        selection.add(entry.value);
      }
      setState(() {
        _query = '';
        _filterActive = false;
        _searchActive = false;
        _highlighted = entry;
        _writeText('');
        if (widget.searchBuilder != null) {
          _refreshSearchEntries(selectedValues: selection);
        }
      });
      final ValueChanged<Set<T>> onSelectionChanged =
          widget.onSelectionChanged!;
      _notifySelection(() => onSelectionChanged(selection));
    } else {
      setState(() {
        _selectedValue = entry.value;
        _highlighted = entry;
        _filterActive = false;
        _searchActive = false;
        _writeText(entry.label ?? '');
      });
      final ValueChanged<T?>? onSelected = widget.onSelected;
      _notifySelection(() => onSelected?.call(entry.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownMenu',
        parameter: 'decoration',
        styleToken: 'style.buttonStyle.decoration',
        value: widget.decoration,
        styleValue: widget.style?.buttonStyle?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownMenu',
        parameter: 'menuDecoration',
        styleToken: 'style.menuStyle.decoration',
        value: widget.menuDecoration,
        styleValue: widget.style?.menuStyle?.decoration,
      ),
    );
    final DropdownStyle theme = DropdownMenuTheme.of(context);
    final List<DropdownStyle?> layers = <DropdownStyle?>[widget.style, theme];
    final MenuStyle menuStyle = (widget.style?.menuStyle ?? const MenuStyle())
        .merge(theme.menuStyle)
        .copyWith(decoration: widget.menuDecoration);
    final bool isButton = _isButton;
    final InteractionState state =
        InteractionState.fromWidgetStates(_fieldStates.value).copyWith(
          isFocused: isButton ? null : anchorFocusNode.hasFocus,
          isSelected: menuOpen,
          isDisabled: !widget.enabled,
        );
    final Widget? trailing = widget.showTrailingIcon
        ? DropdownIcon(
            icon: widget.trailingIcon ?? const ChevronGlyph(),
            open: menuOpen,
            layers: layers,
          )
        : null;
    final Widget? selection =
        widget._multiple && widget.selectionBuilder != null
        ? widget.selectionBuilder!(context, _selectedEntries)
        : null;
    final Widget? leading = selection == null
        ? widget.leadingIcon
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.leadingIcon != null) widget.leadingIcon!,
              selection,
            ],
          );
    final ButtonStyle surfaceStyle = layeredButtonStyle(<ButtonStyle?>[
      ButtonStyle(decoration: decorationLayer(widget.decoration)),
      widget.style?.buttonStyle,
      theme.buttonStyle,
    ]);
    Widget field = isButton
        ? MenuItemButton(
            onPressed: widget.enabled ? _toggle : null,
            style: surfaceStyle,
            statesController: _fieldStates,
            focusNode: anchorFocusNode,
            isExpanded: menuOpen,
            leading: leading,
            trailing: trailing,
            child: _textBox(_fieldLabel(layers, state), layers, state),
          )
        : _editableField(layers, surfaceStyle, leading, trailing);
    if (!isButton) {
      field = IgnorePointer(
        ignoring: !widget.enabled,
        child: ExcludeFocus(excluding: !widget.enabled, child: field),
      );
    }
    field = Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        menuKeyActivator(0x00100000304): const _HighlightIntent(-1),
        menuKeyActivator(0x00100000301): const _HighlightIntent(1),
        if (isButton)
          menuKeyActivator(0x0010000000d): const _SubmitDropdownIntent(),
        if (!isButton) ...<ShortcutActivator, Intent>{
          menuKeyActivator(
            0x00100000302,
          ): const ExtendSelectionByCharacterIntent(
            forward: false,
            collapseSelection: true,
          ),
          menuKeyActivator(
            0x00100000303,
          ): const ExtendSelectionByCharacterIntent(
            forward: true,
            collapseSelection: true,
          ),
        },
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NextFocusIntent: CallbackAction<NextFocusIntent>(
            onInvoke: (NextFocusIntent intent) {
              if (menuOpen) {
                _navigate(1);
              } else {
                Actions.invoke(context, intent);
              }
              return null;
            },
          ),
          PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
            onInvoke: (PreviousFocusIntent intent) {
              if (menuOpen) {
                _navigate(-1);
              } else {
                Actions.invoke(context, intent);
              }
              return null;
            },
          ),
          ScrollIntent: CallbackAction<ScrollIntent>(
            onInvoke: (ScrollIntent intent) {
              if (intent.direction == AxisDirection.up) _navigate(-1);
              if (intent.direction == AxisDirection.down) _navigate(1);
              return null;
            },
          ),
          _HighlightIntent: CallbackAction<_HighlightIntent>(
            onInvoke: (_HighlightIntent intent) {
              _navigate(intent.delta);
              return null;
            },
          ),
          _SubmitDropdownIntent: CallbackAction<_SubmitDropdownIntent>(
            onInvoke: (_SubmitDropdownIntent intent) {
              _submit();
              return null;
            },
          ),
        },
        child: field,
      ),
    );
    if (widget.width != null) {
      field = SizedBox(width: widget.width, child: field);
    } else if (widget.expandedInsets != null) {
      field = Padding(
        padding: widget.expandedInsets!,
        child: SizedBox(width: double.infinity, child: field),
      );
    }
    field = Semantics(
      container: true,
      button: isButton,
      textField: !isButton,
      enabled: widget.enabled,
      expanded: menuOpen,
      label: widget.semanticLabel,
      value: _summary,
      onExpand: widget.enabled && !menuOpen ? _toggle : null,
      onCollapse: widget.enabled && menuOpen ? closeMenu : null,
      child: field,
    );
    return buildMenuHost(
      style: menuStyle,
      maxHeight: widget.menuHeight,
      semanticLabel: widget.semanticLabel,
      textField: !isButton,
      onNavigate: _navigate,
      child: field,
      children: <Widget>[
        for (final DropdownMenuEntry<T> entry in _visibleEntries)
          _buildEntry(entry, theme, layers),
      ],
    );
  }

  Widget _buildEntry(
    DropdownMenuEntry<T> entry,
    DropdownStyle theme,
    List<DropdownStyle?> layers,
  ) {
    assert(
      debugCheckDecorationOverride(
        widget: 'DropdownMenuEntry',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: entry.decoration,
        styleValue: entry.style?.decoration,
      ),
    );
    final bool selected = widget._multiple
        ? widget.selected!.contains(entry.value)
        : entry.value == _selectedValue;
    final WidgetStatesController controller = _statesFor(entry);
    final InteractionState state =
        InteractionState.fromWidgetStates(controller.value).copyWith(
          isSelected: selected,
          isFocused: entry == _highlighted,
          isDisabled: !entry.enabled || !widget.enabled,
        );
    final Widget? indicator = resolveStatefulOrDefault<DropdownStyle, Widget>(
      state,
      layers,
      (DropdownStyle style) => style.selectedIndicator,
      () => defaultSelectionIndicator(selected: state.isSelected),
    );
    final Widget? leading = indicator == null
        ? entry.leadingIcon
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[indicator, ?entry.leadingIcon],
          );
    return ExcludeFocus(
      key: _entryKeys.putIfAbsent(entry, GlobalKey.new),
      child: MenuItemButton(
        onPressed: widget.enabled && entry.enabled
            ? () => _select(entry)
            : null,
        style: layeredButtonStyle(<ButtonStyle?>[
          ButtonStyle(decoration: decorationLayer(entry.decoration)),
          entry.style,
          widget.style?.itemStyle,
          theme.itemStyle,
        ]),
        isSelected: selected,
        isChecked: widget._multiple ? selected : null,
        isFocused: entry == _highlighted,
        statesController: controller,
        leading: leading,
        trailing: entry.trailingIcon,
        child: entry.labelWidget ?? Text(entry.label ?? ''),
      ),
    );
  }

  TextStyle _fieldTextStyle(
    List<DropdownStyle?> layers,
    InteractionState state, {
    bool hint = false,
  }) => DefaultTextStyle.of(context).style
      .merge(
        resolveStateful<ButtonStyle, TextStyle>(
          state,
          layers.map((DropdownStyle? style) => style?.buttonStyle).toList(),
          (ButtonStyle style) => style.textStyle,
        ),
      )
      .merge(
        resolveStateful<DropdownStyle, TextStyle>(
          state,
          layers,
          (DropdownStyle style) => hint ? style.hintStyle : style.textStyle,
        ),
      );

  Widget _fieldLabel(List<DropdownStyle?> layers, InteractionState state) {
    final Widget? selection = _textController.text.isEmpty
        ? _selectedLabelWidget
        : null;
    if (selection != null) {
      return DefaultTextStyle.merge(
        style: _fieldTextStyle(layers, state),
        textAlign: widget.textAlign,
        child: selection,
      );
    }
    return Text(
      widget._multiple
          ? (_summary.isEmpty || widget.selectionBuilder != null
                ? widget.hintText ?? ''
                : _summary)
          : (_textController.text.isEmpty
                ? widget.hintText ?? ''
                : _textController.text),
      textAlign: widget.textAlign,
      style: _fieldTextStyle(
        layers,
        state,
        hint: widget._multiple || _textController.text.isEmpty,
      ),
    );
  }

  Widget _textBox(
    Widget child,
    List<DropdownStyle?> layers,
    InteractionState state,
  ) => Stack(
    alignment: AlignmentDirectional.centerStart,
    children: <Widget>[
      for (final DropdownMenuEntry<T> entry in _allEntries)
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: (entry.label?.isEmpty ?? true) && entry.labelWidget != null
              ? DefaultTextStyle.merge(
                  style: _fieldTextStyle(layers, state),
                  child: entry.labelWidget!,
                )
              : Text(entry.label ?? '', style: _fieldTextStyle(layers, state)),
        ),
      Visibility(
        visible: false,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Text(
          widget.hintText ?? '',
          style: _fieldTextStyle(layers, state),
        ),
      ),
      Positioned.fill(child: child),
    ],
  );

  Widget _editableField(
    List<DropdownStyle?> layers,
    ButtonStyle surface,
    Widget? leading,
    Widget? trailing,
  ) => InteractionDetector(
    enabled: widget.enabled,
    canRequestFocus: false,
    isFocused: anchorFocusNode.hasFocus,
    isSelected: menuOpen,
    mouseCursor: surface.mouseCursor,
    statesController: _fieldStates,
    builder: (BuildContext context, InteractionState state) {
      final TextStyle textStyle = _fieldTextStyle(layers, state);
      // EditableText requires a color even when every theme token is absent.
      final Color cursorColor =
          resolvePlain<DropdownStyle, Color>(
            layers,
            (DropdownStyle style) => style.cursorColor,
          ) ??
          textStyle.color ??
          const Color(0xFF000000);
      final Decoration? decoration = surface.decoration?.resolve(state);
      final Decoration? foreground = surface.foregroundDecoration?.resolve(
        state,
      );
      final BoxConstraints constraints = sizeConstraints(
        minimum: surface.minimumSize?.resolve(state),
        maximum: surface.maximumSize?.resolve(state),
        fixed: surface.fixedSize?.resolve(state),
      );
      final Widget text = _textBox(
        Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            if (_textController.text.isEmpty)
              IgnorePointer(child: _fieldLabel(layers, state)),
            EditableText(
              // Avoid scrolling a visible field merely to add EditableText's
              // default outer margin, which would dismiss its anchored panel.
              scrollPadding: EdgeInsets.zero,
              controller: _textController,
              focusNode: anchorFocusNode,
              readOnly: !widget.enabled,
              style: textStyle,
              cursorColor: cursorColor,
              backgroundCursorColor: cursorColor,
              cursorWidth:
                  resolvePlain<DropdownStyle, double>(
                    layers,
                    (DropdownStyle style) => style.cursorWidth,
                  ) ??
                  2,
              selectionColor: resolvePlain<DropdownStyle, Color>(
                layers,
                (DropdownStyle style) => style.selectionColor,
              ),
              keyboardType: widget.keyboardType,
              textAlign: widget.textAlign,
              onChanged: _typed,
              onSubmitted: (String value) => _submit(),
              onEditingComplete: () {},
            ),
          ],
        ),
        layers,
        state,
      );
      // TextFieldTapRegion's group, made opaque so taps on unpainted padding,
      // gaps or icons still toggle the menu.
      return TapRegion(
        key: _editableTapKey,
        groupId: EditableText,
        behavior: HitTestBehavior.opaque,
        onTapUpInside: widget.enabled
            ? (PointerUpEvent event) {
                final RenderBox box =
                    _editableTapKey.currentContext!.findRenderObject()!
                        as RenderBox;
                if ((Offset.zero & box.size).contains(
                  box.globalToLocal(event.position),
                )) {
                  _toggle();
                }
              }
            : null,
        child: TapTarget(
          minSize: surface.tapTargetSize,
          child: ConstrainedBox(
            constraints: constraints,
            child: AnimatedSurface(
              duration:
                  surface.animationDuration ??
                  const Duration(milliseconds: 200),
              curve: surface.animationCurve ?? Curves.easeInOut,
              decoration: decoration,
              foregroundDecoration: foreground,
              padding: surface.padding?.resolve(state),
              clipBehavior: decoration == null
                  ? Clip.none
                  : surface.clipBehavior ?? Clip.none,
              child: IconTheme(
                data:
                    surface.iconTheme?.resolve(state) ?? const IconThemeData(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: surface.spacing ?? 0,
                  children: <Widget>[
                    ?leading,
                    if (widget.width != null || widget.expandedInsets != null)
                      Expanded(child: text)
                    else
                      Flexible(child: text),
                    ?trailing,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
