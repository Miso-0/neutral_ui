import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../buttons/text_button.dart';
import '../dates/date.dart';
import '../feedback/dialog.dart';
import '../foundation/glyphs.dart';
import '../foundation/motion.dart';
import '../input/text_field.dart';
import '../localizations/neutral_localizations.dart';
import '../menus/key_activators.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_host.dart';
import '../overlay/overlay_placement.dart';
import '../styles/date_picker_style.dart';
import '../styles/text_field_style.dart';
import '../theme/picker_themes.dart';
import 'calendar_date_picker.dart';

/// A date field which opens a calendar in the root overlay.
class DatePickerField extends StatefulWidget {
  /// Creates an anchored date field.
  const DatePickerField({
    super.key,
    this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.currentDate,
    this.selectableDayPredicate,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
    this.fieldStyle,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.labelText,
    this.hintText,
  });

  /// Date displayed by the field.
  final DateTime? value;

  /// First selectable date.
  final DateTime firstDate;

  /// Last selectable date.
  final DateTime lastDate;

  /// Called when a date is chosen.
  final ValueChanged<DateTime>? onChanged;

  /// Overrides the date marked as today.
  final DateTime? currentDate;

  /// Additional selection constraint.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Calendar arithmetic and formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Calendar and overlay tokens.
  final DatePickerStyle? style;

  /// Text field appearance tokens.
  final TextFieldStyle? fieldStyle;

  /// Optional external trigger focus node.
  final FocusNode? focusNode;

  /// Whether the field can open its picker.
  final bool enabled;

  /// Whether the field requests initial focus.
  final bool autofocus;

  /// Optional field label.
  final String? labelText;

  /// Text displayed when no date is selected.
  final String? hintText;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode(debugLabel: 'Date field');
  final FocusScopeNode _panelFocus = FocusScopeNode(
    debugLabel: 'Date picker popover',
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );
  late final AnimationController _motion;
  late final CurvedAnimation _curve;
  DateTime? _date;
  bool _closing = false;

  DatePickerStyle get _style => (widget.style ?? const DatePickerStyle()).merge(
    DatePickerTheme.of(context),
  );

  @override
  void initState() {
    super.initState();
    _date = widget.value;
    _motion = AnimationController(vsync: this);
    _curve = CurvedAnimation(
      parent: _motion,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncText();
    if (_portal.isShowing &&
        (!TickerMode.valuesOf(context).enabled ||
            ModalRoute.isCurrentOf(context) == false)) {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) _close();
      });
    }
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _date = widget.value;
    _syncText();
    if (!widget.enabled && _portal.isShowing) _close();
  }

  void _syncText() {
    _text.text = _date == null
        ? ''
        : widget.calendarDelegate.formatShortDate(
            _date!,
            NeutralLocalizations.of(context),
          );
  }

  void _open() {
    if (!widget.enabled) return;
    _closing = false;
    _motion.duration = reducedMotionDuration(
      context,
      _style.transitionDuration ?? const Duration(milliseconds: 150),
    );
    _motion.reverseDuration = reducedMotionDuration(
      context,
      _style.reverseTransitionDuration ?? const Duration(milliseconds: 100),
    );
    _portal.show();
    _motion.forward();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted && _portal.isShowing) _panelFocus.requestFocus();
    });
  }

  Future<void> _close() async {
    if (!_portal.isShowing || _closing) return;
    _closing = true;
    if (!TickerMode.valuesOf(context).enabled ||
        ModalRoute.isCurrentOf(context) == false) {
      _motion.value = 0;
    } else {
      await _motion.reverse();
    }
    if (!mounted || !_closing) return;
    final bool restore =
        _panelFocus.hasFocus &&
        TickerMode.valuesOf(context).enabled &&
        ModalRoute.isCurrentOf(context) != false;
    _portal.hide();
    _closing = false;
    if (restore) (widget.focusNode ?? _focus).requestFocus();
  }

  @override
  void dispose() {
    _curve.dispose();
    _motion.dispose();
    _focus.dispose();
    _panelFocus.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatePickerStyle style = _style;
    _curve.curve = style.transitionCurve ?? Curves.easeOutCubic;
    _curve.reverseCurve = style.reverseTransitionCurve ?? Curves.easeInCubic;
    return OverlayHost(
      controller: _portal,
      placement:
          style.placement ??
          const OverlayPlacement(overflow: OverlayOverflow.keepSize),
      overlayLocation: OverlayLocation.root,
      outsideTapBehavior:
          style.outsideTapBehavior ?? OutsideTapBehavior.passThrough,
      onTapOutside: (PointerDownEvent event) => _close(),
      overlayBuilder: (BuildContext context) => AnimatedBuilder(
        animation: _curve,
        builder: (BuildContext context, Widget? child) =>
            style.transitionBuilder?.call(context, _curve, child!) ??
            overlayTransition(context, _curve, child!),
        child: Shortcuts(
          shortcuts: <ShortcutActivator, Intent>{
            menuKeyActivator(0x10000001b): const DismissIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (DismissIntent intent) {
                  _close();
                  return null;
                },
              ),
            },
            child: FocusScope(
              node: _panelFocus,
              child: CalendarDatePicker(
                initialDate: _date,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                currentDate: widget.currentDate,
                selectableDayPredicate: widget.selectableDayPredicate,
                calendarDelegate: widget.calendarDelegate,
                style: style,
                autofocus: true,
                onDateChanged: (DateTime date) {
                  setState(() {
                    _date = date;
                    _syncText();
                  });
                  widget.onChanged?.call(date);
                  _close();
                },
              ),
            ),
          ),
        ),
      ),
      child: TextField(
        controller: _text,
        focusNode: widget.focusNode ?? _focus,
        readOnly: true,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        style: widget.fieldStyle,
        labelText: widget.labelText,
        hintText:
            widget.hintText ?? NeutralLocalizations.of(context).dateHelpText,
        suffixIcon: IconButton(
          onPressed: widget.enabled ? _open : null,
          tooltip: NeutralLocalizations.of(context).datePickerHelpText,
          icon: const CalendarGlyph(),
        ),
        onTap: _open,
      ),
    );
  }
}

