import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart';
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/model/failure.dart';
import 'package:altitude/feature/habits/domain/usecases/get_calendar_days_done_usecase.dart';
import 'package:altitude/feature/habits/domain/usecases/has_competition_by_habit_usecase.dart';
import 'package:flutter/material.dart' show Color;
import 'package:mobx/mobx.dart';
part 'habit_details_controller.g.dart';

class HabitDetailsController = _HabitDetailsControllerBase
    with _$HabitDetailsController;

abstract class _HabitDetailsControllerBase with Store {
  final CompleteHabitUsecase _completeHabitUsecase;
  final GetHabitUsecase _getHabitUsecase;
  final HasCompetitionByHabitUsecase _hasCompetitionByHabitUsecase;
  final GetCalendarDaysDoneUsecase _getCalendarDaysDoneUsecase;

  _HabitDetailsControllerBase(this._completeHabitUsecase, this._getHabitUsecase,
      this._hasCompetitionByHabitUsecase, this._getCalendarDaysDoneUsecase);

  String? _id;
  int? _color;

  Color get habitColor => AppColors.habitsColor[_color!];

  DataState<Habit?> habit = DataState();
  DataState<Frequency?> frequency = DataState();
  DataState<Reminder?> reminders = DataState();
  DataState<ObservableMap<DateTime, List<bool>>> calendarMonth = DataState();
  DataState<bool> isHabitDone = DataState();
  DataState<double> rocketForce = DataState();

  Map<DateTime?, List> currentMonth = Map();

  void fetchData(String? habitId, int? color) async {
    _id = habitId;
    _color = color;

    await getHabitDetail();

    DateTime today = DateTime.now().onlyDate;
    (await _getCalendarDaysDoneUsecase.call(GetCalendarDaysDoneParams(
            id: _id ?? "", month: today.month, year: today.year)))
        .result((data) {
      currentMonth = data;
      calendarMonth.setSuccessState(data.asObservable());
      isHabitDone.setSuccessState(data.containsKey(DateTime.now().onlyDate));
      calculateRocketForce();
    }, (error) {
      calendarMonth.setErrorState(error);
    });
  }

  Future<void> getHabitDetail() async {
    (await _getHabitUsecase.call(_id!)).result((data) {
      habit.setSuccessState(data);
      frequency.setSuccessState(data.frequency);
      reminders.setSuccessState(data.reminder);
    }, (error) {
      habit.setErrorState(error);
      frequency.setErrorState(error);
      reminders.setErrorState(error);
    });
  }

  void calculateRocketForce() {
    try {
      double force;
      int timesDays = habit.data!.frequency!.daysCount()!;
      List<DateTime?> dates = currentMonth.keys
          .toList()
          .where((e) => e!.isAfterOrSameDay(
              DateTime.now().onlyDate.subtract(Duration(days: CYCLE_DAYS))))
          .toList();

      int daysDoneLastCycle = dates.length;

      force = daysDoneLastCycle / timesDays;

      if (force > 1.3) force = 1.3;
      rocketForce.setSuccessState(force);
    } catch (error) {
      rocketForce.setErrorState(Failure.genericFailure(error));
    }
  }

  void calendarMonthSwipe(DateTime focusedDay) async {
    calendarMonth.setLoadingState();
    (await _getCalendarDaysDoneUsecase.call(GetCalendarDaysDoneParams(
            id: _id ?? "", month: focusedDay.month, year: focusedDay.year)))
        .result((data) {
      calendarMonth.setSuccessState(data.asObservable());
    }, (error) {
      calendarMonth.setErrorState(error);
    });
  }

  Future<void> setDoneHabit(
      bool add, DateTime date, DonePageType donePageType) async {
    calendarMonth.setLoadingState();
    isHabitDone.setLoadingState();

    int weekDay = date.weekday == 7 ? 0 : date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekDay));
    DateTime endDate = date.lastWeekDay();

    var days = calendarMonth.data!.keys
        .where((e) =>
            e.isAfterOrSameDay(startDate) && e.isBeforeOrSameDay(endDate))
        .toList();

    return (await _completeHabitUsecase
        .call(CompleteParams(
            habitId: _id ?? "",
            date: DateTime(date.year, date.month, date.day),
            isAdd: add,
            daysDone: days))
        .resultComplete((data) {
      Map<DateTime, List<bool>> visibleMonthDays = calendarMonth.data!;

      bool yesterday =
          visibleMonthDays.containsKey(date.subtract(Duration(days: 1)));
      bool tomorrow = visibleMonthDays.containsKey(date.add(Duration(days: 1)));

      if (!add) {
        // Remover dia
        visibleMonthDays.remove(date);
        if (yesterday) {
          visibleMonthDays.update(
              date.subtract(Duration(days: 1)), (old) => [old[0], false]);
        }

        if (tomorrow) {
          visibleMonthDays.update(
              date.add(Duration(days: 1)), (old) => [false, old[1]]);
        }
      } else {
        // Adicionar dia
        visibleMonthDays.putIfAbsent(date, () => [yesterday, tomorrow]);
        if (yesterday) {
          visibleMonthDays.update(
              date.subtract(Duration(days: 1)), (old) => [old[0], true]);
        }

        if (tomorrow) {
          visibleMonthDays.update(
              date.add(Duration(days: 1)), (old) => [true, old[1]]);
        }
      }

      if (date
          .isAfter(DateTime.now().subtract(Duration(days: CYCLE_DAYS + 1)))) {
        currentMonth = visibleMonthDays;
        calculateRocketForce();
      }

      calendarMonth.setSuccessState(visibleMonthDays.asObservable());
      getHabitDetail();
      if (date.isAtSameMomentAs(DateTime.now().onlyDate)) {
        isHabitDone.setSuccessState(add);
      } else {
        isHabitDone.setSuccessState(isHabitDone.data!);
      }
      return;
    }, (error) {
      calendarMonth.setSuccessState(calendarMonth.data!);
      isHabitDone.setSuccessState(isHabitDone.data!);
      throw error;
    }));
  }

  void editCueCallback(String? cue) {
    Habit? newHabit = habit.data;
    if (cue == null) {
      newHabit!.oldCue = "";
    } else {
      newHabit!.oldCue = cue;
    }

    habit.setSuccessState(newHabit);
  }

  void editAlarmCallback(Reminder? newReminder) {
    reminders.setSuccessState(newReminder);
    habit.data!.reminder = newReminder;
  }

  void updateHabitDetailsPageData(Habit newHabit) {
    _color = newHabit.colorCode;
    getHabitDetail();
  }

  Future<bool> hasCompetition() {
    return _hasCompetitionByHabitUsecase
        .call(_id!)
        .resultComplete((data) => data, (error) => false);
  }
}
