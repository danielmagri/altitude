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
        WrapAlignment;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AllHabitsPage extends StatelessWidget {
  AllHabitsPage({Key key})
      : controller = GetIt.I.get<HomeLogic>(),
        super(key: key);

  final HomeLogic controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Text("TODOS OS HÁBITOS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
        ),
        Expanded(
          child: Center(
            child: Observer(builder: (_) {
              return controller.allHabits.handleState(
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
                    return Text(
                      "Crie um novo hábito pelo botão \"+\" na tela principal.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: data.map((habit) {
                          DayDone done = controller.doneHabits
                              .firstWhere((dayDone) => dayDone.habitId == habit.id, orElse: () => null);
                          return HabitCardItem(
                            habit: habit,
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
            }),
          ),
        )
      ],
    );
  }
}
