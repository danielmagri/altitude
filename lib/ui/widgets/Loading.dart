import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  Navigator.of(context).push(new PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.2),
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 100),
      transitionsBuilder:
          (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
              new FadeTransition(opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
      pageBuilder: (BuildContext context, _, __) {
        return LoadingWidget();
      }));
}

void closeLoading(BuildContext context) {
    Navigator.of(context).pop();
}

class LoadingWidget extends StatelessWidget {
  LoadingWidget({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
