import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show Color;
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'EditHabitLogic.g.dart';

class EditHabitLogic = _EditHabitLogicBase with _$EditHabitLogic;

abstract class _EditHabitLogicBase with Store {
  Habit initialHabit;
  Frequency initialFrequency;
  List<Reminder> initialReminders;

  @observable
  int color;

  @observable
  Frequency frequency;

  @computed
  Color get habitColor => AppColors.habitsColor[color];

  void setData(Habit habit, Frequency frequency, List<Reminder> reminders) {
    initialHabit = habit;
    initialFrequency = frequency;
    this.frequency = frequency;
    initialReminders = reminders;
  }

  @action
  void selectColor(int index) {
    color = index;
  }

  @action
  void selectFrequency(Frequency value) {
    frequency = value;
  }

  Future<void> removeHabit() async {
    return await HabitsControl().deleteHabit(initialHabit.id, initialHabit.habit, initialHabit.score, initialReminders);
  }

  Future<void> updateHabit(String habit) async {
    Habit editedHabit = Habit(id: initialHabit.id, color: color, habit: habit);

    if (editedHabit.color != initialHabit.color || editedHabit.habit.compareTo(initialHabit.habit) != 0) {
      await HabitsControl().updateHabit(editedHabit, initialHabit, initialReminders);
    }

    if (!compareFrequency(initialFrequency, frequency)) {
      await HabitsControl().updateFrequency(editedHabit.id, frequency, initialFrequency.runtimeType);
    }

    GetIt.I.get<HabitDetailsLogic>().updateHabitDetailsPageData(color, habit, frequency);
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
