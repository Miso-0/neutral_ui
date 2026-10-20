import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('editing, submission, clear and password reveal are controlled', (
    WidgetTester tester,
  ) async {
    final TextEditingController text = TextEditingController();
    final FocusNode focus = FocusNode();
    addTearDown(text.dispose);
    addTearDown(focus.dispose);
    final List<String> changes = <String>[];
    String? submitted;
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: TextField(
          controller: text,
          focusNode: focus,
          labelText: 'Password',
          obscureText: true,
          showClearButton: true,
          showObscureTextToggle: true,
          onChanged: changes.add,
          onSubmitted: (String value) => submitted = value,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'secret');
    await tester.pumpAndSettle();
    expect(text.text, 'secret');
    expect(changes, <String>['secret']);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
    await tester.tap(find.byType(EyeGlyph));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(submitted, 'secret');
    await tester.tap(find.byType(CloseGlyph));
    await tester.pumpAndSettle();
    expect(text.text, '');
    expect(changes.last, '');
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('form validates, saves, resets and follows controller changes', (
    WidgetTester tester,
  ) async {
    final GlobalKey<FormState> form = GlobalKey<FormState>();
    final TextEditingController text = TextEditingController(text: 'first');
    addTearDown(text.dispose);
    String? saved;
    await pumpNeutralApp(
      tester,
      Form(
        key: form,
        child: SizedBox(
          width: 300,
          child: TextFormField(
            controller: text,
            labelText: 'Name',
            validator: (String? value) =>
                value?.isEmpty == true ? 'Required' : null,
            onSaved: (String? value) => saved = value,
          ),
        ),
      ),
    );
    text.clear();
    await tester.pump();
    expect(form.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'second');
    expect(form.currentState!.validate(), isTrue);
    form.currentState!.save();
    expect(saved, 'second');
    form.currentState!.reset();
    await tester.pumpAndSettle();
    expect(text.text, 'first');
  });

  testWidgets('error and disabled flags resolve style tokens and RTL slots', (
    WidgetTester tester,
  ) async {
    final List<InteractionState> states = <InteractionState>[];
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: TextField(
          enabled: false,
          errorText: 'Invalid',
          prefix: const Text('Before'),
          suffix: const Text('After'),
          style: TextFieldStyle(
            decoration: StateProperty<Decoration?>.resolveWith((
              InteractionState state,
            ) {
              states.add(state);
              return const BoxDecoration();
            }),
          ),
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    expect(states.last.isError, isTrue);
    expect(states.last.isDisabled, isTrue);
    expect(
      tester.getCenter(find.text('Before')).dx,
      greaterThan(tester.getCenter(find.text('After')).dx),
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).readOnly,
      isTrue,
    );
  });

  testWidgets(
    'maximum length limits input and preserves controller ownership',
    (WidgetTester tester) async {
      final TextEditingController first = TextEditingController();
      final TextEditingController second = TextEditingController(text: 'new');
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      Widget field(TextEditingController controller) => SizedBox(
        width: 200,
        child: TextField(controller: controller, maxLength: 3),
      );
      await pumpNeutralApp(tester, field(first));
      await tester.enterText(find.byType(EditableText), 'long');
      await tester.pump();
      expect(first.text, 'lon');
      await pumpNeutralApp(tester, field(second));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller,
        second,
      );
      first.text = 'ok';
      expect(second.text, 'new');
    },
  );
}
