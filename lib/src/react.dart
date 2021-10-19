import 'package:flutter/widgets.dart';
import 'package:love/love.dart';

/// Widget Builder with state and dispatch
typedef WidgetBuilder<S, E> = Widget Function(BuildContext context, S state, Dispatch<E> dispatch);

/// React Widget that is a combination of `reactState` operator and widget.
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

/// React Widget that is a combination of `react` operator and widget.
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

  Dispose? _dispose;
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
    _dispose = widget.system
      .react<V>(
        value: widget.value,
        equals: widget.equals,
        skipInitialValue: false,
        effect: _effect,
      ).run();
  }

  void _disposeSystem() {
    if (_dispose != null) {
      _dispose?.call();
      _dispose = null;
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