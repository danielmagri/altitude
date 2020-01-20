import 'package:flutter/material.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/model/Habit.dart';
import 'package:habit/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:habit/ui/widgets/generic/Skeleton.dart';

class CueWidget extends StatelessWidget {
  CueWidget({Key key, @required this.bloc}) : super(key: key);

  final HabitDeatilsBloc bloc;

  Widget _setCueWidget(String cue) {
    if (cue == null) {
      return Text("Se você quer ter sucesso no hábito então você precisa ter um gatilho inicial!",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16));
    } else {
      return Text(cue, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Habit>(
      stream: bloc.habitDataStream,
      builder: (BuildContext context, AsyncSnapshot<Habit> snapshot) {
        if (!snapshot.hasData) {
          return Skeleton(
            width: double.maxFinite,
            height: 130,
            margin: EdgeInsets.symmetric(horizontal: 8),
          );
        } else {
          return SizedBox(
            height: 130,
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              child: InkWell(
                onTap: () => bloc.openBottomSheet(0),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Gatilho",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: DataHabitDetail().getColor(),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _setCueWidget(snapshot.data.cue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
