import 'package:altitude/model/Habit.dart';
import 'package:altitude/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:altitude/ui/habitDetails/widgets/SkyScene.dart';
import 'package:altitude/ui/widgets/Score.dart';
import 'package:altitude/ui/widgets/generic/Skeleton.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, @required this.bloc, this.color}) : super(key: key);

  final HabitDeatilsBloc bloc;
  final Color color;

  double _setRocketForce() {
    // double force;
    // int cycleDays = CYCLE_DAYS;
    // int timesDays = bloc.data.frequency.daysCount();
    // List<DateTime> dates = bloc.data.daysDone.keys.toList();

    // int daysDoneLastCycle =
    //     dates.where((date) => date.isAfter(DateTime.now().subtract(Duration(days: cycleDays + 1)))).length;

    // force = daysDoneLastCycle / timesDays;

    // if (force > 1.3) force = 1.3;
    // return force;
    return 1;
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
              color: color,
              force: _setRocketForce(),
            ),
          ),
          Expanded(
            child: StreamBuilder<Habit>(
              stream: bloc.habitStream,
              builder: (BuildContext context, AsyncSnapshot<Habit> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.data.habit,
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 19),
                      ),
                      Score(color: color, score: snapshot.data.score),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return SizedBox();
                } else {
                  return Skeleton.custom(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(15),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
