import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import '../theme/button_themes.dart';
import 'segmented_button.dart';

/// A group of independently selected buttons.
class ToggleButtons extends StatelessWidget {
  /// Creates toggle buttons.
  const ToggleButtons({
    super.key,
    required this.children,
    required this.isSelected,
    this.onPressed,
    this.focusNodes,
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
    this.style,
  }) : assert(children.length == isSelected.length),
       assert(focusNodes == null || focusNodes.length == children.length);

  /// The children for this component.
  final List<Widget> children;

  /// The is selected for this component.
  final List<bool> isSelected;

  /// The on pressed for this component.
  final ValueChanged<int>? onPressed;

  /// The focus nodes for this component.
  final List<FocusNode>? focusNodes;

  /// The direction for this component.
  final Axis direction;

  /// The vertical direction for this component.
  final VerticalDirection verticalDirection;

  /// The style for this component.
  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final List<int> indices = List<int>.generate(children.length, (int i) => i);
    if (direction == Axis.vertical &&
        verticalDirection == VerticalDirection.up) {
      indices.sort((int a, int b) => b.compareTo(a));
    }
    return SegmentedButton<int>(
      focusNodes: focusNodes == null
          ? null
          : <FocusNode>[for (final int i in indices) focusNodes![i]],
      style:
          style?.merge(ToggleButtonsTheme.of(context)) ??
          ToggleButtonsTheme.of(context),
      segments: <ButtonSegment<int>>[
        for (final int i in indices)
          ButtonSegment<int>(value: i, label: children[i]),
      ],
      selected: <int>{
        for (int i = 0; i < isSelected.length; i++)
          if (isSelected[i]) i,
      },
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      direction: direction,
      onSelectionChanged: onPressed == null
          ? null
          : (Set<int> next) {
              for (int i = 0; i < isSelected.length; i++) {
                if (next.contains(i) != isSelected[i]) {
                  onPressed!(i);
                  return;
                }
              }
            },
    );
  }
}
