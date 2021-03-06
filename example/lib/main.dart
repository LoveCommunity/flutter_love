import 'package:flutter/material.dart';
import 'package:flutter_love/flutter_love.dart';

// typedef CounterState = int;

abstract class CounterEvent {}
class Increment implements CounterEvent {}
class Decrement implements CounterEvent {}

System<int, CounterEvent> createCounterSystem() {
  return System<int, CounterEvent>
    .create(initialState: 0)
    .on<Increment>(
      reduce: (state, event) => state + 1,
      effect: (state, event, dispatch) async {
        await Future.delayed(Duration(seconds: 3));
        dispatch(Decrement());
      },
    )
    .on<Decrement>(
      reduce: (state, event) => state - 1,
    )
    .log()
    .reactState(
      effect: (state, dispatch) {
        print('Simulate persistence save call with state: $state');
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
      home: UseReactWidgetPage(),
    );
  }
}

/// use `React` widget
class UseReactWidgetPage extends StatefulWidget {

  @override
  createState() => _UseReactWidgetPageState();
}

class _UseReactWidgetPageState extends State<UseReactWidgetPage> {

  late final System<int, CounterEvent> _system;

  @override
  void initState() {
    super.initState();
    _system = createCounterSystem();
  }

  @override
  Widget build(BuildContext context) {
    return ReactState<int, CounterEvent>(
      system: _system,
      builder: (context, state, dispatch) {
        return CounterPage(
          title: 'Use React Widget Page',
          count: state,
          onIncreasePressed: () => dispatch(Increment()),
        );
      }
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
