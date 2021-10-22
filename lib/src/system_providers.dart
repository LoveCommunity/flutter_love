
import 'dart:async' show Stream, StreamController;
import 'package:love/love.dart' show System, Equals, Dispatch, Dispose, ReactOperators;
import 'package:flutter/widgets.dart' show Key, Widget, TransitionBuilder, BuildContext, Builder;
import 'package:nested/nested.dart' show SingleChildStatefulWidget, SingleChildState;
import 'package:provider/provider.dart' show Provider, StreamProvider, Create;

class SystemProviders<S, E> extends SingleChildStatefulWidget {

  SystemProviders.value({
    Key? key,
    required System<S, E> value,
    bool provideState = true,
    bool provideStates = false,
    bool provideDispatch = true,
    Equals<S>? stateEquals,
    TransitionBuilder? builder,
    Widget? child,
  }) : this(
    key: key,
    create: (_) => value,
    provideState: provideState,
    provideStates: provideStates,
    provideDispatch: provideDispatch,
    stateEquals: stateEquals,
    builder: builder,
    child: child,
  );

  const SystemProviders({
    Key? key,
    required this.create,
    this.provideState = true,
    this.provideStates = false,
    this.provideDispatch = true,
    this.stateEquals,
    this.builder,
    Widget? child,
  }) : assert(
    provideState || provideStates || provideDispatch, 
    'SystemProviders should at least provide one of `state`, `states` or `dispatch`'
  ), super(
    key: key,
    child: child,
  );

  final Create<System<S, E>> create;
  final bool provideState;
  final bool provideStates;
  final bool provideDispatch;
  final Equals<S>? stateEquals;
  final TransitionBuilder? builder;

  @override
  _SystemProvidersState<S, E> createState() {
    return _SystemProvidersState();
  }
}

class _SystemProvidersState<S, E> extends SingleChildState<SystemProviders<S, E>> {

  late System<S, E> _system;
  late S _state;
  late final StreamController<S> _controller = StreamController();
  late final Stream<S> _states = _controller.stream.asBroadcastStream();
  late Dispatch<E> _dispatch;
  late Dispose _dispose;

  @override
  void initState() {
    super.initState();
    _checkDebugCheckInvalidValueType(widget.provideStates);
    _createSystem();
    _runSystem();
  }

  @override
  void dispose() {
    _closeStream();
    _disposeSystem();
    super.dispose();
  }

  void _createSystem() {
    _system = widget.create(context);
  }

  void _runSystem() {
    _dispose = _system
      .reactState(
        equals: widget.stateEquals,
        skipInitialState: false,
        effect: _effect,
      ).run();
  }

  void _disposeSystem() {
    _dispose();
  }

  void _effect(S state, Dispatch<E> dispatch) {
    _state = state;
    _controller.add(state);
    _dispatch = dispatch;
  }

  void _closeStream() {
    _controller.close();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    Widget? _child = widget.builder != null 
        ? Builder(builder: (context) => widget.builder!(context, child))
        : child;
    if (widget.provideDispatch) _child = Provider.value(
      value: _dispatch,
      child: _child,
    );
    if (widget.provideStates) _child = Provider.value(
      value: _states,
      child: _child,
    );
    if (widget.provideState) _child = StreamProvider.value(
      value: _states,
      initialData: _state,
      lazy: false,
      child: _child,
    );
    return _child!;
  }
}

void Function<T>(T value)? _debugCheckInvalidValueType;

void _checkDebugCheckInvalidValueType(bool provideStates) {
  final debugCheckInvalidValueType = Provider.debugCheckInvalidValueType;
  if (debugCheckInvalidValueType != null && _debugCheckInvalidValueType == null && provideStates) {
    _debugCheckInvalidValueType = <T>(T value) {
      if (value is Stream) return;
      debugCheckInvalidValueType(value);
    };
    Provider.debugCheckInvalidValueType = _debugCheckInvalidValueType;
  }
}