/// A compact date input with localized parsing and form validation.
class InputDatePickerFormField extends StatefulWidget {
  /// Creates a date input within inclusive bounds.
  const InputDatePickerFormField({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateSubmitted,
    this.onDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.autofocus = false,
    this.acceptEmptyDate = false,
    this.focusNode,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  /// Initially formatted date.
  final DateTime? initialDate;

  /// First valid date, inclusive.
  final DateTime firstDate;

  /// Last valid date, inclusive.
  final DateTime lastDate;

  /// Called after submitting a valid date.
  final ValueChanged<DateTime>? onDateSubmitted;

  /// Called when the enclosing form saves a valid date.
  final ValueChanged<DateTime>? onDateSaved;

  /// Additional validation constraint.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Overrides the localized parse error.
  final String? errorFormatText;

  /// Overrides the localized invalid-date error.
  final String? errorInvalidText;

  /// Overrides the compact date format hint.
  final String? fieldHintText;

  /// Overrides the localized input label.
  final String? fieldLabelText;

  /// Whether the input requests initial focus.
  final bool autofocus;

  /// Whether an empty input is valid.
  final bool acceptEmptyDate;

  /// Optional external focus node.
  final FocusNode? focusNode;

  /// Calendar arithmetic and localized parsing.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Text field appearance tokens.
  final TextFieldStyle? style;

  /// When to automatically validate input.
  final AutovalidateMode autovalidateMode;

  @override
  State<InputDatePickerFormField> createState() =>
      InputDatePickerFormFieldState();
}

/// State exposing validation and save for a compact date input.
class InputDatePickerFormFieldState extends State<InputDatePickerFormField> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormFieldState<String>> _field =
      GlobalKey<FormFieldState<String>>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.initialDate != null) {
        _controller.text = widget.calendarDelegate.formatCompactDate(
          widget.initialDate!,
          NeutralLocalizations.of(context),
        );
      }
    }
  }

  @override
  void didUpdateWidget(InputDatePickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate ||
        widget.calendarDelegate != oldWidget.calendarDelegate) {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (!mounted) return;
        _controller.text = widget.initialDate == null
            ? ''
            : widget.calendarDelegate.formatCompactDate(
                widget.calendarDelegate.dateOnly(widget.initialDate!),
                NeutralLocalizations.of(context),
              );
      });
    }
  }

  DateTime? _parse(String? value) {
    final DateTime? date = widget.calendarDelegate.parseCompactDate(
      value,
      NeutralLocalizations.of(context),
    );
    return date == null ? null : widget.calendarDelegate.dateOnly(date);
  }

  String? _validate(String? value) {
    final NeutralLocalizations l = NeutralLocalizations.of(context);
    if (widget.acceptEmptyDate && (value?.trim().isEmpty ?? true)) return null;
    final DateTime? date = _parse(value);
    if (date == null) return widget.errorFormatText ?? l.invalidDateFormatLabel;
    if (date.isBefore(widget.calendarDelegate.dateOnly(widget.firstDate)) ||
        date.isAfter(widget.calendarDelegate.dateOnly(widget.lastDate)) ||
        !(widget.selectableDayPredicate?.call(date) ?? true)) {
      return widget.errorInvalidText ?? l.dateOutOfRangeLabel;
    }
    return null;
  }

  /// Validates the current text and displays the localized error if invalid.
  bool validate() => _field.currentState?.validate() ?? false;

  /// Saves a valid date through [InputDatePickerFormField.onDateSaved].
  void save() => _field.currentState?.save();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NeutralLocalizations l = NeutralLocalizations.of(context);
    return TextFormField(
      key: _field,
      controller: _controller,
      focusNode: widget.focusNode,
      style: widget.style,
      autofocus: widget.autofocus,
      labelText: widget.fieldLabelText ?? l.dateInputLabel,
      hintText: widget.fieldHintText ?? widget.calendarDelegate.dateHelpText(l),
      autovalidateMode: widget.autovalidateMode,
      validator: _validate,
      onSaved: (String? value) {
        final DateTime? date = _parse(value);
        if (_validate(value) == null && date != null) {
          widget.onDateSaved?.call(date);
        }
      },
      onFieldSubmitted: (String value) {
        if (validate()) {
          final DateTime? date = _parse(value);
          if (date != null) widget.onDateSubmitted?.call(date);
        }
      },
    );
  }
}

