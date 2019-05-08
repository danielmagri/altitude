import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class CueTab extends StatefulWidget {
  CueTab({Key key, this.category, this.controller, this.keyboard, this.onTap}) : super(key: key);

  final Category category;
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
    suggestion = Suggestions.getCues(widget.category);

    _keyboardVisibilitySubscriberId = widget.keyboard.addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          _focusNode.unfocus();
        }
      },
    );

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.keyboard.removeListener(_keyboardVisibilitySubscriberId);
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    List result = new List();
    String reward = widget.controller.text.toLowerCase();

    for (String text in Suggestions.getCues(widget.category)) {
      if (text.toLowerCase().contains(reward)) {
        result.add(text);
      }
    }

    setState(() {
      suggestion = result;
    });
  }

  void validate() {
    String result = Validate.cueTextValidate(widget.controller.text);

    if (result == "") {
      widget.onTap(true);
    } else {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
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
            margin: EdgeInsets.only(top: 64.0, left: 32.0, bottom: 12.0),
            width: double.maxFinite,
            child: Text(
              "Qual será sua deixa?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.done,
              onEditingComplete: validate,
              style: TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                hintText: "Escreva aqui",
                filled: true,
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 16.0),
                  elevation: 5.0,
                  onPressed: validate,
                  child: const Text("CRIAR"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
