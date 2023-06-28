
import 'package:flutter/widgets.dart';
import 'package:flutter_love/flutter_love.dart';
import 'package:flutter_test/flutter_test.dart';

final states = <String>[];
final values = <String>[];

void main() {

  group('ReactState', () {

    tearDown(() {
      states.clear();
    });

    testWidgets('initial state', (tester) async {

      final system = createSystem();

      await tester.pumpWidget(ReactState<String, String>(
        system: system,
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

    });

    testWidgets('state updates', (tester) async {

      final system = createSystem();

      await tester.pumpWidget(ReactState<String, String>(
        system: system,
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('b');
      await tester.pump();

      expect(states, [
        'a',
        'a|b',
      ]);
      expect(find.text('a|b'), findsOneWidget);
      
    });

    testWidgets('system dispose', (tester) async {

      int disposeInvoked = 0;

      final system = createSystem()
        .onDispose(run: () => disposeInvoked += 1);

      await tester.pumpWidget(ReactState<String, String>(
        system: system,
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(disposeInvoked, 0);
      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.pumpWidget(Container());

      expect(disposeInvoked, 1);
      expect(states, ['a']);
      expect(find.text('a'), findsNothing);
    });

    testWidgets('system replacement', (tester) async {

      int runInvokedA = 0;
      int disposeInvokedA = 0;
      int runInvokedB = 0;
      int disposeInvokedB = 0;

      final systemA = System<String, String>
        .create(initialState: 'a')
        .add(reduce: reduce)
        .onRun(effect: (_, __) { 
          runInvokedA += 1;
          return null; 
        })
        .onDispose(run: () { disposeInvokedA += 1; });
      
      final systemB = System<String, String>
        .create(initialState: 'b')
        .add(reduce: reduce)
        .onRun(effect: (_, __) { 
          runInvokedB += 1; 
          return null;  
        })
        .onDispose(run: () { disposeInvokedB += 1; });

      final key = GlobalKey();

      await tester.pumpWidget(ReactState<String, String>(
        key: key,
        system: systemA,
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(runInvokedA, 1);
      expect(disposeInvokedA, 0);
      expect(runInvokedB, 0);
      expect(disposeInvokedB, 0);
      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.pumpWidget(ReactState<String, String>(
        key: key,
        system: systemB,
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(runInvokedA, 1);
      expect(disposeInvokedA, 1);
      expect(runInvokedB, 1);
      expect(disposeInvokedB, 0);
      expect(states, [
        'a',
        'b',
      ]);
      expect(find.text('b'), findsOneWidget);

    });

    testWidgets('default equals', (tester) async {

      final system = System<String, String>
        .create(initialState: 'a')
        .add(reduce: (_, event) => event);

      await tester.pumpWidget(ReactState<String, String>(
        system: system,
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('a');
      await tester.pump();

      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('b');
      await tester.pump();

      expect(states, [
        'a',
        'b',
      ]);
      expect(find.text('b'), findsOneWidget);

    });

    testWidgets('custom equals', (tester) async {

      int equalsInvoked = 0;

      final system = System<String, String>
        .create(initialState: 'a')
        .add(reduce: (_, event) => event);
      
      await tester.pumpWidget(ReactState<String, String>(
        system: system,
        equals: (it1, it2) {
          equalsInvoked += 1;
          return it1.length == it2.length;
        },
        builder: (context, state, dispatch) {
          states.add(state);
          return builder(context, state, dispatch);
        },
      ));

      expect(equalsInvoked, 0);
      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('a');
      await tester.pump();

      expect(equalsInvoked, 1);
      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('b');
      await tester.pump();
      
      expect(equalsInvoked, 2);
      expect(states, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('ab');
      await tester.pump();

      expect(equalsInvoked, 3);
      expect(states, [
        'a',
        'ab',
      ]);
      expect(find.text('ab'), findsOneWidget);

    });
  });

  group('React', () {

    tearDown(() {
      values.clear();
    });

    testWidgets('initial state', (tester) async {

      final system = createSystem();

      await tester.pumpWidget(React<String, String, String>(
        system: system,
        value: (state) => state.split('|').last,
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

    });
    
    testWidgets('state updates', (tester) async {

      final system = createSystem();

      await tester.pumpWidget(React<String, String, String>(
        system: system,
        value: (state) => state.split('|').last,
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('b');
      await tester.pump();

      expect(values, [
        'a',
        'b',
      ]);
      expect(find.text('b'), findsOneWidget);

    });

    testWidgets('system dispose', (tester) async {

      int disposeInvoked = 0;

      final system = createSystem()
        .onDispose(run: () => disposeInvoked += 1);

      await tester.pumpWidget(React<String, String, String>(
        system: system,
        value: (state) => state.split('|').last,
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(disposeInvoked, 0);
      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.pumpWidget(Container());

      expect(disposeInvoked, 1);
      expect(values, ['a']);
      expect(find.text('a'), findsNothing);

    });

    testWidgets('system replacement', (tester) async {

      int runInvokedA = 0;
      int disposeInvokedA = 0;
      int runInvokedB = 0;
      int disposeInvokedB = 0;

      final systemA = System<String, String>
        .create(initialState: 'a')
        .add(reduce: reduce)
        .onRun(effect: (_, __) { 
          runInvokedA += 1;
          return null; 
        })
        .onDispose(run: () { disposeInvokedA += 1; });
      
      final systemB = System<String, String>
        .create(initialState: 'b')
        .add(reduce: reduce)
        .onRun(effect: (_, __) { 
          runInvokedB += 1;
          return null; 
        })
        .onDispose(run: () { disposeInvokedB += 1; });

      final key = GlobalKey();

      await tester.pumpWidget(React<String, String, String>(
        key: key,
        system: systemA,
        value: (state) => state.split('|').last,
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(runInvokedA, 1);
      expect(disposeInvokedA, 0);
      expect(runInvokedB, 0);
      expect(disposeInvokedB, 0);
      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.pumpWidget(React<String, String, String>(
        key: key,
        system: systemB,
        value: (state) => state.split('|').last,
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(runInvokedA, 1);
      expect(disposeInvokedA, 1);
      expect(runInvokedB, 1);
      expect(disposeInvokedB, 0);
      expect(values, [
        'a',
        'b',
      ]);
      expect(find.text('b'), findsOneWidget);

    });

    testWidgets('default equals', (tester) async {

      final system = createSystem();

      await tester.pumpWidget(React<String, String, String>(
        system: system,
        value: (state) => state.split('|').last,
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('a');
      await tester.pump();

      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('b');
      await tester.pump();

      expect(values, [
        'a',
        'b',
      ]);
      expect(find.text('b'), findsOneWidget);
      
    });

    testWidgets('custom equals', (tester) async {

      int equalsInvoked = 0;

      final system = createSystem();

      await tester.pumpWidget(React<String, String, String>(
        system: system,
        value: (state) => state.split('|').last,
        equals: (it1, it2) {
          equalsInvoked += 1;
          return it1.length == it2.length;
        },
        builder: (context, value, dispatch) {
          values.add(value);
          return builder(context, value, dispatch);
        },
      ));

      expect(equalsInvoked, 0);
      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('a');
      await tester.pump();

      expect(equalsInvoked, 1);
      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('b');
      await tester.pump();

      expect(equalsInvoked, 2);
      expect(values, ['a']);
      expect(find.text('a'), findsOneWidget);

      await tester.dispatchText('ab');
      await tester.pump();

      expect(equalsInvoked, 3);
      expect(values, [
        'a',
        'ab',
      ]);
      expect(find.text('ab'), findsOneWidget);
    });
  });
}

System<String, String> createSystem() 
  => System<String, String>
  .create(initialState: 'a')
  .add(reduce: reduce);

String reduce(String state, String event)
  => '$state|$event';

late String _eventText;

Widget builder(BuildContext context, String state, Dispatch<String> dispatch)
  => GestureDetector(
    onTap: () => dispatch(_eventText),
    child: Text(state, textDirection: TextDirection.ltr),
  );

extension on WidgetTester {

  Future<void> dispatchText(String text) async {
    _eventText = text;
    await tap(find.byType(Text));
  }
}