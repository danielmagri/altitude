import 'package:altitude/common/view/Score.dart';
import 'package:altitude/common/view/generic/rocket.dart';
import 'package:altitude/common/view/generic/skeleton.dart';
import 'package:altitude/presentation/habits/controllers/habit_details_controller.dart';
import 'package:altitude/presentation/habits/widgets/sky_scene.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Colors,
        Column,
        Container,
        EdgeInsets,
        Expanded,
        Key,
        MainAxisAlignment,
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
      : controller = GetIt.I.get<HabitDetailsController>(),
        super(key: key);

  final HabitDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Observer(
              builder: (_) {
                return controller.rocketForce.handleState(
                  loading: () {
                    return const Skeleton.custom(
                      child: Rocket(
                        size: Size(140, 140),
                        color: Colors.white,
                      ),
                    );
                  },
                  success: (data) {
                    return SkyScene(
                      size: const Size(140, 140),
                      color: controller.habitColor,
                      force: data,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                return controller.habit.handleState(
                  loading: () {
                    return Skeleton.custom(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  success: (data) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          data!.habit,
                          textAlign: TextAlign.center,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 19),
                        ),
                        Score(color: controller.habitColor, score: data.score),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
