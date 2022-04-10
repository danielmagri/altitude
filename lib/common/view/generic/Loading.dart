import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Key,
        StatelessWidget,
        Widget,
        WillPopScope;

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
