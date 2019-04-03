import 'package:flutter/material.dart';
import 'package:habit/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';

class HabitWidget extends StatelessWidget {
  HabitWidget({Key key, this.habit}) : super(key: key);

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return HabitDetailsPage();
        }));
      },
      child: SizedBox(
        height: 90.0,
        width: 110.0,
        child: Column(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color.fromARGB(255, 250, 127, 114),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 32.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                habit.getHabitText(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
