import 'dart:async';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/datas/dataHabitDetail.dart';
import 'package:altitude/enums/DonePageType.dart';
import 'package:altitude/model/Frequency.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/services/FireAnalytics.dart';
import 'package:altitude/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';

class HabitDeatilsBloc extends BlocBase {
  HabitDeatilsBloc(this.id);

  final int id;

  ScrollController scrollController = new ScrollController();
  PanelController panelController = new PanelController();
  AnimationController controllerScore; // Pensar numa forma diferente de implementar o score
  int previousScore = 0;

  DataHabitDetail data = DataHabitDetail(); // Remover singleton

  CalendarController calendarController = new CalendarController();
  bool isEditingCalendar = false;

  //Habit Data
  Habit habit;
  StreamController<Habit> _habitDataStreamController = StreamController.broadcast();
  Stream<Habit> get habitDataStream => _habitDataStreamController.stream;

  //Frequency Data
  Frequency frequency;
  StreamController<Frequency> _frequencyDataStreamController = StreamController.broadcast();
  Stream<Frequency> get frequencyDataStream => _frequencyDataStreamController.stream;

  //Days Done Data
  Map<DateTime, List> daysDone;
  StreamController<Map<DateTime, List>> _daysDoneDataStreamController = StreamController.broadcast();
  Stream<Map<DateTime, List>> get daysDoneDataStream => _daysDoneDataStreamController.stream;

  //Competition Data
  List<String> competitions;
  StreamController<List<String>> _competitionDataStreamController = StreamController();
  Stream<List<String>> get competitionDataStream => _competitionDataStreamController.stream;

  //Edit Calendar
  StreamController<bool> _editCalendarStreamController = StreamController();
  Stream<bool> get editCalendarStream => _editCalendarStreamController.stream;
  StreamController<bool> _loadingCalendarStreamController = StreamController();
  Stream<bool> get loadingCalendarStream => _loadingCalendarStreamController.stream;

  //Bottom Sheet
  StreamController<int> _bottomSheetStreamController = StreamController();
  Stream<int> get bottomSheetStream => _bottomSheetStreamController.stream;

  @override
  void initialize() {
    controllerScore = AnimationController(duration: const Duration(milliseconds: 1000), vsync: tickerProvider);

    animateScore();

    getData();
  }

  @override
  void dispose() {
    controllerScore.dispose();
    _editCalendarStreamController.close();
    _habitDataStreamController.close();
    _competitionDataStreamController.close();
    _daysDoneDataStreamController.close();
    _frequencyDataStreamController.close();
    _bottomSheetStreamController.close();
    _loadingCalendarStreamController.close();
  }

  void getData() async {
    try {
      habit = await HabitsControl().getHabit(id);
      frequency = await HabitsControl().getFrequency(id);
      daysDone = await HabitsControl()
          .getDaysDone(id, startDate: Util.getLastDayMonthBehind(DateTime.now()), endDate: DateTime.now());
      competitions = await CompetitionsControl().listCompetitionsIds(id);

      _habitDataStreamController.sink.add(habit);
      _frequencyDataStreamController.sink.add(frequency);
      _daysDoneDataStreamController.sink.add(daysDone);
      _competitionDataStreamController.sink.add(competitions);
    } catch (error) {
      _habitDataStreamController.addError(error);
      _frequencyDataStreamController.addError(error);
      _daysDoneDataStreamController.addError(error);
      _competitionDataStreamController.addError(error);

      showToast("Ocorreu um erro");
    }
  }

  void openBottomSheet(int index) {
    _bottomSheetStreamController.sink.add(index);
    if (index == 0) FireAnalytics().sendReadCue();

    panelController.open();
  }

  void closeBottomSheet() {
    panelController.close();
  }

  void animateScore() {
    if (previousScore != data.habit.score) {
      controllerScore.reset();
      controllerScore.forward().orCancel.whenComplete(() {
        previousScore = data.habit.score;
      });
    }
  }

  void editCalendarClick() {
    _editCalendarStreamController.sink.add(!isEditingCalendar);
    isEditingCalendar = !isEditingCalendar;
  }

  void dayCalendarClick(DateTime date, List events) {
    if (isEditingCalendar) {
      _loadingCalendarStreamController.sink.add(true);
      DateTime day = new DateTime(date.year, date.month, date.day);
      bool add = events.length == 0 ? true : false;

      HabitsControl()
          .setHabitDoneAndScore(day, id, DonePageType.Calendar, freq: frequency, add: add)
          .then((earnedScore) {
        Vibration.hasVibrator().then((resp) {
          if (resp != null && resp == true) {
            Vibration.vibrate(duration: 100);
          }
        });

        habit?.score += earnedScore;
        if (add) {
          habit?.daysDone++;
        } else {
          habit?.daysDone--;
        }

        bool yesterday = daysDone.containsKey(day.subtract(Duration(days: 1)));
        bool tomorrow = daysDone.containsKey(day.add(Duration(days: 1)));

        if (!add) {
          // Remover dia
          daysDone?.remove(day);
          if (yesterday) {
            daysDone?.update(day.subtract(Duration(days: 1)), (old) => [old[0], false]);
          }

          if (tomorrow) {
            daysDone?.update(day.add(Duration(days: 1)), (old) => [false, old[1]]);
          }
        } else {
          // Adicionar dia
          daysDone?.putIfAbsent(day, () => [yesterday, tomorrow]);
          if (yesterday) {
            daysDone?.update(day.subtract(Duration(days: 1)), (old) => [old[0], true]);
          }

          if (tomorrow) {
            daysDone?.update(day.add(Duration(days: 1)), (old) => [true, old[1]]);
          }
        }

        _daysDoneDataStreamController.sink.add(daysDone);
        _habitDataStreamController.sink.add(habit);
        _loadingCalendarStreamController.sink.add(false);
      });
    }
  }
}

//atualizar score ao completar um dia e quantidade de dias feito
// swipe entrte meses
// Exibição dos tutoriais
// Panel do gatilho e reminder
// cor do habito
