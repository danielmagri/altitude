import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/view/Score.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:altitude/ui/habitDetails/widgets/SkyScene.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, @required this.bloc}) : super(key: key);

  final HabitDetailsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<double>(
              stream: bloc.rocketForceStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SkyScene(
                    size: const Size(140, 140),
                    color: bloc.habitColor,
                    force: snapshot.data,
                  );
                } else if (snapshot.hasError) {
                  return SizedBox();
                } else {
                  return Skeleton.custom(
                    child: Rocket(
                      size: const Size(140, 140),
                      color: bloc.habitColor,
                    ),
                  );
                }
              },
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
                      Score(color: bloc.habitColor, score: snapshot.data.score),
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
