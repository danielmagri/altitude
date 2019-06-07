import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/ui/addHabitWidgets/colorWidget.dart';
import 'package:habit/ui/addHabitWidgets/cueWidget.dart';
import 'package:habit/ui/addHabitWidgets/habitWidget.dart';
import 'package:habit/ui/addHabitWidgets/frequencyWidget.dart';
import 'package:habit/ui/addHabitWidgets/alarmWidget.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/datas/dataHabitCreation.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/ui/widgets/Toast.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage({Key key, this.habit, this.reminders, this.frequency}) : super(key: key);

  final Habit habit;
  final List<Reminder> reminders;
  final dynamic frequency;

  @override
  _EditHabitPagePageState createState() => _EditHabitPagePageState();
}

class _EditHabitPagePageState extends State<EditHabitPage> {
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();

  final habitController = TextEditingController();
  final cueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    DataHabitCreation().icon = widget.habit.icon;
    DataHabitCreation().indexColor = widget.habit.color;
    DataHabitCreation().frequency = widget.frequency;
    DataHabitCreation().reminders = widget.reminders;

    habitController.text = widget.habit.habit;
    cueController.text = widget.habit.cue;
  }

  @override
  void dispose() {
    habitController.dispose();
    cueController.dispose();
    super.dispose();
  }

  void changeColor(int index) {
    setState(() {
      DataHabitCreation().indexColor = index;
    });
  }

  void _createHabitTap() async {
    if (Validate.habitTextValidate(habitController.text) != null) {
      showToast("O hábito precisa ser preenchido.");
    } else if (Validate.cueTextValidate(cueController.text) != null) {
      showToast("A deixa precisa ser preenchido.");
    } else if (DataHabitCreation().frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      Habit editedHabit = new Habit(
        id: widget.habit.id,
        color: DataHabitCreation().indexColor,
        icon: DataHabitCreation().icon,
        cue: cueController.text,
        habit: habitController.text,
        score: widget.habit.score,
        cycle: widget.habit.cycle,
        daysDone: widget.habit.daysDone,
        initialDate: widget.habit.initialDate
      );

      if (editedHabit.icon != widget.habit.icon ||
          editedHabit.color != widget.habit.color ||
          editedHabit.cue.compareTo(widget.habit.cue) == 0 ||
          editedHabit.habit.compareTo(widget.habit.habit) == 0) {
        await DataControl().updateHabit(editedHabit);
      }

      if (!compareFrequency(widget.frequency, DataHabitCreation().frequency)) {
        await DataControl()
            .updateFrequency(editedHabit.id, DataHabitCreation().frequency, widget.frequency.runtimeType);
      }

      if (!compareReminders(widget.reminders, DataHabitCreation().reminders)) {
        await DataControl().deleteReminders(widget.habit.id, widget.reminders);
        await DataControl().addReminders(editedHabit, DataHabitCreation().reminders);
      }

      Navigator.pop(context, {0:editedHabit, 1: DataHabitCreation().frequency, 2: DataHabitCreation().reminders});
      showToast("O hábito foi editado!");
    }
  }

  bool compareFrequency(dynamic f1, dynamic f2) {
    if (f1.runtimeType == f2.runtimeType) {
      switch (f1.runtimeType) {
        case FreqDayWeek:
          FreqDayWeek dayweek1 = f1;
          FreqDayWeek dayweek2 = f2;
          if (dayweek1.sunday == dayweek2.sunday &&
              dayweek1.monday == dayweek2.monday &&
              dayweek1.tuesday == dayweek2.tuesday &&
              dayweek1.wednesday == dayweek2.wednesday &&
              dayweek1.thursday == dayweek2.thursday &&
              dayweek1.friday == dayweek2.friday &&
              dayweek1.saturday == dayweek2.saturday) {
            return true;
          }
          return false;
        case FreqWeekly:
          FreqWeekly weekly1 = f1;
          FreqWeekly weekly2 = f2;
          if (weekly1.daysTime == weekly2.daysTime) {
            return true;
          }
          return false;
        case FreqRepeating:
          FreqRepeating repeating1 = f1;
          FreqRepeating repeating2 = f2;
          if (repeating1.daysTime == repeating2.daysTime && repeating1.daysCycle == repeating2.daysCycle) {
            return true;
          }
          return false;
      }
    }
    return false;
  }

  bool compareReminders(List<Reminder> r1, List<Reminder> r2) {
    if (r1.length != r2.length) return false;
    if (r1.length == 0 && r2.length == 0) return true;

    if (r1[0].hour != r2[0].hour || r1[0].minute != r2[0].minute) return false;

    for (Reminder reminder in r1) {
      if (r2.firstWhere((r) => r.weekday == reminder.weekday, orElse: () => null) == null) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: BackButton(),
                  ),
                  Spacer(),
                  Text(
                    "EDITAR HÁBITO",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 50,
                    child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Deletar"),
                                content: new Text(
                                    "Você deseja deletar permanentemente o hábito?\n(Todos o progresso dele será perdido)"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Sim"),
                                    onPressed: () {
                                      DataControl().deleteHabit(widget.habit.id).then((status) {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      });
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text("Não"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            ),
            ColorWidget(
              currentColor: DataHabitCreation().indexColor,
              changeColor: changeColor,
            ),
            SizedBox(
              height: 20,
            ),
            HabitWidget(
              color: HabitColors.colors[DataHabitCreation().indexColor],
              controller: habitController,
              keyboard: _keyboardVisibility,
            ),
            FrequencyWidget(
              color: HabitColors.colors[DataHabitCreation().indexColor],
            ),
            CueWidget(
              color: HabitColors.colors[DataHabitCreation().indexColor],
              controller: cueController,
              keyboard: _keyboardVisibility,
            ),
            AlarmWidget(
              color: HabitColors.colors[DataHabitCreation().indexColor],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 28),
              child: RaisedButton(
                color: HabitColors.colors[DataHabitCreation().indexColor],
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                elevation: 5.0,
                onPressed: _createHabitTap,
                child: const Text(
                  "SALVAR",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
