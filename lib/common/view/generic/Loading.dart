import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
        Animation,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Colors,
        CurvedAnimation,
        Curves,
        FadeTransition,
        Navigator,
        PageRouteBuilder,
        StatelessWidget,
        Widget,
        WillPopScope;

abstract class Loading {
  static bool loading = false;

  static void showLoading(BuildContext context) {
    if (!loading) {
      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withOpacity(0.2),
          barrierDismissible: false,
          transitionDuration: Duration(milliseconds: 100),
          transitionsBuilder:
              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
                  FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
          pageBuilder: (BuildContext context, _, __) {
            return LoadingWidget();
          }));
      loading = true;
    }
  }

  static void closeLoading(BuildContext context) {
    if (loading) {
      Navigator.of(context).pop();
      loading = false;
    }
  }
}

class LoadingWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child:
            Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppTheme.of(context).loading))));
  }
}
