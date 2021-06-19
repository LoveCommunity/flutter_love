# flutter_love

Intergrate flutter widgets with `love` state management library, fall in `love` with `flutter`.

## Getting Started

There mainly two options to fall in `love` with `flutter`:

* `React` Widget
* `StoreProvider` 

### `React` Widget

**`React` Widget is a combination of `react operator` and widget.**

It can consume an `EffectSystem` and provide an `builder` function to transform `state`, `dispatch` to flutter widget:

```dart

System<int, CounterEvent> createCouterSystem() { ... }

class UseReactWidgetPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => createCouterSystem()
        .share(),
      builder: (context, _) => React.state<int, CounterEvent>(
        context.read<EffectSystem<int, CounterEvent>>(), 
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

```

### StoreProvider

**`StoreProvider` will consume an  `EffectSystem` then provide `Store` to descendant widget.**

Descendant widget can access `Store` from `context`:

```dart

System<int, CounterEvent> createCouterSystem() { ... }

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

```

## License

The MIT License (MIT)