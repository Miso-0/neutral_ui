import 'package:flutter/widgets.dart';

import '../examples/buttons/button_slots_example.dart';
import '../examples/buttons/disabled_buttons_example.dart';
import '../examples/buttons/elevated_button_example.dart';
import '../examples/buttons/favorite_icon_button_example.dart';
import '../examples/buttons/filled_buttons_example.dart';
import '../examples/buttons/floating_action_buttons_example.dart';
import '../examples/buttons/loading_button_example.dart';
import '../examples/buttons/outlined_button_example.dart';
import '../examples/buttons/segmented_button_example.dart';
import '../examples/buttons/text_button_example.dart';
import '../examples/buttons/toggle_buttons_example.dart';
import '../examples/chips/chip_example.dart';
import '../examples/chips/choice_chip_example.dart';
import '../examples/chips/filter_chip_example.dart';
import '../examples/chips/input_chip_example.dart';
import '../examples/feedback/alert_dialog_example.dart';
import '../examples/feedback/badge_example.dart';
import '../examples/feedback/bottom_sheet_example.dart';
import '../examples/feedback/progress_example.dart';
import '../examples/feedback/simple_dialog_example.dart';
import '../examples/feedback/snack_bar_example.dart';
import '../examples/feedback/tooltip_example.dart';
import '../examples/foundations/consume_overlay_example.dart';
import '../examples/foundations/decorations_example.dart';
import '../examples/foundations/glyphs_example.dart';
import '../examples/foundations/inline_style_example.dart';
import '../examples/foundations/interaction_example.dart';
import '../examples/foundations/local_themes_example.dart';
import '../examples/foundations/localized_dates_example.dart';
import '../examples/input/autocomplete_example.dart';
import '../examples/input/full_screen_search_example.dart';
import '../examples/input/password_example.dart';
import '../examples/input/search_bar_example.dart';
import '../examples/input/text_field_example.dart';
import '../examples/input/validated_field_example.dart';
import '../examples/lists/list_tiles_example.dart';
import '../examples/menus/dropdown_button_example.dart';
import '../examples/menus/expanded_dropdown_example.dart';
import '../examples/menus/filter_dropdown_example.dart';
import '../examples/menus/multiple_dropdown_example.dart';
import '../examples/menus/popup_menu_example.dart';
import '../examples/menus/search_dropdown_example.dart';
import '../examples/navigation/expansion_tile_example.dart';
import '../examples/navigation/navigation_bar_example.dart';
import '../examples/navigation/navigation_drawer_example.dart';
import '../examples/navigation/navigation_rail_example.dart';
import '../examples/navigation/tab_bar_example.dart';
import '../examples/pickers/calendar_date_picker_example.dart';
import '../examples/pickers/calendar_date_range_picker_example.dart';
import '../examples/pickers/date_picker_field_example.dart';
import '../examples/pickers/input_date_picker_example.dart';
import '../examples/pickers/modal_date_picker_example.dart';
import '../examples/pickers/modal_date_range_picker_example.dart';
import '../examples/pickers/modal_time_picker_example.dart';
import '../examples/pickers/time_picker_example.dart';
import '../examples/sliders/continuous_slider_example.dart';
import '../examples/sliders/discrete_slider_example.dart';
import '../examples/sliders/range_slider_example.dart';
import '../examples/tables/grouped_workstreams_example.dart';
import '../examples/tables/project_table_example.dart';
import '../examples/toggles/checkbox_example.dart';
import '../examples/toggles/radio_example.dart';
import '../examples/toggles/radio_group_example.dart';
import '../examples/toggles/switch_example.dart';

/// A standalone widget and its bundled, copyable source file.
class ExampleEntry {
  /// Creates a component example.
  const ExampleEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.sourcePath,
    required this.builder,
  });

  /// A globally unique example identifier.
  final String id;

  /// The human-readable example name.
  final String title;

  /// A short explanation, including any required external assets.
  final String description;

  /// The exact file used by both the preview and the copy button.
  final String sourcePath;

  /// Creates the live preview.
  final WidgetBuilder builder;
}

