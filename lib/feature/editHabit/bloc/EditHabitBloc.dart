import 'dart:async';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/datas/dataHabitCreation.dart';
import 'package:altitude/feature/dialogs/BaseDialog.dart';
import 'package:altitude/feature/habitDetails/page/HabitDetailsPage.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart'
    show BuildContext, Color, FlatButton, FontWeight, Text, TextEditingController, TextStyle, Widget, showDialog;
import 'package:keyboard_visibility/keyboard_visibility.dart';

class EditHabitBloc extends BlocBase {
  final Habit _habit;
  final Frequency _frequency;
  List<Reminder> _reminders;
  int color;

  Color get habitColor => AppColors.habitsColor[color];

  final keyboardVisibility = new KeyboardVisibilityNotification();
  final habitTextController = TextEditingController();

  // Color Widget
  StreamController<int> _colorWidgetStreamController = StreamController();
  Stream<int> get colorWidgetStream => _colorWidgetStreamController.stream;

  // Color
  StreamController<Color> _colorStreamController = StreamController.broadcast();
  Stream<Color> get colorStream => _colorStreamController.stream;

  EditHabitBloc(this._habit, this._frequency, this._reminders) {
    color = _habit.color;
    habitTextController.text = _habit.habit;
    DataHabitCreation().frequency = _frequency;
  }

  @override
  void dispose() {
    _colorWidgetStreamController.close();
    _colorStreamController.close();
    keyboardVisibility.dispose();
    habitTextController.dispose();
  }

  void switchColor(int index) {
    color = index;
    _colorWidgetStreamController.sink.add(index);
    _colorStreamController.sink.add(habitColor);
  }

  Future<bool> validateSafeRemoveHabit(BuildContext context) async {
    showLoading(context);
    var listCompetitions = await CompetitionsControl().listCompetitionsIds(_habit.id);
    hideLoading(context);
    if (listCompetitions.isEmpty) {
      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BaseDialog(
            title: "Opss",
            body: "É preciso sair das competições que esse hábito faz parte para poder deletá-lo.",
            action: <Widget>[
              new FlatButton(
                child: new Text(
                  "Ok",
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  navigatePop(context);
                },
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  void removeHabit(BuildContext context) async {
    if (await validateSafeRemoveHabit(context)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BaseDialog(
            title: "Deletar",
            body: "Você estava indo tão bem... Tem certeza que quer deletá-lo?",
            subBody: "(Todo o progresso dele será perdido e a quilômetragem perdida)",
            action: <Widget>[
              FlatButton(
                child: Text("SIM", style: TextStyle(fontSize: 17)),
                onPressed: () {
                  HabitsControl().deleteHabit(_habit.id, _habit.habit, _habit.score, _reminders).then((status) {
                    navigatePopUntil(context, (route) => route.isFirst);
                  });
                },
              ),
              FlatButton(
                child: Text("NÃO", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                onPressed: () {
                  navigatePop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void updateHabit(BuildContext context) async {
    if (ValidationHandler.habitTextValidate(habitTextController.text) != null) {
      showToast("O hábito precisa ser preenchido.");
    } else if (DataHabitCreation().frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      Habit editedHabit = Habit(id: _habit.id, color: color, habit: habitTextController.text);

      showLoading(context);

      if (editedHabit.color != _habit.color || editedHabit.habit.compareTo(_habit.habit) != 0) {
        await HabitsControl().updateHabit(editedHabit, _habit, _reminders);
      }

      if (!compareFrequency(_frequency, DataHabitCreation().frequency)) {
        await HabitsControl().updateFrequency(editedHabit.id, DataHabitCreation().frequency, _frequency.runtimeType);
      }

      hideLoading(context);
      navigatePop(context);
      navigatePushReplacement(context, HabitDetailsPage(_habit.id, color));
      showToast("O hábito foi editado!");
    }
  }

  bool compareFrequency(dynamic f1, dynamic f2) {
    if (f1.runtimeType == f2.runtimeType) {
      switch (f1.runtimeType) {
        case DayWeek:
          DayWeek dayweek1 = f1;
          DayWeek dayweek2 = f2;
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
        case Weekly:
          Weekly weekly1 = f1;
          Weekly weekly2 = f2;
          if (weekly1.daysTime == weekly2.daysTime) {
            return true;
          }
          return false;
      }
    }
    return false;
  }
}
