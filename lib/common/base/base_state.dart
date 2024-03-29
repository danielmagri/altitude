import 'dart:async';

import 'package:altitude/common/app_logic.dart';
import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/extensions/navigator_extension.dart';
import 'package:altitude/common/view/dialog/base_text_dialog.dart';
import 'package:altitude/common/view/generic/loading.dart';
import 'package:flutter/foundation.dart' show kDebugMode, protected;
import 'package:flutter/material.dart'
    show
        Color,
        Colors,
        CurvedAnimation,
        Curves,
        FadeTransition,
        FontWeight,
        Navigator,
        PageRouteBuilder,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextStyle,
        Widget,
        WidgetsBinding,
        protected,
        showDialog;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:vibration/vibration.dart';

abstract class BaseStateWithController<T extends StatefulWidget,
    L extends Object> extends BaseState<T> {
  L controller = GetIt.I.get<L>();

  @override
  void dispose() {
    super.dispose();
    serviceLocator.resetLazySingleton<L>(instance: controller);
    if (kDebugMode) {
      print('Disposed $L');
    }
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
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
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
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  @protected
  void showLoading(bool show) {
    if (!_loading && show) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withOpacity(0.2),
          barrierDismissible: false,
          fullscreenDialog: true,
          transitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
          pageBuilder: (context, _, __) {
            return const LoadingWidget();
          },
        ),
      );
      _loading = true;
    } else if (_loading && !show) {
      Navigator.of(context).pop();
      _loading = false;
    }
  }

  @protected
  void showSimpleDialog(
    String title,
    String body, {
    String? subBody,
    Function? confirmCallback,
    Function? cancelCallback,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BaseTextDialog(
        title: title,
        body: body,
        subBody: subBody,
        action: [
          TextButton(
            child: const Text(
              'Não',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              navigatePop();
              cancelCallback!();
            },
          ),
          TextButton(
            child: const Text('Sim', style: TextStyle(fontSize: 17)),
            onPressed: () {
              navigatePop();
              confirmCallback!();
            },
          ),
        ],
      ),
    );
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
  // ignore: prefer_void_to_null
  FutureOr<Null> handleError(dynamic error) async {
    showLoading(false);
    if (error is String) {
      showToast(error);
    } else {
      showToast('Ocorreu um erro');
    }
    return;
  }
}
