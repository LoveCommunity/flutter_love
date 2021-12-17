# flutter_love

[![Build Status](https://github.com/LoveCommunity/flutter_love/workflows/Tests/badge.svg)](https://github.com/LoveCommunity/flutter_love/actions/workflows/tests.yml)
[![Coverage Status](https://img.shields.io/codecov/c/github/LoveCommunity/flutter_love/main.svg)](https://codecov.io/gh/LoveCommunity/flutter_love)
[![Pub](https://img.shields.io/pub/v/flutter_love)](https://pub.dev/packages/flutter_love)

`flutter_love` provide flutter widgets handle common use case with [love] state management library.

## `React*` Widgets

**`React*` Widgets are combination of `react*` operators and widget builder.**

  1. `ReactState` will react to system's **whole** state change, then trigger a build with widget builder:
  
     ```dart
     ...

     final System<int, CounterEvent> _system = ...; // store system somewhere

     ...

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
     ```

  2. `React` will react to system's **partial** state change, then trigger a build with widget builder:
  
     ```dart
     ...

     final System<int, CounterEvent> _system = ...; // store system somewhere

     ...

     @override
     Widget build(BuildContext context) {
       return React<int, CounterEvent, bool>(
         system: _system,
         value: (state) => state.isOdd, // map state to value
         builder: (context, isOdd, dispatch) {
           return TextButton(
             onPressed: () => dispatch(Increment()),
             child: Text('isOdd: $isOdd'),
           );
         },
       );
     }
     ```

## License

The MIT License (MIT)

[love]:https://pub.dev/packages/love