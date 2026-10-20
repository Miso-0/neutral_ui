import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const Color _white = Color(0xFFFFFFFF);

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
          : state.isHovered || state.isFocused
          ? const Color(0xFFE4F1E7)
          : _white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: state.isFocused ? _accent : _line),
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

/// Adds the complete interactive roadmap's appearance to the gallery theme.
ThemeData roadmapTheme(ThemeData theme) {
  final ButtonStyle control = _control();
  final ButtonStyle selected = _control(selected: true);
  final BoxDecoration surface = BoxDecoration(
    color: _white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _line),
  );
  final TextFieldStyle field = TextFieldStyle(
    decoration: StateProperty<Decoration?>.resolveWith(
      (InteractionState state) => BoxDecoration(
        color: state.isDisabled ? const Color(0xFFE3EAE4) : _white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: state.isError
              ? const Color(0xFFB13B3B)
              : state.isFocused
              ? _accent
              : _line,
          width: state.isFocused ? 2 : 1,
        ),
      ),
    ),
    contentPadding: const StateProperty<EdgeInsetsGeometry?>.all(
      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    textStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: _ink, fontSize: 14),
    ),
    hintStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: _muted, fontSize: 14),
    ),
    labelStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: _muted, fontSize: 12),
    ),
    errorStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: Color(0xFFB13B3B), fontSize: 12),
    ),
    iconTheme: const StateProperty<IconThemeData?>.all(
      IconThemeData(color: _accent, size: 18),
    ),
    cursorColor: const StateProperty<Color?>.all(_accent),
    selectionColor: const StateProperty<Color?>.all(Color(0x55087F6D)),
    spacing: 6,
  );
  final MenuStyle menu = MenuStyle(
    decoration: surface,
    padding: const EdgeInsets.all(6),
    maximumSize: const Size(480, 300),
  );
  return theme.copyWith(
    tooltipStyle: TooltipStyle(
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.all(9),
      textStyle: const TextStyle(color: _white, fontSize: 12),
    ),
    dialogStyle: DialogStyle(
      decoration: surface,
      padding: const EdgeInsets.all(24),
      insetPadding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 620),
      titleTextStyle: const TextStyle(
        color: _ink,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      actionsPadding: const EdgeInsets.only(top: 16),
      optionStyle: control,
      barrierColor: const Color(0x55142C2A),
    ),
    bottomSheetStyle: BottomSheetStyle(
      decoration: surface,
      padding: const EdgeInsets.all(24),
      dragHandleColor: _muted,
      dragHandleSize: const Size(40, 4),
      constraints: const BoxConstraints(maxWidth: 680),
      barrierColor: const Color(0x55142C2A),
    ),
    snackBarStyle: SnackBarStyle(
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(18),
      constraints: const BoxConstraints(maxWidth: 560),
      textStyle: const TextStyle(color: _white),
      actionStyle: selected,
      spacing: 12,
    ),
    textFieldStyle: field,
    autocompleteStyle: AutocompleteStyle(
      fieldStyle: field,
      menuStyle: menu,
      itemStyle: control,
    ),
    searchStyle: SearchStyle(
      fieldStyle: field,
      viewDecoration: surface,
      viewPadding: const EdgeInsets.all(12),
      menuStyle: menu,
      suggestionStyle: control,
    ),
    datePickerStyle: DatePickerStyle(
      decoration: surface,
      padding: const EdgeInsets.all(12),
      dayStyle: control.copyWith(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
      ),
      selectedDayStyle: selected.copyWith(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
      ),
      todayStyle: control,
      yearStyle: control,
      navigationButtonStyle: control,
      entryModeButtonStyle: control,
      rangeStartStyle: selected,
      rangeEndStyle: selected,
      rangeBandDecoration: const BoxDecoration(color: Color(0xFFD5EAE0)),
      headerTextStyle: const TextStyle(color: _ink, fontSize: 17),
      weekdayTextStyle: const TextStyle(color: _muted, fontSize: 12),
      dayExtent: 38,
      monthWidth: 300,
    ),
    timePickerStyle: TimePickerStyle(
      decoration: surface,
      padding: const EdgeInsets.all(16),
      segmentStyle: control,
      selectedSegmentStyle: selected,
      periodStyle: control,
      selectedPeriodStyle: selected,
      entryModeButtonStyle: control,
      dialDecoration: const BoxDecoration(
        color: Color(0xFFE4F1E7),
        shape: BoxShape.circle,
      ),
      dialTextStyle: const TextStyle(color: _ink, fontSize: 13),
      handColor: _accent,
      dialSize: 220,
      handWidth: 2,
      handRadius: 9,
    ),
    filledButtonStyle: selected,
    floatingActionButtonStyle: selected,
    segmentedButtonStyle: control,
    toggleButtonsStyle: control,
    chipStyle: ChipStyle(
      buttonStyle: control,
      deleteButtonStyle: control.copyWith(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(
          EdgeInsets.all(4),
        ),
      ),
      spacing: 7,
      avatarSize: 20,
    ),
    tabBarStyle: TabBarStyle(
      tabStyle: control,
      indicatorDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: _accent),
      ),
      indicatorWeight: 3,
      labelPadding: const EdgeInsets.all(8),
    ),
    navigationStyle: NavigationStyle(
      destinationStyle: control,
      spacing: 8,
      indicatorDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(
          color: Color(0xFFD5EAE0),
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
      ),
    ),
    expansionTileStyle: const ExpansionTileStyle(
      childrenPadding: EdgeInsets.all(16),
    ),
    progressIndicatorStyle: const ProgressIndicatorStyle(
      color: StateProperty<Color?>.all(_accent),
      backgroundColor: StateProperty<Color?>.all(_line),
      strokeWidth: 4,
      minHeight: 5,
      size: Size(32, 32),
    ),
    badgeStyle: const BadgeStyle(
      decoration: StateProperty<Decoration?>.all(
        BoxDecoration(color: _accent, shape: BoxShape.circle),
      ),
      textStyle: StateProperty<TextStyle?>.all(
        TextStyle(color: _white, fontSize: 11),
      ),
      padding: EdgeInsets.all(5),
    ),
  );
}

