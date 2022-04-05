import 'package:altitude/common/app_logic.dart';
import 'package:altitude/common/constant/level_utils.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/data_state.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/domain/usecases/habits/complete_habit_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/domain/usecases/habits/max_habits_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/domain/usecases/user/update_level_usecase.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

@lazySingleton
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  _HomeControllerBase(
    this._getHabitsUsecase,
    this._completeHabitUsecase,
    this._maxHabitsUsecase,
    this._fireAnalytics,
    this._appLogic,
    this._getUserDataUsecase,
    this._updateLevelUsecase,
    this._sharedPref,
  );

  final GetHabitsUsecase _getHabitsUsecase;
  final CompleteHabitUsecase _completeHabitUsecase;
  final MaxHabitsUsecase _maxHabitsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final UpdateLevelUsecase _updateLevelUsecase;
  final IFireAnalytics _fireAnalytics;
  final SharedPref _sharedPref;
  final AppLogic _appLogic;

  DataState<Person> user = DataState();
  DataState<ObservableList<Habit>> habits = DataState();

  @observable
  bool visibilty = false;

  @observable
  bool pendingCompetitionStatus = false;

  @observable
  bool pendingFriendStatus = false;

  Future<void> getUser() async {
    (await _getUserDataUsecase.call(false)).result((data) {
      user.setSuccessState(data);
    }, (error) {
      user.setErrorState(error);
    });
  }

  Future<void> getHabits() async {
    (await _getHabitsUsecase.call(false)).result((data) {
      habits.setSuccessState(data.asObservable());
    }, (error) {
      habits.setErrorState(error);
    });
  }

  @action
  void fetchPendingStatus() {
    pendingCompetitionStatus = _sharedPref.pendingCompetition;
    pendingFriendStatus = _sharedPref.pendingFriends;
  }

  @action
  void swipeSkyWidget(bool show) {
    visibilty = show;
  }

  @action
  Future<int?> completeHabit(String id) async {
    return (await _completeHabitUsecase
            .call(CompleteParams(habitId: id, date: DateTime.now().onlyDate)))
        .result(
      (_) async {
        await getUser();
        getHabits();
        return user.data!.score;
      },
      (error) => throw error,
    );
  }

  Future<bool> checkLevelUp(int newScore) async {
    int newLevel = LevelUtils.getLevel(newScore);
    int oldLevel = LevelUtils.getLevel(
      (await _getUserDataUsecase
                  .call(false)
                  .resultComplete((data) => data, (error) => null))
              ?.score ??
          0,
    );

    if (newLevel != oldLevel) _updateLevelUsecase.call(newLevel);

    if (newLevel > oldLevel) {
      _fireAnalytics.sendNextLevel(LevelUtils.getLevelText(newScore));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> canAddHabit() => _maxHabitsUsecase
      .call(NoParams())
      .resultComplete((data) => data, (error) => true);

  void updateSystemStyle() => _appLogic.updateSystemStyle();
}
