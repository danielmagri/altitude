import 'package:flutter/material.dart';

class IconButtonStatus extends StatelessWidget {
  IconButtonStatus({this.status, this.icon, this.onPressed, this.color});

  final Icon icon;
  final Function onPressed;
  final Color color;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0.35, 0.4),
      children: <Widget>[
        IconButton(icon: icon, onPressed: onPressed),
        status
            ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color == null ? Colors.red : color),
              )
            : SizedBox(
                height: 10,
                width: 10,
              ),
      ],
    );
  }
}
