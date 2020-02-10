import 'package:flutter/material.dart';
import 'package:altitude/ui/widgets/generic/Toast.dart';
import 'package:altitude/utils/Util.dart';
import 'package:altitude/utils/Validator.dart';
import 'package:altitude/utils/Color.dart';
import 'package:altitude/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:altitude/ui/dialogs/TutorialDialog.dart';
import 'package:altitude/datas/dataHabitCreation.dart';
import 'package:altitude/services/SharedPref.dart';

class HabitWidget extends StatefulWidget {
  HabitWidget({Key key, this.color, this.controller, this.keyboard}) : super(key: key);

  final Color color;
  final TextEditingController controller;
  final KeyboardVisibilityNotification keyboard;

  @override
  _HabitWidgetState createState() => new _HabitWidgetState();
}

class _HabitWidgetState extends State<HabitWidget> {
  FocusNode _focusNode;
  List suggestion;
  int _keyboardVisibilitySubscriberId;

  bool validated = false;

  @override
  initState() {
    super.initState();

    _focusNode = FocusNode();
    suggestion = getSuggestions();

    _keyboardVisibilitySubscriberId = widget.keyboard.addNewListener(
      onChange: (bool visible) {
        if (!visible && DataHabitCreation().lastTextEdited == 0) {
          _focusNode.unfocus();
          _validate();
        }
      },
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        DataHabitCreation().lastTextEdited = 0;
      }
    });

    widget.controller.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await SharedPref().getHabitTutorial()) {
        await showTutorial();
        await SharedPref().setHabitTutorial(true);
      }
    });

    if (widget.controller.text.isNotEmpty) {
      _validate();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.keyboard.removeListener(_keyboardVisibilitySubscriberId);
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  Future showTutorial() async {
    Util.dialogNavigator(
        context,
        TutorialDialog(
          hero: "helpHabit",
          texts: [
            TextSpan(
              text:
                  "  Vamos começar escolhendo qual será o hábito que deseja construir no seu cotidiano e depois com que frequência deseja realizá-lo.",
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
            ),
            TextSpan(
              text: "\n\n  O segredo para conseguir construir um hábito é ",
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
            ),
            TextSpan(
              text: "criar um ritual e sempre fazer a mesma coisa.",
              style: TextStyle(color: Colors.black, fontSize: 18.0, height: 1.2),
            ),
          ],
        ));
  }

  List getSuggestions() {
    List result = new List();
    List data = Suggestions.getHabits();
    String habit = widget.controller.text.toLowerCase();

    for (int i = 0; i < data.length; i++) {
      String word = data[i].trim().toLowerCase();
      if (word.contains(habit) && word != habit) {
        result.add(data[i]);
      }
    }

    return result;
  }

  void _onTextChanged() {
    setState(() {
      suggestion = getSuggestions();
    });
  }

  void _onTextDone() {
    _validate();

    if (validated) {
      _focusNode.unfocus();
    }
  }

  void _validate() {
    String result = Validate.habitTextValidate(widget.controller.text);

    if (result == null) {
      validated = true;
    } else {
      validated = false;
      showToast(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32.0, left: 40),
      child: Column(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(left: 16),
            child: Row(
              children: <Widget>[
                Text(
                  "Qual será seu hábito?",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                IconButton(
                  icon: new Hero(
                    tag: "helpHabit",
                    child: Icon(
                      Icons.help_outline,
                    ),
                  ),
                  onPressed: showTutorial,
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              color: validated ? widget.color : AppColors.disableHabitCreation,
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.go,
                  onEditingComplete: _onTextDone,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: "Escreva seu hábito aqui",
                    hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  ),
                ),
                suggestion.length != 0
                    ? Container(
                        height: 0.25,
                        color: Colors.white,
                        width: double.maxFinite,
                        margin: EdgeInsets.only(right: 30, left: 30, top: 4),
                      )
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  padding: suggestion.length != 0 ? EdgeInsets.only(top: 12, bottom: 8) : EdgeInsets.all(0),
                  physics: BouncingScrollPhysics(),
                  itemCount: suggestion.length < 5 ? suggestion.length : 5,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      onTap: () {
                        String text = suggestion[position];

                        widget.controller.value = new TextEditingValue(text: text);

                        _validate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          suggestion[position],
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
