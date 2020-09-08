import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/view/HabitCardItem.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
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
import 'package:get_it/get_it.dart';

class HabitsPanel extends StatelessWidget {
  HabitsPanel({Key key, @required this.goHabitDetails})
      : controller = GetIt.I.get<HomeLogic>(),
        super(key: key);

  final HomeLogic controller;
  final Function(String id,int oldId, int color) goHabitDetails;

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
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, color: Colors.black26));
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: data.map((habit) {
                    // DayDone done =
                    //     controller.doneHabits.firstWhere((dayDone) => dayDone.habitId == habit.oldId, orElse: () => null);
                    return HabitCardItem(
                        habit: habit,
                        goHabitDetails: goHabitDetails,
                        showDragTarget: controller.swipeSkyWidget,
                        done: false);
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
