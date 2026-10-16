import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../buttons/text_button.dart';
import '../dates/time.dart';
import '../feedback/dialog.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/motion.dart';
import '../foundation/state_property.dart';
import '../input/text_field.dart';
import '../localizations/pure_localizations.dart';
import '../styles/button_style.dart';
import '../styles/text_field_style.dart';
import '../styles/time_picker_style.dart';
import '../theme/picker_themes.dart';
import 'picker_common.dart';

/// An inline time picker with a directly manipulated dial and text entry.
class TimePicker extends StatefulWidget {
  /// Creates a time picker.
  const TimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.onEntryModeChanged,
    this.alwaysUse24HourFormat,
    this.hourLabelText,
    this.minuteLabelText,
    this.errorInvalidText,
    this.style,
    this.decoration,
    this.autofocus = false,
    this.orientation,
  });

  /// Initially displayed time.
  final TimeOfDay initialTime;

  /// Reports valid changes to the selected time.
  final ValueChanged<TimeOfDay> onTimeChanged;

  /// Initial dial or input entry mode.
  final TimePickerEntryMode initialEntryMode;

  /// Reports changes between dial and text entry.
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged;

  /// Overrides the ambient 24-hour preference.
  final bool? alwaysUse24HourFormat;

  /// Overrides the hour input label.
  final String? hourLabelText;

  /// Overrides the minute input label.
  final String? minuteLabelText;

  /// Overrides the localized validation error.
  final String? errorInvalidText;

  /// Appearance and motion tokens.
  final TimePickerStyle? style;

  /// Overrides the picker surface decoration.
  final BoxDecoration? decoration;

  /// Whether the hour input requests initial focus.
  final bool autofocus;

  /// Places controls beside the dial in landscape.
  final Orientation? orientation;

  @override
  State<TimePicker> createState() => TimePickerState();
}

/// State exposing validated time input to an enclosing dialog.
class TimePickerState extends State<TimePicker> with TickerProviderStateMixin {
  late TimeOfDay _time;
  late TimePickerEntryMode _mode;
  bool _hour = true;
  bool _dragging = false;
  bool _inner = false;
  late final AnimationController _angle;
  late final AnimationController _radius;
  final TextEditingController _hours = TextEditingController();
  final TextEditingController _minutes = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _initialized = false;
  bool? _lastUse24;

  TimePickerStyle get _style => (widget.style ?? const TimePickerStyle()).merge(
    TimePickerTheme.of(context),
  );
  bool get _use24 =>
      widget.alwaysUse24HourFormat ??
      MediaQuery.alwaysUse24HourFormatOf(context);
  bool get _input =>
      _mode == TimePickerEntryMode.input ||
      _mode == TimePickerEntryMode.inputOnly;
  double get _targetAngle => (_hour ? _time.hour % 12 / 12 : _time.minute / 60);
  double get _targetRadius =>
      _hour && _use24 && (_time.hour == 0 || _time.hour > 12) ? .55 : .84;

