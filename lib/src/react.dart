import 'package:flutter/widgets.dart';
import 'package:love/love.dart';

// Builder for React Widget.
typedef ReactBuilder<S, E, V> = Widget Function(BuildContext context, V value, Dispatch<E> dispatch);

/// React Widget that is a comination of react operator and widgets.
class React<S, E, V> extends StatefulWidget {

  // React Widget, build is triggered by reacting hold state change.
  static React<S, E, S> state<S, E>(
    EffectSystem<S, E> system, {
    Key? key,
    AreEqual<S>? areEqual,
    required Widget Function(BuildContext context, S state, Dispatch<E> dispatch) builder,
  }) => React._value(
    system, 
    value: (state) => state, 
    builder: builder
  );

  // React Widget, build is triggered by reacting partial state change.
  static React<S, E, V> value<S, E, V>(
    EffectSystem<S, E> system,{
    Key? key,
    required V Function(S state) value,
    AreEqual<V>? areEqual,
    required ReactBuilder<S, E, V> builder,
  }) => React._value(
    system, 
    value: 
    value, 
    builder: builder
  );

  const React._value(
    this.system, {
    Key? key,
    required V Function(S state) value,
    this.areEqual,
    required this.builder,
  }): _value = value,
    super(key: key);

  final EffectSystem<S, E> system;
  final V Function(S state) _value;
  final AreEqual<V>? areEqual;
  final ReactBuilder<S, E, V> builder;

  @override
  _ReactState<S, E, V> createState() => _ReactState();
}

class _ReactState<S, E, V> extends State<React<S, E, V>> {

  V? _value;
  Dispatch<E>? _dispatch;
  Dispose? _dispose;

  @override
  void initState() {
    _start();
    super.initState();
  }


  @override
  void didUpdateWidget(covariant React<S, E, V> oldWidget) {
    if (oldWidget.system != widget.system) {
      _stop();
      _start();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }


  void _start() {
    _dispose = widget.system
      .react<V>(
        value: widget._value,
        areEqual: widget.areEqual,
        effect: (value, dispatch) {
          void _cache() => this._cache(value, dispatch);
          _value == null ? _cache() : setState(_cache);
        },
      ).run();
  }

  void _cache(V value, Dispatch<E> dispatch) {
    _value = value;
    _dispatch = dispatch;
  }

  void _stop() {
    if (_dispose != null) {
      _dispose?.call();
      _dispose = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(_value != null, 'value is null in build method');
    assert(_dispatch != null, 'dispatch is null in build method');
    return widget.builder(context, _value!, _dispatch!);
  }
}