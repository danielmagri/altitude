import 'package:flutter/material.dart';
import 'package:altitude/datas/dataHabitDetail.dart';

class CueWidget extends StatelessWidget {
  CueWidget({Key key, @required this.openBottomSheet}) : super(key: key);

  final Function(int index) openBottomSheet;

  Widget _setCueWidget() {
    if (DataHabitDetail().habit.cue == null) {
      return Text("Se você quer ter sucesso no hábito então você precisa ter um gatilho inicial!",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16));
    } else {
      return Text(DataHabitDetail().habit.cue,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 4,
        child: InkWell(
          onTap: () => openBottomSheet(0),
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
                    child: _setCueWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
