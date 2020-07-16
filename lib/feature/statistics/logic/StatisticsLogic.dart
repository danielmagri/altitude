import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/statistics/model/HabitStatisticData.dart';
import 'package:mobx/mobx.dart';
part 'StatisticsLogic.g.dart';

class StatisticsLogic = _StatisticsLogicBase with _$StatisticsLogic;

abstract class _StatisticsLogicBase with Store {
  DataState<ObservableList<HabitStatisticData>> habitsData = DataState();

  @action
  Future<void> fetchData() async {
    try {
      List<Habit> habits = (await HabitsControl().getAllHabits()).asObservable();
      habitsData
          .setData(habits.map((e) => HabitStatisticData(e.id, e.score, e.habit, e.color)).toList().asObservable());
    } catch (error) {
      habitsData.setError(error);
    }
  }

  @action
  void selectHabit(int id) {
    habitsData.data.forEach((e) {
      e.selected = false;
    });
    habitsData.data.firstWhere((e) => e.id == id).selected = true;
    habitsData.setData(habitsData.data);
  }
}
