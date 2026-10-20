import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../foundation/animated_icon_theme.dart';
import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/state_property.dart';
import '../foundation/style_resolution.dart';
import '../localizations/pure_localizations.dart';
import '../styles/button_style.dart';
import '../styles/text_field_style.dart';
import '../theme/button_themes.dart';
import '../theme/input_themes.dart';

/// A widgets-layer editable field with state-driven decoration and text slots.
///
/// Input formatter and text input action types are services-layer APIs and are
/// intentionally omitted from the widgets-only public API.
class TextField extends StatefulWidget {
  /// Creates an editable field with optional supporting content.
  const TextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.onTapUpOutside,
    this.enabled = true,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.enableInteractiveSelection = true,
    this.selectAllOnFocus,
    this.showCursor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.autofillHints,
    this.scrollController,
    this.scrollPhysics,
    this.selectionControls,
    this.contextMenuBuilder,
    this.undoController,
    this.restorationId,
    this.groupId = EditableText,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.counterText,
    this.showClearButton = false,
    this.showObscureTextToggle = false,
    this.width,
    this.height,
    this.style,
    this.decoration,
    this.foregroundDecoration,
    this.statesController,
  }) : assert(maxLength == null || maxLength > 0),
       assert(width == null || width >= 0),
       assert(height == null || height >= 0),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(maxLines == null || minLines == null || maxLines >= minLines),
       assert(!expands || (maxLines == null && minLines == null)),
       assert(!obscureText || maxLines == 1),
       assert(label == null || labelText == null);

  /// The text and selection controller.
  final TextEditingController? controller;

  /// An externally owned editable focus node.
  final FocusNode? focusNode;

  /// The keyboard layout requested by the field.
  final TextInputType? keyboardType;

  /// Whether to conceal entered text.
  final bool obscureText;

  /// The single character used to conceal text.
  final String obscuringCharacter;

  /// Whether editing is disabled while selection remains available.
  final bool readOnly;

  /// The maximum number of visible text lines.
  final int? maxLines;

  /// The minimum number of visible text lines.
  final int? minLines;

  /// The maximum number of entered characters.
  final int? maxLength;

  /// Whether the editable expands to its parent height.
  final bool expands;

  /// Reports user changes to the text.
  final ValueChanged<String>? onChanged;

  /// Reports keyboard submission.
  final ValueChanged<String>? onSubmitted;

  /// Overrides the default editing completion behavior.
  final VoidCallback? onEditingComplete;

  /// Runs when the field receives a pointer tap.
  final VoidCallback? onTap;

  /// Handles taps outside the editable tap group.
  final TapRegionCallback? onTapOutside;

  /// Handles releases outside the editable tap group.
  final TapRegionUpCallback? onTapUpOutside;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Whether the field requests initial focus.
  final bool autofocus;

  /// Whether the keyboard may correct spelling.
  final bool autocorrect;

  /// Whether keyboard suggestions are enabled.
  final bool enableSuggestions;

  /// Whether selection gestures are enabled.
  final bool enableInteractiveSelection;

  /// Whether focus selects all text.
  final bool? selectAllOnFocus;

  /// Whether to paint the editing cursor.
  final bool? showCursor;

  /// Alignment of entered text.
  final TextAlign textAlign;

  /// Vertical placement of the text, hint and icons inside the field.
  ///
  /// Defaults to [TextAlignVertical.center] for single-line fields and
  /// [TextAlignVertical.top] for multi-line or expanding fields. Icons and
  /// actions align to the start, center or end by the sign of the value.
  final TextAlignVertical? textAlignVertical;

  /// An explicit direction for entered text.
  final TextDirection? textDirection;

  /// Autofill categories advertised to the platform.
  final Iterable<String>? autofillHints;

  /// The editable text scroll controller.
  final ScrollController? scrollController;

  /// The editable text scrolling physics.
  final ScrollPhysics? scrollPhysics;

  /// Controls for selection handles.
  final TextSelectionControls? selectionControls;

  /// Builds the editing context menu.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// An externally owned undo controller.
  final UndoHistoryController? undoController;

  /// Restoration identifier for the editable text.
  final String? restorationId;

  /// The shared editable tap-region group.
  final Object groupId;

  /// Content immediately before the editable text.
  final Widget? prefix;

  /// Content immediately after the editable text.
  final Widget? suffix;

  /// Leading icon content.
  final Widget? prefixIcon;

  /// Trailing icon content.
  final Widget? suffixIcon;

  /// A custom field label.
  final Widget? label;

  /// The field label text.
  final String? labelText;

  /// The empty field hint.
  final String? hintText;

  /// Supporting text below the field.
  final String? helperText;

  /// Validation error text, also resolving error state.
  final String? errorText;

  /// An explicit character counter label.
  final String? counterText;

  /// Whether nonempty editable text has a clear action.
  final bool showClearButton;

  /// Whether concealed text can be revealed.
  final bool showObscureTextToggle;

  /// The exact width of the field, including its label and supporting text.
  ///
  /// Overrides the width of [TextFieldStyle.minimumSize],
  /// [TextFieldStyle.fixedSize] and [TextFieldStyle.maximumSize]. Like any
  /// width from those tokens, it holds even when the parent offers a larger
  /// width, and the field aligns to the start of that space.
  final double? width;

  /// The exact height of the input box, excluding label and supporting text.
  ///
  /// Overrides the height of [TextFieldStyle.minimumSize],
  /// [TextFieldStyle.fixedSize] and [TextFieldStyle.maximumSize], for single
  /// and multi-line fields alike. Padding, text and side controls adapt to
  /// the available space. Multi-line content scrolls within the box.
  final double? height;

  /// Inline appearance tokens.
  final TextFieldStyle? style;

  /// A decoration applied in every state, overriding themes.
  final BoxDecoration? decoration;

  /// An unconditional foreground decoration.
  final BoxDecoration? foregroundDecoration;

  /// Observes pointer and focus interaction flags.
  final WidgetStatesController? statesController;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _TextFieldSelectionGestureDetectorBuilder(this.state)
    : super(delegate: state);

  final _TextFieldState state;

  @override
  void onUserTap() => state.widget.onTap?.call();
}

