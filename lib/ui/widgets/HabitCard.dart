import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/utils/Color.dart';

class HabitWidget extends StatelessWidget {
  HabitWidget({Key key, this.habit}) : super(key: key);

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Habit data = await DataControl().getHabit(habit.id);
        dynamic frequency = await DataControl().getFrequency(habit.id);
        Map<DateTime, List> daysDone = await DataControl().getDaysDone(habit.id);

        if (data != null && data.id != null && frequency != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HabitDetailsPage(
              habit: data,
              frequency: frequency,
              markedDays: daysDone,
            );
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
                color: CategoryColors.getColor(habit.category),
              ),
              child: Hero(
                tag: habit.id,
                transitionOnUserGestures: true,
                child: Icon(
                  Icons.fitness_center,
                  size: 32.0,
                ),
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
