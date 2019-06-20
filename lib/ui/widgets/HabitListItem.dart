import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/ui/widgets/Loading.dart';

class HabitListItem extends StatelessWidget {
  HabitListItem({Key key, this.habit, this.done, this.setHabitDone, this.width}) : super(key: key);

  final Habit habit;
  final bool done;
  final Function setHabitDone;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: width,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: 15,
            bottom: 0,
            right: 60,
            child: Text(
              done ? "Feito!" : "",
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: done ? width - 55 : 40,
            child: Dismissible(
              key: Key(habit.id.toString()),
              confirmDismiss: (direction) async {
                if (!done && direction == DismissDirection.startToEnd) setHabitDone(habit.id);
                Future.value(false);
              },
              direction: done ? DismissDirection.endToStart : DismissDirection.startToEnd,
              child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                width: width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                  color: HabitColors.colors[habit.color],
                  boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  onTap: () async {
                    showLoading(context);

                    Habit data = await DataControl().getHabit(habit.id);
                    List<Reminder> reminders = await DataControl().getReminders(habit.id);
                    dynamic frequency = await DataControl().getFrequency(habit.id);
                    Map<DateTime, List> daysDone = await DataControl().getDaysDone(habit.id);

                    closeLoading(context);
                    if (data != null && data.id != null && frequency != null && reminders != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return HabitDetailsPage(
                          habit: data,
                          reminders: reminders,
                          frequency: frequency,
                          markedDays: daysDone,
                          fromAllHabits: false,
                        );
                      }));
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60.0,
                        height: 50.0,
                        child: Hero(
                          tag: habit.id,
                          transitionOnUserGestures: true,
                          child: Icon(
                            IconData(habit.icon, fontFamily: 'MaterialIcons'),
                            size: 32.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          habit.habit,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
