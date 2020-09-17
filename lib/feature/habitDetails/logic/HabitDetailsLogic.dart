import 'package:altitude/common/constant/Books.dart';
import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/Book.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/core/services/FireConfig.dart';
import 'package:altitude/feature/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/utils/Color.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:flutter/material.dart' show Color;
import 'package:mobx/mobx.dart';
import 'package:table_calendar/table_calendar.dart' show CalendarFormat;
part 'HabitDetailsLogic.g.dart';

class HabitDetailsLogic = _HabitDetailsLogicBase with _$HabitDetailsLogic;

abstract class _HabitDetailsLogicBase with Store {
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;
  final CompetitionUseCase _competitionUseCase = CompetitionUseCase.getInstance;

  String _id;
  int _color;

  Color get habitColor => AppColors.habitsColor[_color];

  DataState<Habit> habit = DataState();
  DataState<Frequency> frequency = DataState();
  DataState<Reminder> reminders = DataState();
  DataState<ObservableMap<DateTime, List>> calendarMonth = DataState();
  DataState<bool> isHabitDone = DataState();
  DataState<double> rocketForce = DataState();

  Map<DateTime, List> currentMonth = Map();

  @observable
  BottomSheetType panelType = BottomSheetType.NONE;

  Book get bookAdvertisement => books[FireConfig.instance.copyBook1];

  void fetchData(String habitId, int color) async {
    _id = habitId;
    _color = color;

    await getHabitDetail();

    DateTime today = DateTime.now().today;
    DateTime startDate = DateTime(today.year, today.month, 1).subtract(const Duration(days: 7));
    DateTime endDate = DateTime(today.year, today.month + 1, 1).add(const Duration(days: 6));
    (await _habitUseCase.getCalendarDaysDone(_id, startDate, endDate)).result((data) {
      currentMonth = data;
      calendarMonth.setData(data.asObservable());
      isHabitDone.setData(data.containsKey(DateTime.now().today));
      calculateRocketForce();
    }, (error) {
      calendarMonth.setError(error);
    });
  }

  Future<void> getHabitDetail() async {
    (await _habitUseCase.getHabit(_id)).result((data) {
      habit.setData(data);
      frequency.setData(data.frequency);
      reminders.setData(data.reminder);
    }, (error) {
      habit.setError(error);
      frequency.setError(error);
      reminders.setError(error);
    });
  }

  void calculateRocketForce() {
    try {
      double force;
      int timesDays = habit.data.frequency.daysCount();
      List<DateTime> dates = currentMonth.keys
          .toList()
          .where((e) => e.isAfterOrSameDay(DateTime.now().today.subtract(Duration(days: CYCLE_DAYS))))
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

  void calendarMonthSwipe(DateTime start, DateTime end, CalendarFormat format) async {
    calendarMonth.setLoading();
    (await _habitUseCase.getCalendarDaysDone(_id, start, end)).result((data) {
      calendarMonth.setData(data.asObservable());
    }, (error) {
      calendarMonth.setError(error);
    });
  }

  Future<void> setDoneHabit(bool add, DateTime date, DonePageType donePageType) async {
    calendarMonth.setLoading();
    isHabitDone.setLoading();

    int weekDay = date.weekday == 7 ? 0 : date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekDay));
    DateTime endDate = date.lastWeekDay();

    var days =
        calendarMonth.data.keys.where((e) => e.isAfterOrSameDay(startDate) && e.isBeforeOrSameDay(endDate)).toList();

    return (await _habitUseCase.completeHabit(_id, date, add, days)).result((data) {
      Map<DateTime, List> visibleMonthDays = calendarMonth.data;

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
        currentMonth = visibleMonthDays;
        calculateRocketForce();
      }

      calendarMonth.setData(visibleMonthDays.asObservable());
      getHabitDetail();
      if (date.isAtSameMomentAs(DateTime.now().today)) {
        isHabitDone.setData(add);
      } else {
        isHabitDone.setLoading(false);
      }
      return Future.value();
    }, (error) {
      calendarMonth.setLoading(false);
      isHabitDone.setLoading(false);
      throw error;
    });
  }

  void editCueCallback(String cue) {
    Habit newHabit = habit.data;
    if (cue == null) {
      newHabit.oldCue = "";
    } else {
      newHabit.oldCue = cue;
    }

    habit.setData(newHabit);
    switchPanelType(BottomSheetType.NONE);
  }

  void editAlarmCallback(Reminder newReminder) {
    reminders.setData(newReminder);
    habit.data.reminder = newReminder;
    switchPanelType(BottomSheetType.NONE);
  }

  void updateHabitDetailsPageData(Habit newHabit) {
    _color = newHabit.colorCode;
    getHabitDetail();
  }

  Future<bool> hasCompetition() {
    return _competitionUseCase.hasCompetitionByHabit(_id);
  }
}
