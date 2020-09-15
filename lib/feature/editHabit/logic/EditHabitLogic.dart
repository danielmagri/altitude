import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show Color;
import 'package:mobx/mobx.dart';
part 'EditHabitLogic.g.dart';

class EditHabitLogic = _EditHabitLogicBase with _$EditHabitLogic;

abstract class _EditHabitLogicBase with Store {
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;

  Habit initialHabit;

  @observable
  int color;

  @observable
  Frequency frequency;

  @computed
  Color get habitColor => AppColors.habitsColor[color];

  void setData(Habit habit) {
    initialHabit = habit;
    this.frequency = habit.frequency;
  }

  @action
  void selectColor(int index) {
    color = index;
  }

  @action
  void selectFrequency(Frequency value) {
    frequency = value;
  }

  Future<Result<void>> removeHabit() {
    return _habitUseCase.deleteHabit(initialHabit);
  }

  Future<void> updateHabit(String habit) async {
    // Habit editedHabit = Habit(id: initialHabit.id, colorCode: color, habit: habit);

    // if (editedHabit.color != initialHabit.color || editedHabit.habit.compareTo(initialHabit.habit) != 0) {
    //   await HabitsControl().updateHabit(editedHabit, initialHabit, initialReminders);
    // }

    // if (!compareFrequency(initialFrequency, frequency)) {
    //   await HabitsControl().updateFrequency(editedHabit.oldId, frequency, initialFrequency.runtimeType);
    // }

    // GetIt.I.get<HabitDetailsLogic>().updateHabitDetailsPageData(color, habit, frequency);
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
