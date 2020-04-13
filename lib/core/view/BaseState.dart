import 'package:altitude/common/view/generic/Loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:altitude/core/extensions/NavigatorExtension.dart';
import 'package:flutter/material.dart'
    show
        Animation,
        BuildContext,
        Color,
        Colors,
        CurvedAnimation,
        Curves,
        FadeTransition,
        Navigator,
        PageRouteBuilder,
        State,
        StatefulWidget,
        Widget,
        protected;

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  static bool _loading = false;

  void onPageBack(Object value) {}

  @protected
  Future<R> navigateSmooth<R>(Widget page) {
    return Navigator.of(context).smooth<R>(page);
  }

  @protected
  void navigatePush(String route, {Object arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments).then(onPageBack);
  }

  @protected
  void navigatePopAndPush(String route, {Object arguments}) {
    Navigator.popAndPushNamed(context, route, arguments: arguments).then(onPageBack);
  }

  @protected
  void navigatePop<R>({R result}) {
    Navigator.pop<R>(context, result);
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
    if (!_loading && show) {
      Navigator.of(context).push(new PageRouteBuilder(
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
    } else if (_loading && !show) {
      Navigator.of(context).pop();
      _loading = false;
    }
  }

  @protected
  void vibratePhone({int duration = 100}) {
    Vibration.hasVibrator().then((resp) {
      if (resp != null && resp == true) {
        Vibration.vibrate(duration: 100);
      }
    });
  }

  @protected
  void handleError(dynamic error) {
    showLoading(false);
    showToast("Ocorreu um erro");
  }
}
