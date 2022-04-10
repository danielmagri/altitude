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
  const ReminderDay({
    required this.day,
    required this.color,
    required this.onTap,
    Key? key,
    this.state,
  }) : super(key: key);

  final String day;
  final bool? state;
  final Color color;
  final Function() onTap;

  @override
  Widget build(context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: state! ? color : Colors.transparent,
        ),
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
                      .color,
            ),
          ),
        ),
      ),
    );
  }
}
