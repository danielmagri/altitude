import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart';
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
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CueWidget extends StatelessWidget {
  CueWidget({Key? key, required this.openBottomSheet})
      : controller = GetIt.I.get<HabitDetailsController>(),
        super(key: key);

  final HabitDetailsController controller;
  final Function openBottomSheet;

  Widget _setCueWidget(String cue) {
    if (cue.isEmpty) {
      return const Text(
          "Se você quer ter sucesso no hábito então você precisa ter um gatilho inicial!",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16));
    } else {
      return Text(cue,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return controller.habit.handleState(() {
          return const Skeleton(
              width: double.maxFinite,
              height: 130,
              margin: const EdgeInsets.symmetric(horizontal: 8));
        }, (data) {
          return SizedBox(
            height: 130,
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              child: InkWell(
                onTap: openBottomSheet as void Function()?,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Gatilho",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: controller.habitColor,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _setCueWidget(data!.oldCue!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, (error) {
          return const SizedBox();
        });
      },
    );
  }
}
