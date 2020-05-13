import 'dart:async' show StreamSubscription;
import 'package:altitude/common/view/dialog/TutorialDialog.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:flutter/material.dart'
    show
        BorderSide,
        Color,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        FocusNode,
        FontWeight,
        GestureDetector,
        Hero,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        Key,
        Navigator,
        Padding,
        Row,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextEditingController,
        TextEditingValue,
        TextField,
        TextInputAction,
        TextSpan,
        TextStyle,
        UnderlineInputBorder,
        Widget;
import 'package:altitude/utils/Suggestions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:altitude/core/extensions/NavigatorExtension.dart';

class HabitText extends StatefulWidget {
  HabitText({Key key, this.color, this.controller}) : super(key: key);

  final Color color;
  final TextEditingController controller;

  @override
  _HabitTextState createState() => _HabitTextState();
}

class _HabitTextState extends State<HabitText> {
  FocusNode focusHabit = FocusNode();
  StreamSubscription<bool> keyboardVisibility;

  List<String> suggestions;

  String validated;

  @override
  initState() {
    super.initState();

    suggestions = getSuggestions();

    keyboardVisibility = KeyboardVisibility.onChange.listen((visible) {
      if (!visible) {
        focusHabit.unfocus();
        _validate();
      }
    });

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    focusHabit.dispose();
    keyboardVisibility.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void showTutorial() {
    Navigator.of(context).smooth(TutorialDialog(
      hero: "helpHabit",
      texts: const [
        TextSpan(text: "  Vamos começar escolhendo qual será o hábito que deseja construir no seu cotidiano."),
        TextSpan(text: "\n\n  O segredo para conseguir construir um hábito é "),
        TextSpan(text: "criar um ritual e sempre fazer a mesma coisa.", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ));
  }

  List<String> getSuggestions() {
    var data = Suggestions.getHabits();
    String habit = widget.controller.text.trim().toLowerCase();

    var list = data.where((e) => e.trim().toLowerCase().contains(habit) && e.trim().toLowerCase() != habit).toList();
    if (list.length > 5) {
      list.removeRange(5, list.length);
    }
    return list;
  }

  void suggestionSelected(String text) {
    widget.controller.value = TextEditingValue(text: text);
    focusHabit.unfocus();
    _validate();
  }

  void _onTextChanged() {
    setState(() {
      suggestions = getSuggestions();
      validated = null;
    });
  }

  void _validate() {
    setState(() {
      validated = ValidationHandler.habitTextValidate(widget.controller.text);
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text("Qual será seu hábito?", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            IconButton(icon: const Hero(tag: "helpHabit", child: Icon(Icons.help_outline)), onPressed: showTutorial),
          ]),
          TextField(
            controller: widget.controller,
            focusNode: focusHabit,
            textInputAction: TextInputAction.done,
            style: const TextStyle(fontSize: 18),
            cursorColor: widget.color,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              hintText: "Escreva seu hábito",
              hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              errorText: validated,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.color, width: 2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.color, width: 2)),
            ),
          ),
          const SizedBox(height: 10),
          validated == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: suggestions
                      .map((suggestion) => GestureDetector(
                          onTap: () => suggestionSelected(suggestion),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(suggestion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                          )))
                      .toList())
              : const SizedBox(),
        ],
      ),
    );
  }
}
