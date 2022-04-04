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

class BaseTextDialog extends StatefulWidget {
  const BaseTextDialog({
    required this.title,
    required this.body,
    required this.action,
    this.subBody,
    Key? key,
  }) : super(key: key);

  final String title;
  final String body;
  final String? subBody;
  final List<Widget> action;

  @override
  _BaseTextDialogState createState() => _BaseTextDialogState();
}

class _BaseTextDialogState extends State<BaseTextDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward();
  }

  @override
  Widget build(_) {
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
            margin:
                const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
            decoration: BoxDecoration(
              color: AppTheme.of(context).materialTheme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.1),
                  ),
                  const SizedBox(height: 4),
                  if (widget.subBody != null)
                    Text(
                      widget.subBody!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        height: 1.1,
                      ),
                    ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.action,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
