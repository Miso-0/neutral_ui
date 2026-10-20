import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

import 'sections/roadmap_sections.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _canvas = Color(0xFFF4F7F3);
const Color _line = Color(0xFFCFDDD4);

/// Starts the sample gallery.
void main() => runApp(const GalleryApp());

Decoration _surface(InteractionState state, {bool solid = false}) =>
    BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : solid
          ? (state.isPressed
                ? const Color(0xFF065F53)
                : state.isHovered
                ? const Color(0xFF0A927E)
                : _accent)
          : (state.isPressed
                ? const Color(0xFFD5EAE0)
                : state.isHovered
                ? const Color(0xFFE9F2EB)
                : const Color(0xFFFFFFFF)),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: state.isFocused
            ? _accent
            : solid
            ? const Color(0x00000000)
            : _line,
        width: state.isFocused ? 2 : 1,
      ),
    );

ButtonStyle _button({bool solid = false}) => ButtonStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => _surface(state, solid: solid),
  ),
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 18, vertical: 13),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  spacing: 9,
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      size: 16,
    ),
  ),
);

ToggleStyle _toggle({bool radio = false, bool isSwitch = false}) => ToggleStyle(
  size: StateProperty<Size?>.all(
    isSwitch ? const Size(44, 26) : const Size(22, 22),
  ),
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : state.isSelected
          ? _accent
          : const Color(0xFFFFFFFF),
      border: Border.all(
        color: state.isFocused
            ? _ink
            : state.isSelected
            ? _accent
            : _line,
        width: state.isFocused ? 2 : 1,
      ),
      borderRadius: BorderRadius.circular(radio || isSwitch ? 30 : 6),
    ),
  ),
  thumbSize: StateProperty<Size?>.all(
    isSwitch ? const Size(20, 20) : const Size(10, 10),
  ),
  thumbDecoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: isSwitch && !state.isSelected ? _muted : const Color(0xFFFFFFFF),
      shape: BoxShape.circle,
    ),
  ),
  padding: isSwitch ? const EdgeInsets.all(3) : const EdgeInsets.all(4),
  indicator: radio || isSwitch
      ? null
      : const StateProperty<Widget?>.all(
          SizedBox(
            width: 12,
            height: 12,
            child: CustomPaint(painter: _CheckPainter()),
          ),
        ),
  indeterminateIndicator: const StateProperty<Widget?>.all(
    SizedBox(width: 10, height: 2, child: ColoredBox(color: Color(0xFFFFFFFF))),
  ),
);

MenuStyle _menuPanel({bool matchAnchorWidth = true}) => MenuStyle(
  decoration: BoxDecoration(
    color: const Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: _line),
    boxShadow: const <BoxShadow>[
      BoxShadow(color: Color(0x18142C2A), blurRadius: 24, offset: Offset(0, 8)),
    ],
  ),
  padding: const EdgeInsets.all(6),
  minimumSize: const Size(180, 0),
  maximumSize: const Size(360, 280),
  matchAnchorWidth: matchAnchorWidth,
  edgePadding: const EdgeInsets.all(12),
  offset: const Offset(0, 6),
  clipBehavior: Clip.antiAlias,
);

ButtonStyle _menuItem() => _button().copyWith(
  iconTheme: const StateProperty<IconThemeData?>.all(
    IconThemeData(color: _accent, size: 16),
  ),
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isFocused || state.isPressed
          ? const Color(0xFFD5EAE0)
          : state.isSelected
          ? const Color(0xFFE4F1E7)
          : state.isHovered
          ? const Color(0xFFF0F5F0)
          : const Color(0x00000000),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ),
  alignment: AlignmentDirectional.centerStart,
);

Decoration _dropdownSurface(InteractionState state) {
  final bool active = state.isFocused || state.isSelected;
  return BoxDecoration(
    color: state.isDisabled
        ? const Color(0xFFE3EAE4)
        : state.isPressed
        ? const Color(0xFFD5EAE0)
        : active
        ? const Color(0xFFE4F1E7)
        : state.isHovered
        ? const Color(0xFFF0F5F0)
        : const Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: state.isDisabled
          ? _line
          : active
          ? _accent
          : state.isHovered
          ? _muted
          : _line,
      width: 2,
    ),
  );
}

