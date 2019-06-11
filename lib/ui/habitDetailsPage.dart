import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:habit/ui/editHabitPage.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit/ui/widgets/Toast.dart';
import 'package:vibration/vibration.dart';

class CueWidget extends StatelessWidget {
  CueWidget({Key key, this.cue, this.color}) : super(key: key);

  final String cue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Deixa", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4, color: color)),
            Text(cue, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key key, this.initialDate, this.daysDone, this.cycles, this.color}) : super(key: key);

  final DateTime initialDate;
  final int daysDone;
  final int cycles;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Informações Legais",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4, color: color)),
            Text(
                "Começou em " +
                    initialDate.day.toString().padLeft(2, '0') +
                    "/" +
                    initialDate.month.toString().padLeft(2, '0') +
                    "/" +
                    initialDate.year.toString(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            Text("Dias cumpridos: " + daysDone.toString(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            Text("Ciclos feitos: " + cycles.toString(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key, @required this.markedDays, this.color}) : super(key: key);

  final Map<DateTime, List> markedDays;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Dias feito",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4, color: color)),
            TableCalendar(
              events: markedDays,
              formatAnimation: FormatAnimation.slide,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableGestures: AvailableGestures.horizontalSwipe,
              forcedCalendarFormat: CalendarFormat.month,
              rowHeight: 40,
              builders: CalendarBuilders(markersBuilder: (context, date, event, list) {
                return <Widget>[
                  Container(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment(0.0, 0.0),
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: event[0] ? 0 : 5, right: event[1] ? 0 : 5),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: event[0] ? Radius.circular(0) : Radius.circular(20),
                            right: event[1] ? Radius.circular(0) : Radius.circular(20)),
                        color: color,
                      ))
                ];
              }, selectedDayBuilder: (context, date, list) {
                return Container(
                  child: Text(
                    date.day.toString(),
                  ),
                  alignment: Alignment(0.0, 0.0),
                );
              }, todayDayBuilder: (context, date, list) {
                return Container(
                  child: Text(
                    date.day.toString(),
                  ),
                  alignment: Alignment(0.0, 0.0),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
                );
              }),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                formatButtonDecoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key, this.habit, this.reminders, this.frequency, this.markedDays, this.fromAllHabits}) : super(key: key);

  final Habit habit;
  final List<Reminder> reminders;
  final dynamic frequency;
  final Map<DateTime, List> markedDays;
  final bool fromAllHabits;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> with TickerProviderStateMixin {
  AnimationController _controllerScore;

  int previousScore = 0;
  Habit habit;
  List<Reminder> reminders;
  dynamic frequency;
  Map<DateTime, List> markedDays;

  @override
  initState() {
    super.initState();

    habit = widget.habit;
    reminders = widget.reminders;
    frequency = widget.frequency;
    markedDays = widget.markedDays;

    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    animateScore();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    super.dispose();
  }

  void animateScore() {
    if (previousScore != habit.score) {
      _controllerScore.reset();
      _controllerScore.forward().then((e) {
        previousScore = habit.score;
      });
    }
  }

  bool hasDoneToday() {
    DateTime now = DateTime.now();
    if (markedDays.containsKey(DateTime(now.year, now.month, now.day))) {
      return true;
    } else {
      return false;
    }
  }

  void setDoneHabit() {
    if (hasDoneToday()) {
      showToast("Você já completou esse hábito hoje!");
    } else {
      Vibration.hasVibrator().then((resp) {
        if (resp != null && resp == true) {
          Vibration.vibrate(duration: 100);
        }
      });

      DataControl().setHabitDoneAndScore(habit.id, habit.cycle).then((earnedScore) {
        DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        bool before;
        if (markedDays.length - 1 >= 0 && markedDays.containsKey(now.subtract(Duration(days: 1)))) {
          markedDays[now.subtract(Duration(days: 1))] = [markedDays[now.subtract(Duration(days: 1))][0], true];
          before = true;
        } else {
          before = false;
        }

        setState(() {
          habit.score += earnedScore;
          markedDays.putIfAbsent(now, () => [before, false]);
          habit.daysDone++;
        });
        animateScore();
      });
    }
  }

  String frequencyText() {
    if (frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = frequency;
      String text = "";
      bool hasOne = false;

      if (freq.monday == 1) {
        text += "Segunda";
        hasOne = true;
      }
      if (freq.tuesday == 1) {
        if (hasOne) text += ", ";
        text += "Terça";
        hasOne = true;
      }
      if (freq.wednesday == 1) {
        if (hasOne) text += ", ";
        text += "Quarta";
        hasOne = true;
      }
      if (freq.thursday == 1) {
        if (hasOne) text += ", ";
        text += "Quinta";
        hasOne = true;
      }
      if (freq.friday == 1) {
        if (hasOne) text += ", ";
        text += "Sexta";
        hasOne = true;
      }
      if (freq.saturday == 1) {
        if (hasOne) text += ", ";
        text += "Sábado";
        hasOne = true;
      }
      if (freq.sunday == 1) {
        if (hasOne) text += ", ";
        text += "Domingo";
      }
      return text;
    } else if (frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = frequency;
      return freq.daysTime.toString() + " vezes por semana";
    } else if (frequency.runtimeType == FreqRepeating) {
      FreqRepeating freq = frequency;
      return freq.daysTime.toString() + " vezes em " + freq.daysCycle.toString() + " dias";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70.0,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                BackButton(color: HabitColors.colors[habit.color]),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.check, size: 34, color: HabitColors.colors[habit.color]),
                    onPressed: setDoneHabit),
                SizedBox(
                  width: 8,
                ),
                IconButton(
                    icon: Icon(Icons.edit, size: 30, color: HabitColors.colors[habit.color]),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return EditHabitPage(
                          habit: habit,
                          reminders: reminders,
                          frequency: frequency,
                        );
                      })).then((editedData) {
                        if (editedData != null) {
                          setState(() {
                            habit = editedData[0];
                            frequency = editedData[1];
                            reminders = editedData[2];
                          });
                        }
                      });
                    }),
              ]),
            ),
            HeaderWidget(
              id: habit.id,
              name: habit.habit,
              score: habit.score,
              previousScore: previousScore,
              color: HabitColors.colors[habit.color],
              icon: habit.icon,
              fromAllHabits: widget.fromAllHabits,
              controllerScore: _controllerScore,
            ),
            Container(
              height: 1,
              color: Colors.grey,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            Text(
              frequencyText(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, color: Colors.black54),
            ),
            CueWidget(
              cue: habit.cue,
              color: HabitColors.colors[habit.color],
            ),
            CoolDataWidget(
              initialDate: habit.initialDate != null ? habit.initialDate : DateTime.now(),
              daysDone: habit.daysDone,
              cycles: habit.cycle,
              color: HabitColors.colors[habit.color],
            ),
            CalendarWidget(
              markedDays: markedDays,
              color: HabitColors.colors[habit.color],
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget(
      {Key key,
      this.id,
      this.name,
      this.score,
      this.previousScore,
      this.color,
      this.icon,
      this.fromAllHabits,
      this.controllerScore})
      : super(key: key);

  final int id;
  final String name;
  final int score;
  final int previousScore;
  final Color color;
  final int icon;
  final bool fromAllHabits;
  final controllerScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      alignment: Alignment(0.0, 0.5),
      child: Row(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 90.0,
            alignment: Alignment(-0.1, 0.0),
            child: Hero(
              tag: fromAllHabits ? id + 1000 : id,
              transitionOnUserGestures: true,
              child: Icon(
                IconData(icon, fontFamily: 'MaterialIcons'),
                size: 40.0,
                color: Colors.white,
              ),
            ),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), topRight: Radius.circular(50)),
                color: color,
                boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
          ),
          Spacer(
            flex: 2,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 65,
              ),
              ScoreWidget(
                color: color,
                animation: IntTween(begin: previousScore, end: score)
                    .animate(CurvedAnimation(parent: controllerScore, curve: Curves.fastOutSlowIn)),
              ),
            ],
          ),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
