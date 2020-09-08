import 'package:altitude/common/constant/Books.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:mobx/mobx.dart';
part 'HomeLogic.g.dart';

class HomeLogic = _HomeLogicBase with _$HomeLogic;

abstract class _HomeLogicBase with Store {
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;

  DataState<Person> user = DataState();
  DataState<ObservableList<Habit>> habits = DataState();

  @observable
  ObservableList<DayDone> doneHabits;

  @observable
  bool visibilty = false;

  @observable
  bool pendingCompetitionStatus = false;

  @observable
  bool pendingFriendStatus = false;

  @observable
  bool pendingLearnStatus = false;

  @observable
  bool pendingStatisticsStatus = false;

  Future<void> getUser() async {
    (await _personUseCase.getPerson()).result((data) {
      user.setData(data);
    }, (error) {
      user.setError(error);
    });
  }

  void getHabits() async {
    // doneHabits = (await HabitsControl().getHabitsDoneToday()).asObservable();
    (await _habitUseCase.getHabits()).result((data) {
      habits.setData(data.asObservable());
    }, (error) {
      habits.setError(error);
    });
  }

  @action
  void fetchPendingStatus() {
    pendingCompetitionStatus = CompetitionsControl().pendingCompetitionsStatus;
    pendingFriendStatus = _personUseCase.pendingFriendsStatus;
    pendingLearnStatus = BOOKS.length != SharedPref.instance.pendingLearn ? true : false;
    pendingStatisticsStatus = SharedPref.instance.pendingStatistic;
  }

  @action
  void swipeSkyWidget(bool show) {
    visibilty = show;
  }

  @action
  Future<int> completeHabit(String id) async {
    return (await _habitUseCase.completeHabit(id, DateTime.now().today)).result((value) {
      getUser();
      //doneHabits.add(DayDone(date: DateTime.now().today, habitId: id));
      return user.data.score;
    }, (error) => throw error);
  }

  Future<bool> checkLevelUp(int newScore) async {
    int newLevel = LevelControl.getLevel(newScore);
    int oldLevel = LevelControl.getLevel(await _personUseCase.getScore());

    if (newLevel != oldLevel) _personUseCase.updateLevel(newLevel);

    if (newLevel > oldLevel) {
      FireAnalytics().sendNextLevel(LevelControl.getLevelText(newScore));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> canAddHabit() => _habitUseCase.maximumNumberReached();
}
