import 'package:flutter/material.dart';
import 'package:habit/model/Reminder.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/services/FireAnalytics.dart';

class EditAlarmDialog extends StatefulWidget {
  EditAlarmDialog({Key key, @required this.closeBottomSheet}) : super(key: key);

  final Function closeBottomSheet;

  @override
  _EditAlarmDialogState createState() => new _EditAlarmDialogState();
}

class _EditAlarmDialogState extends State<EditAlarmDialog> {
  final List<String> _weekdayText = ["D", "S", "T", "Q", "Q", "S", "S"];

  int _reminderType = 0;
  List<bool> _weekdayStatus;
  TimeOfDay _temporaryTime;

  @override
  initState() {
    super.initState();
    resetData();
  }

  @override
  void didUpdateWidget(EditAlarmDialog oldWidget) {
    resetData();
    super.didUpdateWidget(oldWidget);
  }

  void resetData() {
    _weekdayStatus = [false, false, false, false, false, false, false];

    if (DataHabitDetail().reminders.length == 0) {
      _reminderType = 0;
      _temporaryTime = null;
    } else {
      _reminderType = DataHabitDetail().reminders[0].type;
      _temporaryTime = new TimeOfDay(
          hour: DataHabitDetail().reminders[0].hour,
          minute: DataHabitDetail().reminders[0].minute);

      for (Reminder reminder in DataHabitDetail().reminders) {
        _weekdayStatus[reminder.weekday - 1] = true;
      }
    }
  }

  void _save() async {
    if (_temporaryTime == null) {
      showToast("Selecione um horário");
    } else if (!_weekdayStatus.contains(true)) {
      showToast("Selecione pelo menos um dia");
    } else {
      Loading.showLoading(context);
      if (DataHabitDetail().reminders.length != 0) {
        await HabitsControl().deleteReminders(
            DataHabitDetail().habit.id, DataHabitDetail().reminders);
      }

      List<Reminder> reminders = new List();
      String days = "";
      for (int i = 0; i < 7; i++) {
        if (_weekdayStatus[i]) {
          reminders.add(new Reminder(
              habitId: DataHabitDetail().habit.id,
              hour: _temporaryTime.hour,
              minute: _temporaryTime.minute,
              weekday: i + 1,
              type: _reminderType));
          days += _weekdayText[i];
        } else {
          days += "-";
        }
      }

      DataHabitDetail().reminders =
          await HabitsControl().addReminders(DataHabitDetail().habit, reminders);

      FireAnalytics().sendSetAlarm(DataHabitDetail().habit.habit, _reminderType,
          _temporaryTime.hour, _temporaryTime.minute, days);
      showToast("Alarme salvo");
      Loading.closeLoading(context);
      widget.closeBottomSheet();
    }
  }

  void _remove() {
    Loading.showLoading(context);
    HabitsControl()
        .deleteReminders(
            DataHabitDetail().habit.id, DataHabitDetail().reminders)
        .then((status) {
      Loading.closeLoading(context);
      DataHabitDetail().reminders = new List();

      FireAnalytics().sendRemoveAlarm(DataHabitDetail().habit.habit);
      showToast("Alarme removido");
      widget.closeBottomSheet();
    });
  }

  Widget _reminderIndexCard(int index, String text, {String errorMessage}) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 4,
        color: _reminderType == index
            ? DataHabitDetail().getColor()
            : Colors.white,
        child: SizedBox(
          height: 60,
          child: InkWell(
            onTap: () {
              if (errorMessage != null) {
                showToast(errorMessage);
              } else {
                setState(() {
                  _reminderType = index;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Radio(
                    value: _reminderType == index ? true : false,
                    groupValue: true,
                    activeColor: Colors.white,
                    onChanged: (state) {},
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: _reminderType == index
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _weekdayListWidget() {
    List<Widget> widgets = new List();

    for (int i = 0; i < 7; i++) {
      widgets.add(Expanded(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _weekdayStatus[i]
                  ? DataHabitDetail().getColor()
                  : Colors.transparent),
          child: InkWell(
            onTap: () {
              setState(() {
                _weekdayStatus[i] = !_weekdayStatus[i];
              });
            },
            child: Text(
              _weekdayText[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: _weekdayStatus[i] ? Colors.white : Colors.black),
            ),
          ),
        ),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            height: 30,
            child: Text(
              "Alarme",
              style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                  color: DataHabitDetail().getColor()),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Você deseja ser lembrado do hábito ou do gatilho?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ),
          Row(
            children: <Widget>[
              _reminderIndexCard(0, "Lembrar do hábito"),
              SizedBox(width: 8),
              _reminderIndexCard(1, "Lembrar do gatilho",
                  errorMessage: DataHabitDetail().habit.cue == null
                      ? "Adicione o gatilho primeiro"
                      : null),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Selecione os dias e o horário que deseja ser lembrado:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ),
          Row(
            children: _weekdayListWidget(),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: InkWell(
              onTap: () {
                showTimePicker(
                  initialTime:
                      _temporaryTime == null ? TimeOfDay.now() : _temporaryTime,
                  context: context,
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                        data: ThemeData.light().copyWith(
                          accentColor: DataHabitDetail().getColor(),
                          primaryColor: DataHabitDetail().getColor(),
                        ),
                        child: child);
                  },
                ).then((time) {
                  if (time != null) {
                    setState(() {
                      _temporaryTime = time;
                    });
                  }
                });
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Montserrat"),
                  children: <TextSpan>[
                    TextSpan(
                        text: _temporaryTime == null
                            ? "-- : --"
                            : _temporaryTime.hour.toString().padLeft(2, '0') +
                                ":" +
                                _temporaryTime.minute
                                    .toString()
                                    .padLeft(2, '0'),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    TextSpan(text: " hrs"),
                  ],
                ),
              ),
            ),
          ),
          Spacer(
            flex: 3,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DataHabitDetail().reminders.length != 0
                    ? FlatButton(
                        onPressed: _remove,
                        child: Text(
                          "Remover",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : SizedBox(),
                RaisedButton(
                  color: DataHabitDetail().getColor(),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  elevation: 0,
                  onPressed: _save,
                  child: const Text(
                    "SALVAR",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
