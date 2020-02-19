import 'package:flutter/widgets.dart' show Widget, BuildContext;

abstract class BlocWidget<T> {
  Widget build(BuildContext context, T bloc);
}