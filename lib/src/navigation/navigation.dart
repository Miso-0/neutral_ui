import 'package:flutter/widgets.dart';

import '../buttons/selection_button.dart';
import '../feedback/tooltip.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../localizations/pure_localizations.dart';
import '../styles/button_style.dart';
import '../styles/navigation_style.dart';
import '../theme/navigation_themes.dart';

/// Controls when navigation destination labels are displayed.
enum NavigationDestinationLabelBehavior {
  /// Display every destination's label.
  alwaysShow,

  /// Hide labels and display destination icons alone.
  alwaysHide,

  /// Display the selected destination's label.
  onlyShowSelected,
}

/// Controls when rail destination labels are displayed.
enum NavigationRailLabelType {
  /// Hide all destination labels.
  none,

  /// Display the selected destination's label.
  selected,

  /// Display every destination's label.
  all,
}

/// An icon and label in a navigation bar.
class NavigationDestination extends StatelessWidget {
  /// Creates navigation destination.
  const NavigationDestination({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
    this.enabled = true,
  });

  /// The icon for this component.
  final Widget icon;

  /// The selected icon for this component.
  final Widget? selectedIcon;

  /// The label for this component.
  final String label;

  /// The tooltip for this component.
  final String? tooltip;

  /// The enabled for this component.
  final bool enabled;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[icon, Text(label)],
  );
}

/// A horizontal group of navigation destinations.
class NavigationBar extends StatelessWidget {
  /// Creates navigation bar.
  const NavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
    this.style,
  }) : assert(destinations.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < destinations.length);

  /// The destinations for this component.
  final List<Widget> destinations;

  /// The selected index for this component.
  final int selectedIndex;

  /// The on destination selected for this component.
  final ValueChanged<int>? onDestinationSelected;

  /// The label behavior for this component.
  final NavigationDestinationLabelBehavior labelBehavior;

  /// The style for this component.
  final NavigationStyle? style;
  @override
  Widget build(BuildContext context) => _NavigationGroup(
    axis: Axis.horizontal,
    selectedIndex: selectedIndex,
    onSelected: onDestinationSelected,
    style:
        style?.merge(NavigationBarTheme.of(context)) ??
        NavigationBarTheme.of(context),
    destinations: <_Destination>[
      for (final Widget widget in destinations)
        if (widget is NavigationDestination)
          _Destination(
            widget.icon,
            widget.selectedIcon,
            Text(widget.label),
            widget.tooltip,
            widget.enabled,
          )
        else
          _Destination(widget, null, const SizedBox.shrink(), null, true),
    ],
    labels: labelBehavior,
  );
}

/// A destination in a navigation rail.
@immutable
class NavigationRailDestination {
  /// Creates navigation rail destination.
  const NavigationRailDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.disabled = false,
  });

  /// The icon for this component.
  final Widget icon;

  /// The selected icon for this component.
  final Widget? selectedIcon;

  /// The label for this component.
  final Widget label;

  /// The disabled for this component.
  final bool disabled;
}

/// A vertical group of navigation destinations.
class NavigationRail extends StatelessWidget {
  /// Creates navigation rail.
  const NavigationRail({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.extended = false,
    this.leading,
    this.trailing,
    this.labelType = NavigationRailLabelType.none,
    this.groupAlignment = -1,
    this.scrollable = false,
    this.style,
  }) : assert(destinations.length > 1);

  /// The destinations for this component.
  final List<NavigationRailDestination> destinations;

  /// The selected index for this component.
  final int? selectedIndex;

  /// The on destination selected for this component.
  final ValueChanged<int>? onDestinationSelected;

  /// The extended for this component.
  final bool extended;

  /// The leading for this component.
  final Widget? leading;

  /// The trailing for this component.
  final Widget? trailing;

  /// The label type for this component.
  final NavigationRailLabelType labelType;

  /// The group alignment for this component.
  final double groupAlignment;

  /// The scrollable for this component.
  final bool scrollable;

