import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BuildContext,
        Card,
        Column,
        EdgeInsets,
        Expanded,
        FontWeight,
        InkWell,
        Key,
        Padding,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget;
import 'dart:math';

import 'package:get_it/get_it.dart';

// ignore: must_be_immutable
class CompetitionWidget extends StatelessWidget {
  CompetitionWidget({Key? key, required this.goCompetition})
      : controller = GetIt.I.get<HabitDetailsLogic>(),
        super(key: key);

  final HabitDetailsLogic controller;
  final Function(int index) goCompetition;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 4,
        child: InkWell(
          onTap: () => goCompetition(index),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Text(
                  "Competição",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: controller.habitColor,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(_setTex(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16)),
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
