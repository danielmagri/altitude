import 'package:altitude/common/view/generic/Loading.dart';
import 'package:altitude/core/view/ProviderPage.dart';
import 'package:flutter/material.dart'
    show
        Animation,
        BuildContext,
        ChangeNotifier,
        Color,
        Colors,
        CurvedAnimation,
        Curves,
        FadeTransition,
        Navigator,
        PageRouteBuilder,
        StatelessWidget,
        Widget,
        protected;
import 'package:fluttertoast/fluttertoast.dart';

abstract class BasePage<T extends ChangeNotifier> extends StatelessWidget {
  static bool _loading = false;
  BuildContext getContext;

  T createViewModel();

  void onViewModelReady(T) {}

  Widget builder(BuildContext context, T viewmodel);

  void dispose() {}

  @protected
  Future<dynamic> navigateSmooth(BuildContext context, Widget page) {
    return Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
        pageBuilder: (_, __, ___) => page));
  }

  @protected
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Color.fromARGB(255, 220, 220, 220),
        textColor: Colors.black,
        fontSize: 16.0);
  }

  @protected
  void showLoading(bool show) {
    if (!_loading) {
      Navigator.of(getContext).push(new PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withOpacity(0.2),
          barrierDismissible: false,
          fullscreenDialog: true,
          transitionDuration: Duration(milliseconds: 100),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,
                  Widget child) =>
              new FadeTransition(opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
          pageBuilder: (BuildContext context, _, __) {
            return LoadingWidget();
          }));
      _loading = true;
    } else {
      Navigator.of(getContext).pop();
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    getContext = context;
    return ProviderPage<T>(
      viewModel: createViewModel,
      onViewModelReady: onViewModelReady,
      dispose: dispose,
      builder: (BuildContext context, T viewmodel, Widget child) => builder(context, viewmodel),
    );
  }
}
