import 'package:altitude/core/bloc/BlocProvider.dart';
import 'package:altitude/core/bloc/BlocWidget.dart';
import 'package:altitude/core/model/Pair.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/ui/habitDetails/blocs/EditAlarmBloc.dart';
import 'package:altitude/ui/habitDetails/enums/ReminderType.dart';
import 'package:altitude/ui/habitDetails/model/ReminderCard.dart';
import 'package:altitude/ui/widgets/generic/BottomSheetLine.dart';
import 'package:flutter/material.dart';

class EditAlarmDialog extends BlocWidget<EditAlarmBloc> {
  static StatefulWidget instance(Habit habit, Function(int) callback) {
    return BlocProvider<EditAlarmBloc>(
      blocCreator: () => EditAlarmBloc(habit, callback),
      widget: EditAlarmDialog(),
    );
  }

  Widget _reminderCard(EditAlarmBloc bloc, bool isSelected, ReminderCard item) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        elevation: 4,
        color: isSelected ? bloc.habitColor : Colors.white,
        child: SizedBox(
          height: 60,
          child: InkWell(
            onTap: () => bloc.switchReminderType(item.type),
              // if (errorMessage != null) {
              //   showToast(errorMessage);
              // } else {
              //   setState(() {
              //     _reminderType = index;
              //   });
              // }
            // },
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
  }

  // List<Widget> _weekdayListWidget() {
  //   List<Widget> widgets = List();

  //   for (int i = 0; i < 7; i++) {
  //     widgets.add(Expanded(
  //       child: Container(
  //         padding: const EdgeInsets.all(4),
  //         decoration:
  //             BoxDecoration(shape: BoxShape.circle, color: _weekdayStatus[i] ? bloc.habitColor : Colors.transparent),
  //         child: InkWell(
  //           onTap: () {
  //             setState(() {
  //               _weekdayStatus[i] = !_weekdayStatus[i];
  //             });
  //           },
  //           child: Text(
  //             _weekdayText[i],
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 18, color: _weekdayStatus[i] ? Colors.white : Colors.black),
  //           ),
  //         ),
  //       ),
  //     ));
  //   }

  //   return widgets;
  // }

  @override
  Widget build(BuildContext context, EditAlarmBloc bloc) {
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
              initialData: ReminderType.CUE,
              stream: bloc.reminderCardTypeSelectedStream,
              builder: (context, snapshot) {
                return Row(
                  children:
                      bloc.reminderCards.map((item) => _reminderCard(bloc, snapshot.data == item.type, item)).toList(),
                );
                // children: <Widget>[
                //   _reminderIndexCard(0, "Lembrar do hábito"),
                //   SizedBox(width: 8),
                //   _reminderIndexCard(1, "Lembrar do gatilho",
                //       errorMessage: DataHabitDetail().habit.cue == null ? "Adicione o gatilho primeiro" : null),
                // ],
              }),

          // SizedBox(
          //   height: 32,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Text(
          //     "Selecione os dias e o horário que deseja ser lembrado:",
          //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          //   ),
          // ),
          // Row(
          //   children: _weekdayListWidget(),
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: 24),
          //   child: InkWell(
          //     onTap: () {
          //       showTimePicker(
          //         initialTime: _temporaryTime == null ? TimeOfDay.now() : _temporaryTime,
          //         context: context,
          //         builder: (BuildContext context, Widget child) {
          //           return Theme(
          //               data: ThemeData.light().copyWith(
          //                 accentColor: bloc.habitColor,
          //                 primaryColor: bloc.habitColor,
          //               ),
          //               child: child);
          //         },
          //       ).then((time) {
          //         if (time != null) {
          //           setState(() {
          //             _temporaryTime = time;
          //           });
          //         }
          //       });
          //     },
          //     child: RichText(
          //       text: TextSpan(
          //         style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Montserrat"),
          //         children: <TextSpan>[
          //           TextSpan(
          //               text: _temporaryTime == null
          //                   ? "-- : --"
          //                   : _temporaryTime.hour.toString().padLeft(2, '0') +
          //                       ":" +
          //                       _temporaryTime.minute.toString().padLeft(2, '0'),
          //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          //           TextSpan(text: " hrs"),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Spacer(
          //   flex: 3,
          // ),
          // Container(
          //   margin: const EdgeInsets.only(bottom: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       DataHabitDetail().reminders.length != 0
          //           ? FlatButton(
          //               onPressed: bloc.remove,
          //               child: Text(
          //                 "Remover",
          //                 style: TextStyle(fontSize: 16),
          //               ),
          //             )
          //           : SizedBox(),
          //       RaisedButton(
          //         color: bloc.habitColor,
          //         shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //         elevation: 0,
          //         onPressed: bloc.save,
          //         child: const Text(
          //           "SALVAR",
          //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

