import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/home/model/User.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:mobx/mobx.dart';
part 'HomeLogic.g.dart';

class HomeLogic = _HomeLogicBase with _$HomeLogic;

abstract class _HomeLogicBase with Store {
  DataState<User> user = DataState();
  DataState<ObservableList<Habit>> todayHabits = DataState();
  DataState<ObservableList<Habit>> allHabits = DataState();

  @observable
  ObservableList<DayDone> doneHabits;

  @observable
  int pageIndex = 1;

  @observable
  bool visibilty = false;

  @action
  Future<void> fetchData() async {
    try {
      user.setData(await UserControl().getUserData());
      doneHabits = (await HabitsControl().getHabitsDoneToday()).asObservable();
      todayHabits.setData((await HabitsControl().getHabitsToday()).asObservable());
      allHabits.setData((await HabitsControl().getAllHabits()).asObservable());
    } catch (error) {
      user.setError(error);
      todayHabits.setError(error);
      allHabits.setError(error);
    }
  }

  @action
  void swipeSkyWidget(bool show) {
    visibilty = show;
  }

  @action
  void swipedPage(int index) {
    pageIndex = index;
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