  /// The currently selected valid time.
  TimeOfDay get selectedTime => _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
    _mode = widget.initialEntryMode;
    _angle = AnimationController.unbounded(vsync: this, value: _targetAngle);
    _radius = AnimationController.unbounded(vsync: this, value: .84);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _radius.value = _targetRadius;
      _syncText();
    } else if (_lastUse24 != _use24) {
      _syncText();
      _settle();
    }
    _lastUse24 = _use24;
  }

  @override
  void didUpdateWidget(TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.initialTime != oldWidget.initialTime ||
            widget.alwaysUse24HourFormat != oldWidget.alwaysUse24HourFormat) &&
        !_dragging) {
      if (widget.initialTime != oldWidget.initialTime) {
        _time = widget.initialTime;
      }
      _syncText();
      _settle();
      _lastUse24 = _use24;
    }
  }

  void _syncText() {
    final PureLocalizations l = PureLocalizations.of(context);
    _hours.text = l.formatHour(_time, alwaysUse24HourFormat: _use24);
    _minutes.text = l.formatMinute(_time);
  }

  void _changed(TimeOfDay time) {
    if (_time == time) return;
    setState(() {
      _time = time;
    });
    widget.onTimeChanged(time);
  }

  double _nearestAngle(double target) =>
      target + (_angle.value - target).round();

  void _settle({double? velocity}) {
    if (!mounted) return;
    animateWithSpring(
      context,
      _angle,
      _nearestAngle(_targetAngle),
      velocity: velocity,
      spring: _style.spring ?? MotionSpring.quick,
    );
    animateWithSpring(
      context,
      _radius,
      _targetRadius,
      spring: _style.spring ?? MotionSpring.quick,
    );
  }

  void _selectSegment(bool hour) {
    if (_hour == hour) return;
    setState(() {
      _hour = hour;
    });
    _settle();
  }

  void _adjust(bool hour, int delta) {
    _changed(
      hour
          ? _time.replacing(hour: (_time.hour + delta) % 24)
          : _time.replacing(minute: (_time.minute + delta) % 60),
    );
    _settle();
  }

  void _period(DayPeriod period) {
    if (_time.period == period) return;
    _changed(_time.replacing(hour: (_time.hour + 12) % 24));
    if (!_input) _syncText();
    _settle();
  }

  void _position(Offset position, Size size, {required bool tap}) {
    final Offset point = position - size.center(Offset.zero);
    double turns = math.atan2(point.dx, -point.dy) / (2 * math.pi);
    if (turns < 0) turns += 1;
    _angle.stop();
    _radius.stop();
    _angle.value = _nearestAngle(turns);
    _radius.value = (point.distance / (size.shortestSide / 2)).clamp(0, 1);
    if (_hour) {
      final int dialHour = (turns * 12).round() % 12;
      _inner = _use24 && point.distance < size.shortestSide * .35;
      final int hour = _use24
          ? (_inner
                ? (dialHour == 0 ? 0 : dialHour + 12)
                : (dialHour == 0 ? 12 : dialHour))
          : dialHour + _time.periodOffset;
      _changed(_time.replacing(hour: hour));
    } else {
      final int minute = tap
          ? ((turns * 12).round() * 5) % 60
          : (turns * 60).round() % 60;
      _changed(_time.replacing(minute: minute));
    }
  }

  void _release(Offset velocity, Size size) {
    final double radians = _angle.value * 2 * math.pi;
    final double radius = _radius.value * size.shortestSide / 2;
    final double angularVelocity = radius < 1
        ? 0
        : (velocity.dx * math.cos(radians) + velocity.dy * math.sin(radians)) /
              radius /
              (2 * math.pi);
    _dragging = false;
    _settle(velocity: angularVelocity);
  }

  /// Validates text entry and updates [selectedTime] when both fields are valid.
  bool validate() {
    if (!_input) return true;
    if (!(_form.currentState?.validate() ?? false)) return false;
    final int hour = _parseNumber(_hours.text)!;
    final int minute = _parseNumber(_minutes.text)!;
    _changed(
      TimeOfDay(
        hour: _use24 ? hour : hour % 12 + _time.periodOffset,
        minute: minute,
      ),
    );
    return true;
  }

  int? _parseNumber(String? value) {
    String text = value?.trim() ?? '';
    final PureLocalizations l = PureLocalizations.of(context);
    for (int digit = 0; digit < 10; digit++) {
      text = text.replaceAll(l.formatDecimal(digit), digit.toString());
    }
    return int.tryParse(text);
  }

  String? _validateNumber(String? value, {required bool hour}) {
    final int? number = _parseNumber(value);
    final bool valid =
        number != null &&
        (hour
            ? (_use24
                  ? number >= 0 && number <= 23
                  : number >= 1 && number <= 12)
            : number >= 0 && number <= 59);
    return valid
        ? null
        : widget.errorInvalidText ??
              PureLocalizations.of(context).invalidTimeLabel;
  }

  @override
  void dispose() {
    _angle.dispose();
    _radius.dispose();
    _hours.dispose();
    _minutes.dispose();
    super.dispose();
  }

  Widget _segment({
    required bool hour,
    required String text,
    required String label,
    required TimePickerStyle style,
  }) => Semantics(
    label: label,
    value: text,
    increasedValue: hour
        ? PureLocalizations.of(context).formatHour(
            _time.replacing(hour: (_time.hour + 1) % 24),
            alwaysUse24HourFormat: _use24,
          )
        : PureLocalizations.of(context)
              .formatMinute(_time.replacing(minute: (_time.minute + 1) % 60)),
    decreasedValue: hour
        ? PureLocalizations.of(context).formatHour(
            _time.replacing(hour: (_time.hour - 1) % 24),
            alwaysUse24HourFormat: _use24,
          )
        : PureLocalizations.of(context)
              .formatMinute(_time.replacing(minute: (_time.minute - 1) % 60)),
    onIncrease: () => _adjust(hour, 1),
    onDecrease: () => _adjust(hour, -1),
    child: SizedBox(
      width: 72,
      height: 48,
      child: PickerCell(
        selected: _hour == hour,
        styles: <ButtonStyle?>[
          if (_hour == hour) style.selectedSegmentStyle,
          style.segmentStyle,
          ButtonStyle(
            animationDuration: style.animationDuration,
            animationCurve: style.animationCurve,
          ),
        ],
        onPressed: () => _selectSegment(hour),
        child: Text(text, style: style.headerTextStyle),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final PureLocalizations l = PureLocalizations.of(context);
    final TimePickerStyle style = _style;
    assert(
      debugCheckDecorationOverride(
        widget: 'TimePicker',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    final bool canToggle =
        _mode != TimePickerEntryMode.inputOnly &&
        _mode != TimePickerEntryMode.dialOnly;
    final double extent = style.dialSize ?? 256;
    final List<Widget> sections = <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                _input ? l.timePickerInputHelpText : l.timePickerDialHelpText,
                style: style.headerTextStyle,
              ),
            ),
          ),
          if (canToggle)
            IconButton(
              style: style.entryModeButtonStyle,
              tooltip: _input
                  ? l.dialModeButtonLabel
                  : l.inputTimeModeButtonLabel,
              onPressed: () {
                if (_input && !validate()) return;
                _syncText();
                setState(() {
                  _mode = _input
                      ? TimePickerEntryMode.dial
                      : TimePickerEntryMode.input;
                });
                widget.onEntryModeChanged?.call(_mode);
                _settle();
              },
              icon: _input ? const ClockGlyph() : const EditGlyph(),
            ),
        ],
      ),
      if (_input)
        Form(
          key: _form,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _hours,
                  style: TextFieldStyle(
                    textStyle: StateProperty<TextStyle?>.all(
                      style.inputTextStyle,
                    ),
                  ),
                  autofocus: widget.autofocus,
                  labelText: widget.hourLabelText ?? l.timePickerHourLabel,
                  validator: (String? value) =>
                      _validateNumber(value, hour: true),
                ),
              ),
              const Text(':'),
              Expanded(
                child: TextFormField(
                  controller: _minutes,
                  style: TextFieldStyle(
                    textStyle: StateProperty<TextStyle?>.all(
                      style.inputTextStyle,
                    ),
                  ),
                  labelText: widget.minuteLabelText ?? l.timePickerMinuteLabel,
                  validator: (String? value) =>
                      _validateNumber(value, hour: false),
                ),
              ),
            ],
          ),
        )
      else
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _segment(
              hour: true,
              text: l.formatHour(_time, alwaysUse24HourFormat: _use24),
              label: l.timePickerHourLabel,
              style: style,
            ),
            const Text(':'),
            _segment(
              hour: false,
              text: l.formatMinute(_time),
              label: l.timePickerMinuteLabel,
              style: style,
            ),
          ],
        ),
      if (!_use24)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (final DayPeriod period in DayPeriod.values)
              SizedBox(
                width: 64,
                height: 40,
                child: PickerCell(
                  selected: _time.period == period,
                  styles: <ButtonStyle?>[
                    if (_time.period == period) style.selectedPeriodStyle,
                    style.periodStyle,
                    ButtonStyle(
                      animationDuration: style.animationDuration,
                      animationCurve: style.animationCurve,
                    ),
                  ],
                  onPressed: () => _period(period),
                  child: Text(
                    period == DayPeriod.am
                        ? l.anteMeridiemAbbreviation
                        : l.postMeridiemAbbreviation,
                  ),
                ),
              ),
          ],
        ),
      if (!_input)
        Semantics(
          label: _hour
              ? l.timePickerHourModeAnnouncement
              : l.timePickerMinuteModeAnnouncement,
          child: SizedBox.square(
            key: const ValueKey<String>('pure-time-dial'),
            dimension: extent,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Size size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (TapUpDetails details) {
                    _position(details.localPosition, size, tap: true);
                    _settle();
                  },
                  onPanStart: (DragStartDetails details) {
                    _dragging = true;
                    _position(details.localPosition, size, tap: false);
                  },
                  onPanUpdate: (DragUpdateDetails details) =>
                      _position(details.localPosition, size, tap: false),
                  onPanEnd: (DragEndDetails details) =>
                      _release(details.velocity.pixelsPerSecond, size),
                  onPanCancel: () {
                    _dragging = false;
                    _settle();
                  },
                  child: RepaintBoundary(
                    child: DecoratedBox(
                      decoration:
                          style.dialDecoration ??
                          BoxDecoration(color: style.dialBackgroundColor),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: Listenable.merge(<Listenable>[
                                _angle,
                                _radius,
                              ]),
                              builder: (BuildContext context, Widget? child) =>
                                  CustomPaint(
                                    key: const ValueKey<String>(
                                      'pure-time-hand',
                                    ),
                                    painter: _DialHandPainter(
                                      turns: _angle.value,
                                      radiusFactor: _radius.value,
                                      color:
                                          style.handColor ??
                                          IconTheme.of(context).color ??
                                          DefaultTextStyle.of(context)
                                              .style
                                              .color ??
                                          const Color(0xFF000000),
                                      width: style.handWidth ?? 2,
                                      handRadius: style.handRadius ?? 12,
                                      decoration: style.handDecoration,
                                    ),
                                  ),
                            ),
                          ),
                          for (int index = 0; index < 12; index++)
                            _dialLabel(context, size, index, false, style, l),
                          if (_use24 && _hour)
                            for (int index = 0; index < 12; index++)
                              _dialLabel(context, size, index, true, style, l),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
    ];
    final bool landscape =
        !_input && widget.orientation == Orientation.landscape;
    final Widget content = landscape
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: extent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sections.sublist(0, sections.length - 1),
                ),
              ),
              sections.last,
            ],
          )
        : Column(mainAxisSize: MainAxisSize.min, children: sections);
    return Container(
      decoration: widget.decoration ?? style.decoration,
      padding: style.padding,
      width: landscape ? extent * 2 : extent,
      child: content,
    );
  }

  Widget _dialLabel(
    BuildContext context,
    Size size,
    int index,
    bool inner,
    TimePickerStyle style,
    PureLocalizations l,
  ) {
    final double angle = index / 12 * 2 * math.pi;
    final double radius = size.shortestSide / 2 * (inner ? .55 : .84);
    final Offset center =
        size.center(Offset.zero) +
        Offset(math.sin(angle), -math.cos(angle)) * radius;
    final int value = _hour
        ? (inner ? (index == 0 ? 0 : index + 12) : (index == 0 ? 12 : index))
        : index * 5;
    return Positioned(
      left: center.dx - 20,
      top: center.dy - 20,
      width: 40,
      height: 40,
      child: IgnorePointer(
        child: Center(
          child: Text(
            _hour
                ? l.formatDecimal(value)
                : l.formatDecimal(value).padLeft(2, l.formatDecimal(0)),
            style: style.dialTextStyle,
          ),
        ),
      ),
    );
  }
}