// class _EditAlarmDialogState extends State<EditAlarmDialog> {
//   final List<String> _weekdayText = ["D", "S", "T", "Q", "Q", "S", "S"];

//   int _reminderType = 0;
//   List<bool> _weekdayStatus;
//   TimeOfDay _temporaryTime;

//   @override
//   initState() {
//     super.initState();
//     resetData();
//   }

//   @override
//   void didUpdateWidget(EditAlarmDialog oldWidget) {
//     resetData();
//     super.didUpdateWidget(oldWidget);
//   }

//   void resetData() {
//     _weekdayStatus = [false, false, false, false, false, false, false];

//     if (DataHabitDetail().reminders.length == 0) {
//       _reminderType = 0;
//       _temporaryTime = null;
//     } else {
//       _reminderType = DataHabitDetail().reminders[0].type;
//       _temporaryTime = new TimeOfDay(
//           hour: DataHabitDetail().reminders[0].hour,
//           minute: DataHabitDetail().reminders[0].minute);

//       for (Reminder reminder in DataHabitDetail().reminders) {
//         _weekdayStatus[reminder.weekday - 1] = true;
//       }
//     }
//   }

//   void _save() async {
//     if (_temporaryTime == null) {
//       showToast("Selecione um horário");
//     } else if (!_weekdayStatus.contains(true)) {
//       showToast("Selecione pelo menos um dia");
//     } else {
//       Loading.showLoading(context);
//       if (DataHabitDetail().reminders.length != 0) {
//         await HabitsControl().deleteReminders(
//             DataHabitDetail().habit.id, DataHabitDetail().reminders);
//       }

//       List<Reminder> reminders = new List();
//       String days = "";
//       for (int i = 0; i < 7; i++) {
//         if (_weekdayStatus[i]) {
//           reminders.add(new Reminder(
//               habitId: DataHabitDetail().habit.id,
//               hour: _temporaryTime.hour,
//               minute: _temporaryTime.minute,
//               weekday: i + 1,
//               type: _reminderType));
//           days += _weekdayText[i];
//         } else {
//           days += "-";
//         }
//       }

//       DataHabitDetail().reminders =
//           await HabitsControl().addReminders(DataHabitDetail().habit, reminders);

//       FireAnalytics().sendSetAlarm(DataHabitDetail().habit.habit, _reminderType,
//           _temporaryTime.hour, _temporaryTime.minute, days);
//       showToast("Alarme salvo");
//       Loading.closeLoading(context);
//       widget.closeBottomSheet();
//     }
//   }

//   void _remove() {
//     Loading.showLoading(context);
//     HabitsControl()
//         .deleteReminders(
//             DataHabitDetail().habit.id, DataHabitDetail().reminders)
//         .then((status) {
//       Loading.closeLoading(context);
//       DataHabitDetail().reminders = new List();

//       FireAnalytics().sendRemoveAlarm(DataHabitDetail().habit.habit);
//       showToast("Alarme removido");
//       widget.closeBottomSheet();
//     });
//   }

//

//

//
