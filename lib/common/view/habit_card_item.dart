import 'package:altitude/common/view/generic/rocket.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        Draggable,
        EdgeInsets,
        Expanded,
        FontWeight,
        InkWell,
        Key,
        Size,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextAlign,
        TextOverflow,
        TextStyle,
        Transform,
        Widget;

class HabitCardItem extends StatelessWidget {
  const HabitCardItem({
    required this.habit,
    required this.goHabitDetails,
    required this.showDragTarget,
    required this.done,
    Key? key,
  }) : super(key: key);

  final Habit habit;
  final Function(String id, int color) goHabitDetails;
  final Function(bool) showDragTarget;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return done
        ? InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => goHabitDetails(habit.id, habit.colorCode),
            child: Container(
              padding: const EdgeInsets.all(4),
              width: 118,
              height: 103,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Rocket(
                        size: const Size(60, 60),
                        color: habit.color,
                        isExtend: true,
                      ),
                      Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            'Feito!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        habit.habit,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Draggable<String>(
            data: habit.id,
            onDragStarted: () => showDragTarget(true),
            onDragEnd: (details) => showDragTarget(false),
            feedback: Rocket(
              size: const Size(100, 100),
              color: habit.color,
              state: RocketState.onFire,
              isExtend: true,
              fireForce: 1,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => goHabitDetails(habit.id, habit.colorCode),
              child: Container(
                padding: const EdgeInsets.all(4),
                width: 118,
                height: 103,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Rocket(
                      size: const Size(60, 60),
                      color: habit.color,
                      isExtend: true,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          habit.habit,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            childWhenDragging: Container(
              padding: const EdgeInsets.all(4),
              width: 118,
              height: 103,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  const SizedBox(width: 60, height: 60),
                  Expanded(
                    child: Center(
                      child: Text(
                        habit.habit,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
