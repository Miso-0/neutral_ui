import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';

/// The vertical alignment of a tile's leading and trailing content.
enum ListTileTitleAlignment {
  /// Aligns at the top for three-line tiles and at the center otherwise.
  threeLine,

  /// Aligns at the top of the tile's content.
  top,

  /// Aligns at the center of the tile's content.
  center,

  /// Aligns at the bottom of the tile's content.
  bottom,
}

/// Tokens for the structure and appearance of a list tile.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
@immutable
class ListTileStyle {
  /// Creates a collection of optional component tokens.
  const ListTileStyle({
    this.decoration,
    this.foregroundDecoration,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.leadingAndTrailingTextStyle,
    this.iconTheme,
    this.mouseCursor,
    this.contentPadding,
    this.minVerticalPadding,
    this.horizontalTitleGap,
    this.minLeadingWidth,
    this.subtitleSpacing,
    this.minTileHeight,
    this.minTwoLineTileHeight,
    this.minThreeLineTileHeight,
    this.titleAlignment,
    this.animationDuration,
    this.animationCurve,
    this.enableFeedback,
  });

  /// The decoration behind the tile.
  final StateProperty<Decoration?>? decoration;

  /// The decoration painted over the tile.
  final StateProperty<Decoration?>? foregroundDecoration;

  /// The text style inherited by the title.
  final StateProperty<TextStyle?>? titleTextStyle;

  /// The text style inherited by the subtitle.
  final StateProperty<TextStyle?>? subtitleTextStyle;

  /// The text style inherited by the leading and trailing slots.
  final StateProperty<TextStyle?>? leadingAndTrailingTextStyle;

  /// The icon theme inherited by the tile.
  final StateProperty<IconThemeData?>? iconTheme;

  /// The pointer cursor for the current interaction state.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// The inset around all tile content.
  final EdgeInsetsGeometry? contentPadding;

  /// The minimum vertical inset around every slot.
  final double? minVerticalPadding;

  /// The gap between text and an adjacent slot.
  final double? horizontalTitleGap;

  /// The minimum width of the leading slot.
  final double? minLeadingWidth;

  /// The vertical gap between title and subtitle.
  final double? subtitleSpacing;

  /// The minimum height of a one-line tile.
  final double? minTileHeight;

  /// The minimum height of a two-line tile.
  final double? minTwoLineTileHeight;

  /// The minimum height of a three-line tile.
  final double? minThreeLineTileHeight;

  /// The vertical alignment of the leading and trailing slots.
  final ListTileTitleAlignment? titleAlignment;

  /// The duration of visual transitions.
  final Duration? animationDuration;

  /// The curve of visual transitions.
  final Curve? animationCurve;

  /// Whether interactions provide platform feedback.
  final bool? enableFeedback;