/// Live examples of every remaining roadmap family.
class RoadmapSections extends StatefulWidget {
  /// Creates the additional gallery sections.
  const RoadmapSections({super.key, this.onReducedMotionChanged});

  /// Applies the reduced-motion setting to navigation routes as well.
  final ValueChanged<bool>? onReducedMotionChanged;
  @override
  State<RoadmapSections> createState() => _RoadmapSectionsState();
}

class _RoadmapSectionsState extends State<RoadmapSections> {
  DateTime _date = DateTime(2026, 10, 16);
  DateTimeRange<DateTime>? _range;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 30);
  Set<String> _segments = <String>{'Week'};
  bool _filter = true;
  bool _chipVisible = true;
  int _destination = 0;
  RangeValues _values = const RangeValues(0.2, 0.7);
  bool _reducedMotion = false;
  bool _animateProgress = false;
  String _status = 'Try a new component';
  final SearchController _search = SearchController();

  Widget _section(String title, String description, List<Widget> children) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      );
  void _record(String value) => setState(() => _status = value);

  Widget _feedback() => _section(
    '09 / Overlays and feedback',
    'Hover, keyboard focus, route dismissal, sheets and queued messages.',
    <Widget>[
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          Tooltip(
            message: 'Tooltips also open on keyboard focus',
            child: TextButton(
              onPressed: () => _record('Tooltip action'),
              child: const Text('Hover or focus'),
            ),
          ),
          TextButton(
            key: const ValueKey<String>('roadmap-dialog'),
            onPressed: () async {
              final bool? accepted = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Create a workspace?'),
                  content: const Text(
                    'Dialog content, actions and motion inherit your theme.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Create workspace'),
                    ),
                  ],
                ),
              );
              if (mounted) {
                _record(
                  accepted == true ? 'Workspace created' : 'Dialog dismissed',
                );
              }
            },
            child: const Text('Open dialog'),
          ),
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                title: const Text('Choose a workspace'),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Personal workspace'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Team workspace'),
                  ),
                ],
              ),
            ),
            child: const Text('Simple dialog'),
          ),
          TextButton(
            key: const ValueKey<String>('roadmap-sheet'),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              enableDrag: true,
              isScrollControlled: true,
              builder: (BuildContext context) => SizedBox(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'A sheet that follows your drag',
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Drag down to dismiss, or use the close action.',
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close sheet'),
                    ),
                  ],
                ),
              ),
            ),
            child: const Text('Open sheet'),
          ),
          TextButton(
            key: const ValueKey<String>('roadmap-snackbar'),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Your changes are saved'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => _record('Save undone'),
                ),
                showCloseIcon: true,
              ),
            ),
            child: const Text('Queue a message'),
          ),
        ],
      ),
    ],
  );

  Widget _input() => _section(
    '10 / Text input and search',
    'Validation, password reveal, asynchronous options and expanding search.',
    <Widget>[
      Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          SizedBox(
            width: 280,
            child: TextField(
              key: const ValueKey<String>('roadmap-text'),
              labelText: 'Project name',
              hintText: 'Enter a name',
              showClearButton: true,
              onChanged: (String value) => _record('Project: $value'),
            ),
          ),
          const SizedBox(
            width: 280,
            child: TextField(
              height: 30,
              labelText: 'Password',
              hintText: 'Enter a password',
              obscureText: true,
              showObscureTextToggle: true,
            ),
          ),
          SizedBox(
            width: 280,
            child: TextFormField(
              labelText: 'Email address',
              hintText: 'you@example.com',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? text) => text == null || text.contains('@')
                  ? null
                  : 'Enter an email address',
            ),
          ),
          SizedBox(
            width: 280,
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) =>
                  const <String>[
                    'Cape Town',
                    'Johannesburg',
                    'Durban',
                    'Pretoria',
                  ].where(
                    (String city) =>
                        value.text.isNotEmpty &&
                        city.toLowerCase().contains(value.text.toLowerCase()),
                  ),
              onSelected: (String value) => _record('Autocomplete: $value'),
            ),
          ),
          SizedBox(
            width: 360,
            child: SearchAnchor.bar(
              searchController: _search,
              barHintText: 'Search the gallery',
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) =>
                      <Widget>[
                        for (final String item
                            in <String>[
                              'Design systems',
                              'Research',
                              'Engineering',
                            ].where(
                              (String item) => item.toLowerCase().contains(
                                controller.text.toLowerCase(),
                              ),
                            ))
                          TextButton(
                            onPressed: () {
                              controller.closeView(item);
                              _record('Search: $item');
                            },
                            child: Text(item),
                          ),
                      ],
            ),
          ),
          SizedBox(
            width: 280,
            child: SearchAnchor.bar(
              isFullScreen: true,
              barHintText: 'Open full-screen search',
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) =>
                      <Widget>[
                        TextButton(
                          onPressed: () =>
                              controller.closeView('Recent project'),
                          child: const Text('Recent project'),
                        ),
                      ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget _pickers() => _section(
    '11 / Date and time',
    'Inline calendars, anchored fields, validated text input, ranges and a draggable clock.',
    <Widget>[
      Wrap(
        spacing: 20,
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 330,
            child: CalendarDatePicker(
              initialDate: _date,
              firstDate: DateTime(2025),
              lastDate: DateTime(2028, 12, 31),
              onDateChanged: (DateTime date) => setState(() => _date = date),
            ),
          ),
          SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DatePickerField(
                  value: _date,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2028, 12, 31),
                  onChanged: (DateTime date) => setState(() => _date = date),
                ),
                const SizedBox(height: 16),
                InputDatePickerFormField(
                  initialDate: _date,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2028, 12, 31),
                  onDateSubmitted: (DateTime date) =>
                      setState(() => _date = date),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2028, 12, 31),
                    );
                    if (mounted && date != null) setState(() => _date = date);
                  },
                  child: const Text('Modal date picker'),
                ),
                TextButton(
                  onPressed: () async {
                    final DateTimeRange<DateTime>? range =
                        await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2028, 12, 31),
                          initialDateRange: _range,
                        );
                    if (mounted && range != null) {
                      setState(() => _range = range);
                    }
                  },
                  child: const Text('Modal range picker'),
                ),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: _time,
                    );
                    if (mounted && time != null) setState(() => _time = time);
                  },
                  child: const Text('Modal time picker'),
                ),
                if (_range != null)
                  Text(
                    '${NeutralLocalizations.of(context).formatShortDate(_range!.start)} to ${NeutralLocalizations.of(context).formatShortDate(_range!.end)}',
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 290,
            child: TimePicker(
              initialTime: _time,
              onTimeChanged: (TimeOfDay time) => setState(() => _time = time),
            ),
          ),
          SizedBox(
            width: 330,
            height: 330,
            child: CalendarDateRangePicker(
              firstDate: DateTime(2026, 10),
              lastDate: DateTime(2027),
              initialStartDate: _date,
              onChanged: (DateTimeRange<DateTime> range) =>
                  setState(() => _range = range),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _chips() => _section(
    '12 / Chips and button variants',
    'Controlled single or multiple selection, deletable chips and action buttons.',
    <Widget>[
      Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          FilledButton(
            onPressed: () => _record('Filled action'),
            child: const Text('Filled action'),
          ),
          FilledButton.tonalIcon(
            onPressed: () => _record('Tonal action'),
            icon: const CheckGlyph(),
            label: const Text('Tonal action'),
          ),
          FloatingActionButton.small(
            onPressed: () => _record('Small floating action'),
            child: const SearchGlyph(),
          ),
          FloatingActionButton.large(
            onPressed: () => _record('Large floating action'),
            child: const CalendarGlyph(),
          ),
          FloatingActionButton.extended(
            onPressed: () => _record('Extended floating action'),
            icon: const CloseGlyph(),
            label: const Text('Extended action'),
          ),
          SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'Day', label: Text('Day')),
              ButtonSegment<String>(value: 'Week', label: Text('Week')),
              ButtonSegment<String>(value: 'Month', label: Text('Month')),
            ],
            selected: _segments,
            onSelectionChanged: (Set<String> values) =>
                setState(() => _segments = values),
          ),
          ToggleButtons(
            isSelected: <bool>[_filter, !_filter],
            onPressed: (int value) => setState(() => _filter = value == 0),
            children: const <Widget>[Text('List'), Text('Grid')],
          ),
          const Chip(
            label: Text('Status: active'),
            avatar: CheckGlyph(size: 16),
          ),
          FilterChip(
            label: const Text('Available'),
            selected: _filter,
            onSelected: (bool value) => setState(() => _filter = value),
          ),
          ChoiceChip(
            label: const Text('Recommended'),
            selected: !_filter,
            onSelected: (bool value) => setState(() => _filter = !value),
          ),
          if (_chipVisible)
            InputChip(
              label: const Text('Remove me'),
              onDeleted: () => setState(() => _chipVisible = false),
              onPressed: () => _record('Input chip action'),
            ),
          ActionChip(
            label: const Text('Add a label'),
            onPressed: () => setState(() => _chipVisible = true),
          ),
        ],
      ),
    ],
  );

  Widget _navigation() => _section(
    '13 / Navigation and feedback',
    'Swipe tabs, choose destinations, expand details and adjust both range thumbs.',
    <Widget>[
      SizedBox(
        height: 190,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              const TabBar(
                tabs: <Widget>[
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
      const SizedBox(height: 18),
      NavigationBar(
        selectedIndex: _destination,
        onDestinationSelected: (int index) =>
            setState(() => _destination = index),
        destinations: const <Widget>[
          NavigationDestination(icon: SearchGlyph(), label: 'Explore'),
          NavigationDestination(icon: CalendarGlyph(), label: 'Schedule'),
          NavigationDestination(icon: ClockGlyph(), label: 'Recent'),
        ],
      ),
      const SizedBox(height: 18),
      SizedBox(
        height: 260,
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _destination,
              onDestinationSelected: (int index) =>
                  setState(() => _destination = index),
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: SearchGlyph(),
                  label: Text('Explore'),
                ),
                NavigationRailDestination(
                  icon: CalendarGlyph(),
                  label: Text('Schedule'),
                ),
                NavigationRailDestination(
                  icon: ClockGlyph(),
                  label: Text('Recent'),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(
              child: NavigationDrawer(
                selectedIndex: _destination,
                onDestinationSelected: (int index) =>
                    setState(() => _destination = index),
                children: const <Widget>[
                  NavigationDrawerDestination(
                    icon: SearchGlyph(),
                    label: Text('Explore'),
                  ),
                  NavigationDrawerDestination(
                    icon: CalendarGlyph(),
                    label: Text('Schedule'),
                  ),
                  NavigationDrawerDestination(
                    icon: ClockGlyph(),
                    label: Text('Recent'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const ExpansionTile(
        title: Text('Project details'),
        maintainState: true,
        children: <Widget>[Text('This content stays mounted while collapsed.')],
      ),
      const SizedBox(height: 18),
      RangeSlider(
        values: _values,
        onChanged: (RangeValues values) => setState(() => _values = values),
      ),
      Text(
        'Range: ${(_values.start * 100).round()}% to ${(_values.end * 100).round()}%',
      ),
      const SizedBox(height: 18),
      Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          const Badge.count(count: 125, child: SearchGlyph(size: 30)),
          CircularProgressIndicator(value: _animateProgress ? null : 0.65),
          SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              value: _animateProgress ? null : 0.42,
              style: const ProgressIndicatorStyle(size: Size(180, 5)),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Switch(
                value: _animateProgress,
                onChanged: (bool value) =>
                    setState(() => _animateProgress = value),
              ),
              const Text('Animate progress'),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: _reducedMotion),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Switch(
              value: _reducedMotion,
              onChanged: (bool value) => setState(() {
                _reducedMotion = value;
                widget.onReducedMotionChanged?.call(value);
              }),
            ),
            const Text('Reduced motion for new components'),
          ],
        ),
        const SizedBox(height: 18),
        _feedback(),
        const SizedBox(height: 18),
        _input(),
        const SizedBox(height: 18),
        _pickers(),
        const SizedBox(height: 18),
        _chips(),
        const SizedBox(height: 18),
        _navigation(),
        const SizedBox(height: 18),
        Text(
          _status,
          key: const ValueKey<String>('roadmap-status'),
          style: const TextStyle(color: _muted),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }
}
