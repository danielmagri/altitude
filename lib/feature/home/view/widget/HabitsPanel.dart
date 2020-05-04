import 'package:altitude/feature/home/enums/HabitFiltersType.dart';
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
  final Function(int id, int color) goHabitDetails;

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
              return Text(controller.filterSelected.emptyMessage,
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, color: Colors.black26));
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: data.map((habit) {
                    DayDone done =
                        controller.doneHabits.firstWhere((dayDone) => dayDone.habitId == habit.id, orElse: () => null);
                    return HabitCardItem(
                        habit: habit,
                        goHabitDetails: goHabitDetails,
                        showDragTarget: controller.swipeSkyWidget,
                        done: done == null ? false : true);
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
