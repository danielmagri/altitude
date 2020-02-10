import 'package:altitude/enums/BlocProviderType.dart';
import 'package:flutter/material.dart';

import 'BlocBase.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider(
      {Key key,
      @required this.widget,
      @required this.bloc,
      this.type = BlocProviderType.Normal})
      : super(key: key);

  final BlocProviderType type;
  final T bloc;
  final Widget widget;

  @override
  BlocBaseState createState() {
    switch (type) {
      case BlocProviderType.Normal:
        return _BlocProviderState();
      case BlocProviderType.SingleAnimation:
        final state = _BlocProviderSingleAnimationState();
        bloc.tickerProvider = state;
        return state;
      case BlocProviderType.MultiAnimation:
        final state = _BlocProviderAnimationState();
        bloc.tickerProvider = state;
        return state;
      default:
        return _BlocProviderState();
    }
  }
}

abstract class BlocBaseState extends State<BlocProvider<BlocBase>> {
  @override
  initState() {
    widget.bloc.initialize();
    super.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.widget;
}

class _BlocProviderState<T> extends BlocBaseState {}

class _BlocProviderSingleAnimationState<T> extends BlocBaseState
    with SingleTickerProviderStateMixin {}

class _BlocProviderAnimationState<T> extends BlocBaseState
    with TickerProviderStateMixin {}
