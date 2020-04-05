import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/datas/dataHabitCreation.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show Color;
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'EditHabitLogic.g.dart';

class EditHabitLogic = _EditHabitLogicBase with _$EditHabitLogic;

abstract class _EditHabitLogicBase with Store {
  Habit _habit;
  Frequency _frequency;
  List<Reminder> _reminders;

  @computed
  Color get habitColor => AppColors.habitsColor[color];

  @observable
  int color;

  void setData(Habit habit, Frequency frequency, List<Reminder> reminders) {
    _habit = habit;
    _frequency = frequency;
    _reminders = reminders;
  }

  @action
  void switchColor(int index) {
    color = index;
  }

  Future<void> removeHabit() async {
    return await HabitsControl().deleteHabit(_habit.id, _habit.habit, _habit.score, _reminders);
  }

  Future<void> updateHabit(String habit) async {
    Habit editedHabit = Habit(id: _habit.id, color: color, habit: habit);

    if (editedHabit.color != _habit.color || editedHabit.habit.compareTo(_habit.habit) != 0) {
      await HabitsControl().updateHabit(editedHabit, _habit, _reminders);
    }

    if (!compareFrequency(_frequency, DataHabitCreation().frequency)) {
      await HabitsControl().updateFrequency(editedHabit.id, DataHabitCreation().frequency, _frequency.runtimeType);
    }

    GetIt.I.get<HabitDetailsLogic>().updateHabitDetailsPageData(color, habit, DataHabitCreation().frequency);
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
