import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/ui/widgets/TutorialDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CueTab extends StatefulWidget {
  CueTab({Key key, this.category, this.controller, this.keyboard, this.onTap}) : super(key: key);

  final CategoryEnum category;
  final TextEditingController controller;
  final KeyboardVisibilityNotification keyboard;
  final Function onTap;

  @override
  _CueTabState createState() => new _CueTabState();
}

class _CueTabState extends State<CueTab> {
  FocusNode _focusNode;
  List suggestion;

  int _keyboardVisibilitySubscriberId;

  @override
  initState() {
    super.initState();

    _focusNode = FocusNode();
    suggestion = getSuggestion();

    _keyboardVisibilitySubscriberId = widget.keyboard.addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          _focusNode.unfocus();
        }
      },
    );

    widget.controller.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("cueTutorial") == null) {
        await showTutorial();
        prefs.setBool("cueTutorial", true);
      }
    });
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
            texts: [
              TextSpan(
                text:
                "  Todo hábito precisa de uma \"deixa\" para que ele se inicie.. mas o que seria essa deixa?",
                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
              ),
              TextSpan(text: "\n  A deixa é uma ação que estímula seu cérebro a realizar alguma ação (um hábito).",
              style: TextStyle(color: Colors.black, fontSize: 18.0, height: 1.2),),
              TextSpan(
                text: " Por exemplo ao deixar sua roupa de corrida do lado da cama pode uma ótima forma de iniciar seu hábito de correr de manhã.",
                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
              ),
              TextSpan(
                text: "\n\n  Qual seria uma deixa (ação) a ser tomada para que você realize seu hábito? Escreva ela para nós e te lembraremos de faze-la todas as vezes!",
                style: TextStyle(color: Colors.black, fontSize: 18.0, height: 1.2),
              ),
            ],
          );
        }));
  }

  List getSuggestion() {
    List result = new List();
    String cue = widget.controller.text.toLowerCase();

    for (String text in Suggestions.getCues(widget.category)) {
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

  void validate() {
    String result = Validate.cueTextValidate(widget.controller.text);

    if (result == null) {
      widget.onTap(true);
    } else {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color.fromARGB(255, 220, 220, 220),
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 60.0, left: 16.0, bottom: 60.0),
              width: double.maxFinite,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Qual será sua deixa?",
                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                  IconButton(
                      icon: new Hero(
                        tag: "help",
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.white,
                        ),
                        placeholderBuilder: (context, widget) => widget,
                      ),
                      onPressed: showTutorial),
                ],
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: CategoryColors.getSecundaryColor(widget.category),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.done,
              onEditingComplete: validate,
              style: TextStyle(fontSize: 16.0),
              decoration: InputDecoration.collapsed(
                  hintText: "Escreva aqui sua deixa", hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
            ),
          ),
          Expanded(
            flex: 8,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 36.0, right: 36.0, top: 16.0),
              itemExtent: 45.0,
              itemCount: suggestion.length < 5 ? suggestion.length : 5,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {
                    String text = suggestion[position];
                    int cursor = text.indexOf('_');

                    text = text.replaceFirst('_', '');

                    widget.controller.value =
                        new TextEditingValue(text: text, selection: TextSelection.collapsed(offset: cursor));

                    if (cursor == -1) {
                      _focusNode.unfocus();
                    } else {
                      FocusScope.of(context).requestFocus(_focusNode);
                    }
                  },
                  child: Text(
                    suggestion[position],
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: CategoryColors.getSecundaryColor(widget.category),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 31.0, vertical: 15.0),
                  elevation: 5.0,
                  onPressed: () {
                    widget.onTap(false);
                  },
                  child: const Text("VOLTAR"),
                ),
                RaisedButton(
                  color: CategoryColors.getSecundaryColor(widget.category),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  elevation: 5.0,
                  onPressed: validate,
                  child: const Text("AVANÇAR"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
