import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/controllers/HabitsControl.dart';
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
      // showToast("Ocorreu um erro");
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
    HabitsControl().setHabitDoneAndScore(DateTime.now().today, id, DonePageType.Initial).then((score) {
      _user.data.score += score;
      notifyListeners();
      return score;
    }).catchError((error) {
      // showToast("Ocorreu um erro");
      throw error;
    });
  }
}
