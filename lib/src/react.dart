import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:love/love.dart';
import 'package:provider/provider.dart' hide Dispose;

/// React Widget that is a combination of `reactState` operator and widget.
class ReactState<S, E> extends UIEffectBase<S, E> {

  // React Widget, build is triggered by reacting hold state change.
  ReactState({
    Key? key,
    System<S, E>? system, 
    Equals<S>? equals,
    required UIEffectBuilder<S, E> builder,
  }): super(
    key: key,
    builder: builder,
    run: (context, setState, hasCache, cache) {
      final _system = system ?? context.read<System<S, E>>();
      return _system
        .reactState(
          equals: equals,
          skipInitialState: false,
          effect: (state, dispatch) {
            void _cache() => cache(state, dispatch);
            !hasCache() ? _cache() : setState(_cache);
          },
        ).run();
    },
  );
}

/// React Widget that is a combination of `react` operator and widget.
class React<S, E, V> extends UIEffectBase<V, E> {

  // React Widget, build is triggered by reacting partial state change.
  React({
    Key? key,
    System<S, E>? system, 
    required V Function(S state) value,
    Equals<V>? equals,
    required UIEffectBuilder<V, E> builder,  
  }): super(
    key: key,
    builder: builder,
    run: (context, setState, hasCache, cache) {
      final _system = system ?? context.read<System<S, E>>();
      return _system
        .react<V>(
          value: value,
          equals: equals,
          skipInitialValue: false,
          effect: (value, dispatch) {
            void _cache() => cache(value, dispatch);
            !hasCache() ? _cache() : setState(_cache);
          },
        ).run();
    },
  );
}

/// Run within a stateful context
typedef UIEffectRun<S, E> = Dispose Function(
  BuildContext context,
  void Function(void Function()) setState,
  bool Function() hasCache,
  void Function(S state, Dispatch<E> dispatch) cache,
);

/// Builder for presentation effect
typedef UIEffectBuilder<S, E> = Widget Function(BuildContext context, S state, Dispatch<E> dispatch);

/// Base class to consume `run` with a widget `builder`
class UIEffectBase<S, E> extends StatefulWidget {

  const UIEffectBase({
    Key? key, 
    required this.run,
    required this.builder,
  }) : super(key: key);

  final UIEffectRun<S, E> run;
  final UIEffectBuilder<S, E> builder;

  @override
  State<UIEffectBase<S, E>> createState() => _UIEffectBaseState();
}

class _UIEffectBaseState<S, E> extends State<UIEffectBase<S, E>> {

  Dispose? _dispose;
  S? _state;
  Dispatch<E>? _dispatch;

  @override
  void initState() {
    super.initState();
    _dispose = widget.run(context, setState, _hasCache, _cache);
  }

  bool _hasCache() => _dispatch != null;

  void _cache(S state, Dispatch<E> dispatch) {
    _state = state;
    _dispatch = dispatch;
  }

  @override
  void dispose() {
    if (_dispose != null) {
      _dispose?.call();
      _dispose = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(_state is S);
    assert(_dispatch != null);
    return widget.builder(context, _state as S, _dispatch!);
  }
}