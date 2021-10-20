# flutter_love

`flutter_love` provide flutter widgets handle common use case with [love] state management library, so fall in `love` with `flutter`.

## Getting Started

There are mainly one option to integrate [love] with flutter:

1. `React` Widget

### 1. `React` Widget

**`React` Widget is a combination of `react operator` and widget builder.**

It can consume a `System` with widget `builder`:

```dart

System<int, CounterEvent> createCounterSystem() { ... }

class UseReactWidgetPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => createCounterSystem(),
      child: ReactState<int, CounterEvent>(
        builder: (context, state, dispatch) {
          return CounterPage(
            title: 'Use React Widget Page',
            count: state,
            onIncreasePressed: () => dispatch(Increment()),
          );
        }
      ),
    );
  }
}

```

## License

The MIT License (MIT)

[love]:https://pub.dev/packages/love/versions/0.1.0-beta.6