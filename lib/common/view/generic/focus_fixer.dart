import 'package:flutter/material.dart'
    show BuildContext, FocusNode, FocusScope, GestureDetector, Key, StatelessWidget, Widget;

class FocusFixer extends StatelessWidget {
  FocusFixer({required this.child, Key? key}) : super(key: key);
  final Widget child;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: child,
    );
  }
}
