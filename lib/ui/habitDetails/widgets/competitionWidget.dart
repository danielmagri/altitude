import 'package:flutter/material.dart';
import 'package:altitude/datas/dataHabitDetail.dart';
import 'dart:math';

import 'package:altitude/services/FireAnalytics.dart';

class CompetitionWidget extends StatelessWidget {
  CompetitionWidget({Key key, @required this.goCompetition}) : super(key: key);

  final Function goCompetition;
  int index = 0;

  String _setTex() {
    index = Random().nextInt(2);

    switch(index) {
      case 0:
        return "Competir com os amigos é uma ótima forma de criar hábitos.";
      case 1:
        return "Crie uma competição com seus amigos. Quem será que vence?";
      default:
        return "default";
    }
  }

  void onClicked() {
    FireAnalytics().sendGoCompetition(index.toString());
    goCompetition();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 4,
        child: InkWell(
          onTap: onClicked,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Text(
                  "Competição",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: DataHabitDetail().getColor(),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(_setTex(),
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
