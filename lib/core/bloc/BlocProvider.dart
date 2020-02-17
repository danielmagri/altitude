import 'package:flutter/widgets.dart';
import 'BlocBase.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({Key key, @required this.widget, @required this.bloc}) : super(key: key);

  final T bloc;
  final Widget widget;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void didChangeDependencies() {
    widget.bloc.initialize();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.widget;
  }
}
