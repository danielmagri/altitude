import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/statistics/model/HabitStatisticData.dart';
import 'package:altitude/feature/statistics/model/HistoricStatisticData.dart';
import "package:collection/collection.dart";
import 'package:mobx/mobx.dart';
part 'StatisticsLogic.g.dart';

class StatisticsLogic = _StatisticsLogicBase with _$StatisticsLogic;

abstract class _StatisticsLogicBase with Store {
  DataState<ObservableList<HabitStatisticData>> habitsData = DataState();

  DataState<List<HistoricStatisticData>> historicData = DataState();

  int selectedId;

  @action
  Future<void> fetchData() async {
    try {
      List<Habit> habits = (await HabitsControl().getAllHabits()).asObservable();
      List<DayDone> daysDone = await HabitsControl().getAllDaysDone();

      historicData.setData(await handleHistoricData(daysDone, habits));
      habitsData
          .setData(habits.map((e) => HabitStatisticData(e.id, e.score, e.habit, e.color)).toList().asObservable());
    } catch (error) {
      habitsData.setError(error);
      historicData.setError(error);
    }
  }

  Future<List<HistoricStatisticData>> handleHistoricData(List<DayDone> daysDone, List<Habit> habits) async {
    Map<DateTime, List<DayDone>> dayGroup =
        groupBy<DayDone, DateTime>(daysDone, (e) => DateTime(e.dateDone.year, e.dateDone.month));
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
    dayGroup.forEach((key, value) {
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

    return dayHistoric;
  }

  @action
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