  /// Returns a copy with the supplied non-null tokens replaced.
  ListTileStyle copyWith({
    StateProperty<Decoration?>? decoration,
    StateProperty<Decoration?>? foregroundDecoration,
    StateProperty<TextStyle?>? titleTextStyle,
    StateProperty<TextStyle?>? subtitleTextStyle,
    StateProperty<TextStyle?>? leadingAndTrailingTextStyle,
    StateProperty<IconThemeData?>? iconTheme,
    StateProperty<MouseCursor?>? mouseCursor,
    EdgeInsetsGeometry? contentPadding,
    double? minVerticalPadding,
    double? horizontalTitleGap,
    double? minLeadingWidth,
    double? subtitleSpacing,
    double? minTileHeight,
    double? minTwoLineTileHeight,
    double? minThreeLineTileHeight,
    ListTileTitleAlignment? titleAlignment,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableFeedback,
  }) {
    return ListTileStyle(
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      leadingAndTrailingTextStyle:
          leadingAndTrailingTextStyle ?? this.leadingAndTrailingTextStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      contentPadding: contentPadding ?? this.contentPadding,
      minVerticalPadding: minVerticalPadding ?? this.minVerticalPadding,
      horizontalTitleGap: horizontalTitleGap ?? this.horizontalTitleGap,
      minLeadingWidth: minLeadingWidth ?? this.minLeadingWidth,
      subtitleSpacing: subtitleSpacing ?? this.subtitleSpacing,
      minTileHeight: minTileHeight ?? this.minTileHeight,
      minTwoLineTileHeight: minTwoLineTileHeight ?? this.minTwoLineTileHeight,
      minThreeLineTileHeight:
          minThreeLineTileHeight ?? this.minThreeLineTileHeight,
      titleAlignment: titleAlignment ?? this.titleAlignment,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableFeedback: enableFeedback ?? this.enableFeedback,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  ListTileStyle merge(ListTileStyle? other) {
    if (other == null) {
      return this;
    }
    return ListTileStyle(
      decoration: decoration ?? other.decoration,
      foregroundDecoration: foregroundDecoration ?? other.foregroundDecoration,
      titleTextStyle: titleTextStyle ?? other.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? other.subtitleTextStyle,
      leadingAndTrailingTextStyle:
          leadingAndTrailingTextStyle ?? other.leadingAndTrailingTextStyle,
      iconTheme: iconTheme ?? other.iconTheme,
      mouseCursor: mouseCursor ?? other.mouseCursor,
      contentPadding: contentPadding ?? other.contentPadding,
      minVerticalPadding: minVerticalPadding ?? other.minVerticalPadding,
      horizontalTitleGap: horizontalTitleGap ?? other.horizontalTitleGap,
      minLeadingWidth: minLeadingWidth ?? other.minLeadingWidth,
      subtitleSpacing: subtitleSpacing ?? other.subtitleSpacing,
      minTileHeight: minTileHeight ?? other.minTileHeight,
      minTwoLineTileHeight: minTwoLineTileHeight ?? other.minTwoLineTileHeight,
      minThreeLineTileHeight:
          minThreeLineTileHeight ?? other.minThreeLineTileHeight,
      titleAlignment: titleAlignment ?? other.titleAlignment,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
      enableFeedback: enableFeedback ?? other.enableFeedback,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ListTileStyle &&
            decoration == other.decoration &&
            foregroundDecoration == other.foregroundDecoration &&
            titleTextStyle == other.titleTextStyle &&
            subtitleTextStyle == other.subtitleTextStyle &&
            leadingAndTrailingTextStyle == other.leadingAndTrailingTextStyle &&
            iconTheme == other.iconTheme &&
            mouseCursor == other.mouseCursor &&
            contentPadding == other.contentPadding &&
            minVerticalPadding == other.minVerticalPadding &&
            horizontalTitleGap == other.horizontalTitleGap &&
            minLeadingWidth == other.minLeadingWidth &&
            subtitleSpacing == other.subtitleSpacing &&
            minTileHeight == other.minTileHeight &&
            minTwoLineTileHeight == other.minTwoLineTileHeight &&
            minThreeLineTileHeight == other.minThreeLineTileHeight &&
            titleAlignment == other.titleAlignment &&
            animationDuration == other.animationDuration &&
            animationCurve == other.animationCurve &&
            enableFeedback == other.enableFeedback;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    foregroundDecoration,
    titleTextStyle,
    subtitleTextStyle,
    leadingAndTrailingTextStyle,
    iconTheme,
    mouseCursor,
    contentPadding,
    minVerticalPadding,
    horizontalTitleGap,
    minLeadingWidth,
    subtitleSpacing,
    minTileHeight,
    minTwoLineTileHeight,
    minThreeLineTileHeight,
    titleAlignment,
    animationDuration,
    animationCurve,
    enableFeedback,
  ]);

  @override
  String toString() =>
      'ListTileStyle(decoration: $decoration, foregroundDecoration: $foregroundDecoration, titleTextStyle: $titleTextStyle, subtitleTextStyle: $subtitleTextStyle, leadingAndTrailingTextStyle: $leadingAndTrailingTextStyle, iconTheme: $iconTheme, mouseCursor: $mouseCursor, contentPadding: $contentPadding, minVerticalPadding: $minVerticalPadding, horizontalTitleGap: $horizontalTitleGap, minLeadingWidth: $minLeadingWidth, subtitleSpacing: $subtitleSpacing, minTileHeight: $minTileHeight, minTwoLineTileHeight: $minTwoLineTileHeight, minThreeLineTileHeight: $minThreeLineTileHeight, titleAlignment: $titleAlignment, animationDuration: $animationDuration, animationCurve: $animationCurve, enableFeedback: $enableFeedback)';
}
