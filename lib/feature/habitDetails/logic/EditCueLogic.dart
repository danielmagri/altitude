import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/utils/Suggestions.dart';
import 'package:flutter/material.dart' show Color;
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'EditCueLogic.g.dart';

class EditCueLogic = _EditCueLogicBase with _$EditCueLogic;

abstract class _EditCueLogicBase with Store {
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;
  final HabitDetailsLogic habitDetailsLogic = GetIt.I.get<HabitDetailsLogic>();

  Color get habitColor => habitDetailsLogic.habitColor;
  String get cue => habitDetailsLogic.habit.data.oldCue;

  @observable
  bool showAllTutorialText = false;

  @observable
  ObservableList<String> suggestions = ObservableList();

  _EditCueLogicBase() {
    fetchSuggestions(habitDetailsLogic.habit.data.oldCue);
  }

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
    Habit habit = habitDetailsLogic.habit.data;
    habit.oldCue = cue;

    return (await _habitUseCase.updateHabit(habit)).result((data) {
      habitDetailsLogic.editCueCallback(cue);
      return true;
    }, (error) => throw error);
  }

  Future<bool> removeCue() async {
    Habit habit = habitDetailsLogic.habit.data;
    habit.oldCue = null;

    return (await _habitUseCase.updateHabit(habit)).result((data) {
      habitDetailsLogic.editCueCallback(null);
      return true;
    }, (error) => throw error);
  }
}
