import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/view/HabitCardItem.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:flutter/material.dart'
    show
        BouncingScrollPhysics,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        EdgeInsets,
        Expanded,
        FontWeight,
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

class TodayHabits extends StatelessWidget {
  TodayHabits({Key key, @required this.goHabitDetails})
      : controller = GetIt.I.get<HomeLogic>(),
        super(key: key);

  final HomeLogic controller;
  final Function(int id, int color) goHabitDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          child: const Text("HÁBITOS DE HOJE", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
        ),
        Expanded(
          child: Center(
            child: Observer(
              builder: (_) {
                return controller.todayHabits.handleState(
                  () {
                    return Skeleton.custom(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Rocket(
                          size: const Size(100, 100),
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          "Não tem hábitos para serem feitos hoje",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: data.map((habit) {
                            DayDone done = controller.doneHabits
                                .firstWhere((dayDone) => dayDone.habitId == habit.id, orElse: () => null);
                            return HabitCardItem(
                              habit: habit,
                              goHabitDetails: goHabitDetails,
                              showDragTarget: controller.swipeSkyWidget,
                              done: done == null ? false : true,
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                  (error) {
                    return Text("Ocorreu um erro", textAlign: TextAlign.center);
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
