import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);

/// Two independently controlled thumbs select a range.
class RangeSliderExample extends StatefulWidget {
  /// Creates the range slider example.
  const RangeSliderExample({super.key});
  @override
  State<RangeSliderExample> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  RangeValues _values = const RangeValues(0.2, 0.7);

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Range: ${(_values.start * 100).round()} to ${(_values.end * 100).round()}',
        ),
        RangeSlider(
          style: _sliderStyle(),
          values: _values,
          onChanged: (RangeValues values) => setState(() => _values = values),
        ),
      ],
    ),
  );
}

SliderStyle _sliderStyle() => SliderStyle(
  trackHeight: const StateProperty<double?>.all(5),
  trackDecoration: const StateProperty<Decoration?>.all(
    BoxDecoration(
      color: _line,
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
  ),
  activeTrackDecoration: const StateProperty<Decoration?>.all(
    BoxDecoration(
      color: _accent,
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
  ),
  secondaryActiveTrackDecoration: const StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFFA5CDBB)),
  ),
  thumbSize: const StateProperty<Size?>.all(Size(20, 20)),
  thumbDecoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled ? _muted : _accent,
      shape: BoxShape.circle,
      border: Border.all(
        color: state.isFocused ? _ink : const Color(0xFFFFFFFF),
        width: 3,
      ),
    ),
  ),
  tickMarkSize: const StateProperty<Size?>.all(Size(3, 3)),
  tickMarkDecoration: const StateProperty<Decoration?>.all(
    BoxDecoration(color: _muted, shape: BoxShape.circle),
  ),
  activeTickMarkDecoration: const StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFFFFFFFF), shape: BoxShape.circle),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 4),
);