DropdownStyle _dropdown() => DropdownStyle(
  buttonStyle: _button().copyWith(
    alignment: AlignmentDirectional.centerStart,
    decoration: StateProperty<Decoration?>.resolveWith(_dropdownSurface),
    iconTheme: const StateProperty<IconThemeData?>.all(
      IconThemeData(color: _muted, size: 14),
    ),
  ),
  menuStyle: _menuPanel(),
  itemStyle: _menuItem(),
  textStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _ink, fontSize: 14),
  ),
  hintStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 14),
  ),
  cursorColor: _accent,
  selectionColor: const Color(0x40087F6D),
  cursorWidth: 2,
);

ThemeData _theme() => ThemeData(
  elevatedButtonStyle: _button(solid: true),
  outlinedButtonStyle: _button(),
  textButtonStyle: _button().copyWith(
    decoration: StateProperty<Decoration?>.resolveWith(
      (InteractionState state) => BoxDecoration(
        color: state.isHovered
            ? const Color(0xFFE9F2EB)
            : const Color(0x00000000),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  iconButtonStyle: _button().copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(10)),
  ),
  dropdownButtonStyle: _dropdown(),
  dropdownMenuStyle: _dropdown(),
  popupMenuStyle: PopupMenuStyle(
    buttonStyle: _button(),
    menuStyle: _menuPanel(matchAnchorWidth: false),
    itemStyle: _menuItem(),
    dividerDecoration: const BoxDecoration(color: _line),
    dividerHeight: 1,
  ),
  checkboxStyle: _toggle(),
  switchStyle: _toggle(isSwitch: true),
  radioStyle: _toggle(radio: true),
  listTileStyle: ListTileStyle(
    decoration: StateProperty<Decoration?>.resolveWith(
      (InteractionState state) => BoxDecoration(
        color: state.isSelected
            ? const Color(0xFFE4F1E7)
            : state.isHovered
            ? const Color(0xFFF0F5F0)
            : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    titleTextStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: _ink, fontSize: 15, fontWeight: FontWeight.w600),
    ),
    subtitleTextStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: _muted, fontSize: 13, height: 1.5),
    ),
    iconTheme: const StateProperty<IconThemeData?>.all(
      IconThemeData(color: _muted, size: 16),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    horizontalTitleGap: 14,
    minVerticalPadding: 4,
    subtitleSpacing: 4,
    minTileHeight: 54,
    minTwoLineTileHeight: 72,
    minThreeLineTileHeight: 92,
  ),
  sliderStyle: SliderStyle(
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
  ),
);

/// A NeutralApp gallery with all visual tokens supplied by a central theme.
class GalleryApp extends StatefulWidget {
  /// Creates the gallery application.
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  bool _rtl = false;
  bool _reducedMotion = false;

  @override
  Widget build(BuildContext context) => NeutralApp(
    color: _canvas,
    title: 'NeutralUI gallery',
    debugShowCheckedModeBanner: false,
    textStyle: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    theme: roadmapTheme(_theme()),
    builder: (BuildContext context, Widget? child) => Directionality(
      textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: _reducedMotion),
        child: child!,
      ),
    ),
    home: ScaffoldMessenger(
      child: _Gallery(
        onDirectionChanged: (bool value) => setState(() => _rtl = value),
        onReducedMotionChanged: (bool value) =>
            setState(() => _reducedMotion = value),
      ),
    ),
  );
}

class _Gallery extends StatefulWidget {
  const _Gallery({this.onDirectionChanged, this.onReducedMotionChanged});
  final ValueChanged<bool>? onDirectionChanged;
  final ValueChanged<bool>? onReducedMotionChanged;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  bool? _checked = true;
  bool _switched = true;
  bool _selected = false;
  bool _loading = false;
  bool _rtl = false;
  int? _radio = 1;
  int? _groupRadio = 1;
  double _value = 0.42;
  double _discrete = 0.6;
  double _decorationValue = 0.35;
  bool _decorationSwitched = true;
  String _activity = 'Ready to interact';
  String? _projectType;
  String? _workspace = 'Personal';
  Set<String> _disciplines = <String>{'Engineering'};
  bool _pinned = true;

