import 'package:altitude/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:altitude/ui/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/ui/widgets/generic/Skeleton.dart';
import 'package:flutter/material.dart';

class CueWidget extends StatelessWidget {
  CueWidget({Key key, @required this.bloc}) : super(key: key);

  final HabitDeatilsBloc bloc;

  Widget _setCueWidget(String cue) {
    if (cue.isEmpty) {
      return Text("Se você quer ter sucesso no hábito então você precisa ter um gatilho inicial!",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16));
    } else {
      return Text(cue, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: bloc.cueTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 130,
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              child: InkWell(
                onTap: () => bloc.openBottomSheet(BottomSheetType.CUE),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Gatilho",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: bloc.habitColor,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _setCueWidget(snapshot.data),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox();
        } else {
          return Skeleton(
            width: double.maxFinite,
            height: 130,
            margin: EdgeInsets.symmetric(horizontal: 8),
          );
        }
      },
    );
  }
}
