import 'package:altitude/feature/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CompetitionWidget extends StatelessWidget {
  CompetitionWidget({Key key, this.bloc}) : super(key: key);

  final HabitDetailsBloc bloc;

  int index = 0;

  String _setTex() {
    index = Random().nextInt(2);

    switch (index) {
      case 0:
        return "Competir com os amigos é uma ótima forma de criar hábitos.";
      case 1:
        return "Crie uma competição com seus amigos. Quem será que vence?";
      default:
        return "default";
    }
  }

  void onClicked(BuildContext context) {
    bloc.goCompetition(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 4,
        child: InkWell(
          onTap: () => onClicked(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Text(
                  "Competição",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: bloc.habitColor,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(_setTex(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
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
