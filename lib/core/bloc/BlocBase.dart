import 'package:altitude/common/view/generic/Loading.dart';
import 'package:flutter/material.dart' show Colors, MaterialPageRoute;
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BlocBase {
  static bool _loading = false;

  void dispose();

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
  bool navigatePop<T>(BuildContext context, [T data]) {
    return Navigator.of(context).pop<T>(data);
  }

  @protected
  Future<T> navigatePush<T>(BuildContext context, Widget page, [String name = ""]) {
    return Navigator.of(context).push<T>(MaterialPageRoute(
        builder: (_) {
          return page;
        },
        settings: RouteSettings(name: name)));
  }

  @protected
  Future navigatePushReplacement(BuildContext context, Widget page, [String name = ""]) {
    return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) {
          return page;
        },
        settings: RouteSettings(name: name)));
  }

  @protected
  void navigatePopUntil(BuildContext context, bool Function(Route<dynamic>) predicate) {
    return Navigator.of(context).popUntil(predicate);
  }

  @protected
  void showLoading(BuildContext context) {
    if (!_loading) {
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
    }
  }

  @protected
  void hideLoading(BuildContext context) {
    if (_loading) {
      Navigator.of(context).pop();
      _loading = false;
    }
  }
}
