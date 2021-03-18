import 'package:altitude/common/view/ReminderDay.dart';
import 'package:altitude/common/view/generic/BottomSheetLine.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/habitDetails/enums/ReminderType.dart';
import 'package:altitude/feature/habitDetails/logic/EditAlarmLogic.dart';
import 'package:altitude/feature/habitDetails/model/ReminderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class EditAlarmDialog extends StatefulWidget {
  const EditAlarmDialog();

  @override
  _EditAlarmDialogState createState() => _EditAlarmDialogState();
}

class _EditAlarmDialogState extends BaseState<EditAlarmDialog> {
  EditAlarmLogic controller = GetIt.I.get<EditAlarmLogic>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<EditAlarmLogic>();
    super.dispose();
  }

  void switchReminderType(ReminderType type) {
    if (type == ReminderType.CUE && controller.habitDetailsLogic.habit.data.oldCue == "") {
      showToast("Adicione o gatilho primeiro");
      return;
    }
    controller.switchReminderType(type);
  }

  void reminderTimeClick() {
    showTimePicker(
      initialTime: controller.reminderTime,
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
            data: ThemeData.light().copyWith(
              accentColor: controller.habitColor,
              primaryColor: controller.habitColor,
            ),
            child: child);
      },
    ).then(controller.updateReminderTime);
  }

  void save() {
    if (!controller.reminderWeekdaySelection.any((item) => item.state)) {
      showToast("Selecione pelo menos um dia");
    } else {
      showLoading(true);
      controller.saveReminders().then((_) {
        showToast("Alarme salvo");
        showLoading(false);
      }).catchError(handleError);
    }
  }

  void remove() {
    showLoading(true);
    controller.removeReminders().then((_) {
      showLoading(false);
      showToast("Alarme removido");
    }).catchError(handleError);
  }

  Widget _reminderCard(bool isSelected, ReminderCard item) => Expanded(
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          elevation: 4,
          color: isSelected ? controller.habitColor : Colors.white,
          child: SizedBox(
            height: 60,
            child: InkWell(
              onTap: () => switchReminderType(item.type),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: isSelected ? true : false,
                      groupValue: true,
                      activeColor: Colors.white,
                      onChanged: (state) => switchReminderType(item.type),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: <Widget>[
          const BottomSheetLine(),
          Container(
            margin: const EdgeInsets.only(top: 18),
            height: 30,
            child: Text("Alarme",
                style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold, color: controller.habitColor)),
          ),
          const Spacer(flex: 1),
          const Padding(
            padding: const EdgeInsets.all(8),
            child: const Text("Você deseja ser lembrado do hábito ou do gatilho?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
          ),
          Observer(
            builder: (_) {
              return Row(
                  children: controller.reminderCards
                      .map((item) => _reminderCard(controller.cardTypeSelected == item.type, item))
                      .toList());
            },
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Selecione os dias e o horário que deseja ser lembrado:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
          ),
          Observer(
            builder: (_) {
              return Row(
                children: controller.reminderWeekdaySelection
                    .map((item) => ReminderDay(
                        day: item.title,
                        state: item.state,
                        color: controller.habitColor,
                        onTap: () => controller.reminderWeekdayClick(item.id, !item.state)))
                    .toList(),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: InkWell(
              onTap: reminderTimeClick,
              child: Observer(
                builder: (_) {
                  return RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Montserrat"),
                      children: <TextSpan>[
                        TextSpan(
                            text: controller.timeText, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const TextSpan(text: " hrs"),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(flex: 3),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                controller.reminder != null && controller.reminder.hasAnyDay()
                    ? TextButton(
                        onPressed: remove,
                        child: const Text("Remover", style: TextStyle(fontSize: 16, color: Colors.black)),
                      )
                    : const SizedBox(),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(controller.habitColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                      overlayColor: MaterialStateProperty.all(Colors.white24),
                      elevation: MaterialStateProperty.all(2)),
                  onPressed: save,
                  child: const Text("SALVAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
