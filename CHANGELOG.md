## [0.1.0-beta.5]

* refactor - `ReactState` extends `UIEffectBase` directly (previously extends `React`)
* improvements - explicitly give `system.react` operator's parameter `skipFirst*` in `React*` widgets
* visibility - export package:love/love.dart by default

## [0.1.0-beta.4] - 2020-07-12

* refactor - remove `EffectSystem`

## [0.1.0-beta.2] - 2020-07-5

* refactor - extract widget `UIEffectBase<S, E>`
* refactor - replace `React.state<S, E>` with `ReactState<S, E>`
* refactor - `React*` widgets constructor parameter `EffectSystem` is optional now

## [0.1.0-beta.1] - 2020-06-19

* feature - add `React<S, E, V>` widget
* feature - add `StoreProvider<State, Event>`