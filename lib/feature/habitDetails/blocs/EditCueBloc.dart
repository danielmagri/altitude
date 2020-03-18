import 'dart:async';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/utils/Color.dart';
import 'package:altitude/utils/Suggestions.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart' show TextEditingController, Color, ScrollController, Curves, BuildContext;
import 'package:keyboard_visibility/keyboard_visibility.dart';

class EditCueBloc extends BlocBase {
  final Habit habit;
  final Function(String) callback;

  Color get habitColor => AppColors.habitsColor[habit.color];

  KeyboardVisibilityNotification keyboardVisibilityNotification = new KeyboardVisibilityNotification();
  ScrollController scrollController = new ScrollController();
  TextEditingController textEditingController = new TextEditingController();
  TapGestureRecognizer tapGestureRecognizer = new TapGestureRecognizer();

  // Cue Text Show
  StreamController<bool> _cueTextShowStreamController = StreamController();
  Stream<bool> get cueTextShowStream => _cueTextShowStreamController.stream;

  // Suggestion List
  StreamController<List<String>> _suggestionListStreamController = StreamController();
  Stream<List<String>> get suggestionListStream => _suggestionListStreamController.stream;

  EditCueBloc(this.habit, this.callback) {
    // Seta o gatilho no textField
    textEditingController.text = habit.cue;

    keyboardVisibilityNotification.addNewListener(
      onChange: (bool visible) {
        if (visible) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      },
    );

    // Ao clicar em "Saiba mais"
    tapGestureRecognizer.onTap = showAllCueText;

    fetchSuggestions(habit.cue);
  }

  @override
  void dispose() {
    _cueTextShowStreamController.close();
    _suggestionListStreamController.close();

    keyboardVisibilityNotification.dispose();
    scrollController.dispose();
    textEditingController.dispose();
    tapGestureRecognizer.dispose();
  }

  void showAllCueText() {
    _cueTextShowStreamController.sink.add(true);
  }

  void onTextChanged(String text) {
    fetchSuggestions(text);
  }

  void fetchSuggestions(String text) {
    List<String> result = new List();
    String cue = text.toLowerCase().trim();

    for (String text in Suggestions.getCues()) {
      if (text.toLowerCase().contains(cue) && text.toLowerCase() != cue) {
        result.add(text);
      }
    }

    _suggestionListStreamController.sink.add(result);
  }

  void saveCue(BuildContext context) async {
    String validate = ValidationHandler.cueTextValidate(textEditingController.text);

    if (validate == null) {
      showLoading(context);
      HabitsControl().updateCue(habit.id, habit.habit, textEditingController.text).then((result) {
        hideLoading(context);
        callback(textEditingController.text);
      }).catchError((error) {
        hideLoading(context);
        showToast("Ocorreu um erro");
      });
    } else {
      showToast(validate);
    }
  }

  void removeCue(BuildContext context) {
    showLoading(context);
    HabitsControl().updateCue(habit.id, habit.habit, null).then((result) {
      hideLoading(context);
      callback(null);
    }).catchError((error) {
      hideLoading(context);
      showToast("Ocorreu um erro");
    });
  }
}
