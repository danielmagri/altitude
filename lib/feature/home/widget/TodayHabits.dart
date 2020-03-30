import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/view/HabitCardItem.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/home/viewmodel/HomeViewModel.dart';
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
import 'package:provider/provider.dart' show Provider;

class TodayHabits extends StatelessWidget {
  const TodayHabits({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<HomeViewModel>(context);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Text(
            "HÁBITOS DE HOJE",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          child: Center(
            child: viewmodel.todayHabits.handleState(
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
                        DayDone done = viewmodel.doneHabits.data
                            .firstWhere((dayDone) => dayDone.habitId == habit.id, orElse: () => null);
                        return HabitCardItem(
                          habit: habit,
                          showDragTarget: viewmodel.swipeSkyWidget,
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
            ),
          ),
        )
      ],
    );
  }
}
