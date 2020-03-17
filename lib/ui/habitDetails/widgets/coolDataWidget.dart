import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:flutter/material.dart';

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key key, @required this.bloc}) : super(key: key);

  final HabitDetailsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Habit>(
        stream: bloc.habitStream,
        builder: (BuildContext context, AsyncSnapshot<Habit> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8),
                    child: Text("Informações Legais",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold, color: bloc.habitColor)),
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
                            text: snapshot.data.initialDate.day.toString().padLeft(2, '0') +
                                "/" +
                                snapshot.data.initialDate.month.toString().padLeft(2, '0') +
                                "/" +
                                snapshot.data.initialDate.year.toString() +
                                "\n",
                          ),
                          TextSpan(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            text: snapshot.data.daysDone.toString(),
                          ),
                          TextSpan(text: " dias cumpridos no total"),
                        ],
                      ),
                    ),
                  ),
                ],
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
        });
  }
}