class _DialHandPainter extends CustomPainter {
  const _DialHandPainter({
    required this.turns,
    required this.radiusFactor,
    required this.color,
    required this.width,
    required this.handRadius,
    this.decoration,
  });
  final double turns;
  final double radiusFactor;
  final Color color;
  final double width;
  final double handRadius;
  final Decoration? decoration;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radians = turns * 2 * math.pi;
    final Offset end =
        center +
        Offset(math.sin(radians), -math.cos(radians)) *
            size.shortestSide /
            2 *
            radiusFactor;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, end, paint);
    canvas.drawCircle(center, width * 1.5, paint);
    if (decoration == null) {
      canvas.drawCircle(end, handRadius, paint..style = PaintingStyle.stroke);
    } else {
      final BoxPainter painter = decoration!.createBoxPainter();
      painter.paint(
        canvas,
        end - Offset(handRadius, handRadius),
        ImageConfiguration(size: Size.square(handRadius * 2)),
      );
      painter.dispose();
    }
  }

  @override
  bool shouldRepaint(_DialHandPainter oldDelegate) =>
      turns != oldDelegate.turns ||
      radiusFactor != oldDelegate.radiusFactor ||
      color != oldDelegate.color ||
      width != oldDelegate.width ||
      handRadius != oldDelegate.handRadius ||
      decoration != oldDelegate.decoration;
}

