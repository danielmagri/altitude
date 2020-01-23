import 'package:flutter/material.dart';
import 'package:altitude/datas/dataHabitDetail.dart';

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
            padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8),
            child: Text("Informações Legais",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: DataHabitDetail().getColor())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    height: 1.2,
                    fontFamily: "Montserrat"),
                children: <TextSpan>[
                  TextSpan(text: "Começou em "),
                  TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    text: DataHabitDetail().habit.initialDate.day.toString().padLeft(2, '0') +
                        "/" +
                        DataHabitDetail().habit.initialDate.month.toString().padLeft(2, '0') +
                        "/" +
                        DataHabitDetail().habit.initialDate.year.toString() +
                        "\n",
                  ),
                  TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    text: DataHabitDetail().habit.daysDone.toString(),
                  ),
                  TextSpan(text: " dias cumpridos no total"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
