import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'button_style.dart';

/// Appearance and motion tokens shared by the chip family.
@immutable
class ChipStyle {
  /// Creates chip style.
  const ChipStyle({
    this.buttonStyle,
    this.deleteButtonStyle,
    this.avatarSize,
    this.spacing,
    this.selectedIcon,
    this.deleteIcon,
    this.animationDuration,
    this.animationCurve,
  });

  /// The button style token.
  final ButtonStyle? buttonStyle;

  /// The delete button style token.
  final ButtonStyle? deleteButtonStyle;

  /// The avatar size token.
  final double? avatarSize;

  /// The spacing token.
  final double? spacing;

  /// The selected icon token.
  final StateProperty<Widget?>? selectedIcon;

  /// The delete icon token.
  final StateProperty<Widget?>? deleteIcon;

  /// The animation duration token.
  final Duration? animationDuration;

  /// The animation curve token.
  final Curve? animationCurve;

  /// Returns a copy with the supplied non-null tokens replaced.
  ChipStyle copyWith({
    ButtonStyle? buttonStyle,
    ButtonStyle? deleteButtonStyle,
    double? avatarSize,
    double? spacing,
    StateProperty<Widget?>? selectedIcon,
    StateProperty<Widget?>? deleteIcon,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => ChipStyle(
    buttonStyle: buttonStyle ?? this.buttonStyle,
    deleteButtonStyle: deleteButtonStyle ?? this.deleteButtonStyle,
    avatarSize: avatarSize ?? this.avatarSize,
    spacing: spacing ?? this.spacing,
    selectedIcon: selectedIcon ?? this.selectedIcon,
    deleteIcon: deleteIcon ?? this.deleteIcon,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Inherits unset tokens while retaining this style's values.
  ChipStyle merge(ChipStyle? other) => other == null
      ? this
      : ChipStyle(
          buttonStyle:
              buttonStyle?.merge(other.buttonStyle) ?? other.buttonStyle,
          deleteButtonStyle:
              deleteButtonStyle?.merge(other.deleteButtonStyle) ??
              other.deleteButtonStyle,
          avatarSize: avatarSize ?? other.avatarSize,
          spacing: spacing ?? other.spacing,
          selectedIcon: selectedIcon ?? other.selectedIcon,
          deleteIcon: deleteIcon ?? other.deleteIcon,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
        );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChipStyle &&
          buttonStyle == other.buttonStyle &&
          deleteButtonStyle == other.deleteButtonStyle &&
          avatarSize == other.avatarSize &&
          spacing == other.spacing &&
          selectedIcon == other.selectedIcon &&
          deleteIcon == other.deleteIcon &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;
  @override
  int get hashCode => Object.hashAll(<Object?>[
    buttonStyle,
    deleteButtonStyle,
    avatarSize,
    spacing,
    selectedIcon,
    deleteIcon,
    animationDuration,
    animationCurve,
  ]);
  @override
  String toString() =>
      'ChipStyle(buttonStyle: $buttonStyle, deleteButtonStyle: $deleteButtonStyle, avatarSize: $avatarSize, spacing: $spacing, selectedIcon: $selectedIcon, deleteIcon: $deleteIcon, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
