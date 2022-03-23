import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart';
import 'package:altitude/utils/Suggestions.dart';
import 'package:flutter/material.dart' show Color;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'edit_cue_controller.g.dart';

@LazySingleton()
class EditCueController = _EditCueControllerBase with _$EditCueController;

abstract class _EditCueControllerBase with Store {
  final HabitUseCase _habitUseCase;
  final HabitDetailsController habitDetailsLogic;
  final IFireAnalytics _fireAnalytics;

  Color get habitColor => habitDetailsLogic!.habitColor;
  String? get cue => habitDetailsLogic!.habit.data!.oldCue;

  @observable
  bool showAllTutorialText = false;

  @observable
  ObservableList<String> suggestions = ObservableList();

  _EditCueControllerBase(this._habitUseCase, this._fireAnalytics, this.habitDetailsLogic) {
    fetchSuggestions(habitDetailsLogic!.habit.data!.oldCue!);
  }

  @action
  void showAllCueText() {
    showAllTutorialText = true;
  }

  @action
  void fetchSuggestions(String text) {
    ObservableList<String> result = ObservableList();
    String cue = text.toLowerCase().trim();

    for (String text in Suggestions.getCues() as Iterable<String>) {
      if (text.toLowerCase().contains(cue) && text.toLowerCase() != cue) {
        result.add(text);
      }
    }

    suggestions = result;
  }

  Future<bool> saveCue(String cue) async {
    Habit habit = habitDetailsLogic!.habit.data!;
    habit.oldCue = cue;

    return (await _habitUseCase!.updateHabit(habit)).result((data) {
      _fireAnalytics!.sendSetCue(habit.habit, cue);
      habitDetailsLogic!.editCueCallback(cue);
      return true;
    }, ((error) => throw error));
  }

  Future<bool> removeCue() async {
    Habit habit = habitDetailsLogic!.habit.data!;
    habit.oldCue = null;

    return (await _habitUseCase!.updateHabit(habit)).result((data) {
      _fireAnalytics!.sendRemoveCue(habit.habit);
      habitDetailsLogic!.editCueCallback(null);
      return true;
    }, ((error) => throw error));
  }
}
