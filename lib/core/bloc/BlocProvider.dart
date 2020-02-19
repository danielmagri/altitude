import 'package:altitude/core/bloc/BlocWidget.dart';
import 'package:flutter/widgets.dart';
import 'BlocBase.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({Key key, @required this.widget, @required this.bloc}) : super(key: key);

  final T bloc;
  final BlocWidget widget;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>(bloc);
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  _BlocProviderState(this.bloc);

  final T bloc;

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
    return widget.widget.build(context, bloc);
  }
}
