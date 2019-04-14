import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';

class HabitWidget extends StatelessWidget {
  HabitWidget({Key key, this.habit}) : super(key: key);

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Habit data = await DataControl().getHabit(habit.id);
        if(data!= null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HabitDetailsPage(habit: data,);
          }));
        }
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
                color: Color.fromARGB(255, 239, 83, 80),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 32.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                habit.habit,
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
