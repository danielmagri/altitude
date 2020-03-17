import 'dart:async';
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/Constants.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/core/bloc/model/LoadableData.dart';
import 'package:altitude/core/bloc/stream/LoadableStreamController.dart';
import 'package:altitude/services/FireAnalytics.dart';
import 'package:altitude/ui/competition/competitionPage.dart';
import 'package:altitude/ui/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show ScrollController, Color, BuildContext;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class HabitDetailsBloc extends BlocBase {
  final int _id;
  final int _color;

  Color get habitColor => AppColors.habitsColor[_color];

  ScrollController scrollController = new ScrollController();
  PanelController panelController = new PanelController();

  CalendarController calendarController = new CalendarController();

  // Datas
  Habit _habit;
  Frequency _frequency;
  List<Reminder> _reminders;
  Map<DateTime, List> _currentMonthDaysDone;
  List<String> _competitions;

  Habit get habit => _habit;
  List<Reminder> get reminders => _reminders;

  // Rocket Widget
  StreamController<double> _rocketForceStreamController = StreamController();
  Stream<double> get rocketForceStream => _rocketForceStreamController.stream;

  // Bottom Sheet
  StreamController<BottomSheetType> _bottomSheetStreamController = StreamController();
  Stream<BottomSheetType> get bottomSheetStream => _bottomSheetStreamController.stream;

  // Habit
  StreamController<Habit> _habitStreamController = StreamController.broadcast();
  Stream<Habit> get habitStream => _habitStreamController.stream;

  // Reminder Button
  StreamController<int> _reminderButtonController = StreamController();
  Stream<int> get reminderButtonStream => _reminderButtonController.stream;

  // Complete Button
  LoadableStreamController<bool> _completeButtonStreamController = LoadableStreamController();
  Stream<LoadableData<bool>> get completeButtonStram => _completeButtonStreamController.stream;

  // Frequency Text
  StreamController<Frequency> _frequencyTextStreamController = StreamController();
  Stream<Frequency> get frequencyTextStream => _frequencyTextStreamController.stream;

  // Cue Text
  StreamController<String> _cueTextStreamController = StreamController();
  Stream<String> get cueTextStream => _cueTextStreamController.stream;

  // Calendar Widget
  LoadableStreamController<Map<DateTime, List>> _calendarWidgetStreamController = LoadableStreamController();
  Stream<LoadableData<Map<DateTime, List>>> get calendarWidgetStreamcontroller =>
      _calendarWidgetStreamController.stream;

  // Competition List
  StreamController<List<String>> _competitionListStreamController = StreamController();
  Stream<List<String>> get competitionListStream => _competitionListStreamController.stream;

  HabitDetailsBloc(this._id, this._color) {
    fetchData();
  }

  @override
  void dispose() {
    _rocketForceStreamController.close();
    _habitStreamController.close();
    _reminderButtonController.close();
    _bottomSheetStreamController.close();
    _calendarWidgetStreamController.close();
    _completeButtonStreamController.close();
    _frequencyTextStreamController.close();
    _cueTextStreamController.close();
    _competitionListStreamController.close();

    scrollController.dispose();
    calendarController.dispose();
  }

  void goCompetition(BuildContext context, int index) {
    FireAnalytics().sendGoCompetition(index.toString());
    navigatePushToPage(context, CompetitionPage(), "Competitor page");
  }

  void fetchData() async {
    try {
      _habit = await HabitsControl().getHabit(_id);
      _reminders = await HabitsControl().getReminders(_id);
      _frequency = await HabitsControl().getFrequency(_id);
      _currentMonthDaysDone = await HabitsControl().getDaysDone(_id,
          startDate: DateTime.now().lastDayOfPreviousMonth().subtract(Duration(days: 6)),
          endDate: DateTime.now().today.add(Duration(days: 7)));
      _competitions = await CompetitionsControl().listCompetitionsIds(_id);

      calculateRocketForce();

      _habitStreamController.sink.add(_habit);
      _reminderButtonController.sink.add(_reminders.length);
      _completeButtonStreamController.success(_currentMonthDaysDone.containsKey(DateTime.now().today));
      _frequencyTextStreamController.sink.add(_frequency);
      _cueTextStreamController.sink.add(_habit.cue);
      _calendarWidgetStreamController.success(_currentMonthDaysDone);
      _competitionListStreamController.sink.add(_competitions);
    } catch (error) {
      _habitStreamController.addError(error);
      _completeButtonStreamController.error(error);
      _frequencyTextStreamController.sink.addError(error);
      _cueTextStreamController.sink.addError(error);
      _calendarWidgetStreamController.error(error);
      _competitionListStreamController.addError(error);

      showToast("Ocorreu um erro");
    }
  }

  void openBottomSheet(BottomSheetType type) {
    _bottomSheetStreamController.sink.add(type);
    if (type == BottomSheetType.CUE) FireAnalytics().sendReadCue();

    panelController.open();
  }

  void closeBottomSheet() {
    panelController.close();
  }

  void emptyBottomSheet() {
    _bottomSheetStreamController.sink.add(BottomSheetType.NONE);
  }

  void calculateRocketForce() async {
    try {
      double force;
      int timesDays = _frequency.daysCount();
      List<DateTime> dates = (await HabitsControl().getDaysDone(_id,
              startDate: DateTime.now().today.subtract(Duration(days: CYCLE_DAYS)), endDate: DateTime.now().today))
          .keys
          .toList();

      int daysDoneLastCycle = dates.length;

      force = daysDoneLastCycle / timesDays;

      if (force > 1.3) force = 1.3;
      _rocketForceStreamController.sink.add(force);
    } catch (error) {
      _rocketForceStreamController.addError(error);
    }
  }

  void calendarMonthSwipe(DateTime start, DateTime end, CalendarFormat format) {
    _calendarWidgetStreamController.loading();
    HabitsControl()
        .getDaysDone(_id, startDate: start.subtract(Duration(days: 1)), endDate: end.add(Duration(days: 1)))
        .then((map) {
      _calendarWidgetStreamController.success(map);
    });
  }

  void editCalendarClick() {
    // onPressed: () {
    //   setState(() {
    //     _editing = !_editing;
    //   });

    //   if (!_editing) {
    //     //widget.showSuggestionsDialog(suggestionsType.SET_ALARM);
    //   }
    // },
  }

  void dayCalendarClick(DateTime date, List events) {
    DateTime day = DateTime(date.year, date.month, date.day);
    bool add = events.length == 0;

    completeHabit(add, day, DonePageType.Calendar);
  }

  void completeHabit(bool add, DateTime date, DonePageType donePageType) {
    _calendarWidgetStreamController.loading();
    if (!_completeButtonStreamController.lastDataSend) {
      _completeButtonStreamController.loading();
    }

    HabitsControl().setHabitDoneAndScore(date, _id, donePageType, add: add).then((earnedScore) {
      Vibration.hasVibrator().then((resp) {
        if (resp != null && resp == true) {
          Vibration.vibrate(duration: 100);
        }
      });

      _habit?.score += earnedScore;
      if (add) {
        _habit?.daysDone++;
      } else {
        _habit?.daysDone--;
      }

      Map<DateTime, List> visibleMonthDays = _calendarWidgetStreamController.lastDataSend;

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

      _calendarWidgetStreamController.success(visibleMonthDays);
      _habitStreamController.sink.add(_habit);
      if (date.isAtSameMomentAs(DateTime.now().today)) {
        _completeButtonStreamController.success(add);
      } else {
        _completeButtonStreamController.loading(false);
      }
    });
  }

  void editCueCallback(String cue) {
    if (cue == null) {
      // Removido
      _habit.cue = "";
    } else {
      // Alterado
      _habit.cue = cue;
    }

    _cueTextStreamController.sink.add(_habit.cue);
    closeBottomSheet();
  }

  void editAlarmCallback(List<Reminder> newReminders) {
    _reminders = newReminders;
    _reminderButtonController.sink.add(newReminders.length);
    closeBottomSheet();
  }
}

// Exibição dos tutoriais
