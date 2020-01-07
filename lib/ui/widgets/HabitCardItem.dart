import 'package:flutter/material.dart';
import 'package:habit/model/Habit.dart';
import 'package:habit/utils/Util.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/ui/widgets/generic/Rocket.dart';

class HabitCardItem extends StatelessWidget {
  HabitCardItem({Key key, this.habit, this.showDragTarget, this.done}) : super(key: key);

  final Habit habit;
  final Function(bool show) showDragTarget;
  final bool done;

  Widget build(BuildContext context) {
    return done
        ? InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => Util.goDetailsPage(context, habit.id),
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
                        color: AppColors.habitsColor[habit.color],
                        isExtend: true,
                      ),
                      Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Feito!",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Draggable<int>(
            data: habit.id,
            onDragStarted: () => showDragTarget(true),
            onDragEnd: (details) => showDragTarget(false),
            feedback: Rocket(
              size: const Size(100, 100),
              color: AppColors.habitsColor[habit.color],
              state: RocketState.ON_FIRE,
              isExtend: true,
              fireForce: 1,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => Util.goDetailsPage(context, habit.id),
              child: Container(
                padding: const EdgeInsets.all(4),
                width: 118,
                height: 103,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Rocket(
                      size: const Size(60, 60),
                      color: AppColors.habitsColor[habit.color],
                      isExtend: true,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          habit.habit,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
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
                  SizedBox(
                    width: 60,
                    height: 60,
                  ),
                  // Rocket(size: const Size(110, 60), color: HabitColors.colors[habit.color], state: RocketState.DISABLED,),
                  Expanded(
                    child: Center(
                      child: Text(
                        habit.habit,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
