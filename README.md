# flutter_love

`flutter_love` provide flutter widgets handle common use case with [love] state management library, so fall in `love` with `flutter`.

## Getting Started

There are mainly two options to integrate [love] with flutter:

1. `React` Widget
2. `StoreProvider` 

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

### 2. StoreProvider

**`StoreProvider` can consume a `System` then provide `Store` to descendant widgets.**

Descendant widget can access `Store` from `context`:

```dart

System<int, CounterEvent> createCounterSystem() { ... }

class UseStoreProviderPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      create: (_) => createCounterSystem(),
      builder: (context, _) {
        final store = context.watch<Store<int, CounterEvent>>();
        return CounterPage(
          title: 'Use Store Provider Page', 
          count: store.state, 
          onIncreasePressed: () => store.dispatch(Increment())
        );
      },
    );
  }
}

```

## License

The MIT License (MIT)

[love]:https://pub.dev/packages/love/versions/0.1.0-beta.6