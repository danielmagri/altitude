import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'HomeLogic.g.dart';

@LazySingleton()
class HomeLogic = _HomeLogicBase with _$HomeLogic;

abstract class _HomeLogicBase with Store {
  final HabitUseCase _habitUseCase;
  final PersonUseCase _personUseCase;
  final CompetitionUseCase _competitionUseCase;
  final IFireAnalytics _fireAnalytics;

  _HomeLogicBase(this._habitUseCase, this._personUseCase, this._competitionUseCase, this._fireAnalytics);

  DataState<Person> user = DataState();
  DataState<ObservableList<Habit>> habits = DataState();

  @observable
  bool visibilty = false;

  @observable
  bool pendingCompetitionStatus = false;

  @observable
  bool pendingFriendStatus = false;

  Future<void> getUser() async {
    (await _personUseCase.getPerson()).result((data) {
      user.setData(data);
    }, (error) {
      user.setError(error);
    });
  }

  void getHabits() async {
    (await _habitUseCase.getHabits()).result((data) {
      habits.setData(data.asObservable());
    }, (error) {
      habits.setError(error);
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
  Future<int> completeHabit(String id) async {
    return (await _habitUseCase.completeHabit(id, DateTime.now().today)).result((_) async {
      await getUser();
      getHabits();
      return user.data.score;
    }, (error) => throw error);
  }

  Future<bool> checkLevelUp(int newScore) async {
    int newLevel = LevelControl.getLevel(newScore);
    int oldLevel = LevelControl.getLevel(await _personUseCase.getScore());

    if (newLevel != oldLevel) _personUseCase.updateLevel(newLevel);

    if (newLevel > oldLevel) {
      _fireAnalytics.sendNextLevel(LevelControl.getLevelText(newScore));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> canAddHabit() => _habitUseCase.maximumNumberReached();
}
