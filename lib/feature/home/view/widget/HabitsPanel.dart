import 'package:altitude/common/view/HabitCardItem.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:flutter/material.dart'
    show
        BouncingScrollPhysics,
        Center,
        Colors,
        Key,
        SingleChildScrollView,
        Size,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget,
        Wrap,
        WrapAlignment,
        required;
import 'package:flutter_mobx/flutter_mobx.dart';

class HabitsPanel extends StatelessWidget {
  HabitsPanel({Key key, @required this.controller, @required this.goHabitDetails}) : super(key: key);

  final HomeLogic controller;
  final Function(String id, int color) goHabitDetails;

  @override
  Widget build(context) {
    return Center(
      child: Observer(builder: (_) {
        return controller.habits.handleState(
          () => Skeleton.custom(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Rocket(
                size: const Size(100, 100),
                color: Colors.white,
              ),
            ),
          ),
          (data) {
            if (data.isEmpty) {
              return Text("Crie um novo hábito pelo botão \"+\" na tela principal.",
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 22));
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: data.map((habit) {
                    return HabitCardItem(
                        habit: habit,
                        goHabitDetails: goHabitDetails,
                        showDragTarget: controller.swipeSkyWidget,
                        done: DateTime.now().today.isSameDay(habit.lastDone));
                  }).toList(),
                ),
              );
            }
          },
          (error) => const DataError(),
        );
      }),
    );
  }
}
