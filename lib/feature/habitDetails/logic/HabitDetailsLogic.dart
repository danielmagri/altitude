import 'package:altitude/common/Constants.dart';
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/services/FireAnalytics.dart';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/utils/Color.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:flutter/material.dart' show Color;
import 'package:mobx/mobx.dart';
import 'package:table_calendar/table_calendar.dart' show CalendarFormat;
part 'HabitDetailsLogic.g.dart';

class HabitDetailsLogic = _HabitDetailsLogicBase with _$HabitDetailsLogic;

abstract class _HabitDetailsLogicBase with Store {
  int _id;
  int _color;

  Color get habitColor => AppColors.habitsColor[_color];

  DataState<Habit> habit = DataState();
  DataState<Frequency> frequency = DataState();
  DataState<ObservableList<String>> competitions = DataState();
  DataState<ObservableList<Reminder>> reminders = DataState();
  DataState<ObservableMap<DateTime, List>> calendarMonth = DataState();
  DataState<bool> isHabitDone = DataState();
  DataState<double> rocketForce = DataState();

  @observable
  BottomSheetType panelType = BottomSheetType.NONE;

  void fetchData(int habitId, int color) async {
    _id = habitId;
    _color = color;

    try {
      var _habit = await HabitsControl().getHabit(_id);
      var _frequency = await HabitsControl().getFrequency(_id);
      var _reminders = (await HabitsControl().getReminders(_id)).asObservable();
      var _competitions = (await CompetitionsControl().listCompetitionsIds(_id)).asObservable();
      var _calendarMonth = (await HabitsControl().getDaysDone(_id,
              startDate: DateTime.now().lastDayOfPreviousMonth().subtract(Duration(days: 6)),
              endDate: DateTime.now().today.add(Duration(days: 7))))
          .asObservable();

      habit.setData(_habit);
      frequency.setData(_frequency);
      competitions.setData(_competitions);
      reminders.setData(_reminders);
      calendarMonth.setData(_calendarMonth);
      isHabitDone.setData(_calendarMonth.containsKey(DateTime.now().today));
      calculateRocketForce();
    } catch (error) {
      habit.setError(error);
      frequency.setError(error);
      competitions.setError(error);
      reminders.setError(error);
    }
  }

  void calculateRocketForce() async {
    try {
      double force;
      int timesDays = frequency.data.daysCount();
      List<DateTime> dates = (await HabitsControl().getDaysDone(_id,
              startDate: DateTime.now().today.subtract(Duration(days: CYCLE_DAYS)), endDate: DateTime.now().today))
          .keys
          .toList();

      int daysDoneLastCycle = dates.length;

      force = daysDoneLastCycle / timesDays;

      if (force > 1.3) force = 1.3;
      rocketForce.setData(force);
    } catch (error) {
      rocketForce.setError(error);
    }
  }

  @action
  void switchPanelType(BottomSheetType type) {
    if (type == BottomSheetType.CUE) FireAnalytics().sendReadCue();
    panelType = type;
  }

  void calendarMonthSwipe(DateTime start, DateTime end, CalendarFormat format) {
    calendarMonth.setLoading();
    HabitsControl()
        .getDaysDone(_id, startDate: start.subtract(Duration(days: 1)), endDate: end.add(Duration(days: 1)))
        .then((map) {
      calendarMonth.setData(map.asObservable());
    });
  }

  Future<void> setDoneHabit(bool add, DateTime date, DonePageType donePageType) async {
    calendarMonth.setLoading();
    isHabitDone.setLoading();

    int earnedScore = await HabitsControl().setHabitDoneAndScore(date, _id, donePageType, add: add);

    Habit newHabit = habit.data;
    newHabit.score += earnedScore;
    if (add) {
      newHabit.daysDone++;
    } else {
      newHabit.daysDone--;
    }

    ObservableMap<DateTime, List> visibleMonthDays = calendarMonth.data;

    bool yesterday = visibleMonthDays.containsKey(date.subtract(Duration(days: 1)));
    bool tomorrow = visibleMonthDays.containsKey(date.add(Duration(days: 1)));

    if (!add) {
      // Remover dia
      visibleMonthDays?.remove(date);
      if (yesterday) {
        visibleMonthDays?.update(date.subtract(Duration(days: 1)), (old) => [old[0], false]);
      }

      if (tomorrow) {
        visibleMonthDays?.update(date.add(Duration(days: 1)), (old) => [false, old[1]]);
      }
    } else {
      // Adicionar dia
      visibleMonthDays?.putIfAbsent(date, () => [yesterday, tomorrow]);
      if (yesterday) {
        visibleMonthDays?.update(date.subtract(Duration(days: 1)), (old) => [old[0], true]);
      }

      if (tomorrow) {
        visibleMonthDays?.update(date.add(Duration(days: 1)), (old) => [true, old[1]]);
      }
    }

    if (date.isAfter(DateTime.now().subtract(Duration(days: CYCLE_DAYS + 1)))) {
      calculateRocketForce();
    }

    calendarMonth.setData(visibleMonthDays);
    habit.setData(newHabit);
    if (date.isAtSameMomentAs(DateTime.now().today)) {
      isHabitDone.setData(add);
    } else {
      isHabitDone.setLoading(loading: false);
    }
    return Future.value();
  }

  @action
  void editCueCallback(String cue) {
    Habit newHabit = habit.data;
    if (cue == null) {
      newHabit.cue = "";
    } else {
      newHabit.cue = cue;
    }

    habit.setData(newHabit);
    switchPanelType(BottomSheetType.NONE);
  }

  void editAlarmCallback(List<Reminder> newReminders) {
    // _reminders = newReminders;
    // _reminderButtonController.sink.add(newReminders.length);
    // closeBottomSheet();
  }
}
