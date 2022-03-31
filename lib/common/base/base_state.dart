import 'package:altitude/common/app_logic.dart';
import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/extensions/navigator_extension.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/common/view/generic/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:vibration/vibration.dart';
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
        Route,
        State,
        StatefulWidget,
        TextButton,
        Widget,
        WidgetsBinding,
        protected,
        showDialog;

abstract class BaseStateWithController<T extends StatefulWidget, L extends Object>
    extends BaseState<T> {
  L controller = GetIt.I.get<L>();

  @override
  dispose() async {
    super.dispose();
    await serviceLocator.resetLazySingleton<L>(instance: controller);
    print("Disposed $L");
  }
}

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  static bool _loading = false;

  void onPageBack(Object? value) {}

  @protected
  Future<R?> navigateSmooth<R>(Widget page) {
    return Navigator.of(context).smooth<R>(page);
  }

  @protected
  void navigatePush(String route, {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments).then(onPageBack);
  }

  @protected
  void navigatePushReplacement(String route, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments)
        .then(onPageBack);
  }

  @protected
  void navigatePopAndPush(String route, {Object? arguments}) {
    Navigator.popAndPushNamed(context, route, arguments: arguments)
        .then(onPageBack);
  }

  @protected
  void navigatePop<R>({R? result}) {
    Navigator.pop<R>(context, result);
  }

  @protected
  void navigateRemoveUntil(String route) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
  }

  @protected
  void changeSystemStyle(SystemUiOverlayStyle style) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      GetIt.I.get<AppLogic>().changeSystemStyle(style: style);
    });
  }

  @protected
  void resetSystemStyle() {
    GetIt.I.get<AppLogic>().changeSystemStyle();
  }

  @protected
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
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
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              new FadeTransition(
                  opacity: new CurvedAnimation(
                      parent: animation, curve: Curves.easeOut),
                  child: child),
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
  void showSimpleDialog(String title, String body,
      {String? subBody, Function? confirmCallback, Function? cancelCallback}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BaseTextDialog(
              title: title,
              body: body,
              subBody: subBody,
              action: [
                TextButton(
                  child: const Text("Não",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    navigatePop();
                    cancelCallback!();
                  },
                ),
                TextButton(
                  child: const Text("Sim", style: TextStyle(fontSize: 17)),
                  onPressed: () {
                    navigatePop();
                    confirmCallback!();
                  },
                ),
              ],
            ));
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
  Future<Null> handleError(dynamic error) async {
    showLoading(false);
    if (error is String) {
      showToast(error);
    } else {
      showToast("Ocorreu um erro");
    }
    return null;
  }
}
