import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        BoxDecoration,
        BoxShape,
        Color,
        Colors,
        Container,
        EdgeInsets,
        Expanded,
        InkWell,
        Key,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget;

class ReminderDay extends StatelessWidget {
  final String day;
  final bool? state;
  final Color color;
  final Function() onTap;

  ReminderDay(
      {Key? key,
      required this.day,
      this.state,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: state! ? color : Colors.transparent),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: state!
                    ? Colors.white
                    : AppTheme.of(context)
                        .materialTheme
                        .textTheme
                        .headline1!
                        .color),
          ),
        ),
      ),
    );
  }
}
