import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/utils/Suggestions.dart';
import 'package:flutter/material.dart' show Color;
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'EditCueLogic.g.dart';

class EditCueLogic = _EditCueLogicBase with _$EditCueLogic;

abstract class _EditCueLogicBase with Store {
  HabitDetailsLogic habitDetailsLogic = GetIt.I.get<HabitDetailsLogic>();

  Color get habitColor => habitDetailsLogic.habitColor;
  String get cue => habitDetailsLogic.habit.data.cue;

  @observable
  bool showAllTutorialText = false;

  @observable
  ObservableList<String> suggestions = ObservableList();

  _EditCueLogicBase() {
    fetchSuggestions(habitDetailsLogic.habit.data.cue);
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
    bool result =
        await HabitsControl().updateCue(habitDetailsLogic.habit.data.id, habitDetailsLogic.habit.data.habit, cue);
    habitDetailsLogic.editCueCallback(cue);
    return result;
  }

  Future<bool> removeCue() async {
    bool result =
        await HabitsControl().updateCue(habitDetailsLogic.habit.data.id, habitDetailsLogic.habit.data.habit, null);
    habitDetailsLogic.editCueCallback(null);
    return result;
  }
}
