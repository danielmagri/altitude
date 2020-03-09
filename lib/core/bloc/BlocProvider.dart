import 'package:altitude/core/bloc/BlocWidget.dart';
import 'package:flutter/widgets.dart';
import 'BlocBase.dart';

typedef T BlocCreator<T extends BlocBase>();

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({Key key, @required this.widget, @required this.blocCreator}) : super(key: key);

  final BlocCreator blocCreator;
  final BlocWidget widget;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>(blocCreator(), widget);
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<BlocBase>> {
  _BlocProviderState(this.bloc, this.child);

  final T bloc;
  final BlocWidget child;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return child.build(context, bloc);
  }
}
