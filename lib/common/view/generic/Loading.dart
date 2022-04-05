import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Colors,
        CurvedAnimation,
        Curves,
        FadeTransition,
        Key,
        Navigator,
        PageRouteBuilder,
        StatelessWidget,
        Widget,
        WillPopScope;

abstract class Loading {
  static bool loading = false;

  static void showLoading(BuildContext context) {
    if (!loading) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withOpacity(0.2),
          barrierDismissible: false,
          transitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (context,
                  animation,
                  secondaryAnimation,
                  child) =>
              FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
          pageBuilder: (context, _, __) {
            return const LoadingWidget();
          },
        ),
      );
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
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppTheme.of(context).loading),
        ),
      ),
    );
  }
}
