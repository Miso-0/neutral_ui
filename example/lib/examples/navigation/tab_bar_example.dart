import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const Color _white = Color(0xFFFFFFFF);

/// A focus ring drawn outside the control, so showing it never moves content.
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

ButtonStyle _control({bool selected = false}) => ButtonStyle(
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 9),
  ),
  spacing: 8,
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : state.isSelected || selected
          ? _accent
          : state.isHovered
          ? const Color(0xFFE4F1E7)
          : _white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: state.isFocused ? _accent : _line),
      // The ring stays visible on selected, accent-filled controls.
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isSelected || selected
          ? _white
          : state.isDisabled
          ? _muted
          : _ink,
      fontSize: 14,
    ),
  ),
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      size: 18,
      color: state.isSelected || selected ? _white : _accent,
    ),
  ),
);

/// A tab strip and swipeable content with a local controller.
class TabBarExample extends StatelessWidget {
  /// Creates the example.
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14),
    child: SizedBox(
      height: 190,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            TabBar(
              style: TabBarStyle(
                tabStyle: _control(),
                indicatorDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: _accent),
                ),
                indicatorWeight: 3,
                labelPadding: const EdgeInsets.all(8),
              ),
              tabs: const <Widget>[
                Tab(text: 'Overview'),
                Tab(text: 'Activity'),
                Tab(text: 'Settings'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: <Widget>[
                  Center(child: Text('Swipe to explore each tab')),
                  Center(child: Text('Activity appears here')),
                  Center(child: Text('Your preferences')),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
