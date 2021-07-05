import 'package:flutter/material.dart';
import 'package:love/love.dart';
import 'package:flutter_love/flutter_love.dart';
import 'package:provider/provider.dart';

// typedef CounterState = int;

abstract class CounterEvent {}
class CounterEventIncrease implements CounterEvent {}
class CounterEventDecrease implements CounterEvent {}

System<int, CounterEvent> createCouterSystem() {
  return System<int, CounterEvent>
    .create(initialState: 0)
    .on<CounterEventIncrease>(
      reduce: (state, event) => state + 1,
      effect: (state, event, dispatch) async {
        await Future.delayed(Duration(seconds: 3));
        dispatch(CounterEventDecrease());
      },
    )
    .on<CounterEventDecrease>(
      reduce: (state, event) => state - 1,
    )
    .add(effect: (state, oldState, event, dispatch) {
      print('\nEvent: $event');
      print('State: $state');
      print('OldState: $oldState');
    })
    .react<int>(
      value: (state) => state,
      skipFirstValue: true,
      effect: (value, dispatch) {
        print('Simulate persistence save call with state: $value');
      },
    );
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UseReactWidgetPage(), // use `React` widget
      // home: UseStoreProviderPage(), // or use `StoreProvider`
    );
  }
}

/// option 1: use `React` widget
class UseReactWidgetPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => createCouterSystem()
        .share(),
      child: ReactState<int, CounterEvent>(
        builder: (context, state, dispatch) {
          return CounterPage(
            title: 'Use React Widget Page',
            count: state,
            onIncreasePressed: () => dispatch(CounterEventIncrease()),
          );
        }
      ),
    );
  }
}

/// option 2: use `StoreProvider`
class UseStoreProviderPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      create: (_) => createCouterSystem()
        .asEffectSystem(),
      builder: (context, _) {
        final store = context.watch<Store<int, CounterEvent>>();
        return CounterPage(
          title: 'Use Store Provider Page', 
          count: store.state, 
          onIncreasePressed: () => store.dispatch(CounterEventIncrease())
        );
      },
    );
  }
}

class CounterPage extends StatelessWidget {

  const CounterPage({
    Key? key,
    required this.title,
    required this.count,
    required this.onIncreasePressed,
  }) : super(key: key);

  final String title;
  final int count;
  final VoidCallback onIncreasePressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onIncreasePressed,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
