import 'package:altitude/common/view/HabitCardItem.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/presentation/home/controllers/home_controller.dart';
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
        WrapAlignment;
import 'package:flutter_mobx/flutter_mobx.dart';

class HabitsPanel extends StatelessWidget {
  HabitsPanel(
      {Key? key, required this.controller, required this.goHabitDetails})
      : super(key: key);

  final HomeController controller;
  final Function(String? id, int? color) goHabitDetails;

  @override
  Widget build(context) {
    return Center(
      child: Observer(builder: (_) {
        return controller.habits.handleState(
          loading: () => Skeleton.custom(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Rocket(
                size: const Size(100, 100),
                color: Colors.white,
              ),
            ),
          ),
          success: (data) {
            if (data.isEmpty) {
              return Text(
                  "Crie um novo hábito pelo botão \"+\" na tela principal.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22));
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
                        done:
                            DateTime.now().onlyDate.isSameDay(habit.lastDone));
                  }).toList(),
                ),
              );
            }
          },
          error: (error) => const DataError(),
        );
      }),
    );
  }
}
