import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/ui/widgets/TutorialDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardTab extends StatefulWidget {
  RewardTab({Key key, this.category, this.controller, this.keyboard, this.onTap}) : super(key: key);

  final CategoryEnum category;
  final TextEditingController controller;
  final KeyboardVisibilityNotification keyboard;
  final Function onTap;

  @override
  _RewardTabState createState() => new _RewardTabState();
}

class _RewardTabState extends State<RewardTab> {
  FocusNode _focusNode;
  List suggestion;

  int _keyboardVisibilitySubscriberId;

  @override
  initState() {
    super.initState();

    _focusNode = FocusNode();
    suggestion = Suggestions.getRewards(widget.category);

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
      if (prefs.getBool("rewardTutorial") == null) {
        await showTutorial();
        prefs.setBool("rewardTutorial", true);
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
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => new TutorialDialog(
            title: "Qual sua meta?",
            texts: [
              "Em poucas palavras nos defina qual será sua meta principal com esse hábito.",
              "Com isso nós verificamos seu progresso em direção ao objetivo! Não é demais?!",
              "Se estiver com dúvidas temos alguns exemplos das atividades mais realizadas."
            ],
          ),
    );
  }

  void _onTextChanged() {
    List result = new List();
    String reward = widget.controller.text.toLowerCase();

    for (String text in Suggestions.getRewards(widget.category)) {
      if (text.toLowerCase().contains(reward)) {
        result.add(text);
      }
    }

    setState(() {
      suggestion = result;
    });
  }

  void _validate() {
    _focusNode.unfocus();
    String result = Validate.rewardTextValidate(widget.controller.text);

    if (result == null) {
      widget.onTap(true);
    } else {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: CategoryColors.getSecundaryColor(widget.category),
          textColor: Colors.white,
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
              margin: EdgeInsets.only(top: 64.0, left: 32.0),
              width: double.maxFinite,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Qual é sua meta?",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.help_outline, color: Colors.white,), onPressed: showTutorial),
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
              textInputAction: TextInputAction.go,
              onEditingComplete: _validate,
              style: TextStyle(fontSize: 16.0),
              decoration: InputDecoration.collapsed(
                  hintText: "Escreva aqui", hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
            ),
          ),
          Expanded(
            flex: 8,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: suggestion.length,
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      suggestion[position],
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
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
                  onPressed: _validate,
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