class _TextFieldState extends State<TextField>
    with SingleTickerProviderStateMixin
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();
  late final TextSelectionGestureDetectorBuilder _selectionGestures =
      _TextFieldSelectionGestureDetectorBuilder(this);

  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableKey;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled =>
      widget.enabled && widget.enableInteractiveSelection;

  late TextEditingController _controller;
  late FocusNode _focusNode;
  late final AnimationController _labelMotion;
  bool _revealed = false;
  bool _writing = false;
  double? _labelTarget;
  Duration? _labelDuration;
  Curve? _labelCurve;
  TextEditingValue? _previousValue;

  void _syncStates() {
    widget.statesController?.update(WidgetState.focused, _focusNode.hasFocus);
    widget.statesController?.update(
      WidgetState.error,
      widget.errorText != null,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'PureUI TextField');
    _controller.addListener(_textChanged);
    _previousValue = _controller.value;
    _focusNode.addListener(_focusChanged);
    _syncStates();
    _labelMotion = AnimationController(
      vsync: this,
      value: _controller.text.isEmpty && !_focusNode.hasFocus ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_textChanged);
      final TextEditingValue value = _controller.value;
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? TextEditingController.fromValue(value);
      _controller.addListener(_textChanged);
      _previousValue = _controller.value;
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_focusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode =
          widget.focusNode ?? FocusNode(debugLabel: 'PureUI TextField');
      _focusNode.addListener(_focusChanged);
    }
    if (!widget.enabled && _focusNode.hasFocus) _focusNode.unfocus();
    _syncStates();
    _retargetLabel();
  }

  TextFieldStyle get _style =>
      widget.style?.merge(TextFieldTheme.of(context)) ??
      TextFieldTheme.of(context);

  void _retargetLabel() {
    if (!mounted) return;
    final TextFieldStyle style = _style;
    final double target = _focusNode.hasFocus || _controller.text.isNotEmpty
        ? 1
        : 0;
    final Duration duration = reducedMotionDuration(
      context,
      style.animationDuration ?? const Duration(milliseconds: 200),
    );
    final Curve curve = style.animationCurve ?? Curves.easeInOut;
    if (_labelMotion.isAnimating &&
        target == _labelTarget &&
        duration == _labelDuration &&
        curve == _labelCurve) {
      return;
    }
    if (!_labelMotion.isAnimating && _labelMotion.value == target) return;
    _labelTarget = target;
    _labelDuration = duration;
    _labelCurve = curve;
    _labelMotion.animateTo(target, duration: duration, curve: curve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retargetLabel();
  }

  void _textChanged() {
    if (_writing || !mounted) return;
    final TextEditingValue? previous = _previousValue;
    final TextEditingValue current = _controller.value;
    _previousValue = current;
    if (previous != null &&
        previous.text == current.text &&
        previous.composing.isValid &&
        !previous.composing.isCollapsed &&
        (!current.composing.isValid || current.composing.isCollapsed) &&
        widget.maxLength != null &&
        current.text.characters.length > widget.maxLength!) {
      _changed(current.text);
    }
    setState(() {});
    _retargetLabel();
  }

  void _focusChanged() {
    if (!mounted) return;
    _syncStates();
    setState(() {});
    _retargetLabel();
  }

  void _changed(String text) {
    final int? limit = widget.maxLength;
    if (limit != null &&
        text.characters.length > limit &&
        (!_controller.value.composing.isValid ||
            _controller.value.composing.isCollapsed)) {
      final String truncated = text.characters.take(limit).toString();
      _writing = true;
      _controller.value = TextEditingValue(
        text: truncated,
        selection: TextSelection(
          baseOffset: _controller.selection.baseOffset.clamp(
            0,
            truncated.length,
          ),
          extentOffset: _controller.selection.extentOffset.clamp(
            0,
            truncated.length,
          ),
          affinity: _controller.selection.affinity,
          isDirectional: _controller.selection.isDirectional,
        ),
      );
      _writing = false;
      _previousValue = _controller.value;
      text = truncated;
      setState(() {});
    }
    widget.onChanged?.call(text);
  }

  // Field actions stay icon-sized so they never make the field taller.
  static const ButtonStyle _compactAction = ButtonStyle(
    padding: StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
    minimumSize: StateProperty<Size?>.all(Size.zero),
    tapTargetSize: Size.zero,
  );

  BoxConstraints _sizeConstraints(
    TextFieldStyle style,
    InteractionState state,
    bool multiline,
  ) {
    final Size? fixed = style.fixedSize?.resolve(state);
    BoxConstraints size = sizeConstraints(
      minimum: style.minimumSize?.resolve(state),
      maximum: style.maximumSize?.resolve(state),
      fixed: multiline ? null : fixed,
    );
    // Multi-line fields take their height from their lines, so only the
    // fixed width applies to them.
    if (multiline && fixed != null) {
      final double width = size.constrainWidth(fixed.width);
      if (width.isFinite) {
        size = size.copyWith(minWidth: width, maxWidth: width);
      }
    }
    if (widget.width != null) {
      size = size.copyWith(minWidth: widget.width, maxWidth: widget.width);
    }
    if (widget.height != null) {
      size = size.copyWith(minHeight: widget.height, maxHeight: widget.height);
    }
    return size;
  }

  double _lineHeight(
    BuildContext context,
    TextStyle style,
    TextScaler textScaler, {
    bool editable = true,
  }) {
    // Match the typography applied by EditableText and Text, including
    // platform accessibility overrides and the editable's forced strut.
    final TextStyle metrics = style.copyWith(
      height: MediaQuery.maybeLineHeightScaleFactorOverrideOf(context),
      letterSpacing: MediaQuery.maybeLetterSpacingOverrideOf(context),
      wordSpacing: MediaQuery.maybeWordSpacingOverrideOf(context),
      fontWeight: !editable && MediaQuery.boldTextOf(context)
          ? FontWeight.bold
          : null,
    );
    final TextPainter painter = TextPainter(
      text: TextSpan(text: ' ', style: metrics),
      textDirection: widget.textDirection ?? Directionality.of(context),
      textScaler: textScaler,
      locale: Localizations.maybeLocaleOf(context),
      strutStyle: editable
          ? StrutStyle.fromTextStyle(metrics, forceStrutHeight: true)
          : null,
      textHeightBehavior: editable
          ? DefaultTextHeightBehavior.maybeOf(context)
          : DefaultTextStyle.of(context).textHeightBehavior ??
                DefaultTextHeightBehavior.maybeOf(context),
    )..layout();
    final double height = painter.preferredLineHeight;
    painter.dispose();
    return height;
  }

  Widget _inputContent(
    BuildContext context,
    TextFieldStyle style,
    InteractionState state,
    PureLocalizations strings,
    Duration duration,
    bool multiline,
    double alignY,
  ) {
    final TextStyle textStyle = DefaultTextStyle.of(context).style
        .merge(style.textStyle?.resolve(state));
    final TextStyle hintStyle = textStyle.merge(
      style.hintStyle?.resolve(state),
    );
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final double unscaledTextHeight = _lineHeight(
      context,
      textStyle,
      TextScaler.noScaling,
    );
    final bool sameHintMetrics = widget.hintText == null;
    final double unscaledHintHeight = sameHintMetrics
        ? unscaledTextHeight
        : _lineHeight(
            context,
            hintStyle,
            TextScaler.noScaling,
            editable: false,
          );
    final double textHeight = textScaler == TextScaler.noScaling
        ? unscaledTextHeight
        : _lineHeight(context, textStyle, textScaler);
    final double hintHeight = sameHintMetrics
        ? textHeight
        : textScaler == TextScaler.noScaling
        ? unscaledHintHeight
        : _lineHeight(context, hintStyle, textScaler, editable: false);
    final int sideCount =
        <Widget?>[
          widget.prefixIcon,
          widget.prefix,
          widget.suffix,
          widget.suffixIcon,
        ].whereType<Widget>().length +
        (widget.showClearButton &&
                _controller.text.isNotEmpty &&
                !widget.readOnly &&
                widget.enabled
            ? 1
            : 0) +
        (widget.showObscureTextToggle && widget.obscureText ? 1 : 0);
    // Reserve the action's line height before it becomes visible too, so
    // clearing or entering text never changes the typography's fit.
    final bool hasIcons =
        widget.prefixIcon != null ||
        widget.suffixIcon != null ||
        widget.showClearButton ||
        (widget.showObscureTextToggle && widget.obscureText);
    final double spacing = style.spacing ?? 0;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final IconThemeData icons = IconTheme.of(context);
        final double iconSize = icons.size ?? 24;
        final double lineHeight = math.max(
          math.max(textHeight, hintHeight),
          hasIcons ? iconSize : 0,
        );
        final Color cursor =
            style.cursorColor?.resolve(state) ??
            icons.color ??
            textStyle.color ??
            const Color(0xFF000000);
        final EdgeInsets padding =
            (style.contentPadding?.resolve(state) ?? EdgeInsets.zero).resolve(
              Directionality.of(context),
            );
        final double minimumTextWidth = math.min(
          lineHeight,
          box.maxWidth / (sideCount + 1),
        );
        final double horizontalRoom = math.max(
          0,
          box.maxWidth - minimumTextWidth - sideCount * iconSize,
        );
        final double horizontalFit = padding.horizontal == 0
            ? 1
            : math.min(1, horizontalRoom / padding.horizontal);
        final double verticalFit =
            !box.hasBoundedHeight || padding.vertical == 0
            ? 1
            : math.min(
                1,
                math.max(0, box.maxHeight - lineHeight) / padding.vertical,
              );
        return AnimatedPadding(
          duration: duration,
          curve: style.animationCurve ?? Curves.easeInOut,
          padding: EdgeInsets.fromLTRB(
            padding.left * horizontalFit,
            padding.top * verticalFit,
            padding.right * horizontalFit,
            padding.bottom * verticalFit,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double unscaledHeight = math.max(
                unscaledTextHeight,
                unscaledHintHeight,
              );
              final TextScaler fittedTextScaler =
                  !constraints.hasBoundedHeight || unscaledHeight == 0
                  ? textScaler
                  : textScaler.clamp(
                      maxScaleFactor: constraints.maxHeight / unscaledHeight,
                    );
              final double fittedIconSize = math.min(
                iconSize,
                constraints.maxHeight,
              );
              final double textWidth = math.min(
                lineHeight,
                constraints.maxWidth / (sideCount + 1),
              );
              final double fittedSpacing = sideCount == 0
                  ? spacing
                  : math.min(
                      spacing,
                      math.max(
                            0,
                            constraints.maxWidth -
                                textWidth -
                                sideCount * fittedIconSize,
                          ) /
                          sideCount,
                    );
              final double sideWidth = sideCount == 0
                  ? 0
                  : math.max(
                      0,
                      (constraints.maxWidth -
                              textWidth -
                              sideCount * fittedSpacing) /
                          sideCount,
                    );
              Widget side(Widget child) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: sideWidth,
                  maxHeight: constraints.maxHeight,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional(0, alignY),
                  child: child,
                ),
              );
              Widget editable = EditableText(
                key: _editableKey,
                rendererIgnoresPointer: true,
                controller: _controller,
                focusNode: _focusNode,
                readOnly: widget.readOnly || !widget.enabled,
                style: textStyle,
                textScaler: fittedTextScaler,
                cursorColor: cursor,
                backgroundCursorColor: cursor,
                selectionColor: style.selectionColor?.resolve(state),
                cursorWidth: math.min(
                  style.cursorWidth ?? 2,
                  constraints.maxWidth,
                ),
                cursorHeight: style.cursorHeight == null
                    ? null
                    : math.min(style.cursorHeight!, constraints.maxHeight),
                cursorRadius: style.cursorRadius,
                obscureText: widget.obscureText && !_revealed,
                obscuringCharacter: widget.obscuringCharacter,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                expands: widget.expands,
                autofocus: widget.autofocus && widget.enabled,
                autocorrect: widget.autocorrect,
                enableSuggestions: widget.enableSuggestions,
                enableInteractiveSelection: widget.enableInteractiveSelection,
                selectAllOnFocus: widget.selectAllOnFocus,
                showCursor: widget.enabled ? widget.showCursor : false,
                textAlign: widget.textAlign,
                textDirection: widget.textDirection,
                locale: Localizations.maybeLocaleOf(context),
                onChanged: _changed,
                onSubmitted: widget.onSubmitted,
                onEditingComplete: widget.onEditingComplete,
                onTapOutside: widget.onTapOutside,
                onTapUpOutside: widget.onTapUpOutside,
                groupId: widget.groupId,
                scrollController: widget.scrollController,
                scrollPhysics: widget.scrollPhysics,
                scrollPadding: style.scrollPadding ?? EdgeInsets.zero,
                autofillHints: widget.autofillHints,
                selectionControls: widget.selectionControls,
                contextMenuBuilder: widget.contextMenuBuilder,
                undoController: widget.undoController,
                restorationId: widget.restorationId,
              );
              editable = Stack(
                alignment: AlignmentDirectional(-1, alignY),
                children: <Widget>[
                  if (_controller.text.isEmpty && widget.hintText != null)
                    IgnorePointer(
                      child: Text(
                        widget.hintText!,
                        style: hintStyle,
                        textScaler: fittedTextScaler,
                        maxLines: multiline ? widget.maxLines : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  editable,
                ],
              );
              final ButtonStyle actionStyle =
                  (style.actionStyle ?? const ButtonStyle()).merge(
                    _compactAction,
                  );
              Widget action(Widget button) =>
                  side(IconButtonTheme(data: actionStyle, child: button));
              final List<Widget> row = <Widget>[
                if (widget.prefixIcon != null) side(widget.prefixIcon!),
                if (widget.prefix != null) side(widget.prefix!),
                Expanded(child: editable),
                if (widget.suffix != null) side(widget.suffix!),
                if (widget.suffixIcon != null) side(widget.suffixIcon!),
                if (widget.showClearButton &&
                    _controller.text.isNotEmpty &&
                    !widget.readOnly &&
                    widget.enabled)
                  action(
                    IconButton(
                      onPressed: () {
                        _controller.clear();
                        widget.onChanged?.call('');
                        _focusNode.requestFocus();
                      },
                      tooltip: strings.clearButtonTooltip,
                      icon: const CloseGlyph(),
                    ),
                  ),
                if (widget.showObscureTextToggle && widget.obscureText)
                  action(
                    IconButton(
                      onPressed: widget.enabled
                          ? () => setState(() => _revealed = !_revealed)
                          : null,
                      tooltip: _revealed
                          ? strings.hidePasswordTooltip
                          : strings.showPasswordTooltip,
                      icon: EyeGlyph(obscured: !_revealed),
                    ),
                  ),
              ];

              return IconTheme.merge(
                data: IconThemeData(size: fittedIconSize),
                child: Row(
                  crossAxisAlignment: alignY < 0
                      ? CrossAxisAlignment.start
                      : alignY > 0
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < row.length; i++) ...<Widget>[
                      if (i > 0 && fittedSpacing != 0)
                        SizedBox(width: fittedSpacing),
                      row[i],
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'TextField',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    assert(
      debugCheckDecorationOverride(
        widget: 'TextField',
        parameter: 'foregroundDecoration',
        styleToken: 'style.foregroundDecoration',
        value: widget.foregroundDecoration,
        styleValue: widget.style?.foregroundDecoration,
      ),
    );
    final TextFieldStyle style = _style;
    final Duration duration = reducedMotionDuration(
      context,
      style.animationDuration ?? const Duration(milliseconds: 200),
    );
    final PureLocalizations strings = PureLocalizations.of(context);
    return InteractionDetector(
      enabled: widget.enabled,
      canRequestFocus: false,
      isFocused: _focusNode.hasFocus,
      statesController: widget.statesController,
      mouseCursor: style.mouseCursor,
      builder: (BuildContext context, InteractionState interaction) {
        final InteractionState state = interaction.copyWith(
          isFocused: _focusNode.hasFocus,
          isError: widget.errorText != null,
        );
        T? token<T>(T? Function(TextFieldStyle) select) =>
            resolvePlain<TextFieldStyle, T>(<TextFieldStyle>[style], select);
        final bool multiline = widget.expands || widget.maxLines != 1;
        final double alignY =
            (widget.textAlignVertical ??
                    (multiline
                        ? TextAlignVertical.top
                        : TextAlignVertical.center))
                .y;
        final double spacing = style.spacing ?? 0;
        final BoxConstraints size = _sizeConstraints(style, state, multiline);
        final bool fill = widget.expands && !size.hasBoundedHeight;
        Widget field = AnimatedSurface(
          duration: duration,
          curve: style.animationCurve ?? Curves.easeInOut,
          decoration: widget.decoration ?? style.decoration?.resolve(state),
          foregroundDecoration:
              widget.foregroundDecoration ??
              style.foregroundDecoration?.resolve(state),
          clipBehavior:
              (widget.decoration ?? style.decoration?.resolve(state)) == null
              ? Clip.none
              : style.clipBehavior ?? Clip.none,
          child: _inputContent(
            context,
            style,
            state,
            strings,
            duration,
            multiline,
            alignY,
          ),
        );
        if (size.minHeight > 0 || size.hasBoundedHeight) {
          field = ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.minHeight,
              maxHeight: size.maxHeight,
            ),
            child: field,
          );
        }
        field = _selectionGestures.buildGestureDetector(
          behavior: HitTestBehavior.translucent,
          child: field,
        );
        field = TextFieldTapRegion(
          groupId: widget.groupId,
          child: ExcludeFocus(
            excluding: !widget.enabled,
            child: IgnorePointer(ignoring: !widget.enabled, child: field),
          ),
        );
        final Widget? label =
            widget.label ??
            (widget.labelText == null
                ? null
                : Text(
                    widget.labelText!,
                    style: style.labelStyle?.resolve(state),
                  ));
        final TextFieldLabelBehavior behavior =
            style.labelBehavior ?? TextFieldLabelBehavior.above;
        if (label != null && behavior != TextFieldLabelBehavior.none) {
          if (behavior == TextFieldLabelBehavior.floating) {
            field = AnimatedBuilder(
              animation: _labelMotion,
              child: field,
              builder: (BuildContext context, Widget? child) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ExcludeSemantics(
                    excluding: widget.labelText != null,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Transform.translate(
                        offset: Offset(0, (1 - _labelMotion.value) * 12),
                        child: Transform.scale(
                          alignment: AlignmentDirectional.centerStart.resolve(
                            Directionality.of(context),
                          ),
                          scale:
                              1 -
                              _labelMotion.value *
                                  (1 - (style.labelScale ?? 0.8)),
                          child: label,
                        ),
                      ),
                    ),
                  ),
                  if (fill) Flexible(child: child!) else child!,
                ],
              ),
            );
          } else {
            field = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                widget.labelText == null
                    ? label
                    : ExcludeSemantics(child: label),
                if (spacing != 0) SizedBox(height: spacing),
                if (fill) Flexible(child: field) else field,
              ],
            );
          }
        }
        final String? supporting = widget.errorText ?? widget.helperText;
        final String? counter =
            widget.counterText ??
            (widget.maxLength == null
                ? null
                : '${strings.formatDecimal(_controller.text.characters.length)}/${strings.formatDecimal(widget.maxLength!)}');
        if (supporting != null || counter != null) {
          field = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (fill) Flexible(child: field) else field,
              if (spacing != 0) SizedBox(height: spacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: supporting == null
                        ? const SizedBox()
                        : Semantics(
                            container: true,
                            liveRegion: widget.errorText != null,
                            child: Text(
                              supporting,
                              style: widget.errorText != null
                                  ? style.errorStyle?.resolve(state)
                                  : style.helperStyle?.resolve(state),
                            ),
                          ),
                  ),
                  if (counter != null)
                    Text(counter, style: style.counterStyle?.resolve(state)),
                ],
              ),
            ],
          );
        }
        if (size != const BoxConstraints()) {
          // Explicit sizes hold even when the parent offers more space.
          field = Align(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: 1,
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: size.minWidth,
                maxWidth: size.maxWidth,
              ),
              child: field,
            ),
          );
        }
        final IconThemeData? icons = token<IconThemeData>(
          (TextFieldStyle style) => style.iconTheme?.resolve(state),
        );
        if (icons != null) {
          field = AnimatedIconTheme(
            data: icons,
            duration: duration,
            curve: style.animationCurve ?? Curves.easeInOut,
            child: field,
          );
        }
        return Semantics(
          enabled: widget.enabled,
          label: widget.labelText,
          child: field,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_textChanged);
    _focusNode.removeListener(_focusChanged);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _labelMotion.dispose();
    super.dispose();
  }
}

