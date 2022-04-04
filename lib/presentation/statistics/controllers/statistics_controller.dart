import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/data_state.dart';
import 'package:altitude/common/model/failure.dart';
import 'package:altitude/domain/models/frequency_statistic_data.dart';
import 'package:altitude/domain/models/habit_statistic_data.dart';
import 'package:altitude/domain/models/historic_statistic_data.dart';
import 'package:altitude/domain/usecases/habits/get_all_days_done_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'statistics_controller.g.dart';

@lazySingleton
class StatisticsController = _StatisticsControllerBase
    with _$StatisticsController;

abstract class _StatisticsControllerBase with Store {
  _StatisticsControllerBase(
    this._getHabitsUsecase,
    this._getUserDataUsecase,
    this._getAllDaysDoneUsecase,
    this._scoreService,
  );

  final GetHabitsUsecase _getHabitsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final GetAllDaysDoneUsecase _getAllDaysDoneUsecase;
  final IScoreService _scoreService;

  DataState<ObservableList<HabitStatisticData>?> habitsData = DataState();
  DataState<List<HistoricStatisticData>> historicData = DataState();
  DataState<List<FrequencyStatisticData>> frequencyData = DataState();

  @observable
  String? selectedId;

  @action
  Future<void> fetchData() async {
    try {
      List<Habit> habits = (await _getHabitsUsecase
              .call(false)
              .resultComplete((data) => data, (error) => throw error))
          .asObservable();
      int? totalScore = (await _getUserDataUsecase
              .call(false)
              .resultComplete((data) => data, (error) => null))
          ?.score;
      List<DayDone> daysDone = await _getAllDaysDoneUsecase
          .call(habits)
          .resultComplete((data) => data, (error) => throw error);

      Map<DateTime, List<DayDone>> dateGrouped = groupBy<DayDone, DateTime>(
        daysDone,
        (e) => DateTime(e.date!.year, e.date!.month),
      );

      historicData
          .setSuccessState(await handleHistoricData(dateGrouped, habits));
      frequencyData.setSuccessState(handleFrequencyData(dateGrouped, habits));
      habitsData.setSuccessState(
        habits
            .map(
              (e) => HabitStatisticData(
                e.id,
                e.score,
                e.habit,
                e.colorCode,
                totalScore,
              ),
            )
            .toList()
            .asObservable(),
      );
    } catch (error) {
      habitsData.setErrorState(Failure.genericFailure(error));
      historicData.setErrorState(Failure.genericFailure(error));
      frequencyData.setErrorState(Failure.genericFailure(error));
    }
  }

  Future<List<HistoricStatisticData>> handleHistoricData(
    Map<DateTime, List<DayDone>> dateGrouped,
    List<Habit> habits,
  ) async {
    List<HistoricStatisticData> dayHistoric = [];
    int currentYear = 0;
    int lastMonth = 0;

    // Passa por cada grupo de mês
    dateGrouped.forEach((key, value) {
      // Separa o grupo por hábitos para somar a pontuação total
      Map<String?, List<DayDone>> dayGroupedHabit =
          groupBy<DayDone, String?>(value, (e) => e.habitId);
      Map<Habit, int> habitsMap = {};
      // Faz o calcula da pontuação total
      dayGroupedHabit.forEach((key, value) {
        Habit? habit = habits.firstWhereOrNull((e) => e.id == key);
        if (habit != null) {
          habitsMap.putIfAbsent(
            habit,
            () => _scoreService.scoreEarnedTotal(
              habit.frequency!,
              value.map((e) => e.date).toList(),
            ),
          );
        }
      });

      if (key.month > lastMonth + 1 && lastMonth != 0) {
        List.generate(
          key.month - lastMonth - 1,
          (i) => dayHistoric.add(
            HistoricStatisticData(
              {},
              lastMonth + 1 + i,
              key.year,
              false,
            ),
          ),
        );
      }

      dayHistoric.add(
        HistoricStatisticData(
          habitsMap,
          key.month,
          key.year,
          currentYear != key.year,
        ),
      );

      lastMonth = key.month;
      if (currentYear != key.year) {
        currentYear = key.year;
      }
    });

    if (DateTime.now().month > lastMonth) {
      List.generate(
        DateTime.now().month - lastMonth,
        (i) => dayHistoric.add(
          HistoricStatisticData(
            {},
            lastMonth + 1 + i,
            DateTime.now().year,
            DateTime.now().month == 1,
          ),
        ),
      );
    }

    return dayHistoric.reversed.toList();
  }

  List<FrequencyStatisticData> handleFrequencyData(
    Map<DateTime, List<DayDone>> dateGrouped,
    List<Habit> habits,
  ) {
    List<FrequencyStatisticData> dayFrequency = [];

    int currentYear = 0;
    int lastMonth = 0;

    dateGrouped.forEach((key, value) {
      Map<DateTime, List<DayDone>> dayGrouped = groupBy<DayDone, DateTime>(
        value,
        (e) => DateTime(e.date!.year, e.date!.month, e.date!.day),
      );
      Map<String?, List<DayDone>> dayGroupedHabit =
          groupBy<DayDone, String?>(value, (e) => e.habitId);

      Map<Habit, List<int>> habitsMap = {};
      dayGroupedHabit.forEach((key, value) {
        Habit? habit = habits.firstWhereOrNull((e) => e.id == key);
        if (habit != null) {
          habitsMap.putIfAbsent(
            habit,
            () => List.generate(
              7,
              (i) => value
                  .where(
                    (e) =>
                        e.date!.weekday == i ||
                        (e.date!.weekday == 7 && i == 0),
                  )
                  .length,
            ),
          );
        }
      });

      List<int> weekdayDone = List.generate(
        7,
        (i) => dayGrouped.keys
            .where((e) => e.weekday == i || (e.weekday == 7 && i == 0))
            .length,
      );

      if (key.month > lastMonth + 1 && lastMonth != 0) {
        List.generate(
          key.month - lastMonth - 1,
          (i) => dayFrequency.add(
            FrequencyStatisticData(
              [],
              {},
              lastMonth + 1 + i,
              key.year,
              false,
            ),
          ),
        );
      }

      dayFrequency.add(
        FrequencyStatisticData(
          weekdayDone,
          habitsMap,
          key.month,
          key.year,
          currentYear != key.year,
        ),
      );

      lastMonth = key.month;
      if (currentYear != key.year) {
        currentYear = key.year;
      }
    });

    if (DateTime.now().month > lastMonth) {
      List.generate(
        DateTime.now().month - lastMonth,
        (i) => dayFrequency.add(
          FrequencyStatisticData(
            [],
            {},
            lastMonth + 1 + i,
            DateTime.now().year,
            DateTime.now().month == 1,
          ),
        ),
      );
    }

    return dayFrequency.reversed.toList();
  }

  @action
  void selectHabit(String? id) {
    if (selectedId != null) {
      habitsData.data!.firstWhere((e) => e.id == selectedId).selected = false;
    }

    if (selectedId != id) {
      habitsData.data!.firstWhere((e) => e.id == id).selected = true;
      selectedId = id;
    } else {
      selectedId = null;
    }
    habitsData.setSuccessState(habitsData.data);
  }
}