  /// The style for this component.
  final NavigationStyle? style;
  @override
  Widget build(BuildContext context) {
    Widget group = _NavigationGroup(
      axis: Axis.vertical,
      selectedIndex: selectedIndex,
      onSelected: onDestinationSelected,
      style:
          style?.merge(NavigationRailTheme.of(context)) ??
          NavigationRailTheme.of(context),
      destinations: <_Destination>[
        for (final NavigationRailDestination destination in destinations)
          _Destination(
            destination.icon,
            destination.selectedIcon,
            destination.label,
            null,
            !destination.disabled,
          ),
      ],
      horizontalLabel: extended,
      labels: extended
          ? NavigationDestinationLabelBehavior.alwaysShow
          : switch (labelType) {
              NavigationRailLabelType.none =>
                NavigationDestinationLabelBehavior.alwaysHide,
              NavigationRailLabelType.selected =>
                NavigationDestinationLabelBehavior.onlyShowSelected,
              NavigationRailLabelType.all =>
                NavigationDestinationLabelBehavior.alwaysShow,
            },
    );
    if (scrollable) group = SingleChildScrollView(child: group);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ?leading,
        Flexible(
          child: Align(
            alignment: Alignment(0, groupAlignment),
            widthFactor: 1,
            heightFactor: 1,
            child: group,
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// An icon and label in a navigation drawer.
class NavigationDrawerDestination extends StatelessWidget {
  /// Creates navigation drawer destination.
  const NavigationDrawerDestination({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.enabled = true,
  });

  /// The icon for this component.
  final Widget icon;

  /// The selected icon for this component.
  final Widget? selectedIcon;

  /// The label for this component.
  final Widget label;

  /// The enabled for this component.
  final bool enabled;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[icon, label]);
}

/// A vertical navigation group that also accepts headings and separators.
class NavigationDrawer extends StatelessWidget {
  /// Creates navigation drawer.
  const NavigationDrawer({
    super.key,
    required this.children,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.style,
  });

  /// The children for this component.
  final List<Widget> children;

  /// The selected index for this component.
  final int? selectedIndex;

  /// The on destination selected for this component.
  final ValueChanged<int>? onDestinationSelected;

  /// The style for this component.
  final NavigationStyle? style;
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: PureLocalizations.of(context).drawerLabel,
    child: _NavigationGroup(
      axis: Axis.vertical,
      selectedIndex: selectedIndex,
      onSelected: onDestinationSelected,
      horizontalLabel: true,
      style:
          style?.merge(NavigationDrawerTheme.of(context)) ??
          NavigationDrawerTheme.of(context),
      destinations: <_Destination>[
        for (final Widget widget in children)
          if (widget is NavigationDrawerDestination)
            _Destination(
              widget.icon,
              widget.selectedIcon,
              widget.label,
              null,
              widget.enabled,
            )
          else
            _Destination(
              widget,
              null,
              const SizedBox.shrink(),
              null,
              false,
              heading: true,
            ),
      ],
      labels: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}

class _Destination {
  const _Destination(
    this.icon,
    this.selectedIcon,
    this.label,
    this.tooltip,
    this.enabled, {
    this.heading = false,
  });
  final Widget icon;
  final Widget? selectedIcon;
  final Widget label;
  final String? tooltip;
  final bool enabled;
  final bool heading;
}

class _NavigationGroup extends StatefulWidget {
  const _NavigationGroup({
    required this.axis,
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
    required this.style,
    required this.labels,
    this.horizontalLabel = false,
  });
  final Axis axis;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final List<_Destination> destinations;
  final NavigationStyle style;
  final NavigationDestinationLabelBehavior labels;
  final bool horizontalLabel;
  @override
  State<_NavigationGroup> createState() => _NavigationGroupState();
}

class _NavigationGroupState extends State<_NavigationGroup> {
  final GlobalKey _stack = GlobalKey();
  final List<GlobalKey> _keys = <GlobalKey>[];
  final List<FocusNode> _nodes = <FocusNode>[];
  Rect? _indicator;
  int _logicalIndex(int raw) => widget.destinations
      .take(raw)
      .where((_Destination destination) => !destination.heading)
      .length;
  @override
  void dispose() {
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _measure() {
    if (!mounted) return;
    Rect? next;
    for (int i = 0; i < widget.destinations.length; i++) {
      if (!widget.destinations[i].heading &&
          _logicalIndex(i) == widget.selectedIndex) {
        final RenderObject? child = _keys[i].currentContext?.findRenderObject();
        final RenderObject? parent = _stack.currentContext?.findRenderObject();
        if (child is RenderBox &&
            parent is RenderBox &&
            child.hasSize &&
            parent.hasSize) {
          next =
              child.localToGlobal(Offset.zero, ancestor: parent) & child.size;
        }
      }
    }
    if (next != _indicator) setState(() => _indicator = next);
  }

  Object? _move(TraversalDirection direction) {
    final bool horizontal =
        direction == TraversalDirection.left ||
        direction == TraversalDirection.right;
    if (horizontal != (widget.axis == Axis.horizontal) ||
        widget.onSelected == null) {
      return null;
    }
    final List<int> enabled = <int>[
      for (int i = 0; i < widget.destinations.length; i++)
        if (widget.destinations[i].enabled && !widget.destinations[i].heading)
          i,
    ];
    if (enabled.isEmpty) return null;
    int focused = enabled.indexWhere((int i) => _nodes[i].hasFocus);
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final int step = switch (direction) {
      TraversalDirection.right => rtl ? -1 : 1,
      TraversalDirection.left => rtl ? 1 : -1,
      TraversalDirection.down => 1,
      TraversalDirection.up => -1,
    };
    focused = (focused + step) % enabled.length;
    _nodes[enabled[focused]].requestFocus();
    widget.onSelected!(_logicalIndex(enabled[focused]));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    while (_keys.length < widget.destinations.length) {
      _keys.add(GlobalKey());
      _nodes.add(FocusNode());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    final NavigationStyle style = widget.style;
    final Duration duration = reducedMotionDuration(
      context,
      style.animationDuration ?? const Duration(milliseconds: 250),
    );
    final InteractionState state = const InteractionState(isSelected: true);
    final Decoration? decoration =
        resolveStatefulOrDefault<NavigationStyle, Decoration>(
          state,
          <NavigationStyle?>[style],
          (NavigationStyle style) => style.indicatorDecoration,
          () => BoxDecoration(
            color: IconTheme.of(context).color?.withValues(alpha: 0.12),
          ),
        );
    Rect? indicator = _indicator;
    if (indicator != null) {
      indicator = (style.indicatorPadding ?? EdgeInsets.zero)
          .resolve(Directionality.of(context))
          .deflateRect(indicator);
      if (style.indicatorSize != null) {
        indicator = Rect.fromCenter(
          center: indicator.center,
          width: style.indicatorSize!.width,
          height: style.indicatorSize!.height,
        );
      }
    }
    return Padding(
      padding: style.padding ?? EdgeInsets.zero,
      child: FocusTraversalGroup(
        child: Actions(
          actions: <Type, Action<Intent>>{
            DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
              onInvoke: (DirectionalFocusIntent intent) =>
                  _move(intent.direction),
            ),
          },
          child: Stack(
            key: _stack,
            children: <Widget>[
              if (indicator != null && decoration != null)
                AnimatedPositioned.fromRect(
                  rect: indicator,
                  duration: duration,
                  curve: style.animationCurve ?? Curves.easeOutCubic,
                  child: IgnorePointer(
                    child: DecoratedBox(decoration: decoration),
                  ),
                ),
              Flex(
                direction: widget.axis,
                mainAxisSize: MainAxisSize.min,
                spacing: style.spacing ?? 0,
                children: <Widget>[
                  for (int i = 0; i < widget.destinations.length; i++)
                    if (widget.axis == Axis.horizontal)
                      Expanded(child: _destination(i, duration))
                    else
                      _destination(i, duration),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _destination(int raw, Duration duration) {
    final _Destination destination = widget.destinations[raw];
    if (destination.heading) {
      return KeyedSubtree(key: _keys[raw], child: destination.icon);
    }
    final int index = _logicalIndex(raw);
    final bool selected = index == widget.selectedIndex;
    final bool showLabel = switch (widget.labels) {
      NavigationDestinationLabelBehavior.alwaysShow => true,
      NavigationDestinationLabelBehavior.alwaysHide => false,
      NavigationDestinationLabelBehavior.onlyShowSelected => selected,
    };
    final ButtonStyle
    style = (widget.style.destinationStyle ?? const ButtonStyle()).copyWith(
      textStyle:
          widget.style.labelStyle ?? widget.style.destinationStyle?.textStyle,
      iconTheme:
          widget.style.iconTheme ?? widget.style.destinationStyle?.iconTheme,
    );
    final Widget icon = selected
        ? destination.selectedIcon ?? destination.icon
        : destination.icon;
    final Widget label = ClipRect(
      child: AnimatedSize(
        duration: duration,
        curve: widget.style.animationCurve ?? Curves.easeOutCubic,
        child: showLabel ? destination.label : const SizedBox.shrink(),
      ),
    );
    final Widget content = widget.horizontalLabel
        ? Row(
            mainAxisSize: MainAxisSize.min,
            spacing: widget.style.spacing ?? 0,
            children: <Widget>[icon, label],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[icon, label],
          );
    final String? labelText = destination.label is Text
        ? (destination.label as Text).data ??
              (destination.label as Text).textSpan?.toPlainText()
        : null;
    Widget result = Semantics(
      tooltip: destination.tooltip,
      label: showLabel ? null : labelText,
      child: SelectionButton(
        key: _keys[raw],
        focusNode: _nodes[raw],
        isSelected: selected,
        style: style,
        onPressed: destination.enabled && widget.onSelected != null
            ? () {
                _nodes[raw].requestFocus();
                widget.onSelected!(index);
              }
            : null,
        child: content,
      ),
    );
    final String? tooltip = destination.tooltip ?? labelText;
    if (tooltip != null && tooltip.isNotEmpty) {
      result = Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: result,
      );
    }
    return result;
  }
}
