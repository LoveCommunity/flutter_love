# flutter_love

`flutter_love` provide flutter widgets handle common use case with [love] state management library, so fall in `love` with `flutter`.

## Getting Started

There are mainly two options to integrate [love] with flutter:

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

```

### StoreProvider

**`StoreProvider` can consume an  `EffectSystem` then provide `Store` to descendant widgets.**

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

[love]:https://pub.dev/packages/love/versions/0.1.0-beta.2