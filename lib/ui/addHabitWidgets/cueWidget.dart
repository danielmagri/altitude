import 'package:flutter/material.dart';
import 'package:habit/ui/widgets/Toast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/ui/widgets/TutorialDialog.dart';
import 'package:habit/utils/enums.dart';

class CueWidget extends StatefulWidget {
  CueWidget({Key key, this.color, this.controller, this.keyboard}) : super(key: key);

  final Color color;
  final TextEditingController controller;
  final KeyboardVisibilityNotification keyboard;

  @override
  _CueWidgetState createState() => new _CueWidgetState();
}

class _CueWidgetState extends State<CueWidget> {
  FocusNode _focusNode;
  List suggestion;
  int _keyboardVisibilitySubscriberId;

  bool validated = false;

  @override
  initState() {
    super.initState();

    _focusNode = FocusNode();
    suggestion = getSuggestion();

    _keyboardVisibilitySubscriberId = widget.keyboard.addNewListener(
      onChange: (bool visible) {
        if (!visible && _focusNode.hasFocus) {
          print("CUE KEYBORAD");
          _focusNode.unfocus();
          _validate();
        }
      },
    );

    widget.controller.addListener(_onTextChanged);

//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      if (prefs.getBool("cueTutorial") == null) {
//        await showTutorial();
//        prefs.setBool("cueTutorial", true);
//      }
//    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.keyboard.removeListener(_keyboardVisibilitySubscriberId);
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  Future showTutorial() async {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,
                Widget child) =>
            new FadeTransition(opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
        pageBuilder: (BuildContext context, _, __) {
          return TutorialDialog(
            hero: "helpCue",
            texts: [
              TextSpan(
                text: "  Todo hábito precisa de uma \"deixa\" para que ele se inicie.. mas o que seria essa deixa?",
                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
              ),
              TextSpan(
                text: "\n  A deixa é uma ação que estímula seu cérebro a realizar alguma ação (um hábito).",
                style: TextStyle(color: Colors.black, fontSize: 18.0, height: 1.2),
              ),
              TextSpan(
                text:
                    " Por exemplo ao deixar sua roupa de corrida do lado da cama pode ser uma boa forma de iniciar seu hábito de correr de manhã.",
                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
              ),
              TextSpan(
                text:
                    "\n\n  Qual seria uma deixa (ação) a ser tomada para que você realize seu hábito? Escreva ela para nós e te lembraremos de faze-la todas as vezes!",
                style: TextStyle(color: Colors.black, fontSize: 18.0, height: 1.2),
              ),
            ],
          );
        }));
  }

  List getSuggestion() {
    List result = new List();
    String cue = widget.controller.text.toLowerCase();

    for (String text in Suggestions.getCues(CategoryEnum.PHYSICAL)) {
      if (text.toLowerCase().contains(cue) && text.toLowerCase() != cue) {
        result.add(text);
      }
    }

    return result;
  }

  void _onTextChanged() {
    setState(() {
      suggestion = getSuggestion();
    });
  }

  void _onTextDone() {
    _validate();

    if (validated) {
      _focusNode.unfocus();
    }
  }

  void _validate() {
    String result = Validate.cueTextValidate(widget.controller.text);

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
                  "Qual será sua deixa?",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                IconButton(
                  icon: new Hero(
                    tag: "helpCue",
                    child: Icon(
                      Icons.help_outline,
                    ),
                  ),
                  onPressed: showTutorial,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              color: validated ? widget.color : HabitColors.disableHabitCreation,
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
                  decoration: InputDecoration.collapsed(
                      hintText: "Escreva aqui sua deixa",
                      hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
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
                  physics: BouncingScrollPhysics(),
                  padding: suggestion.length != 0 ? EdgeInsets.only(top: 12, bottom: 8) : EdgeInsets.all(0),
                  itemExtent: 40,
                  itemCount: suggestion.length < 5 ? suggestion.length : 5,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      onTap: () {
                        String text = suggestion[position];

                        widget.controller.value = new TextEditingValue(text: text);

                        _validate();
                      },
                      child: Text(
                        suggestion[position],
                        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w300),
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
