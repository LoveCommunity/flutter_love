## 0.2.0

- cicd 
  - improvement github workflows [\#53](https://github.com/LoveCommunity/flutter_love/pull/53)
- refactor 
  - upgrade dependencies [\#52](https://github.com/LoveCommunity/flutter_love/pull/52)

## [0.1.0] - 2020-12-22

* tests - add tests for widget by @beeth0ven in [43](https://github.com/LoveCommunity/flutter_love/pull/43)
* feature - add github action tests by @beeth0ven in [44](https://github.com/LoveCommunity/flutter_love/pull/44)
* docs - add shields images by @beeth0ven in [45](https://github.com/LoveCommunity/flutter_love/pull/45)
* docs - improve docs with example codes by @beeth0ven in [48](https://github.com/LoveCommunity/flutter_love/pull/48)

## [0.1.0-beta.8] - 2020-11-23

* feature - CD - auto publish package to pub.dev after cut a github release by @beeth0ven in [37](https://github.com/LoveCommunity/flutter_love/pull/37)
* upgrade - upgrade `love` to v0.1.0 by @beeth0ven in [40](https://github.com/LoveCommunity/flutter_love/pull/40)
* refactor - explicit import and export types by @beeth0ven in [35](https://github.com/LoveCommunity/flutter_love/pull/35)
* refactor - remove `provider` from `flutter_love` by @beeth0ven in [41](https://github.com/LoveCommunity/flutter_love/pull/41)

## [0.1.0-beta.7] - 2020-11-02

* upgrade - upgrade `love` to v0.1.0-rc.2 [#32](https://github.com/LoveCommunity/flutter_love/issues/32)
* upgrade - upgrade `provider` to v6.0.0 [#25](https://github.com/LoveCommunity/flutter_love/issues/25)
* upgrade - upgrade `love` to v0.1.0-rc.1 [#26](https://github.com/LoveCommunity/flutter_love/issues/26)
* refactor - reimplement `React` and `ReactState` widget to simplify the logic [#28](https://github.com/LoveCommunity/flutter_love/issues/28)
* refactor - remove `StoreProvider`, see [#20](https://github.com/LoveCommunity/flutter_love/issues/20)
* feature - add `SystemProviders` to provide `state` and `dispatch` [#30](https://github.com/LoveCommunity/flutter_love/issues/30)

## [0.1.0-beta.6] - 2020-09-22

* upgrade - upgrade `love` to v0.1.0-beta.6
* feature - accept `null` as `state`

## [0.1.0-beta.5] - 2020-08-06

* refactor - update example to adapt new API
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