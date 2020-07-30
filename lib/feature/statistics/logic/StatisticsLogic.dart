import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/statistics/model/FrequencyStatisticData.dart';
import 'package:altitude/feature/statistics/model/HabitStatisticData.dart';
import 'package:altitude/feature/statistics/model/HistoricStatisticData.dart';
import "package:collection/collection.dart";
import 'package:mobx/mobx.dart';
part 'StatisticsLogic.g.dart';

class StatisticsLogic = _StatisticsLogicBase with _$StatisticsLogic;

abstract class _StatisticsLogicBase with Store {
  DataState<ObservableList<HabitStatisticData>> habitsData = DataState();
  DataState<List<HistoricStatisticData>> historicData = DataState();
  DataState<List<FrequencyStatisticData>> frequencyData = DataState();

  int selectedId;

  @action
  Future<void> fetchData() async {
    if (SharedPref.instance.pendingStatistic) {
      SharedPref.instance.pendingStatistic = false;
    }
    
    try {
      List<Habit> habits = (await HabitsControl().getAllHabits()).asObservable();
      List<DayDone> daysDone = await HabitsControl().getAllDaysDone();

      Map<DateTime, List<DayDone>> dateGrouped =
          groupBy<DayDone, DateTime>(daysDone, (e) => DateTime(e.dateDone.year, e.dateDone.month));

      historicData.setData(await handleHistoricData(dateGrouped, habits));
      frequencyData.setData(handleFrequencyData(dateGrouped));
      habitsData
          .setData(habits.map((e) => HabitStatisticData(e.id, e.score, e.habit, e.color)).toList().asObservable());
    } catch (error) {
      habitsData.setError(error);
      historicData.setError(error);
    }
  }

  Future<List<HistoricStatisticData>> handleHistoricData(
      Map<DateTime, List<DayDone>> dateGrouped, List<Habit> habits) async {
    Map<int, Frequency> frequencies = Map();

    // Coleta a frequencia de todos os hábitos
    for (Habit habit in habits) {
      Frequency frequency = await HabitsControl().getFrequency(habit.id);
      frequencies.putIfAbsent(habit.id, () => frequency);
    }

    List<HistoricStatisticData> dayHistoric = List();
    int currentYear = 0;
    int lastMonth = 0;

    // Passa por cada grupo de mês
    dateGrouped.forEach((key, value) {
      // Separa o grupo por hábitos para somar a pontuação total
      Map<int, List<DayDone>> dayGroupedHabit = groupBy<DayDone, int>(value, (e) => e.habitId);
      Map<Habit, int> habitsMap = Map();
      // Faz o calcula da pontuação total
      dayGroupedHabit.forEach((key, value) {
        habitsMap.putIfAbsent(
            habits.firstWhere((e) => e.id == key), () => ScoreControl().scoreEarnedTotal(frequencies[key], value));
      });

      if (key.month > lastMonth + 1 && lastMonth != 0) {
        List.generate(key.month - lastMonth - 1,
            (i) => dayHistoric.add(HistoricStatisticData(Map(), lastMonth + 1 + i, key.year, false)));
      }

      dayHistoric.add(HistoricStatisticData(habitsMap, key.month, key.year, currentYear != key.year));

      lastMonth = key.month;
      if (currentYear != key.year) {
        currentYear = key.year;
      }
    });

    if (DateTime.now().month > lastMonth) {
      List.generate(
          DateTime.now().month - lastMonth,
          (i) => dayHistoric
              .add(HistoricStatisticData(Map(), lastMonth + 1 + i, DateTime.now().year, DateTime.now().month == 1)));
    }

    return dayHistoric.reversed.toList();
  }

  List<FrequencyStatisticData> handleFrequencyData(Map<DateTime, List<DayDone>> dateGrouped) {
    List<FrequencyStatisticData> dayFrequency = List();

    int currentYear = 0;
    int lastMonth = 0;

    dateGrouped.forEach((key, value) {
      Map<DateTime, List<DayDone>> dayGrouped = 
          groupBy<DayDone, DateTime>(value, (e) => DateTime(e.dateDone.year, e.dateDone.month, e.dateDone.day));

      List<int> weekdayDone = List.generate(
          7, (i) => dayGrouped.keys.where((e) => e.weekday == i || (e.weekday == 7 && i == 0)).length);

      if (key.month > lastMonth + 1 && lastMonth != 0) {
        List.generate(key.month - lastMonth - 1,
            (i) => dayFrequency.add(FrequencyStatisticData(List(), lastMonth + 1 + i, key.year, false)));
      }

      dayFrequency.add(FrequencyStatisticData(weekdayDone, key.month, key.year, currentYear != key.year));

      lastMonth = key.month;
      if (currentYear != key.year) {
        currentYear = key.year;
      }
    });

    if (DateTime.now().month > lastMonth) {
      List.generate(
          DateTime.now().month - lastMonth,
          (i) => dayFrequency
              .add(FrequencyStatisticData(List(), lastMonth + 1 + i, DateTime.now().year, DateTime.now().month == 1)));
    }

    return dayFrequency.reversed.toList();
  }

  void selectHabit(int id) {
    // if (selectedId != null) {
    //   habitsData.data.firstWhere((e) => e.id == selectedId).selected = false;
    // }

    // if (selectedId != id) {
    //   habitsData.data.firstWhere((e) => e.id == id).selected = true;
    //   selectedId = id;
    // } else {
    //   selectedId = null;
    // }
    // habitsData.setData(habitsData.data);
  }
}
