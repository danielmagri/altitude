import 'dart:async';
import 'package:habit/controllers/DaysDoneControl.dart';
import 'package:habit/controllers/ScoreControl.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/objects/Frequency.dart';

class DataControl {
  static final DataControl _singleton = new DataControl._internal();

  factory DataControl() {
    return _singleton;
  }

  DataControl._internal();

  // ***** PERSON *****
  Future<Person> getPerson() async {
    return await DatabaseService().getPerson();
  }

  // ***** HABIT *****
  Future<List<Habit>> getAllHabits() async {
    return await DatabaseService().getAllHabits();
  }

  Future<Habit> getHabit(int id) async {
    return await DatabaseService().getHabit(id);
  }

  Future<List<Habit>> getHabitsToday() async {
    return await DatabaseService().getHabitsToday();
  }

  Future<bool> addHabit(Habit habit, dynamic frequency) async {
    return await DatabaseService().addHabit(habit, frequency);
  }

  Future<bool> updateHabit(Habit habit) async {
    return await DatabaseService().updateHabit(habit);
  }

  Future<bool> deleteHabit(int id) async {
    return await DatabaseService().deleteHabit(id);
  }

  // ***** FREQUENCY *****
  Future<dynamic> getFrequency(int id) async {
    return await DatabaseService().getFrequency(id);
  }

  Future<bool> updateFrequency(int id, dynamic frequency) async {}

  // ***** DAYDONE *****
  Future<Map<DateTime, List>> getDaysDone(int id) async {
    Map<DateTime, List> map = new Map();
    List<DayDone> list = await DatabaseService().getDaysDone(id);

    for (DayDone day in list) {
      map.putIfAbsent(day.dateDone, () => ['']);
    }
    return map;
  }

  Future<List<DayDone>> getCycleDaysDone(int id, int cycle) async {
    return await DatabaseService().getCycleDaysDone(id, cycle);
  }

  Future<int> setHabitDoneAndScore(int id, int cycle) async {
    dynamic freq = await getFrequency(id);
    Map result;

    if (freq.runtimeType == FreqDayWeek) {
      result = await DaysDoneControl().checkCycleDoneDayWeek(id, cycle);
    } else if (freq.runtimeType == FreqWeekly) {
      result = await DaysDoneControl().checkCycleDoneWeekly(id, cycle);
    } else {
      result = await DaysDoneControl().checkCycleDoneRepeating(id, cycle, freq);
    }

    if (result != null) {
      int score = await ScoreControl().calculateScore(id, freq, result[1]);

      print("Pontuação: $score");
      await DatabaseService().updateScore(id, score);
      await DatabaseService().habitDone(id, cycle, result[0]);
      return score;
    } else {
      return 0;
    }
  }

  Future<bool> setHabitProgress(int id, double progress) async {
    return await DatabaseService().updateProgress(id, progress);
  }
}