/// A modal dial or input time picker.
class TimePickerDialog extends StatefulWidget {
  /// Creates a time picker dialog.
  const TimePickerDialog({
    super.key,
    required this.initialTime,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.onEntryModeChanged,
    this.style,
    this.restorationId,
    this.orientation,
  });

  /// Initially displayed time.
  final TimeOfDay initialTime;

  /// Initial dial or input entry mode.
  final TimePickerEntryMode initialEntryMode;

  /// Overrides the cancel label.
  final String? cancelText;

  /// Overrides the confirmation label.
  final String? confirmText;

  /// Optional additional dialog heading.
  final String? helpText;

  /// Overrides the localized input error.
  final String? errorInvalidText;

  /// Overrides the hour input label.
  final String? hourLabelText;

  /// Overrides the minute input label.
  final String? minuteLabelText;

  /// Reports changes to entry mode.
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged;

  /// Appearance and motion tokens.
  final TimePickerStyle? style;

  /// Reserved restoration scope identifier.
  final String? restorationId;

  /// Preferred layout orientation.
  final Orientation? orientation;

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  final GlobalKey<TimePickerState> _picker = GlobalKey<TimePickerState>();

  @override
  Widget build(BuildContext context) {
    final PureLocalizations l = PureLocalizations.of(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.helpText != null) Text(widget.helpText!),
            TimePicker(
              key: _picker,
              initialTime: widget.initialTime,
              initialEntryMode: widget.initialEntryMode,
              onTimeChanged: (TimeOfDay time) {},
              onEntryModeChanged: widget.onEntryModeChanged,
              hourLabelText: widget.hourLabelText,
              minuteLabelText: widget.minuteLabelText,
              errorInvalidText: widget.errorInvalidText,
              style: widget.style,
              autofocus: true,
              orientation:
                  widget.orientation ?? MediaQuery.orientationOf(context),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(widget.cancelText ?? l.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    if (_picker.currentState?.validate() ?? false) {
                      Navigator.of(context)
                          .pop(_picker.currentState!.selectedTime);
                    }
                  },
                  child: Text(widget.confirmText ?? l.okButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a time picker and returns the confirmed time, or null on cancel.
Future<TimeOfDay?> showTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  TransitionBuilder? builder,
  bool useRootNavigator = true,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  String? cancelText,
  String? confirmText,
  String? helpText,
  String? errorInvalidText,
  String? hourLabelText,
  String? minuteLabelText,
  RouteSettings? routeSettings,
  ValueChanged<TimePickerEntryMode>? onEntryModeChanged,
  Offset? anchorPoint,
  Orientation? orientation,
  bool barrierDismissible = true,
  String? barrierLabel,
  TimePickerStyle? style,
}) => showDialog<TimeOfDay>(
  context: context,
  useRootNavigator: useRootNavigator,
  routeSettings: routeSettings,
  anchorPoint: anchorPoint,
  barrierDismissible: barrierDismissible,
  barrierLabel: barrierLabel,
  builder: (BuildContext context) {
    final Widget dialog = TimePickerDialog(
      initialTime: initialTime,
      initialEntryMode: initialEntryMode,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorInvalidText: errorInvalidText,
      hourLabelText: hourLabelText,
      minuteLabelText: minuteLabelText,
      onEntryModeChanged: onEntryModeChanged,
      orientation: orientation,
      style: style,
    );
    return builder?.call(context, dialog) ?? dialog;
  },
);