  static const List<DropdownMenuEntry<String>> _cities =
      <DropdownMenuEntry<String>>[
        DropdownMenuEntry<String>(
          value: 'Cape Town',
          labelWidget: Text('Cape Town'),
        ),
        DropdownMenuEntry<String>(
          value: 'Johannesburg',
          labelWidget: Text('Johannesburg'),
        ),
        DropdownMenuEntry<String>(value: 'Durban', labelWidget: Text('Durban')),
        DropdownMenuEntry<String>(
          value: 'Pretoria',
          labelWidget: Text('Pretoria'),
        ),
        DropdownMenuEntry<String>(
          value: 'Bloemfontein',
          labelWidget: Text('Bloemfontein'),
          enabled: false,
        ),
      ];
  static const List<DropdownMenuEntry<String>> _languages =
      <DropdownMenuEntry<String>>[
        DropdownMenuEntry<String>(value: 'Dart', label: 'Dart'),
        DropdownMenuEntry<String>(value: 'Flutter', label: 'Flutter'),
        DropdownMenuEntry<String>(value: 'Swift', label: 'Swift'),
        DropdownMenuEntry<String>(value: 'Kotlin', label: 'Kotlin'),
      ];
  static const List<DropdownMenuEntry<String>> _teams =
      <DropdownMenuEntry<String>>[
        DropdownMenuEntry<String>(value: 'Design', label: 'Design'),
        DropdownMenuEntry<String>(value: 'Engineering', label: 'Engineering'),
        DropdownMenuEntry<String>(value: 'Research', label: 'Research'),
      ];

  void _record(String message) => setState(() {
    _activity = message;
  });

