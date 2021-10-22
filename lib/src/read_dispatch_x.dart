
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:love/love.dart' show Dispatch;
import 'package:provider/provider.dart' show ReadContext;

extension ReadDispatchX on BuildContext {

  Dispatch<E> readDispatch<E>() => read();

  void dispatch<E>(E event) => readDispatch<E>().call(event);
}