/// A form-integrated TextField with validation, saving and reset support.
class TextFormField extends FormField<String> {
  /// Creates a text form field.
  TextFormField({
    super.key,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    bool obscureText = false,
    String obscuringCharacter = '•',
    bool readOnly = false,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    bool expands = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    VoidCallback? onEditingComplete,
    VoidCallback? onTap,
    super.enabled,
    bool autofocus = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool enableInteractiveSelection = true,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    Iterable<String>? autofillHints,
    super.restorationId,
    Widget? prefix,
    Widget? suffix,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? label,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    String? counterText,
    bool showClearButton = false,
    bool showObscureTextToggle = false,
    double? width,
    double? height,
    TextFieldStyle? style,
    BoxDecoration? decoration,
    BoxDecoration? foregroundDecoration,
    super.onSaved,
    super.validator,
    super.forceErrorText,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  }) : assert(controller == null || initialValue == null),
       super(
         initialValue: controller?.text ?? initialValue ?? '',
         builder: (FormFieldState<String> state) {
           final _TextFormFieldState field = state as _TextFormFieldState;
           return TextField(
             controller: field.effectiveController,
             focusNode: focusNode,
             keyboardType: keyboardType,
             obscureText: obscureText,
             obscuringCharacter: obscuringCharacter,
             readOnly: readOnly,
             maxLines: maxLines,
             minLines: minLines,
             maxLength: maxLength,
             expands: expands,
             onChanged: (String value) {
               if (state.value != value) state.didChange(value);
               onChanged?.call(value);
             },
             onSubmitted: onFieldSubmitted,
             onEditingComplete: onEditingComplete,
             onTap: onTap,
             enabled: enabled,
             autofocus: autofocus,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             enableInteractiveSelection: enableInteractiveSelection,
             textAlign: textAlign,
             textAlignVertical: textAlignVertical,
             textDirection: textDirection,
             autofillHints: autofillHints,
             restorationId: restorationId,
             prefix: prefix,
             suffix: suffix,
             prefixIcon: prefixIcon,
             suffixIcon: suffixIcon,
             label: label,
             labelText: labelText,
             hintText: hintText,
             helperText: helperText,
             errorText: state.errorText ?? errorText,
             counterText: counterText,
             showClearButton: showClearButton,
             showObscureTextToggle: showObscureTextToggle,
             width: width,
             height: height,
             style: style,
             decoration: decoration,
             foregroundDecoration: foregroundDecoration,
           );
         },
       );

  /// The externally owned text controller, if supplied.
  final TextEditingController? controller;

  @override
  FormFieldState<String> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  TextEditingController? _ownedController;
  TextFormField get field => widget as TextFormField;
  TextEditingController get effectiveController =>
      field.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (field.controller == null) {
      _ownedController = TextEditingController(text: field.initialValue);
    }
    effectiveController.addListener(_controllerChanged);
  }

  void _controllerChanged() {
    if (effectiveController.text != value) didChange(effectiveController.text);
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (effectiveController.text != value) {
      effectiveController.text = value ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant TextFormField oldWidget) {
    final TextEditingController oldController =
        oldWidget.controller ?? _ownedController!;
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != field.controller) {
      oldController.removeListener(_controllerChanged);
      if (field.controller == null) {
        _ownedController = TextEditingController.fromValue(oldController.value);
      } else {
        _ownedController?.dispose();
        _ownedController = null;
      }
      effectiveController.addListener(_controllerChanged);
      setValue(effectiveController.text);
    }
  }

  @override
  void reset() {
    effectiveController.text = field.initialValue ?? '';
    super.reset();
  }

  @override
  void dispose() {
    effectiveController.removeListener(_controllerChanged);
    _ownedController?.dispose();
    super.dispose();
  }
}
