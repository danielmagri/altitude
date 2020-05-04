import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/home/enums/HabitFiltersType.dart';
import 'package:altitude/feature/home/model/User.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:mobx/mobx.dart';
part 'HomeLogic.g.dart';

class HomeLogic = _HomeLogicBase with _$HomeLogic;

abstract class _HomeLogicBase with Store {
  DataState<User> user = DataState();
  DataState<ObservableList<Habit>> habits = DataState();

  @observable
  ObservableList<DayDone> doneHabits;

  @observable
  HabitFiltersType filterSelected;

  @observable
  bool visibilty = false;

  @observable
  bool pendingCompetitionStatus = false;

  @observable
  bool pendingFriendStatus = false;

  @action
  Future<void> fetchData() async {
    try {
      filterSelected = HabitFiltersType.values[SharedPref.instance.habitFilters];
      user.setData(await UserControl().getUserData());
      doneHabits = (await HabitsControl().getHabitsDoneToday()).asObservable();
      await fetchHabits();
    } catch (error) {
      user.setError(error);
    }
  }

  Future<void> fetchHabits() async {
    try {
      habits.setInitial();
      switch (filterSelected) {
        case HabitFiltersType.TODAY_HABITS:
          habits.setData((await HabitsControl().getHabitsToday()).asObservable());
          break;
        case HabitFiltersType.ALL_HABITS:
          habits.setData((await HabitsControl().getAllHabits()).asObservable());
          break;
      }
    } catch (error) {
      habits.setError(error);
    }
  }

  @action
  void fetchPendingStatus() {
    pendingCompetitionStatus = CompetitionsControl().pendingCompetitionsStatus;
    pendingFriendStatus = UserControl().getPendingFriendsStatus();
  }

  @action
  void swipeSkyWidget(bool show) {
    visibilty = show;
  }

  @action
  void selectFilter(HabitFiltersType type) {
    if (type != filterSelected) {
      filterSelected = type;
      SharedPref.instance.habitFilters = type.index;
      fetchHabits();
    }
  }

  @action
  Future<int> completeHabit(int id) async {
    int earnedScore = await HabitsControl().setHabitDoneAndScore(DateTime.now().today, id, DonePageType.Initial);
    var newUser = user.data;
    newUser.score += earnedScore;
    user.setData(newUser);
    doneHabits.add(DayDone(dateDone: DateTime.now().today, habitId: id));
    return user.data.score;
  }

  Future<bool> checkLevelUp(int newScore) async {
    int newLevel = LevelControl.getLevel(newScore);
    int oldLevel = SharedPref.instance.level;

    if (newLevel != oldLevel) SharedPref.instance.level = newLevel;

    if (newLevel > oldLevel) {
      FireAnalytics().sendNextLevel(LevelControl.getLevelText(newScore));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> canAddHabit() async {
    if (await HabitsControl().getAllHabitCount() < MAX_HABITS) {
      return true;
    }
    return false;
  }
}