/// A shareable component family and its examples.
class ComponentCategory {
  /// Creates a category in the library catalog.
  const ComponentCategory({
    required this.id,
    required this.title,
    required this.summary,
    required this.examples,
  });

  /// The URL path segment for this category.
  final String id;

  /// The human-readable family name.
  final String title;

  /// A short introduction to the family.
  final String summary;

  /// Every live example in this family.
  final List<ExampleEntry> examples;
}

/// The single catalog used by routes, navigation and search.
final List<ComponentCategory> componentCategories = <ComponentCategory>[
  ComponentCategory(
    id: "buttons",
    title: "Buttons",
    summary: "Actions, loading states and grouped controls.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "buttons/elevated_button",
        title: "Elevated button",
        description: "A primary action with hover, focus and pressed styles.",
        sourcePath: "lib/examples/buttons/elevated_button_example.dart",
        builder: (BuildContext context) => const ElevatedButtonExample(),
      ),
      ExampleEntry(
        id: "buttons/outlined_button",
        title: "Outlined button with icon",
        description: "An outlined action with a leading library glyph.",
        sourcePath: "lib/examples/buttons/outlined_button_example.dart",
        builder: (BuildContext context) => const OutlinedButtonExample(),
      ),
      ExampleEntry(
        id: "buttons/text_button",
        title: "Text button",
        description: "A text action with a subtle hover surface.",
        sourcePath: "lib/examples/buttons/text_button_example.dart",
        builder: (BuildContext context) => const TextButtonExample(),
      ),
      ExampleEntry(
        id: "buttons/favorite_icon_button",
        title: "Favorite icon button",
        description: "A favorite action with a controlled selected state.",
        sourcePath: "lib/examples/buttons/favorite_icon_button_example.dart",
        builder: (BuildContext context) => const FavoriteIconButtonExample(),
      ),
      ExampleEntry(
        id: "buttons/loading_button",
        title: "Loading button",
        description: "A loading state with an explicit reset action.",
        sourcePath: "lib/examples/buttons/loading_button_example.dart",
        builder: (BuildContext context) => const LoadingButtonExample(),
      ),
      ExampleEntry(
        id: "buttons/button_slots",
        title: "Leading and trailing slots",
        description: "An action with independent leading and trailing content.",
        sourcePath: "lib/examples/buttons/button_slots_example.dart",
        builder: (BuildContext context) => const ButtonSlotsExample(),
      ),
      ExampleEntry(
        id: "buttons/disabled_buttons",
        title: "Disabled buttons",
        description: "Disabled actions preserve their shape and expose disabled semantics.",
        sourcePath: "lib/examples/buttons/disabled_buttons_example.dart",
        builder: (BuildContext context) => const DisabledButtonsExample(),
      ),
      ExampleEntry(
        id: "buttons/filled_buttons",
        title: "Filled and tonal buttons",
        description: "Filled actions and a tonal action with a glyph.",
        sourcePath: "lib/examples/buttons/filled_buttons_example.dart",
        builder: (BuildContext context) => const FilledButtonsExample(),
      ),
      ExampleEntry(
        id: "buttons/floating_action_buttons",
        title: "Floating action buttons",
        description: "Small, large and extended floating actions.",
        sourcePath: "lib/examples/buttons/floating_action_buttons_example.dart",
        builder: (BuildContext context) => const FloatingActionButtonsExample(),
      ),
      ExampleEntry(
        id: "buttons/segmented_button",
        title: "Segmented button",
        description: "Controlled selection across a group of day, week and month actions.",
        sourcePath: "lib/examples/buttons/segmented_button_example.dart",
        builder: (BuildContext context) => const SegmentedButtonExample(),
      ),
      ExampleEntry(
        id: "buttons/toggle_buttons",
        title: "Toggle buttons",
        description: "An index-based list or grid selector.",
        sourcePath: "lib/examples/buttons/toggle_buttons_example.dart",
        builder: (BuildContext context) => const ToggleButtonsExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "toggles",
    title: "Selection",
    summary: "Checkboxes, switches and radios with local state.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "toggles/checkbox",
        title: "Tri-state checkbox",
        description: "A checkbox cycles through selected, clear and indeterminate, alongside a disabled variant.",
        sourcePath: "lib/examples/toggles/checkbox_example.dart",
        builder: (BuildContext context) => const CheckboxExample(),
      ),
      ExampleEntry(
        id: "toggles/switch",
        title: "Switch",
        description:
            "A controlled notification switch with a styled track and thumb.",
        sourcePath: "lib/examples/toggles/switch_example.dart",
        builder: (BuildContext context) => const SwitchExample(),
      ),
      ExampleEntry(
        id: "toggles/radio",
        title: "Radio",
        description: "Two radio controls share an explicit selected value.",
        sourcePath: "lib/examples/toggles/radio_example.dart",
        builder: (BuildContext context) => const RadioExample(),
      ),
      ExampleEntry(
        id: "toggles/radio_group",
        title: "RadioGroup",
        description: "A native radio group coordinates keyboard navigation and selection.",
        sourcePath: "lib/examples/toggles/radio_group_example.dart",
        builder: (BuildContext context) => const RadioGroupExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "lists",
    title: "List tiles",
    summary: "Flexible rows for one, two or three lines of content.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "lists/list_tiles",
        title: "List tiles",
        description: "One, two and three-line tiles, a trailing switch, and a disabled row.",
        sourcePath: "lib/examples/lists/list_tiles_example.dart",
        builder: (BuildContext context) => const ListTilesExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "sliders",
    title: "Sliders",
    summary: "Continuous, discrete and range selection.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "sliders/continuous_slider",
        title: "Continuous slider",
        description: "A continuous slider with a secondary track and a disabled variant.",
        sourcePath: "lib/examples/sliders/continuous_slider_example.dart",
        builder: (BuildContext context) => const ContinuousSliderExample(),
      ),
      ExampleEntry(
        id: "sliders/discrete_slider",
        title: "Discrete slider",
        description:
            "A slider with discrete stops and a custom value indicator.",
        sourcePath: "lib/examples/sliders/discrete_slider_example.dart",
        builder: (BuildContext context) => const DiscreteSliderExample(),
      ),
      ExampleEntry(
        id: "sliders/range_slider",
        title: "Range slider",
        description: "Two independently controlled thumbs select a range.",
        sourcePath: "lib/examples/sliders/range_slider_example.dart",
        builder: (BuildContext context) => const RangeSliderExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "menus",
    title: "Menus",
    summary: "Dropdowns, search, multiple selection and popup actions.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "menus/dropdown_button",
        title: "Dropdown with hint",
        description:
            "A classic dropdown chooses a project type and starts with a hint.",
        sourcePath: "lib/examples/menus/dropdown_button_example.dart",
        builder: (BuildContext context) => const DropdownButtonExample(),
      ),
      ExampleEntry(
        id: "menus/expanded_dropdown",
        title: "Expanded and disabled dropdowns",
        description: "A dropdown fills available width while another shows its disabled hint.",
        sourcePath: "lib/examples/menus/expanded_dropdown_example.dart",
        builder: (BuildContext context) => const ExpandedDropdownExample(),
      ),
      ExampleEntry(
        id: "menus/filter_dropdown",
        title: "Dropdown with search builder",
        description: "Typing filters city results using a search builder.",
        sourcePath: "lib/examples/menus/filter_dropdown_example.dart",
        builder: (BuildContext context) => const FilterDropdownExample(),
      ),
      ExampleEntry(
        id: "menus/search_dropdown",
        title: "Highlight search dropdown",
        description: "Typing highlights matching languages while keeping all options visible.",
        sourcePath: "lib/examples/menus/search_dropdown_example.dart",
        builder: (BuildContext context) => const SearchDropdownExample(),
      ),
      ExampleEntry(
        id: "menus/multiple_dropdown",
        title: "Multiple selection dropdown",
        description:
            "A searchable team selector displays its selected values as chips.",
        sourcePath: "lib/examples/menus/multiple_dropdown_example.dart",
        builder: (BuildContext context) => const MultipleDropdownExample(),
      ),
      ExampleEntry(
        id: "menus/popup_menu",
        title: "Popup menus",
        description: "Project action menus open over or under their triggers and support checked and disabled rows.",
        sourcePath: "lib/examples/menus/popup_menu_example.dart",
        builder: (BuildContext context) => const PopupMenuExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "input",
    title: "Text input",
    summary: "Fields, validation, autocomplete and search.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "input/text_field",
        title: "Text field with clear",
        description:
            "A text field with an accessible clear action and local output.",
        sourcePath: "lib/examples/input/text_field_example.dart",
        builder: (BuildContext context) => const TextFieldExample(),
      ),
      ExampleEntry(
        id: "input/password",
        title: "Password reveal",
        description: "A compact password field with a reveal button.",
        sourcePath: "lib/examples/input/password_example.dart",
        builder: (BuildContext context) => const PasswordExample(),
      ),
      ExampleEntry(
        id: "input/validated_field",
        title: "Validated text form field",
        description: "An email field with form validation and save feedback.",
        sourcePath: "lib/examples/input/validated_field_example.dart",
        builder: (BuildContext context) => const ValidatedFieldExample(),
      ),
      ExampleEntry(
        id: "input/autocomplete",
        title: "Autocomplete",
        description: "City autocomplete with locally styled options.",
        sourcePath: "lib/examples/input/autocomplete_example.dart",
        builder: (BuildContext context) => const AutocompleteExample(),
      ),
      ExampleEntry(
        id: "input/search_bar",
        title: "Search bar",
        description: "Search suggestions in a docked panel.",
        sourcePath: "lib/examples/input/search_bar_example.dart",
        builder: (BuildContext context) => const SearchBarExample(),
      ),
      ExampleEntry(
        id: "input/full_screen_search",
        title: "Full-screen search",
        description: "Search suggestions in a full-screen route.",
        sourcePath: "lib/examples/input/full_screen_search_example.dart",
        builder: (BuildContext context) => const FullScreenSearchExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "pickers",
    title: "Dates and time",
    summary: "Inline calendars, anchored fields and modal pickers.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "pickers/calendar_date_picker",
        title: "Calendar date picker",
        description: "A calendar with all appearance tokens in this file.",
        sourcePath: "lib/examples/pickers/calendar_date_picker_example.dart",
        builder: (BuildContext context) => const CalendarDatePickerExample(),
      ),
      ExampleEntry(
        id: "pickers/date_picker_field",
        title: "Date picker field",
        description: "An anchored calendar field with explicit field and calendar styles.",
        sourcePath: "lib/examples/pickers/date_picker_field_example.dart",
        builder: (BuildContext context) => const DatePickerFieldExample(),
      ),
      ExampleEntry(
        id: "pickers/input_date_picker",
        title: "Input date picker form field",
        description: "A localized date input validated by an enclosing form.",
        sourcePath: "lib/examples/pickers/input_date_picker_example.dart",
        builder: (BuildContext context) => const InputDatePickerExample(),
      ),
      ExampleEntry(
        id: "pickers/modal_date_picker",
        title: "Date picker dialog",
        description: "A modal date picker with its own dialog, input and action styling.",
        sourcePath: "lib/examples/pickers/modal_date_picker_example.dart",
        builder: (BuildContext context) => const ModalDatePickerExample(),
      ),
      ExampleEntry(
        id: "pickers/modal_date_range_picker",
        title: "Date range picker dialog",
        description: "A modal range calendar with a locally styled input mode.",
        sourcePath: "lib/examples/pickers/modal_date_range_picker_example.dart",
        builder: (BuildContext context) => const ModalDateRangePickerExample(),
      ),
      ExampleEntry(
        id: "pickers/calendar_date_range_picker",
        title: "Calendar date range picker",
        description: "A scrollable calendar for choosing a date range.",
        sourcePath:
            "lib/examples/pickers/calendar_date_range_picker_example.dart",
        builder: (BuildContext context) =>
            const CalendarDateRangePickerExample(),
      ),
      ExampleEntry(
        id: "pickers/time_picker",
        title: "Inline time picker",
        description:
            "A clock dial with locally styled time and period controls.",
        sourcePath: "lib/examples/pickers/time_picker_example.dart",
        builder: (BuildContext context) => const TimePickerExample(),
      ),
      ExampleEntry(
        id: "pickers/modal_time_picker",
        title: "Time picker dialog",
        description:
            "A modal clock with self-contained dialog and input styling.",
        sourcePath: "lib/examples/pickers/modal_time_picker_example.dart",
        builder: (BuildContext context) => const ModalTimePickerExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "feedback",
    title: "Feedback and overlays",
    summary: "Dialogs, sheets, notifications and status indicators.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "feedback/tooltip",
        title: "Tooltip",
        description:
            "A tooltip available on hover, long press and keyboard focus.",
        sourcePath: "lib/examples/feedback/tooltip_example.dart",
        builder: (BuildContext context) => const TooltipExample(),
      ),
      ExampleEntry(
        id: "feedback/alert_dialog",
        title: "Alert dialog",
        description: "An alert dialog whose surface and action styles travel with the snippet.",
        sourcePath: "lib/examples/feedback/alert_dialog_example.dart",
        builder: (BuildContext context) => const AlertDialogExample(),
      ),
      ExampleEntry(
        id: "feedback/simple_dialog",
        title: "Simple dialog",
        description: "A choice dialog with explicit option and surface styles.",
        sourcePath: "lib/examples/feedback/simple_dialog_example.dart",
        builder: (BuildContext context) => const SimpleDialogExample(),
      ),
      ExampleEntry(
        id: "feedback/bottom_sheet",
        title: "Bottom sheet",
        description: "A draggable modal sheet with an explicit surface and close action.",
        sourcePath: "lib/examples/feedback/bottom_sheet_example.dart",
        builder: (BuildContext context) => const BottomSheetExample(),
      ),
      ExampleEntry(
        id: "feedback/snack_bar",
        title: "Snack bar",
        description: "A queued message with its own messenger, undo action and close button.",
        sourcePath: "lib/examples/feedback/snack_bar_example.dart",
        builder: (BuildContext context) => const SnackBarExample(),
      ),
      ExampleEntry(
        id: "feedback/badge",
        title: "Badge",
        description: "A capped count badge and a simple status dot.",
        sourcePath: "lib/examples/feedback/badge_example.dart",
        builder: (BuildContext context) => const BadgeExample(),
      ),
      ExampleEntry(
        id: "feedback/progress",
        title: "Progress indicators",
        description: "Determinate and indeterminate progress with explicit paint tokens.",
        sourcePath: "lib/examples/feedback/progress_example.dart",
        builder: (BuildContext context) => const ProgressExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "chips",
    title: "Chips",
    summary: "Compact labels, filters and removable choices.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "chips/chip",
        title: "Chip",
        description: "A label with a decorative avatar.",
        sourcePath: "lib/examples/chips/chip_example.dart",
        builder: (BuildContext context) => const ChipExample(),
      ),
      ExampleEntry(
        id: "chips/filter_chip",
        title: "Filter chip",
        description: "Selected and disabled filters.",
        sourcePath: "lib/examples/chips/filter_chip_example.dart",
        builder: (BuildContext context) => const FilterChipExample(),
      ),
      ExampleEntry(
        id: "chips/choice_chip",
        title: "Choice chips",
        description: "Exclusive local choices.",
        sourcePath: "lib/examples/chips/choice_chip_example.dart",
        builder: (BuildContext context) => const ChoiceChipExample(),
      ),
      ExampleEntry(
        id: "chips/input_chip",
        title: "Input and action chips",
        description: "Delete and restore a label.",
        sourcePath: "lib/examples/chips/input_chip_example.dart",
        builder: (BuildContext context) => const InputChipExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "navigation",
    title: "Navigation",
    summary: "Tabs, destinations and expandable content.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "navigation/tab_bar",
        title: "Tabs",
        description: "A tab strip with a swipeable view.",
        sourcePath: "lib/examples/navigation/tab_bar_example.dart",
        builder: (BuildContext context) => const TabBarExample(),
      ),
      ExampleEntry(
        id: "navigation/navigation_bar",
        title: "Navigation bar",
        description: "A bottom navigation bar with local selection.",
        sourcePath: "lib/examples/navigation/navigation_bar_example.dart",
        builder: (BuildContext context) => const NavigationBarExample(),
      ),
      ExampleEntry(
        id: "navigation/navigation_rail",
        title: "Navigation rail",
        description: "A vertical navigation rail with selected destinations.",
        sourcePath: "lib/examples/navigation/navigation_rail_example.dart",
        builder: (BuildContext context) => const NavigationRailExample(),
      ),
      ExampleEntry(
        id: "navigation/navigation_drawer",
        title: "Navigation drawer",
        description: "A navigation drawer with controlled destinations.",
        sourcePath: "lib/examples/navigation/navigation_drawer_example.dart",
        builder: (BuildContext context) => const NavigationDrawerExample(),
      ),
      ExampleEntry(
        id: "navigation/expansion_tile",
        title: "Expansion tile",
        description: "Expandable details with maintained child state.",
        sourcePath: "lib/examples/navigation/expansion_tile_example.dart",
        builder: (BuildContext context) => const ExpansionTileExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "tables",
    title: "Tables",
    summary: "Interactive portfolios and grouped workstreams.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "tables/project_table",
        title: "Project portfolio",
        description:
            "Sort, select, expand, view totals and scroll horizontally.",
        sourcePath: "lib/examples/tables/project_table_example.dart",
        builder: (BuildContext context) => const ProjectTableExample(),
      ),
      ExampleEntry(
        id: "tables/grouped_workstreams",
        title: "Grouped workstreams",
        description: "Collapsible groups and nested task expansion.",
        sourcePath: "lib/examples/tables/grouped_workstreams_example.dart",
        builder: (BuildContext context) => const GroupedWorkstreamsExample(),
      ),
    ],
  ),
  ComponentCategory(
    id: "foundations",
    title: "Theming and foundations",
    summary: "Local themes, direct decorations, glyphs and overlay behavior.",
    examples: <ExampleEntry>[
      ExampleEntry(
        id: "foundations/local_themes",
        title: "Local component themes",
        description: "Local component themes can merge inherited styles or replace a tile style.",
        sourcePath: "lib/examples/foundations/local_themes_example.dart",
        builder: (BuildContext context) => const LocalThemesExample(),
      ),
      ExampleEntry(
        id: "foundations/inline_style",
        title: "Inline copyWith",
        description:
            "A copy of a self-contained button style changes its decoration.",
        sourcePath: "lib/examples/foundations/inline_style_example.dart",
        builder: (BuildContext context) => const InlineStyleExample(),
      ),
      ExampleEntry(
        id: "foundations/decorations",
        title: "Direct decorations",
        description: "Gradient and image surfaces, a custom slider and a constant switch thumb. Copy assets/decoration_pattern.png into your app and declare it in pubspec.yaml.",
        sourcePath: "lib/examples/foundations/decorations_example.dart",
        builder: (BuildContext context) => const DecorationsExample(),
      ),
      ExampleEntry(
        id: "foundations/glyphs",
        title: "Library glyphs",
        description: "Painted glyphs follow the icon theme and directional arrows mirror in RTL.",
        sourcePath: "lib/examples/foundations/glyphs_example.dart",
        builder: (BuildContext context) => const GlyphsExample(),
      ),
      ExampleEntry(
        id: "foundations/localized_dates",
        title: "Localized dates",
        description: "NeutralLocalizations formats full and compact dates without additional dependencies.",
        sourcePath: "lib/examples/foundations/localized_dates_example.dart",
        builder: (BuildContext context) => const LocalizedDatesExample(),
      ),
      ExampleEntry(
        id: "foundations/interaction",
        title: "InteractionDetector",
        description: "A custom interactive surface exposes live pointer and keyboard focus state.",
        sourcePath: "lib/examples/foundations/interaction_example.dart",
        builder: (BuildContext context) => const InteractionExample(),
      ),
      ExampleEntry(
        id: "foundations/consume_overlay",
        title: "Consume outside taps",
        description: "An outside tap dismisses the overlay and consumes the gesture before an underlying action can run.",
        sourcePath: "lib/examples/foundations/consume_overlay_example.dart",
        builder: (BuildContext context) => const ConsumeOverlayExample(),
      ),
    ],
  ),
];

/// Finds a category from a route path segment.
ComponentCategory? categoryById(String id) {
  for (final ComponentCategory category in componentCategories) {
    if (category.id == id) return category;
  }
  return null;
}
