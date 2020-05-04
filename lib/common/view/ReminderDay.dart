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
        Widget,
        required;

class ReminderDay extends StatelessWidget {
  final String day;
  final bool state;
  final Color color;
  final Function() onTap;

  ReminderDay({Key key, @required this.day, this.state, @required this.color, @required this.onTap}) : super(key: key);

  @override
  Widget build(context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.circle, color: state ? color : Colors.transparent),
        child: InkWell(
          onTap: onTap,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: state ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
