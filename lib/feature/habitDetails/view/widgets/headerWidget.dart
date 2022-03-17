import 'package:altitude/common/view/Score.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/feature/habitDetails/view/widgets/SkyScene.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Expanded,
        Key,
        MainAxisAlignment,
        MainAxisSize,
        Row,
        Size,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextOverflow,
        TextStyle,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key? key})
      : controller = GetIt.I.get<HabitDetailsLogic>(),
        super(key: key);

  final HabitDetailsLogic controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Observer(
              builder: (_) {
                return controller.rocketForce.handleState(() {
                  return Skeleton.custom(child: Rocket(size: const Size(140, 140), color: Colors.white));
                }, (data) {
                  return SkyScene(size: const Size(140, 140), color: controller.habitColor, force: data!);
                }, (error) {
                  return const SizedBox();
                });
              },
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                return controller.habit.handleState(() {
                  return Skeleton.custom(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          width: 120,
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        )
                      ],
                    ),
                  );
                }, (data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data!.habit!,
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 19),
                      ),
                      Score(color: controller.habitColor, score: data.score),
                    ],
                  );
                }, (error) {
                  return SizedBox();
                });
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
