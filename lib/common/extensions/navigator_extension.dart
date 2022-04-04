import 'package:flutter/widgets.dart'
    show CurvedAnimation, Curves, FadeTransition, NavigatorState, PageRouteBuilder, Widget;

extension NavigatorStateExtension on NavigatorState {
  Future<T?> smooth<T>(Widget child) {
    return push(PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
        pageBuilder: (_, __, ___) => child));
  }
}
