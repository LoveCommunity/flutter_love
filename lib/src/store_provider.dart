import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:love/love.dart';
import 'package:provider/provider.dart';

/// A store that can hold state and dispatch event
class Store<State, Event> {
  Store(this.state, this.dispatch);

  final State state;
  final Dispatch<Event> dispatch;
}

/// Provide Store to descendant widget
class StoreProvider<State, Event> extends DeferredInheritedProvider<EffectSystem<State, Event>, Store<State, Event>> {
 
  /// Creates a [EffectSystem] from `create` and run it.
  ///
  /// `create` must not be `null`. 
  StoreProvider({
    Key? key,
    bool? lazy,
    required Create<EffectSystem<State, Event>> create,
    UpdateShouldNotify<Store<State, Event>>? updateShouldNotify,
    TransitionBuilder? builder,
    Widget? child,
  }): super(
    key: key,
    lazy: lazy,
    create: create,
    updateShouldNotify: updateShouldNotify,
    builder: builder,
    child: child,
    startListening: _systemStartListening(),
  );

  /// Run system from value parameter.
  ///
  /// `value` must not be `null`. 
  StoreProvider.value({
    Key? key,
    bool? lazy,
    required EffectSystem<State, Event> value,
    UpdateShouldNotify<Store<State, Event>>? updateShouldNotify,
    TransitionBuilder? builder,
    Widget? child,
  }): super.value(
    key: key,
    lazy: lazy,
    value: value,
    updateShouldNotify: updateShouldNotify,
    builder: builder,
    child: child,
    startListening: _systemStartListening(),
  );
}

DeferredStartListening<EffectSystem<State, Event>, Store<State, Event>> _systemStartListening<State, Event>() {
  return (context, setState, system, __) {
    bool isDisposed = false;
    final dispose = system.run(
      effect: (state, _, __, dispatch) {
        if (isDisposed) return;
        setState(Store(state, dispatch));
      },
    );
    return () {
      if (isDisposed) return;
      isDisposed = true;
      dispose();
    };
  };
}