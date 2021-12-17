import 'package:flutter/widgets.dart' show BuildContext, Key, State, StatefulWidget, Widget;
import 'package:love/love.dart' show Dispatch, Disposer, Equals, ReactX, System;

/// Widget Builder with state and dispatch
typedef WidgetBuilder<S, E> = Widget Function(BuildContext context, S state, Dispatch<E> dispatch);

/// [ReactState] widget will react to system's whole state change, 
/// then trigger a build with widget builder.
/// 
/// ## API Overview
/// 
/// ```dart
/// ReactState<int, CounterEvent>(
///   system: _system,
///   equals: (it1, it2) { // `equals` is used to determine if old state equals 
///     return it1 == it2; // to new state. If there are not equal, then build
///   },                   // is triggered. `equals` defaults to 
///                        // `==` if omitted.                                
///   builder: (context, state, dispatch) {
///     return ...; // return widget based on state, required
///   },
/// );
/// ```
/// 
/// ## Usage Example:
/// 
/// Below code shown a counter example:
/// 
/// ```dart
/// ...
///
/// final System<int, CounterEvent> _system = ...; // store system somewhere
///
/// ...
///
/// @override
/// Widget build(BuildContext context) {
///   return ReactState<int, CounterEvent>(
///     system: _system,
///     builder: (context, state, dispatch) {
///       return CounterPage(
///         title: 'Use React Widget Page',
///         count: state,
///         onIncreasePressed: () => dispatch(Increment()),
///       );
///     },
///   );
/// }
/// ```
/// 
class ReactState<S, E> extends React<S, E, S> {

  const ReactState({
    Key? key,
    required System<S, E> system,
    Equals<S>? equals,
    required WidgetBuilder<S, E> builder,
  }) : super(
    key: key,
    system: system,
    value: _this,
    equals: equals,
    builder: builder
  );
}

/// enable **const** constructor for `ReactState`
S _this<S>(S value) => value;

/// [React] widget will react to system's partial state change, 
/// then trigger a build with widget builder.
/// 
/// ## API Overview
/// 
/// ```dart
/// React<AsyncState, CounterEvent, bool>(
///   system: _system,
///   value: (state) => state.loading, // map state to value, required
///   equals: (value1, value2) { // `equals` is used to determine if old value equals 
///     return value1 == value2; // to new value. If there are not equal, then build
///   },                         // is triggered. `equals` defaults to 
///                              // `==` if omitted.                                
///   builder: (context, loading, dispatch) {
///     return ...; // return widget based on loading status, required
///   },
/// );
/// ```
/// 
/// ## Usage Example:
/// 
/// Below code shown how to build widget based on `counts.isOdd`:
/// 
/// ```dart
/// ...
///
/// final System<int, CounterEvent> _system = ...; // store system somewhere
///
/// ...
///
/// @override
/// Widget build(BuildContext context) {
///   return React<int, CounterEvent, bool>(
///     system: _system,
///     value: (state) => state.isOdd, // map state to value
///     builder: (context, isOdd, dispatch) {
///       return TextButton(
///         onPressed: () => dispatch(Increment()),
///         child: Text('isOdd: $isOdd'),
///       );
///     },
///   );
/// }
/// ```
/// 
class React<S, E, V> extends StatefulWidget {

  const React({
    Key? key, 
    required this.system,
    required this.value,
    this.equals,
    required this.builder,
  }) : super(key: key);

  final System<S, E> system;
  final V Function(S state) value;
  final Equals<V>? equals;
  final WidgetBuilder<V, E> builder;

  @override
  State<React<S, E, V>> createState() => _ReactState();
}

class _ReactState<S, E, V> extends State<React<S, E, V>> {

  Disposer? _disposer;
  V? _value;
  Dispatch<E>? _dispatch;

  @override
  void initState() {
    super.initState();
    _runSystem();
  }

  @override
  void didUpdateWidget(React<S, E, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.system != widget.system) {
      _disposeSystem();
      _runSystem();
    }
  }

  @override
  void dispose() {
    _disposeSystem();
    super.dispose();
  }

  void _runSystem() {
    _disposer = widget.system
      .react<V>(
        value: widget.value,
        equals: widget.equals,
        skipInitialValue: false,
        effect: _effect,
      ).run();
  }

  void _disposeSystem() {
    if (_disposer != null) {
      _disposer?.call();
      _disposer = null;
      _value = null;
      _dispatch = null;
    }
  }

  bool _hasCache() => _dispatch != null;

  void _cache(V state, Dispatch<E> dispatch) {
    _value = state;
    _dispatch = dispatch;
  }

  void _effect(V value, Dispatch<E> dispatch) {
    if (!_hasCache()) {
      _cache(value, dispatch);
    } else {
      setState(() => _cache(value, dispatch));
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(_value is V);
    assert(_dispatch != null);
    return widget.builder(context, _value as V, _dispatch!);
  }
}