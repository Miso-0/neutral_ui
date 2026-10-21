import '../feedback/tooltip.dart';
import '../foundation/animated_reveal.dart';
import '../foundation/glyphs.dart';
import '../foundation/motion.dart';
import '../styles/button_style.dart';
import '../theme/button_themes.dart';

import 'package:flutter/widgets.dart';

import 'selection_button.dart';

/// A value and its label in a [SegmentedButton].
@immutable
class ButtonSegment<T> {
  /// Creates button segment.
  const ButtonSegment({
    required this.value,
    this.icon,
    this.label,
    this.tooltip,
    this.enabled = true,
  });

  /// The value for this component.
  final T value;

  /// The icon for this component.
  final Widget? icon;

  /// The label for this component.
  final Widget? label;

  /// The tooltip for this component.
  final String? tooltip;

  /// The enabled for this component.
  final bool enabled;
}

/// A keyboard navigable single or multiple selection group.
class SegmentedButton<T> extends StatefulWidget {
  /// Creates segmented button.
  const SegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.showSelectedIcon = true,
    this.selectedIcon,
    this.direction = Axis.horizontal,
    this.style,
    this.expandedInsets,
    this.focusNodes,
  }) : assert(segments.length > 0),
       assert(multiSelectionEnabled || selected.length <= 1),
       assert(emptySelectionAllowed || selected.length > 0),
       assert(focusNodes == null || focusNodes.length == segments.length);

  /// The segments for this component.
  final List<ButtonSegment<T>> segments;

  /// The selected for this component.
  final Set<T> selected;

  /// The on selection changed for this component.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// The multi selection enabled for this component.
  final bool multiSelectionEnabled;

  /// The empty selection allowed for this component.
  final bool emptySelectionAllowed;

  /// The show selected icon for this component.
  final bool showSelectedIcon;

  /// The selected icon for this component.
  final Widget? selectedIcon;

  /// The direction for this component.
  final Axis direction;

  /// The style for this component.
  final ButtonStyle? style;

  /// The expanded insets for this component.
  final EdgeInsetsGeometry? expandedInsets;

  /// The focus nodes for this component.
  final List<FocusNode>? focusNodes;
  @override
  State<SegmentedButton<T>> createState() => _SegmentedButtonState<T>();
}

class _SegmentedButtonState<T> extends State<SegmentedButton<T>> {
  final Map<T, FocusNode> _nodes = <T, FocusNode>{};
  FocusNode _node(T value) {
    final int index = widget.segments.indexWhere(
      (ButtonSegment<T> s) => s.value == value,
    );
    return widget.focusNodes?[index] ??
        _nodes.putIfAbsent(
          value,
          () => FocusNode(debugLabel: 'Segment $value'),
        );
  }

  @override
  void dispose() {
    for (final FocusNode node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _select(ButtonSegment<T> segment) {
    if (!segment.enabled || widget.onSelectionChanged == null) return;
    final Set<T> next = widget.multiSelectionEnabled
        ? Set<T>.of(widget.selected)
        : <T>{};
    if (widget.selected.contains(segment.value) &&
        (widget.multiSelectionEnabled || widget.emptySelectionAllowed)) {
      next.remove(segment.value);
    } else {
      next.add(segment.value);
    }
    if (next.isEmpty && !widget.emptySelectionAllowed) return;
    widget.onSelectionChanged!(next);
  }

  Object? _move(TraversalDirection direction) {
    final bool horizontal =
        direction == TraversalDirection.left ||
        direction == TraversalDirection.right;
    if (horizontal != (widget.direction == Axis.horizontal)) return null;
    final List<ButtonSegment<T>> enabled = widget.segments
        .where((ButtonSegment<T> s) => s.enabled)
        .toList();
    if (enabled.isEmpty) return null;
    int index = enabled.indexWhere(
      (ButtonSegment<T> s) => _node(s.value).hasFocus,
    );
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final int step = switch (direction) {
      TraversalDirection.right => rtl ? -1 : 1,
      TraversalDirection.left => rtl ? 1 : -1,
      TraversalDirection.down => 1,
      TraversalDirection.up => -1,
    };
    index = (index + step) % enabled.length;
    _node(enabled[index].value).requestFocus();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.segments
              .map((ButtonSegment<T> segment) => segment.value)
              .toSet()
              .length ==
          widget.segments.length,
      'Segment values must be unique.',
    );
    assert(
      widget.selected.every(
        (T value) => widget.segments.any(
          (ButtonSegment<T> segment) => segment.value == value,
        ),
      ),
      'Every selected value must identify a segment.',
    );
    final ButtonStyle theme = SegmentedButtonTheme.of(context);
    final Duration duration = reducedMotionDuration(
      context,
      widget.style?.animationDuration ??
          theme.animationDuration ??
          const Duration(milliseconds: 200),
    );
    final Curve curve =
        widget.style?.animationCurve ??
        theme.animationCurve ??
        Curves.easeInOut;
    final List<Widget> children = widget.segments.map((
      ButtonSegment<T> segment,
    ) {
      final bool selected = widget.selected.contains(segment.value);
      Widget button = SelectionButton(
        key: ValueKey<T>(segment.value),
        isSelected: selected,
        themeStyle: theme,
        style: widget.style,
        focusNode: _node(segment.value),
        onPressed: widget.onSelectionChanged != null && segment.enabled
            ? () => _select(segment)
            : null,
        leading: widget.showSelectedIcon
            ? AnimatedReveal(
                visible: selected,
                duration: duration,
                curve: curve,
                child: widget.selectedIcon ?? const CheckGlyph(),
              )
            : null,
        icon: segment.icon,
        child: segment.label,
      );
      if (segment.tooltip != null) {
        button = Tooltip(message: segment.tooltip, child: button);
      }
      if (widget.expandedInsets != null) {
        button = Expanded(
          child: Padding(padding: widget.expandedInsets!, child: button),
        );
      }
      return button;
    }).toList();
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: FocusTraversalGroup(
        child: Actions(
          actions: <Type, Action<Intent>>{
            DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
              onInvoke: (DirectionalFocusIntent intent) =>
                  _move(intent.direction),
            ),
          },
          child: Flex(
            direction: widget.direction,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
