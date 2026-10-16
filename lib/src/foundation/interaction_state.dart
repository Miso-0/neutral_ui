import 'package:flutter/widgets.dart';

/// The interaction flags used to resolve a component's tokens.
///
/// [isFocused] describes visible keyboard focus rather than raw focus.
@immutable
class InteractionState {
  /// Creates a snapshot of a component's interaction state.
  const InteractionState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isSelected = false,
    this.isDisabled = false,
    this.isDragged = false,
    this.isError = false,
  });

  /// Creates a snapshot from the corresponding Flutter widget states.
  factory InteractionState.fromWidgetStates(Set<WidgetState> states) {
    return InteractionState(
      isPressed: states.contains(WidgetState.pressed),
      isHovered: states.contains(WidgetState.hovered),
      isFocused: states.contains(WidgetState.focused),
      isSelected: states.contains(WidgetState.selected),
      isDisabled: states.contains(WidgetState.disabled),
      isDragged: states.contains(WidgetState.dragged),
      isError: states.contains(WidgetState.error),
    );
  }

  /// Whether a pointer or activation key is pressing the control.
  final bool isPressed;

  /// Whether an enabled control is under a pointer.
  final bool isHovered;

  /// Whether the control should display its keyboard focus indication.
  final bool isFocused;

  /// Whether the control is selected.
  final bool isSelected;

  /// Whether the control is unavailable for interaction.
  final bool isDisabled;

  /// Whether a horizontal drag is active.
  final bool isDragged;

  /// Whether the control has a validation error.
  final bool isError;

  /// Whether the control is available for interaction.
  bool get isEnabled => !isDisabled;

  /// Returns the Flutter widget states represented by this snapshot.
  Set<WidgetState> toWidgetStates() {
    return <WidgetState>{
      if (isPressed) WidgetState.pressed,
      if (isHovered) WidgetState.hovered,
      if (isFocused) WidgetState.focused,
      if (isSelected) WidgetState.selected,
      if (isDisabled) WidgetState.disabled,
      if (isDragged) WidgetState.dragged,
      if (isError) WidgetState.error,
    };
  }

  /// Returns a copy with the supplied flags replaced.
  InteractionState copyWith({
    bool? isPressed,
    bool? isHovered,
    bool? isFocused,
    bool? isSelected,
    bool? isDisabled,
    bool? isDragged,
    bool? isError,
  }) {
    return InteractionState(
      isPressed: isPressed ?? this.isPressed,
      isHovered: isHovered ?? this.isHovered,
      isFocused: isFocused ?? this.isFocused,
      isSelected: isSelected ?? this.isSelected,
      isDisabled: isDisabled ?? this.isDisabled,
      isDragged: isDragged ?? this.isDragged,
      isError: isError ?? this.isError,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InteractionState &&
            isPressed == other.isPressed &&
            isHovered == other.isHovered &&
            isFocused == other.isFocused &&
            isSelected == other.isSelected &&
            isDisabled == other.isDisabled &&
            isDragged == other.isDragged &&
            isError == other.isError;
  }

  @override
  int get hashCode => Object.hash(
    isPressed,
    isHovered,
    isFocused,
    isSelected,
    isDisabled,
    isDragged,
    isError,
  );

  @override
  String toString() =>
      'InteractionState(isPressed: $isPressed, isHovered: $isHovered, '
      'isFocused: $isFocused, isSelected: $isSelected, '
      'isDisabled: $isDisabled, isDragged: $isDragged, isError: $isError)';
}
