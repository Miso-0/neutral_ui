import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../foundation/animated_icon_theme.dart';
import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../localizations/pure_localizations.dart';
import '../styles/text_field_style.dart';
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
    this.style,
    this.decoration,
    this.foregroundDecoration,
    this.statesController,
  }) : assert(maxLength == null || maxLength > 0),
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

class _TextFieldState extends State<TextField>
    with SingleTickerProviderStateMixin
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();
  late final TextSelectionGestureDetectorBuilder _selectionGestures =
      TextSelectionGestureDetectorBuilder(delegate: this);

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

  Widget _styledText(String text, TextStyle? style) => Text(text, style: style);

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
        final TextStyle textStyle = DefaultTextStyle.of(context).style
            .merge(style.textStyle?.resolve(state));
        final Color cursor =
            style.cursorColor?.resolve(state) ??
            IconTheme.of(context).color ??
            textStyle.color ??
            const Color(0xFF000000);
        Widget editable = EditableText(
          key: _editableKey,
          rendererIgnoresPointer: true,
          controller: _controller,
          focusNode: _focusNode,
          readOnly: widget.readOnly || !widget.enabled,
          style: textStyle,
          cursorColor: cursor,
          backgroundCursorColor: cursor,
          selectionColor: style.selectionColor?.resolve(state),
          cursorWidth: style.cursorWidth ?? 2,
          cursorHeight: style.cursorHeight,
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
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            if (_controller.text.isEmpty && widget.hintText != null)
              IgnorePointer(
                child: _styledText(
                  widget.hintText!,
                  style.hintStyle?.resolve(state),
                ),
              ),
            editable,
          ],
        );
        editable = _selectionGestures.buildGestureDetector(
          behavior: HitTestBehavior.translucent,
          child: editable,
        );
        final double spacing = style.spacing ?? 0;
        final List<Widget> row = <Widget>[
          if (widget.prefixIcon != null) widget.prefixIcon!,
          if (widget.prefix != null) widget.prefix!,
          Expanded(child: editable),
          if (widget.suffix != null) widget.suffix!,
          if (widget.suffixIcon != null) widget.suffixIcon!,
          if (widget.showClearButton &&
              _controller.text.isNotEmpty &&
              !widget.readOnly &&
              widget.enabled)
            IconButton(
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
                _focusNode.requestFocus();
              },
              tooltip: strings.clearButtonTooltip,
              icon: const CloseGlyph(),
            ),
          if (widget.showObscureTextToggle && widget.obscureText)
            IconButton(
              onPressed: widget.enabled
                  ? () => setState(() => _revealed = !_revealed)
                  : null,
              tooltip: _revealed
                  ? strings.hidePasswordTooltip
                  : strings.showPasswordTooltip,
              icon: EyeGlyph(obscured: !_revealed),
            ),
        ];
        Widget field = AnimatedSurface(
          duration: duration,
          curve: style.animationCurve ?? Curves.easeInOut,
          decoration: widget.decoration ?? style.decoration?.resolve(state),
          foregroundDecoration:
              widget.foregroundDecoration ??
              style.foregroundDecoration?.resolve(state),
          padding: style.contentPadding?.resolve(state),
          clipBehavior:
              (widget.decoration ?? style.decoration?.resolve(state)) == null
              ? Clip.none
              : style.clipBehavior ?? Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < row.length; i++) ...<Widget>[
                if (i > 0 && spacing != 0) SizedBox(width: spacing),
                row[i],
              ],
            ],
          ),
        );
        field = TextFieldTapRegion(
          groupId: widget.groupId,
          child: ExcludeFocus(
            excluding: !widget.enabled,
            child: IgnorePointer(
              ignoring: !widget.enabled,
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: widget.enabled
                    ? (PointerDownEvent event) {
                        _focusNode.requestFocus();
                        widget.onTap?.call();
                      }
                    : null,
                child: field,
              ),
            ),
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
                  child!,
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
                field,
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
              field,
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
