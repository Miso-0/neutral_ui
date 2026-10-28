import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);

/// A continuous slider with a secondary track and a disabled variant.
class ContinuousSliderExample extends StatefulWidget {
  /// Creates the continuous slider example.
  const ContinuousSliderExample({super.key});
  @override
  State<ContinuousSliderExample> createState() =>
      _ContinuousSliderExampleState();
}

class _ContinuousSliderExampleState extends State<ContinuousSliderExample> {
  double _value = 0.42;

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
        Text('Volume: ${(_value * 100).round()}%'),
        Slider(
          style: _sliderStyle(),
          value: _value,
          secondaryTrackValue: 0.8,
          onChanged: (double value) => setState(() => _value = value),
        ),
        const SizedBox(height: 12),
        const Text('Disabled'),
        Slider(style: _sliderStyle(), value: 0.3, onChanged: null),
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
