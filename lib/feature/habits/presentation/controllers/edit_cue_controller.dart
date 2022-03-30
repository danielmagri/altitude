import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/feature/habits/domain/usecases/update_habit_usecase.dart';
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart';
import 'package:altitude/utils/Suggestions.dart';
import 'package:flutter/material.dart' show Color;
import 'package:mobx/mobx.dart';
part 'edit_cue_controller.g.dart';

class EditCueController = _EditCueControllerBase with _$EditCueController;

abstract class _EditCueControllerBase with Store {
  final UpdateHabitUsecase _updateHabitUsecase;
  final HabitDetailsController habitDetailsLogic;
  final IFireAnalytics _fireAnalytics;

  _EditCueControllerBase(
      this._updateHabitUsecase, this._fireAnalytics, this.habitDetailsLogic) {
    fetchSuggestions(habitDetailsLogic.habit.data!.oldCue!);
  }

  Color get habitColor => habitDetailsLogic.habitColor;
  String? get cue => habitDetailsLogic.habit.data!.oldCue;

  @observable
  bool showAllTutorialText = false;

  @observable
  ObservableList<String> suggestions = ObservableList();

  @action
  void showAllCueText() {
    showAllTutorialText = true;
  }

  @action
  void fetchSuggestions(String text) {
    ObservableList<String> result = ObservableList();
    String cue = text.toLowerCase().trim();

    for (String text in Suggestions.getCues()) {
      if (text.toLowerCase().contains(cue) && text.toLowerCase() != cue) {
        result.add(text);
      }
    }

    suggestions = result;
  }

  Future<bool> saveCue(String cue) async {
    Habit habit = habitDetailsLogic.habit.data!;
    habit.oldCue = cue;

    return (await _updateHabitUsecase.call(UpdateHabitParams(habit: habit)))
        .result((data) {
      _fireAnalytics.sendSetCue(habit.habit, cue);
      habitDetailsLogic.editCueCallback(cue);
      return true;
    }, ((error) => throw error));
  }

  Future<bool> removeCue() async {
    Habit habit = habitDetailsLogic.habit.data!;
    habit.oldCue = null;

    return (await _updateHabitUsecase.call(UpdateHabitParams(habit: habit)))
        .result((data) {
      _fireAnalytics.sendRemoveCue(habit.habit);
      habitDetailsLogic.editCueCallback(null);
      return true;
    }, ((error) => throw error));
  }
}
