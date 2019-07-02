import 'package:flutter/material.dart';

class ScoreWidget extends AnimatedWidget {
  ScoreWidget({Key key, this.color, Animation<int> animation}) : super(key: key, listenable: animation);

  final Color color;

  Widget build(BuildContext context) {
    final Animation<int> animation = listenable;
    return Column(
      children: <Widget>[
        Text(
          animation.value.toString(),
          style: TextStyle(
              fontSize: 70, fontWeight: FontWeight.bold, height: 0, color: color == null ? Colors.black : color),
        ),
        Text(
          "FORÇA DE VONTADE",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
