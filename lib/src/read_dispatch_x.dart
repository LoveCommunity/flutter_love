
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:love/love.dart' show Dispatch;
import 'package:provider/provider.dart' show ReadContext;

extension ReadDispatchX on BuildContext {

  /// `readDispatch` is a shortcut for `context.read<Dispatch<E>>()`.
  Dispatch<E> readDispatch<E>() => read();

  /// `dispatch` is a shortcut for `context.read<Dispatch<E>>().call(event)`.
  /// 
  /// Warning: please don't omit the type `E` when calling this method:
  /// - Bad: `context.dispatch(Increment());`
  /// - Good: `context.dispatch<CounterEvent>(Increment());`
  /// 
  /// Since the type `E` is needed for looking up `Dispatch<E>`.
  /// 
  void dispatch<E>(E event) => readDispatch<E>().call(event);
}