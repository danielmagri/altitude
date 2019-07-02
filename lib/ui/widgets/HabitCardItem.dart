import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/ui/widgets/Loading.dart';
import 'package:habit/datas/dataHabitDetail.dart';

class HabitCardItem extends StatelessWidget {
  HabitCardItem({Key key, this.habit}) : super(key: key);

  final Habit habit;

  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () async {
        showLoading(context);

        Habit data = await DataControl().getHabit(habit.id);
        List<Reminder> reminders = await DataControl().getReminders(habit.id);
        dynamic frequency = await DataControl().getFrequency(habit.id);
        Map<DateTime, List> daysDone = await DataControl().getDaysDone(habit.id);

        closeLoading(context);
        if (data != null && data.id != null && frequency != null && reminders != null) {
          DataHabitDetail().habit = data;
          DataHabitDetail().reminders = reminders;
          DataHabitDetail().frequency = frequency;
          DataHabitDetail().daysDone = daysDone;

          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HabitDetailsPage(
              fromAllHabits: true,
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
              width: 70.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: HabitColors.colors[habit.color],
                boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))],
              ),
              child: Hero(
                tag: habit.id + 1000,
                transitionOnUserGestures: true,
                child: Icon(
                  IconData(habit.icon, fontFamily: 'MaterialIcons'),
                  size: 32.0,
                  color: Colors.white,
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
