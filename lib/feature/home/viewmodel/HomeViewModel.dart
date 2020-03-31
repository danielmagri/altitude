import 'package:altitude/common/Constants.dart' show MAX_HABITS;
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/services/FireAnalytics.dart';
import 'package:altitude/common/services/SharedPref.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/controllers/LevelControl.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/feature/home/model/User.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class HomeViewModel extends ChangeNotifier {
  DataState<User> _user = DataState();
  DataState<User> get user => _user;

  DataState<List<Habit>> _todayHabits = DataState();
  DataState<List<Habit>> get todayHabits => _todayHabits;

  DataState<List<Habit>> _allHabits = DataState();
  DataState<List<Habit>> get allHabits => _allHabits;

  DataState<List<DayDone>> _doneHabits = DataState();
  DataState<List<DayDone>> get doneHabits => _doneHabits;

  int _pageIndex = 1;
  int get pageIndex => _pageIndex;

  bool visibilty = false;

  HomeViewModel() {
    fetchData();
  }

  void fetchData() async {
    try {
      _user.data = await UserControl().getUserData();
      _todayHabits.data = await HabitsControl().getHabitsToday();
      _allHabits.data = await HabitsControl().getAllHabits();
      _doneHabits.data = await HabitsControl().getHabitsDoneToday();

      notifyListeners();
    } catch (error) {
      _user.error = error;
      _todayHabits.error = error;
      _allHabits.error = error;
      _doneHabits.error = error;

      notifyListeners();
    }
  }

  void swipeSkyWidget(bool show) {
    visibilty = show;
    notifyListeners();
  }

  void swipedPage(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<int> completeHabit(int id) async {
    int earnedScore = await HabitsControl().setHabitDoneAndScore(DateTime.now().today, id, DonePageType.Initial);
    _user.data.score += earnedScore;
    _doneHabits.data.add(DayDone(dateDone: DateTime.now().today, habitId: id));
    notifyListeners();
    return _user.data.score;
  }

  Future<bool> checkLevelUp(int newScore) async {
    int newLevel = LevelControl.getLevel(newScore);
    int oldLevel = await SharedPref().getLevel();

    if (newLevel != oldLevel) SharedPref().setLevel(newLevel);

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
