import 'package:flutter/material.dart'
    show
        Alignment,
        BoxDecoration,
        BoxShape,
        Color,
        Colors,
        Container,
        Icon,
        IconButton,
        SizedBox,
        Stack,
        StatelessWidget,
        Widget,
        required;

class IconButtonStatus extends StatelessWidget {
  IconButtonStatus({@required this.status, @required this.icon, @required this.onPressed, this.color});

  final Icon icon;
  final Function onPressed;
  final Color color;
  final bool status;

  @override
  Widget build(_) {
    return Stack(
      alignment: const Alignment(0.5, -0.4),
      children: <Widget>[
        IconButton(icon: icon, onPressed: onPressed),
        status
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? Colors.white),
              )
            : const SizedBox(height: 10, width: 10),
        status
            ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? Colors.orange),
              )
            : const SizedBox(height: 10, width: 10),
      ],
    );
  }
}
