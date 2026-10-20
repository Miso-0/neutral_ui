import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../list_tile/list_tile.dart';
import '../localizations/neutral_localizations.dart';
import '../styles/expansion_tile_style.dart';
import '../theme/navigation_themes.dart';

/// A list tile whose children smoothly expand beneath its header.
class ExpansionTile extends StatefulWidget {
  /// Creates expansion tile.
  const ExpansionTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.children = const <Widget>[],
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.enabled = true,
    this.controller,
    this.style,
    this.decoration,
    this.showTrailingIcon = true,
    this.clipBehavior = Clip.hardEdge,
  });

  /// The title for this component.
  final Widget title;

  /// The leading for this component.
  final Widget? leading;

  /// The subtitle for this component.
  final Widget? subtitle;

  /// The trailing for this component.
  final Widget? trailing;

  /// The children for this component.
  final List<Widget> children;

  /// The on expansion changed for this component.
  final ValueChanged<bool>? onExpansionChanged;

  /// The initially expanded for this component.
  final bool initiallyExpanded;

  /// The maintain state for this component.
  final bool maintainState;

  /// The enabled for this component.
  final bool enabled;

  /// The controller for this component.
  final ExpansibleController? controller;

  /// The style for this component.
  final ExpansionTileStyle? style;

  /// The decoration for this component.
  final BoxDecoration? decoration;

  /// The show trailing icon for this component.
  final bool showTrailingIcon;

  /// The clip behavior for this component.
  final Clip clipBehavior;
  @override
  State<ExpansionTile> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile> {
  late ExpansibleController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ExpansibleController();
    if (widget.initiallyExpanded) _controller.expand();
    _controller.addListener(_changed);
  }

  @override
  void didUpdateWidget(ExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final bool expanded = _controller.isExpanded;
      _controller.removeListener(_changed);
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? ExpansibleController();
      if (expanded) _controller.expand();
      _controller.addListener(_changed);
    }
  }

  void _changed() {
    if (mounted) {
      setState(() {});
      widget.onExpansionChanged?.call(_controller.isExpanded);
    }
  }

  void _toggle() {
    if (_controller.isExpanded) {
      _controller.collapse();
    } else {
      _controller.expand();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'ExpansionTile',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    final ExpansionTileStyle style =
        widget.style?.merge(ExpansionTileTheme.of(context)) ??
        ExpansionTileTheme.of(context);
    final Duration duration = reducedMotionDuration(
      context,
      style.animationDuration ?? const Duration(milliseconds: 200),
    );
    final NeutralLocalizations localizations = NeutralLocalizations.of(context);
    final Decoration? decoration =
        widget.decoration ??
        style.decoration?.resolve(
          InteractionState(
            isSelected: _controller.isExpanded,
            isDisabled: !widget.enabled,
          ),
        );
    return AnimatedSurface(
      duration: duration,
      curve: style.animationCurve ?? Curves.easeInOut,
      padding: style.padding,
      decoration: decoration,
      clipBehavior: decoration == null ? Clip.none : widget.clipBehavior,
      child: Expansible(
        controller: _controller,
        animationStyle: AnimationStyle(
          duration: duration,
          curve: style.animationCurve ?? Curves.easeInOut,
        ),
        maintainState: widget.maintainState,
        headerBuilder: (BuildContext context, Animation<double> animation) =>
            Semantics(
              expanded: _controller.isExpanded,
              liveRegion: true,
              hint: _controller.isExpanded
                  ? localizations.expansionTileExpandedTapHint
                  : localizations.expansionTileCollapsedTapHint,
              onExpand: widget.enabled && !_controller.isExpanded
                  ? _toggle
                  : null,
              onCollapse: widget.enabled && _controller.isExpanded
                  ? _toggle
                  : null,
              child: ListTile(
                title: widget.title,
                subtitle: widget.subtitle,
                leading: widget.leading,
                enabled: widget.enabled,
                onTap: widget.enabled ? _toggle : null,
                style: style.tileStyle,
                trailing:
                    widget.trailing ??
                    (widget.showTrailingIcon
                        ? RotationTransition(
                            turns: animation.drive(
                              Tween<double>(begin: 0, end: 0.5),
                            ),
                            child: const ChevronGlyph(
                              direction: GlyphDirection.down,
                            ),
                          )
                        : null),
              ),
            ),
        bodyBuilder: (BuildContext context, Animation<double> animation) =>
            Padding(
              padding: style.childrenPadding ?? EdgeInsets.zero,
              child: Align(
                alignment:
                    style.expandedAlignment ?? AlignmentDirectional.centerStart,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      style.expandedCrossAxisAlignment ??
                      CrossAxisAlignment.center,
                  children: widget.children,
                ),
              ),
            ),
      ),
    );
  }
}