  Widget _section(
    String index,
    String title,
    String description,
    List<Widget> children,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$index / $title',
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(description, style: const TextStyle(color: _muted, fontSize: 13)),
        const SizedBox(height: 24),
        ...children,
      ],
    ),
  );

  Widget _label(String label, Widget control) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[control, const SizedBox(width: 6), Text(label)],
  );

  Widget _menuDemo(String label, Widget child, {double width = 270}) =>
      SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );

  List<PopupMenuEntry<String>> _projectActions(
    BuildContext context,
  ) => <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
      value: 'duplicate',
      leading: _PlusGlyph(),
      child: Text('Duplicate project'),
    ),
    CheckedPopupMenuItem<String>(
      value: 'pin',
      checked: _pinned,
      child: const Text('Pin to sidebar'),
    ),

    const PopupMenuDivider(),
    PopupMenuItem<String>(
      value: 'archive',
      enabled: false,
      onTap: () {},
      child: Text('Archive project'),
    ),
    const PopupMenuItem<String>(value: 'delete', child: Text('Delete project')),
  ];

  void _selectAction(String value) => setState(() {
    if (value == 'pin') {
      _pinned = !_pinned;
    }
    _activity = 'Project action: $value';
  });

  Widget _menus() => _section(
    '06',
    'Menus',
    'Choose a value, type to filter or search, select several teams, or open project actions.',
    <Widget>[
      Wrap(
        spacing: 22,
        runSpacing: 22,
        children: <Widget>[
          _menuDemo(
            'Classic select with a hint',
            DropdownButton<String>(
              key: const ValueKey<String>('classic-select'),
              semanticLabel: 'Project type',
              hint: const Text('Choose project type'),
              value: _projectType,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'Website',
                  child: Text('Website'),
                ),
                DropdownMenuItem<String>(
                  value: 'Mobile app',
                  child: Text('Mobile app'),
                ),
                DropdownMenuItem<String>(
                  value: 'Prototype',
                  child: Text('Prototype'),
                ),
              ],
              onChanged: (String? value) => setState(() {
                _projectType = value;
                _activity = 'Project type: $value';
              }),
            ),
          ),
          _menuDemo(
            'Expanded select',
            DropdownButton<String>(
              key: const ValueKey<String>('expanded-select'),
              semanticLabel: 'Workspace type',
              isExpanded: true,
              value: _workspace,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'Personal',
                  child: Text('Personal'),
                ),
                DropdownMenuItem<String>(
                  value: 'Shared workspace',
                  child: Text('Shared workspace'),
                ),
              ],
              onChanged: (String? value) => setState(() {
                _workspace = value;
                _activity = 'Workspace: $value';
              }),
            ),
          ),
          _menuDemo(
            'Disabled select',
            DropdownButton<String>(
              semanticLabel: 'Unavailable select',
              disabledHint: const Text('No workspaces available'),
              items: const <DropdownMenuItem<String>>[],
              onChanged: null,
            ),
          ),
          _menuDemo(
            'Search with a results builder',
            DropdownMenu<String>(
              key: const ValueKey<String>('filter-menu'),
              semanticLabel: 'Filter cities',
              hintText: 'Find a city',
              width: 270,
              requestFocusOnTap: true,
              searchBuilder: (BuildContext context, String query) => _cities
                  .where(
                    (DropdownMenuEntry<String> entry) =>
                        entry.value.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList(),
              onSelected: (String? value) => _record('City: $value'),
            ),
          ),
          _menuDemo(
            'Search highlights without filtering',
            DropdownMenu<String>(
              key: const ValueKey<String>('search-menu'),
              semanticLabel: 'Search languages',
              hintText: 'Find a language',
              width: 270,
              requestFocusOnTap: true,
              dropdownMenuEntries: _languages,
              onSelected: (String? value) => _record('Language: $value'),
            ),
          ),
          _menuDemo(
            'Multiple teams with selection chips',
            DropdownMenu<String>.multiple(
              key: const ValueKey<String>('multiple-menu'),
              semanticLabel: 'Choose teams',
              hintText: 'Add a team',
              width: 560,
              requestFocusOnTap: true,
              enableFilter: true,
              dropdownMenuEntries: _teams,
              selected: _disciplines,
              onSelectionChanged: (Set<String> values) => setState(() {
                _disciplines = values;
                _activity = 'Teams: ${values.join(', ')}';
              }),
              selectionBuilder:
                  (
                    BuildContext context,
                    List<DropdownMenuEntry<String>> selectedEntries,
                  ) => ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: <Widget>[
                        for (final DropdownMenuEntry<String> entry
                            in selectedEntries)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4F1E7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              entry.label ?? '',
                              style: const TextStyle(
                                color: _accent,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
            ),
            width: 560,
          ),
        ],
      ),
      const SizedBox(height: 22),
      Wrap(
        spacing: 22,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          _label(
            'Icon trigger / over',
            PopupMenuButton<String>(
              key: const ValueKey<String>('popup-over'),
              tooltip: 'Project actions over',
              semanticLabel: 'Project actions',
              icon: const DotsGlyph(),
              position: PopupMenuPosition.over,
              itemBuilder: _projectActions,
              onSelected: _selectAction,
              onCanceled: () => _record('Project menu dismissed'),
            ),
          ),
          PopupMenuButton<String>(
            key: const ValueKey<String>('popup-under'),
            semanticLabel: 'Project actions below',
            position: PopupMenuPosition.under,
            offset: const Offset(0, 8),
            itemBuilder: _projectActions,
            onSelected: _selectAction,
            child: const Text('Project actions below'),
          ),
        ],
      ),
    ],
  );

  Widget _decorations() => _section(
    '07',
    'Decorations',
    'Pass a BoxDecoration directly for a surface that stays consistent in every interaction state.',
    <Widget>[
      ElevatedButton(
        key: const ValueKey<String>('decorated-button'),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF087F6D), Color(0xFF20594F)],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0x26087F6D),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        onPressed: () => _record('Decorated button activated'),
        child: const Text('A gradient, directly'),
      ),
      const SizedBox(height: 18),
      ListTile(
        key: const ValueKey<String>('decorated-tile'),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/decoration_pattern.png'),
            repeat: ImageRepeat.repeat,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.fromBorderSide(BorderSide(color: _line)),
        ),
        title: const Text('A little texture'),
        subtitle: const Text('An asset image in a widget-level decoration.'),
        trailing: const _ArrowGlyph(),
        onTap: () => _record('Decorated tile activated'),
      ),
      const SizedBox(height: 18),
      Row(
        children: <Widget>[
          const Text('Custom track and thumb'),
          const Spacer(),
          Text(
            '${(_decorationValue * 100).round()}%',
            key: const ValueKey<String>('decorated-slider-value'),
            style: const TextStyle(color: _accent),
          ),
        ],
      ),
      Slider(
        key: const ValueKey<String>('decorated-slider'),
        value: _decorationValue,
        trackDecoration: const BoxDecoration(
          color: Color(0xFFE6D9BC),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        thumbDecoration: const BoxDecoration(
          color: Color(0xFFF3D694),
          shape: BoxShape.circle,
          border: Border.fromBorderSide(BorderSide(color: _ink, width: 2)),
        ),
        style: const SliderStyle(
          trackHeight: StateProperty<double?>.all(8),
          thumbSize: StateProperty<Size?>.all(Size(24, 24)),
        ),
        onChanged: (double value) => setState(() {
          _decorationValue = value;
        }),
      ),
      const SizedBox(height: 10),
      _label(
        'A constant thumb, in either position',
        Switch(
          key: const ValueKey<String>('decorated-switch'),
          value: _decorationSwitched,
          semanticLabel: 'Decorated switch',
          thumbDecoration: const BoxDecoration(
            color: Color(0xFFF3D694),
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color: _ink)),
          ),
          onChanged: (bool value) => setState(() {
            _decorationSwitched = value;
          }),
        ),
      ),
    ],
  );

  Widget _foundations() {
    final NeutralLocalizations strings = NeutralLocalizations.of(context);
    final DateTime date = DateTime(2026, 10, 16);
    return _section(
      '08',
      'Foundations',
      'Directional glyphs, localized dates and smooth anchored overlays.',
      <Widget>[
        const IconTheme(
          data: IconThemeData(color: _accent, size: 28),
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            children: <Widget>[
              ChevronGlyph(direction: GlyphDirection.start),
              ChevronGlyph(direction: GlyphDirection.end),
              CloseGlyph(),
              SearchGlyph(),
              CalendarGlyph(),
              ClockGlyph(),
              EditGlyph(),
              ArrowGlyph(direction: GlyphDirection.start),
              ArrowGlyph(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(strings.formatFullDate(date)),
        Text(
          strings.formatCompactDate(date),
          style: const TextStyle(color: _muted),
        ),
        const SizedBox(height: 20),
        PopupMenuButton<String>(
          key: const ValueKey<String>('consume-menu'),
          style: PopupMenuStyle(
            buttonStyle: _button(),
            menuStyle: _menuPanel().copyWith(
              outsideTapBehavior: OutsideTapBehavior.consume,
            ),
            itemStyle: _menuItem(),
          ),
          onSelected: (String value) => _record(value),
          itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Foundation selected',
              child: Text('Select foundation'),
            ),
          ],
          child: const Text('Open an overlay'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
    child: ColoredBox(
      color: _canvas,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'p',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'neutralui',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                      ),
                      const Spacer(),
                      _label(
                        'RTL',
                        Switch(
                          value: _rtl,
                          onChanged: (bool value) => setState(() {
                            _rtl = value;
                            widget.onDirectionChanged?.call(value);
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Structure first.\nMake it yours.',
                    style: TextStyle(
                      fontSize: 48,
                      height: 1.08,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Accessible controls. Composable themes. Every visual choice is yours.',
                    style: TextStyle(color: _muted, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'NEUTRALUI / COMPONENT GALLERY',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _section(
                    '01',
                    'Actions',
                    'Pointer, keyboard, focus and loading states share one interaction model.',
                    <Widget>[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () =>
                                _record('Primary action activated'),
                            child: const Text('Create project'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _record('Outline action activated'),
                            icon: const _PlusGlyph(),
                            label: const Text('Add item'),
                          ),
                          TextButton(
                            onPressed: () => _record('Text action activated'),
                            child: const Text('Learn more'),
                          ),
                          IconButton(
                            icon: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CustomPaint(painter: _StarPainter()),
                            ),
                            selectedIcon: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CustomPaint(
                                painter: _StarPainter(filled: true),
                              ),
                            ),
                            isSelected: _selected,
                            tooltip: 'Favorite',
                            onPressed: () => setState(() {
                              _selected = !_selected;
                            }),
                          ),
                          const ElevatedButton(
                            onPressed: null,
                            child: Text('Unavailable'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => setState(() {
                              _loading = true;
                            }),
                            isLoading: _loading,
                            child: const Text('Save changes'),
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              _loading = false;
                            }),
                            child: const Text('Reset loading'),
                          ),
                          OutlinedButton(
                            onPressed: () => _record('Slots action activated'),
                            leading: const _PlusGlyph(),
                            trailing: const _ArrowGlyph(),
                            child: const Text('With slots'),
                          ),
                          Builder(
                            builder: (BuildContext context) => ElevatedButton(
                              onPressed: () =>
                                  _record('Inline theme activated'),
                              style: ElevatedButtonTheme.of(context).copyWith(
                                decoration:
                                    const StateProperty<Decoration?>.all(
                                      BoxDecoration(
                                        color: Color(0xFF394F88),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(24),
                                        ),
                                      ),
                                    ),
                              ),
                              child: const Text('Inline copyWith'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _section(
                    '02',
                    'Selection',
                    'Controlled values with touch targets, directional layout and native radio groups.',
                    <Widget>[
                      Wrap(
                        spacing: 28,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          _label(
                            'Tri-state',
                            Checkbox(
                              value: _checked,
                              tristate: true,
                              semanticLabel: 'Tri-state',
                              onChanged: (bool? value) => setState(() {
                                _checked = value;
                              }),
                            ),
                          ),
                          _label(
                            'Notifications',
                            Switch(
                              value: _switched,
                              semanticLabel: 'Notifications',
                              onChanged: (bool value) => setState(() {
                                _switched = value;
                              }),
                            ),
                          ),
                          _label(
                            'Disabled',
                            const Checkbox(value: true, onChanged: null),
                          ),
                          for (final int value in <int>[1, 2])
                            _label(
                              'Option $value',
                              Radio<int>(
                                value: value,
                                groupValue: _radio,
                                onChanged: (int? value) => setState(() {
                                  _radio = value;
                                }),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RadioGroup<int>(
                        groupValue: _groupRadio,
                        onChanged: (int? value) => setState(() {
                          _groupRadio = value;
                        }),
                        child: Wrap(
                          spacing: 22,
                          children: <Widget>[
                            _label(
                              'Group: personal',
                              const Radio<int>(value: 1),
                            ),
                            _label('Group: team', const Radio<int>(value: 2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _section(
                    '03',
                    'Content rows',
                    'One, two and three-line content with leading and trailing slots.',
                    <Widget>[
                      ListTile(
                        leading: const Text(
                          '01',
                          style: TextStyle(color: _accent),
                        ),
                        title: const Text('Your workspace'),
                        trailing: const _ArrowGlyph(),
                        onTap: () => _record('Workspace opened'),
                      ),
                      ListTile(
                        selected: true,
                        leading: const Text(
                          '02',
                          style: TextStyle(color: _accent),
                        ),
                        title: const Text('Stay in the loop'),
                        subtitle: const Text(
                          'Updates delivered on your terms.',
                        ),
                        trailing: Switch(
                          value: _switched,
                          onChanged: (bool value) => setState(() {
                            _switched = value;
                          }),
                        ),
                      ),
                      const ListTile(
                        isThreeLine: true,
                        leading: Text('03', style: TextStyle(color: _accent)),
                        title: Text('Room for more'),
                        subtitle: Text(
                          'Longer descriptions flow naturally.\nThe theme controls spacing and minimum height.',
                        ),
                      ),
                      const ListTile(
                        enabled: false,
                        title: Text('An unavailable item'),
                        subtitle: Text(
                          'Disabled controls retain their structure.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _section(
                    '04',
                    'Range',
                    'Drag, tap or use arrow keys. The same geometry works in both directions.',
                    <Widget>[
                      Row(
                        children: <Widget>[
                          const Text('Volume'),
                          const Spacer(),
                          Text(
                            '${(_value * 100).round()}%',
                            style: const TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _value,
                        secondaryTrackValue: 0.8,
                        onChanged: (double value) => setState(() {
                          _value = value;
                        }),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Discrete steps',
                        style: TextStyle(color: _muted),
                      ),
                      Slider(
                        value: _discrete,
                        divisions: 5,
                        label: '${(_discrete * 100).round()}%',
                        onChanged: (double value) => setState(() {
                          _discrete = value;
                        }),
                        style: SliderStyle(
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
                      ),
                      const Slider(value: 0.3, onChanged: null),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _section(
                    '05',
                    'Local themes',
                    'A subtree can inherit selected tokens or replace a component theme.',
                    <Widget>[
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: <Widget>[
                          ElevatedButtonTheme.merge(
                            data: const ButtonStyle(
                              decoration: StateProperty<Decoration?>.all(
                                BoxDecoration(
                                  color: Color(0xFF85553B),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () => _record('Local theme activated'),
                              child: const Text('Local button theme'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _record('Global theme activated'),
                            child: const Text('Global sibling'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTileTheme(
                        data: const ListTileStyle(
                          contentPadding: EdgeInsets.all(16),
                          decoration: StateProperty<Decoration?>.all(
                            BoxDecoration(
                              color: Color(0xFFF4EDDF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: const Text('A local tile theme'),
                          subtitle: const Text(
                            'Only this subtree uses these tokens.',
                          ),
                          onTap: () => _record('Local tile activated'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _menus(),
                  const SizedBox(height: 18),
                  _decorations(),
                  const SizedBox(height: 18),
                  _foundations(),
                  const SizedBox(height: 18),
                  InteractionDetector(
                    onTap: () =>
                        _record('Custom interaction surface activated'),
                    builder: (BuildContext context, InteractionState state) =>
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: state.isPressed
                                ? const Color(0xFFD5EAE0)
                                : const Color(0xFFE8EFE8),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: state.isFocused ? _accent : _line,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'LIVE INTERACTION STATE',
                                style: TextStyle(
                                  color: _accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'pressed ${state.isPressed}  /  hovered ${state.isHovered}  /  focused ${state.isFocused}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _activity,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                  const SizedBox(height: 24),
                  RoadmapSections(
                    onReducedMotionChanged: widget.onReducedMotionChanged,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'NeutralUI 0.10 / Flutter widgets, your visual language.',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Paints gallery content glyphs in the ambient icon theme, like NeutralUI's glyphs.
Widget _galleryGlyph(
  BuildContext context,
  CustomPainter Function(Color color, TextDirection direction) painter,
) {
  final IconThemeData theme = IconTheme.of(context);
  return ExcludeSemantics(
    child: SizedBox.square(
      dimension: theme.size ?? 24,
      child: CustomPaint(
        painter: painter(theme.color ?? _ink, Directionality.of(context)),
      ),
    ),
  );
}

Paint _glyphStroke(Color color, Size size) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = size.shortestSide / 10
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

class _PlusGlyph extends StatelessWidget {
  const _PlusGlyph();

  @override
  Widget build(BuildContext context) => _galleryGlyph(
    context,
    (Color color, TextDirection direction) => _PlusPainter(color),
  );
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = _glyphStroke(color, size);
    canvas
      ..drawLine(
        Offset(size.width * 0.5, size.height * 0.22),
        Offset(size.width * 0.5, size.height * 0.78),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.22, size.height * 0.5),
        Offset(size.width * 0.78, size.height * 0.5),
        paint,
      );
  }

  @override
  bool shouldRepaint(_PlusPainter oldDelegate) => color != oldDelegate.color;
}

/// A forward arrow that points toward the end edge, so it mirrors in RTL.
class _ArrowGlyph extends StatelessWidget {
  const _ArrowGlyph();

  @override
  Widget build(BuildContext context) => _galleryGlyph(
    context,
    (Color color, TextDirection direction) => _ArrowPainter(color, direction),
  );
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter(this.color, this.direction);

  final Color color;
  final TextDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    double x(double fraction) =>
        size.width * (direction == TextDirection.ltr ? fraction : 1 - fraction);
    canvas.drawPath(
      Path()
        ..moveTo(x(0.2), size.height * 0.5)
        ..lineTo(x(0.8), size.height * 0.5)
        ..moveTo(x(0.56), size.height * 0.28)
        ..lineTo(x(0.8), size.height * 0.5)
        ..lineTo(x(0.56), size.height * 0.72),
      _glyphStroke(color, size),
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) =>
      color != oldDelegate.color || direction != oldDelegate.direction;
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final Path path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.8)
      ..lineTo(size.width * 0.9, size.height * 0.2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => false;
}

class _StarPainter extends CustomPainter {
  const _StarPainter({this.filled = false});

  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    const List<Offset> points = <Offset>[
      Offset(0.5, 0.04),
      Offset(0.64, 0.34),
      Offset(0.97, 0.39),
      Offset(0.73, 0.63),
      Offset(0.79, 0.96),
      Offset(0.5, 0.8),
      Offset(0.21, 0.96),
      Offset(0.27, 0.63),
      Offset(0.03, 0.39),
      Offset(0.36, 0.34),
    ];
    final Path path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    path.close();
    final Paint paint = Paint()
      ..color = _ink
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => filled != oldDelegate.filled;
}
