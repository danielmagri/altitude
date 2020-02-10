import 'package:altitude/core/Constants.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:altitude/ui/habitDetails/widgets/SkyScene.dart';
import 'package:altitude/ui/widgets/ScoreTextAnimated.dart';
import 'package:altitude/ui/widgets/generic/Skeleton.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, @required this.bloc}) : super(key: key);

  final HabitDeatilsBloc bloc;

  double _setRocketForce() {
    double force;
    int cycleDays = CYCLE_DAYS;
    int timesDays = bloc.data.frequency.daysCount();
    List<DateTime> dates = bloc.data.daysDone.keys.toList();

    int daysDoneLastCycle =
        dates.where((date) => date.isAfter(DateTime.now().subtract(Duration(days: cycleDays + 1)))).length;

    force = daysDoneLastCycle / timesDays;

    if (force > 1.3) force = 1.3;
    return force;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SkyScene(
              size: const Size(140, 140),
              color: bloc.data.getColor(),
              force: _setRocketForce(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<Habit>(
                  stream: bloc.habitDataStream,
                  
                  builder: (BuildContext context, AsyncSnapshot<Habit> snapshot) {
                    if (!snapshot.hasData) {
                      return Skeleton(
                        width: double.maxFinite,
                        height: 30,
                        margin: EdgeInsets.only(left: 8),
                      );
                    } else {
                      return Text(
                        snapshot.data.habit,
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 19),
                      );
                    }
                  },
                ),
                ScoreWidget(
                  color: bloc.data.getColor(),
                  animation: IntTween(begin: bloc.previousScore, end: bloc.data.habit.score)
                      .animate(CurvedAnimation(parent: bloc.controllerScore, curve: Curves.fastOutSlowIn)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
