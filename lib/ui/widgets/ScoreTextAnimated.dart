import 'package:flutter/material.dart';

class ScoreWidget extends AnimatedWidget {
  ScoreWidget({Key key, Animation<int> animation}) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<int> animation = listenable;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          animation.value.toString(),
          style: TextStyle(fontSize: 55.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          "pts",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
