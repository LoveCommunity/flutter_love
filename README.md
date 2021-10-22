# flutter_love

`flutter_love` provide flutter widgets handle common use case with [love] state management library, so fall in `love` with `flutter`.

## Getting Started

There are mainly two options to integrate [love] with flutter:

1. `React` Widget
2. `SystemProviders`

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
      builder: (context, _) => ReactState<int, CounterEvent>(
        system: context.read(),
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

### 2. SystemProviders

**`SystemProviders` can consume a `System` then provide `state` and `dispatch` to descendant widgets.**

Descendant widget can access `state` and `dispatch` from `context`:

```dart

System<int, CounterEvent> createCounterSystem() { ... }

class UseSystemProvidersPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SystemProviders(
      create: (_) => createCounterSystem(),
      builder: (context, _) {
        final state = context.watch<int>(); // <- access state
        return CounterPage(
          title: 'Use System Providers Page',
          count: state,
          onIncreasePressed: () => context.dispatch<CounterEvent>(Increment()), // <- access dispatch
        );
      },
    );
  }
}

```

## License

The MIT License (MIT)

[love]:https://pub.dev/packages/love/versions/0.1.0-beta.6