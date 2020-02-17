import 'dart:async';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/core/bloc/model/LoadableData.dart';
import 'package:altitude/core/bloc/stream/LoadableStreamController.dart';
import 'package:altitude/enums/DonePageType.dart';
import 'package:altitude/model/Frequency.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/model/Reminder.dart';
import 'package:altitude/services/FireAnalytics.dart';
import 'package:altitude/ui/competition/competitionPage.dart';
import 'package:altitude/ui/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show ScrollController, Color, BuildContext;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class HabitDeatilsBloc extends BlocBase {
  HabitDeatilsBloc(this._id, this._color);

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
  Map<DateTime, List> _daysDone;
  List<String> _competitions;

  Habit get habit => _habit;

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

  @override
  void initialize() {
    fetchData();
  }

  @override
  void dispose() {
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
      _daysDone = await HabitsControl().getDaysDone(_id,
          startDate: DateTime.now().lastDayOfPreviousMonth().subtract(Duration(days: 6)),
          endDate: DateTime.now().today.add(Duration(days: 7)));
      _competitions = await CompetitionsControl().listCompetitionsIds(_id);

      _habitStreamController.sink.add(_habit);
      _reminderButtonController.sink.add(_reminders.length);
      _completeButtonStreamController.success(_daysDone.containsKey(DateTime.now().today));
      _frequencyTextStreamController.sink.add(_frequency);
      _cueTextStreamController.sink.add(_habit.cue);
      _calendarWidgetStreamController.success(_daysDone);
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

  void calendarMonthSwipe(DateTime start, DateTime end, CalendarFormat format) {
    _calendarWidgetStreamController.loading();
    HabitsControl()
        .getDaysDone(_id, startDate: start.subtract(Duration(days: 1)), endDate: end.add(Duration(days: 1)))
        .then((map) {
      _daysDone = map;
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

      bool yesterday = _daysDone.containsKey(date.subtract(Duration(days: 1)));
      bool tomorrow = _daysDone.containsKey(date.add(Duration(days: 1)));

      if (!add) {
        // Remover dia
        _daysDone?.remove(date);
        if (yesterday) {
          _daysDone?.update(date.subtract(Duration(days: 1)), (old) => [old[0], false]);
        }

        if (tomorrow) {
          _daysDone?.update(date.add(Duration(days: 1)), (old) => [false, old[1]]);
        }
      } else {
        // Adicionar dia
        _daysDone?.putIfAbsent(date, () => [yesterday, tomorrow]);
        if (yesterday) {
          _daysDone?.update(date.subtract(Duration(days: 1)), (old) => [old[0], true]);
        }

        if (tomorrow) {
          _daysDone?.update(date.add(Duration(days: 1)), (old) => [true, old[1]]);
        }
      }

      _calendarWidgetStreamController.success(_daysDone);
      _habitStreamController.sink.add(_habit);
      if (date.isAtSameMomentAs(DateTime.now().today)) {
        _completeButtonStreamController.success(add);
      } else {
        _completeButtonStreamController.loading(false);
      }
    });
  }
}

// ações do Panel do gatilho e reminder
// Exibição dos tutoriais
// Alterar fogo do foguete
// pesquisar vantagens e destavantagens dos tipos de navegação
