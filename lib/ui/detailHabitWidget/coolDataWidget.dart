import 'package:flutter/material.dart';
import 'package:habit/datas/dataHabitDetail.dart';

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 12),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), topRight: Radius.circular(50)),
                color: DataHabitDetail().getColor(),
                boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
            child: Text("Informações Legais",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "Começou em " +
                        DataHabitDetail().habit.initialDate.day.toString().padLeft(2, '0') +
                        "/" +
                        DataHabitDetail().habit.initialDate.month.toString().padLeft(2, '0') +
                        "/" +
                        DataHabitDetail().habit.initialDate.year.toString(),
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
                Text("Dias cumpridos: " + DataHabitDetail().habit.daysDone.toString(),
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
                Text("Ciclos feitos: " + DataHabitDetail().habit.cycle.toString(),
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
