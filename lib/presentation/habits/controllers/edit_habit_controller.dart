import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/model/result.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/usecases/habits/delete_habit_usecase.dart';
import 'package:altitude/domain/usecases/habits/update_habit_usecase.dart';
import 'package:altitude/presentation/habits/controllers/habit_details_controller.dart';
import 'package:flutter/material.dart' show Color;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'edit_habit_controller.g.dart';

@lazySingleton
class EditHabitController = _EditHabitControllerBase with _$EditHabitController;

abstract class _EditHabitControllerBase with Store {
  _EditHabitControllerBase(this._updateHabitUsecase, this._deleteHabitUsecase);

  final UpdateHabitUsecase _updateHabitUsecase;
  final DeleteHabitUsecase _deleteHabitUsecase;

  late Habit initialHabit;

  @observable
  int? color;

  @observable
  Frequency? frequency;

  @computed
  Color get habitColor => AppColors.habitsColor[color!];

  void setData(Habit habit) {
    initialHabit = habit;
    frequency = habit.frequency;
    color = habit.colorCode;
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
    return _deleteHabitUsecase.call(initialHabit);
  }

  Future updateHabit(String habit) async {
    Habit editedHabit = Habit(
      id: initialHabit.id,
      habit: habit,
      colorCode: color!,
      score: initialHabit.score,
      oldCue: initialHabit.oldCue,
      frequency: frequency!,
      reminder: initialHabit.reminder,
      lastDone: initialHabit.lastDone,
      initialDate: initialHabit.initialDate,
      daysDone: initialHabit.daysDone,
    );

    if (editedHabit.color != initialHabit.color ||
        editedHabit.habit.compareTo(initialHabit.habit) != 0 ||
        !compareFrequency(initialHabit.frequency, frequency)) {
      (await _updateHabitUsecase.call(
        UpdateHabitParams(
          habit: editedHabit,
          inititalHabit: initialHabit,
        ),
      ))
          .result(
        (data) {
          GetIt.I
              .get<HabitDetailsController>()
              .updateHabitDetailsPageData(editedHabit);
        },
        (error) => throw error,
      );
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
