import 'package:flutter/material.dart';
import 'package:habit/datas/dataHabitDetail.dart';

class CueWidget extends StatelessWidget {
  CueWidget({Key key, @required this.openBottomSheet}) : super(key: key);

  final Function openBottomSheet;

  Widget _setCueWidget() {
    if (DataHabitDetail().habit.cue == null) {
      return Text(
          "Se você quer ter sucesso no hábito então você precisa ter uma deixa! Adicione agora!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16));
    } else {
      return Text(
          DataHabitDetail().habit.cue,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, height: 1.2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 12),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), topRight: Radius.circular(50)),
                      color: DataHabitDetail().getColor(),
                      boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
                  child:
                      Text("Deixa", style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                SizedBox(width: 6),
                InkWell(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          DataHabitDetail().habit.cue == null ? "Adicionar" : "Editar",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )),
                    onTap: () => openBottomSheet(0)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            child: _setCueWidget(),
          ),
        ],
      ),
    );
  }
}
