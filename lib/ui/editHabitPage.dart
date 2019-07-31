import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/ui/addHabitWidgets/colorWidget.dart';
import 'package:habit/ui/addHabitWidgets/habitWidget.dart';
import 'package:habit/ui/addHabitWidgets/frequencyWidget.dart';
import 'package:habit/ui/addHabitWidgets/alarmWidget.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/datas/dataHabitCreation.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/datas/dataHabitDetail.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage({Key key}) : super(key: key);

  @override
  _EditHabitPagePageState createState() => _EditHabitPagePageState();
}

class _EditHabitPagePageState extends State<EditHabitPage> {
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();

  final habitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    DataHabitCreation().icon = DataHabitDetail().habit.icon;
    DataHabitCreation().indexColor = DataHabitDetail().habit.color;
    DataHabitCreation().frequency = DataHabitDetail().frequency;
    DataHabitCreation().reminders = DataHabitDetail().reminders;

    habitController.text = DataHabitDetail().habit.habit;
  }

  @override
  void dispose() {
    habitController.dispose();
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
    } else if (DataHabitCreation().frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      Habit editedHabit = new Habit(
          id: DataHabitDetail().habit.id,
          color: DataHabitCreation().indexColor,
          icon: DataHabitCreation().icon,
          habit: habitController.text,
          cue: DataHabitDetail().habit.cue,
          score: DataHabitDetail().habit.score,
          daysDone: DataHabitDetail().habit.daysDone,
          initialDate: DataHabitDetail().habit.initialDate);

      Loading.showLoading(context);

      if (editedHabit.icon != DataHabitDetail().habit.icon ||
          editedHabit.color != DataHabitDetail().habit.color ||
          editedHabit.habit.compareTo(DataHabitDetail().habit.habit) == 0) {
        await DataControl().updateHabit(editedHabit);
      }

      if (!compareFrequency(DataHabitDetail().frequency, DataHabitCreation().frequency)) {
        await DataControl()
            .updateFrequency(editedHabit.id, DataHabitCreation().frequency, DataHabitDetail().frequency.runtimeType);
      }

      if (!compareReminders(DataHabitDetail().reminders, DataHabitCreation().reminders)) {
        await DataControl().deleteReminders(DataHabitDetail().habit.id, DataHabitDetail().reminders);
        await DataControl().addReminders(editedHabit, DataHabitCreation().reminders);
      }

      Loading.closeLoading(context);

      DataHabitDetail().habit = editedHabit;
      DataHabitDetail().frequency = DataHabitCreation().frequency;
      DataHabitDetail().reminders = DataHabitCreation().reminders;
      Navigator.of(context).pop();
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
              margin: EdgeInsets.only(top: 40),
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
                                      DataControl().deleteHabit(DataHabitDetail().habit.id, DataHabitDetail().habit.score).then((status) {
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
              margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 30),
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
