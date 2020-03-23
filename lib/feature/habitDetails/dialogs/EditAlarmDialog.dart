import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/view/generic/BottomSheetLine.dart';
import 'package:altitude/feature/habitDetails/blocs/EditAlarmBloc.dart';
import 'package:altitude/feature/habitDetails/enums/ReminderType.dart';
import 'package:altitude/feature/habitDetails/model/ReminderCard.dart';
import 'package:altitude/feature/habitDetails/model/ReminderWeekday.dart';
import 'package:flutter/material.dart';

class EditAlarmDialog extends StatefulWidget {
  EditAlarmDialog(this.habit, this.reminders, this.callback);

  final Habit habit;
  final List<Reminder> reminders;
  final Function(List<Reminder>) callback;

  @override
  _EditAlarmDialogState createState() => _EditAlarmDialogState();
}

class _EditAlarmDialogState extends State<EditAlarmDialog> {
  EditAlarmBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = EditAlarmBloc(widget.habit, widget.reminders, widget.callback);
  }

  Widget _reminderCard(bool isSelected, ReminderCard item) => Expanded(
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          elevation: 4,
          color: isSelected ? bloc.habitColor : Colors.white,
          child: SizedBox(
            height: 60,
            child: InkWell(
              onTap: () => bloc.switchReminderType(item.type),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: isSelected ? true : false,
                      groupValue: true,
                      activeColor: Colors.white,
                      onChanged: (state) => bloc.switchReminderType(item.type),
                    ),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _reminderWeekday(ReminderWeekday item) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(shape: BoxShape.circle, color: item.state ? bloc.habitColor : Colors.transparent),
          child: InkWell(
            onTap: () => bloc.reminderWeekdayClick(item.id, !item.state),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: item.state ? Colors.white : Colors.black),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: <Widget>[
          BottomSheetLine(),
          Container(
            margin: const EdgeInsets.only(top: 18),
            height: 30,
            child: Text(
              "Alarme",
              style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold, color: bloc.habitColor),
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
          StreamBuilder<ReminderType>(
            initialData: bloc.currentTypeSelected,
            stream: bloc.reminderCardTypeSelectedStream,
            builder: (context, snapshot) {
              return Row(
                children: bloc.reminderCards.map((item) => _reminderCard(snapshot.data == item.type, item)).toList(),
              );
            },
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
          StreamBuilder<List<ReminderWeekday>>(
            initialData: bloc.reminderWeekdays,
            stream: bloc.reminderWeekdaySelectionStream,
            builder: (context, snapshot) {
              return Row(
                children: snapshot.data.map((item) => _reminderWeekday(item)).toList(),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: InkWell(
              onTap: () => bloc.reminderTimeClick(context),
              child: StreamBuilder<TimeOfDay>(
                initialData: bloc.reminderTime,
                stream: bloc.reminderTimeStream,
                builder: (context, snapshot) {
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Montserrat"),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "${snapshot.data.hour.toString().padLeft(2, '0')} : ${snapshot.data.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        TextSpan(text: " hrs"),
                      ],
                    ),
                  );
                },
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
                bloc.reminders.length != 0
                    ? FlatButton(
                        onPressed: () => bloc.remove(context),
                        child: Text(
                          "Remover",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : SizedBox(),
                RaisedButton(
                  color: bloc.habitColor,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  elevation: 0,
                  onPressed: () => bloc.save(context),
                  child: const Text(
                    "SALVAR",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
