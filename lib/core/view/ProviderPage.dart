import 'package:flutter/material.dart' show BuildContext, ChangeNotifier, State, StatefulWidget, Widget;
import 'package:provider/provider.dart' show ChangeNotifierProvider, Consumer;

typedef T ViewModel<T extends ChangeNotifier>();

class ProviderPage<T extends ChangeNotifier> extends StatefulWidget {
  ProviderPage({this.viewModel, this.onViewModelReady, this.didChangeDependencies, this.builder, this.dispose});

  final ViewModel viewModel;
  final Function(T) onViewModelReady;
  final Function didChangeDependencies;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function dispose;

  @override
  _ProviderPageState createState() => _ProviderPageState<T>();
}

class _ProviderPageState<T extends ChangeNotifier> extends State<ProviderPage<T>> {
  _ProviderPageState() {
    viewmodel = widget.viewModel();
  }

  T viewmodel;

  @override
  void initState() {
    if (widget.onViewModelReady != null) {
      widget.onViewModelReady(viewmodel);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.dispose != null) {
      widget.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(create: (context) => viewmodel, child: Consumer<T>(builder: widget.builder));
  }
}