/// A modal date picker with calendar and validated text entry modes.
class DatePickerDialog extends StatefulWidget {
  /// Creates a date picker dialog.
  const DatePickerDialog({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.initialCalendarMode = DatePickerMode.day,
    this.selectableDayPredicate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.onDatePickerModeChange,
    this.style,
    this.restorationId,
  });

  /// Initially selected date.
  final DateTime? initialDate;

  /// First selectable date.
  final DateTime firstDate;

  /// Last selectable date.
  final DateTime lastDate;

  /// Overrides the date marked as today.
  final DateTime? currentDate;

  /// Initial calendar or input entry mode.
  final DatePickerEntryMode initialEntryMode;

  /// Initial calendar day or year mode.
  final DatePickerMode initialCalendarMode;

  /// Additional date selection constraint.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Overrides the dialog help text.
  final String? helpText;

  /// Overrides the cancel label.
  final String? cancelText;

  /// Overrides the confirm label.
  final String? confirmText;

  /// Overrides the localized parse error.
  final String? errorFormatText;

  /// Overrides the localized invalid-date error.
  final String? errorInvalidText;

  /// Overrides the compact date format hint.
  final String? fieldHintText;

  /// Overrides the input field label.
  final String? fieldLabelText;

  /// Calendar arithmetic and formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Reports changes to the entry mode.
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange;

  /// Picker appearance tokens.
  final DatePickerStyle? style;

