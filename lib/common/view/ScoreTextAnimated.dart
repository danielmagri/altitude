import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ScoreWidget extends AnimatedWidget {
  ScoreWidget({Key key, this.color, Animation<int> animation})
      : super(key: key, listenable: animation);

  final formatNumber = new NumberFormat.decimalPattern("pt_BR");
  final Color color;

  Widget build(BuildContext context) {
    final Animation<int> animation = listenable;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        AutoSizeText(
          '${formatNumber.format(animation.value)}',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            height: 0.2,
            color: color == null ? Colors.black : color,
          ),
          maxLines: 1,
        ),
        Text(
          "QUILÔMETROS",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
