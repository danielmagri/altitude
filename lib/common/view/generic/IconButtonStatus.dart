import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        BoxDecoration,
        BoxShape,
        Color,
        Colors,
        Container,
        IconButton,
        SizedBox,
        Stack,
        StatelessWidget,
        Widget;

class IconButtonStatus extends StatelessWidget {
  IconButtonStatus(
      {required this.status,
      required this.icon,
      required this.onPressed,
      this.color = Colors.orange,
      this.backgroundColor});

  final Widget icon;
  final Function onPressed;
  final Color? backgroundColor;
  final Color color;
  final bool status;

  @override
  Widget build(context) {
    return Stack(
      alignment: const Alignment(0.55, -0.4),
      children: [
        IconButton(icon: icon, onPressed: onPressed as void Function()?),
        status
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor ?? AppTheme.of(context).materialTheme.backgroundColor),
              )
            : const SizedBox(height: 10, width: 10),
        status
            ? Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color))
            : const SizedBox(height: 10, width: 10),
      ],
    );
  }
}
