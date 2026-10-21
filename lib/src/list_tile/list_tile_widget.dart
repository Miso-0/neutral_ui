import '../foundation/animated_icon_theme.dart';
import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../styles/list_tile_style.dart';
import '../theme/list_tile_theme.dart';

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A headless row with optional leading, title, subtitle and trailing slots.
class ListTile extends StatelessWidget {
  /// Creates a tile that sizes to its content and resolved style tokens.
  const ListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.enabled = true,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.style,
    this.decoration,
    this.foregroundDecoration,
  }) : assert(!isThreeLine || subtitle != null);

  /// Content preceding the text block in reading order.
  final Widget? leading;

  /// The primary content.
  final Widget? title;

  /// The secondary content below the title.
  final Widget? subtitle;

  /// Content following the text block in reading order.
  final Widget? trailing;

  /// Whether to use the three-line minimum height and alignment.
  final bool isThreeLine;

  /// Whether user interaction is enabled.
  final bool enabled;

  /// Whether this tile represents a selected item.
  final bool selected;

  /// Called when the tile is activated.
  final GestureTapCallback? onTap;

  /// Called when the tile is held.
  final GestureLongPressCallback? onLongPress;

  /// Reports changes to enabled hover state.
  final ValueChanged<bool>? onHover;

  /// Reports raw focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// An externally owned focus node.
  final FocusNode? focusNode;

  /// Whether to request initial focus.
  final bool autofocus;

  /// An externally owned interaction state controller.
  final WidgetStatesController? statesController;

  /// Inline tokens that take precedence over the component theme.
  final ListTileStyle? style;

  /// Replaces the background decoration and theme defaults in every state.
  ///
  /// Must not be supplied with [ListTileStyle.decoration] in [style].
  final BoxDecoration? decoration;

  /// Replaces the foreground decoration and theme defaults in every state.
  ///
  /// Must not be supplied with [ListTileStyle.foregroundDecoration] in [style].
  final BoxDecoration? foregroundDecoration;

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'ListTile',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: decoration,
        styleValue: style?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'ListTile',
        parameter: 'foregroundDecoration',
        styleToken: 'style.foregroundDecoration',
        value: foregroundDecoration,
        styleValue: style?.foregroundDecoration,
      ),
    );
    final List<ListTileStyle?> layers = <ListTileStyle?>[
      ListTileStyle(
        decoration: decorationLayer(decoration),
        foregroundDecoration: decorationLayer(foregroundDecoration),
      ),
      style,
      ListTileTheme.of(context),
    ];
    final bool hasAction = onTap != null || onLongPress != null;
    return Semantics(
      container: true,
      button: hasAction,
      selected: selected,
      enabled: enabled,
      child: InteractionDetector(
        enabled: enabled,
        canRequestFocus: hasAction,
        isSelected: selected,
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        statesController: statesController,
        mouseCursor: StateProperty<MouseCursor?>.resolveWith(
          (InteractionState state) =>
              resolveStateful<ListTileStyle, MouseCursor>(
                state,
                layers,
                (ListTileStyle s) => s.mouseCursor,
              ),
        ),
        enableFeedback:
            resolvePlain<ListTileStyle, bool>(
              layers,
              (ListTileStyle s) => s.enableFeedback,
            ) ??
            true,
        builder: (BuildContext context, InteractionState detected) {
          // A tile without an action shows no hover or press.
          final InteractionState state = hasAction
              ? detected
              : detected.copyWith(isHovered: false, isPressed: false);
          T? plain<T>(T? Function(ListTileStyle) select) =>
              resolvePlain<ListTileStyle, T>(layers, select);
          T? token<T>(StateProperty<T?>? Function(ListTileStyle) select) =>
              resolveStateful<ListTileStyle, T>(state, layers, select);
          final Duration duration = reducedMotionDuration(
            context,
            plain<Duration>((ListTileStyle s) => s.animationDuration) ??
                const Duration(milliseconds: 200),
          );
          final Curve curve =
              plain<Curve>((ListTileStyle s) => s.animationCurve) ??
              Curves.easeInOut;
          final EdgeInsetsGeometry padding =
              plain<EdgeInsetsGeometry>(
                (ListTileStyle s) => s.contentPadding,
              ) ??
              EdgeInsets.zero;
          final double vertical =
              plain<double>((ListTileStyle s) => s.minVerticalPadding) ?? 0;
          final double gap =
              plain<double>((ListTileStyle s) => s.horizontalTitleGap) ?? 0;
          final double oneLine =
              plain<double>((ListTileStyle s) => s.minTileHeight) ?? 0;
          final double twoLine =
              plain<double>((ListTileStyle s) => s.minTwoLineTileHeight) ??
              oneLine;
          final double threeLine =
              plain<double>((ListTileStyle s) => s.minThreeLineTileHeight) ??
              twoLine;
          final double minHeight = isThreeLine
              ? threeLine
              : subtitle != null
              ? twoLine
              : oneLine;
          final ListTileTitleAlignment titleAlignment =
              plain<ListTileTitleAlignment>(
                (ListTileStyle s) => s.titleAlignment,
              ) ??
              ListTileTitleAlignment.threeLine;
          final CrossAxisAlignment alignment = switch (titleAlignment) {
            ListTileTitleAlignment.top => CrossAxisAlignment.start,
            ListTileTitleAlignment.center => CrossAxisAlignment.center,
            ListTileTitleAlignment.bottom => CrossAxisAlignment.end,
            ListTileTitleAlignment.threeLine =>
              isThreeLine
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
          };
          Widget text(Widget child, TextStyle? textStyle) {
            final DefaultTextStyle ambient = DefaultTextStyle.of(context);
            return AnimatedDefaultTextStyle(
              style: ambient.style.merge(textStyle),
              textAlign: ambient.textAlign,
              softWrap: ambient.softWrap,
              overflow: ambient.overflow,
              maxLines: ambient.maxLines,
              duration: duration,
              curve: curve,
              child: child,
            );
          }

          Widget slot(Widget child, {bool leading = false}) => Padding(
            padding: EdgeInsets.symmetric(vertical: vertical),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: leading
                    ? plain<double>((ListTileStyle s) => s.minLeadingWidth) ?? 0
                    : 0,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: 1,
                heightFactor: 1,
                child: text(
                  child,
                  token<TextStyle>(
                    (ListTileStyle s) => s.leadingAndTrailingTextStyle,
                  ),
                ),
              ),
            ),
          );
          return AnimatedSurface(
            duration: duration,
            curve: curve,
            padding: padding,
            decoration: token<Decoration>((ListTileStyle s) => s.decoration),
            foregroundDecoration: token<Decoration>(
              (ListTileStyle s) => s.foregroundDecoration,
            ),
            child: AnimatedIconTheme(
              duration: duration,
              curve: curve,
              data:
                  token<IconThemeData>((ListTileStyle s) => s.iconTheme) ??
                  const IconThemeData(),
              child: Row(
                crossAxisAlignment: alignment,
                children: <Widget>[
                  if (leading != null) ...<Widget>[
                    slot(leading!, leading: true),
                    SizedBox(width: gap),
                  ],
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(
                          0,
                          minHeight -
                              padding
                                  .resolve(Directionality.of(context))
                                  .vertical,
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        heightFactor: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: vertical),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (title != null)
                                text(
                                  title!,
                                  token<TextStyle>(
                                    (ListTileStyle s) => s.titleTextStyle,
                                  ),
                                ),
                              if (subtitle != null) ...<Widget>[
                                if (title != null)
                                  SizedBox(
                                    height:
                                        plain<double>(
                                          (ListTileStyle s) =>
                                              s.subtitleSpacing,
                                        ) ??
                                        0,
                                  ),
                                text(
                                  subtitle!,
                                  token<TextStyle>(
                                    (ListTileStyle s) => s.subtitleTextStyle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (trailing != null) ...<Widget>[
                    SizedBox(width: gap),
                    slot(trailing!),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
