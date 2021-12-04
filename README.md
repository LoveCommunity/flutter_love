# flutter_love

[![Build Status](https://github.com/LoveCommunity/flutter_love/workflows/Tests/badge.svg)](https://github.com/LoveCommunity/flutter_love/actions/workflows/tests.yml)
[![Coverage Status](https://img.shields.io/codecov/c/github/LoveCommunity/flutter_love/main.svg)](https://codecov.io/gh/LoveCommunity/flutter_love)
[![Pub](https://img.shields.io/pub/v/flutter_love)](https://pub.dev/packages/flutter_love)

`flutter_love` provide flutter widgets handle common use case with [love] state management library.

### `React` Widget

**`React` Widget is a combination of `react operator` and widget builder.**

It can consume a `System` with widget `builder`:

```dart

System<int, CounterEvent> createCounterSystem() { ... }

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

```

## License

The MIT License (MIT)

[love]:https://pub.dev/packages/love