  /// Reserved restoration scope identifier.
  final String? restorationId;

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  late DatePickerEntryMode _mode;
  DateTime? _selected;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool get _input =>
      _mode == DatePickerEntryMode.input ||
      _mode == DatePickerEntryMode.inputOnly;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialEntryMode;
    _selected = widget.initialDate == null
        ? null
        : widget.calendarDelegate.dateOnly(widget.initialDate!);
  }

  void _confirm() {
    if (_input) {
      if (!(_form.currentState?.validate() ?? false)) return;
      _form.currentState!.save();
    }
    if (_selected != null) Navigator.of(context).pop(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final NeutralLocalizations l = NeutralLocalizations.of(context);
    final DatePickerStyle style = (widget.style ?? const DatePickerStyle())
        .merge(DatePickerTheme.of(context));
    final bool canToggle =
        _mode != DatePickerEntryMode.calendarOnly &&
        _mode != DatePickerEntryMode.inputOnly;
    return Dialog(
      child: SizedBox(
        width: style.monthWidth ?? 336,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.helpText ?? l.datePickerHelpText,
                      style: style.headerTextStyle,
                    ),
                  ),
                  if (canToggle)
                    IconButton(
                      style: style.entryModeButtonStyle,
                      tooltip: _input
                          ? l.calendarModeButtonLabel
                          : l.inputDateModeButtonLabel,
                      onPressed: () {
                        if (_input &&
                            (_form.currentState?.validate() ?? false)) {
                          _form.currentState!.save();
                        }
                        setState(() {
                          _mode = _input
                              ? DatePickerEntryMode.calendar
                              : DatePickerEntryMode.input;
                        });
                        widget.onDatePickerModeChange?.call(_mode);
                      },
                      icon: _input ? const CalendarGlyph() : const EditGlyph(),
                    ),
                ],
              ),
              Semantics(
                liveRegion: true,
                child: Text(
                  _selected == null
                      ? l.unspecifiedDate
                      : widget.calendarDelegate.formatMediumDate(_selected!, l),
                  style: style.headerTextStyle,
                ),
              ),
              if (_input)
                Form(
                  key: _form,
                  child: InputDatePickerFormField(
                    initialDate: _selected,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    calendarDelegate: widget.calendarDelegate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    errorFormatText: widget.errorFormatText,
                    errorInvalidText: widget.errorInvalidText,
                    fieldHintText: widget.fieldHintText,
                    fieldLabelText: widget.fieldLabelText,
                    autofocus: true,
                    onDateSaved: (DateTime date) {
                      _selected = date;
                    },
                    onDateSubmitted: (DateTime date) {
                      _selected = date;
                      _confirm();
                    },
                  ),
                )
              else
                CalendarDatePicker(
                  initialDate: _selected,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  currentDate: widget.currentDate,
                  initialCalendarMode: widget.initialCalendarMode,
                  selectableDayPredicate: widget.selectableDayPredicate,
                  calendarDelegate: widget.calendarDelegate,
                  style: style,
                  autofocus: true,
                  onDateChanged: (DateTime date) => setState(() {
                    _selected = date;
                  }),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(widget.cancelText ?? l.cancelButtonLabel),
                  ),
                  TextButton(
                    onPressed: _input || _selected != null ? _confirm : null,
                    child: Text(widget.confirmText ?? l.okButtonLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a modal date picker and returns the confirmed date, or null on cancel.
Future<DateTime?> showDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  Offset? anchorPoint,
  bool barrierDismissible = true,
  String? barrierLabel,
  ValueChanged<DatePickerEntryMode>? onDatePickerModeChange,
  CalendarDelegate<DateTime> calendarDelegate =
      const GregorianCalendarDelegate(),
  DatePickerStyle? style,
}) {
  initialDate = initialDate == null
      ? null
      : calendarDelegate.dateOnly(initialDate);
  firstDate = calendarDelegate.dateOnly(firstDate);
  lastDate = calendarDelegate.dateOnly(lastDate);
  currentDate = calendarDelegate.dateOnly(
    currentDate ?? calendarDelegate.now(),
  );
  assert(!lastDate.isBefore(firstDate));
  assert(
    initialDate == null ||
        (!initialDate.isBefore(firstDate) && !initialDate.isAfter(lastDate)),
  );
  assert(
    initialDate == null ||
        selectableDayPredicate == null ||
        selectableDayPredicate(initialDate),
  );
  Widget dialog = DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    initialCalendarMode: initialDatePickerMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
    onDatePickerModeChange: onDatePickerModeChange,
    calendarDelegate: calendarDelegate,
    style: style,
  );
  if (textDirection != null) {
    dialog = Directionality(textDirection: textDirection, child: dialog);
  }
  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }
  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    builder: (BuildContext context) => builder?.call(context, dialog) ?? dialog,
  );
}
