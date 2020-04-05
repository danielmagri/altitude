import 'package:flutter/widgets.dart'
    show CurvedAnimation, Curves, FadeTransition, NavigatorState, PageRouteBuilder, Widget;

extension navigatorState on NavigatorState {
  /// Retorna a data de hoje, sem as horas
  Future<T> smooth<T>(Widget child) {
    return this.push(PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
        pageBuilder: (_, __, ___) => child));
  }
}
