import 'dart:ui' show ImageFilter;
import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        AnimatedBuilder,
        Animation,
        AnimationController,
        BackdropFilter,
        BorderRadius,
        BoxDecoration,
        BoxShadow,
        Center,
        Colors,
        Column,
        Container,
        CurvedAnimation,
        Curves,
        EdgeInsets,
        FontWeight,
        Key,
        MainAxisAlignment,
        MainAxisSize,
        Material,
        Offset,
        Row,
        ScaleTransition,
        SingleTickerProviderStateMixin,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget;

class BaseDialog extends StatefulWidget {
  BaseDialog({Key? key, required this.title, required this.body, required this.action}) : super(key: key);

  final String? title;
  final Widget body;
  final List<Widget> action;

  @override
  _BaseDialogState createState() => _BaseDialogState();
}

class _BaseDialogState extends State<BaseDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward();
  }

  Widget build(context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => ScaleTransition(
          scale: _scaleAnimation,
          child: child,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
            decoration: BoxDecoration(
              color: AppTheme.of(context).materialTheme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                const BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  widget.body,
                  const SizedBox(height: 18),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: widget.action)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
