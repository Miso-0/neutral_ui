import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);

/// A slider with discrete stops and a custom value indicator.
class DiscreteSliderExample extends StatefulWidget {
  /// Creates the discrete slider example.
  const DiscreteSliderExample({super.key});
  @override
  State<DiscreteSliderExample> createState() => _DiscreteSliderExampleState();
}

class _DiscreteSliderExampleState extends State<DiscreteSliderExample> {
  double _value = 0.6;

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
        Text('Discrete steps: ${(_value * 100).round()}%'),
        Slider(
          value: _value,
          divisions: 5,
          label: '${(_value * 100).round()}%',
          style: _sliderStyle().copyWith(
            valueIndicatorBuilder:
                (
                  BuildContext context,
                  InteractionState state,
                  double value,
                  String? label,
                ) => state.isPressed || state.isDragged
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _ink,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      label ?? '',
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 11,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          onChanged: (double value) => setState(() => _value = value),
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
