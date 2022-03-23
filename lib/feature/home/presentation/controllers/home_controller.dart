import 'package:altitude/common/app_logic.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

@LazySingleton()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final GetHabitsUsecase _getHabitsUsecase;
  final CompleteHabitUsecase _completeHabitUsecase;
  final MaxHabitsUsecase _maxHabitsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;

  final PersonUseCase _personUseCase;
  final CompetitionUseCase _competitionUseCase;
  final IFireAnalytics _fireAnalytics;
  final AppLogic _appLogic;

  _HomeControllerBase(
    this._getHabitsUsecase,
    this._completeHabitUsecase,
    this._maxHabitsUsecase,
    this._fireAnalytics,
    this._appLogic,
    this._personUseCase,
    this._competitionUseCase,
    this._getUserDataUsecase,
  );

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

  void getHabits() async {
    (await _getHabitsUsecase.call(false)).result((data) {
      habits.setSuccessState(data.asObservable());
    }, (error) {
      habits.setErrorState(error);
    });
  }

  @action
  void fetchPendingStatus() {
    pendingCompetitionStatus = _competitionUseCase.pendingCompetitionsStatus;
    pendingFriendStatus = _personUseCase.pendingFriendsStatus;
  }

  @action
  void swipeSkyWidget(bool show) {
    visibilty = show;
  }

  @action
  Future<int?> completeHabit(String id) async {
    return (await _completeHabitUsecase
            .call(CompleteParams(habitId: id, date: DateTime.now().today)))
        .result((_) async {
      await getUser();
      getHabits();
      return user.data!.score;
    }, (error) => throw error);
  }

  Future<bool> checkLevelUp(int newScore) async {
    int newLevel = LevelControl.getLevel(newScore);
    int oldLevel =
        LevelControl.getLevel((await _personUseCase.getScore()) ?? 0);

    if (newLevel != oldLevel) _personUseCase.updateLevel(newLevel);

    if (newLevel > oldLevel) {
      _fireAnalytics.sendNextLevel(LevelControl.getLevelText(newScore));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> canAddHabit() => _maxHabitsUsecase
      .call()
      .resultComplete((data) => data ?? true, (error) => true);

  void updateSystemStyle() => _appLogic.updateSystemStyle();
}
