import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class HabitTab extends StatefulWidget {
  HabitTab({Key key, this.category, this.controller, this.keyboard, this.onTap}) : super(key: key);

  final CategoryEnum category;
  final TextEditingController controller;
  final KeyboardVisibilityNotification keyboard;
  final Function onTap;

  @override
  _HabitTabState createState() => new _HabitTabState();
}

class _HabitTabState extends State<HabitTab> {
  FocusNode _focusNode;
  int iconId = 0xe028;
  List suggestion;

  int _keyboardVisibilitySubscriberId;

  @override
  initState() {
    super.initState();

    _focusNode = FocusNode();
    suggestion = Suggestions.getHabits(widget.category);

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
    List data = Suggestions.getHabits(widget.category);
    String reward = widget.controller.text.toLowerCase();

    for (int i = 0; i < data.length; i++) {
      if (data[i][1].toLowerCase().contains(reward)) {
        result.add(data[i]);
      }
    }

    setState(() {
      suggestion = result;
    });
  }

  void _validate() {
    String result = Validate.habitTextValidate(widget.controller.text);

    if (result == null) {
      widget.onTap(true, iconId);
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
              "Qual será seu hábito?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
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
              decoration: InputDecoration(
                icon: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(),
                    ).then((result) {
                      if (result != -1) {
                        setState(() {
                          iconId = result;
                        });
                      }
                    });
                  },
                  child: Icon(
                    IconData(iconId, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                  ),
                ),
                hintText: "Escreva aqui",
                hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                border: InputBorder.none,
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
                    String text = suggestion[position][1];
                    int cursor = text.indexOf('_');

                    text = text.replaceFirst('_', '');

                    widget.controller.value =
                        new TextEditingValue(text: text, selection: TextSelection.collapsed(offset: cursor));

                    if (cursor == -1) {
                      _focusNode.unfocus();
                    } else {
                      FocusScope.of(context).requestFocus(_focusNode);
                    }

                    setState(() {
                      iconId = suggestion[position][0];
                    });
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          Icon(IconData(suggestion[position][0], fontFamily: 'MaterialIcons')),
                          Text(
                            suggestion[position][1],
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                          ),
                        ],
                      )),
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
                    widget.onTap(false, null);
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

class CustomDialog extends StatelessWidget {
  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(top: 16.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Escolha um ícone para ser hábito:",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: new GridView.builder(
              itemCount: icons.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(icons[index]);
                  },
                  child: Icon(IconData(icons[index], fontFamily: 'MaterialIcons'), size: 64),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop(-1); // To close the dialog
              },
              child: Text("Cancelar"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  final List icons = [
    0xe190,
    0xe92c,
    0xe1fe,
    0xe630,
    0xe195,
    0xeb3c,
    0xe865,
    0xe019,
    0xe0e6,
    0xe226,
    0xe227,
    0xe3a1,
    0xeb3e,
    0xe3ae,
    0xe868,
    0xe869,
    0xe0af,
    0xe7e9,
    0xe0b0,
    0xe574,
    0xeb41,
    0xeb42,
    0xe3b7,
    0xe30a,
    0xe150,
    0xe870,
    0xe873,
    0xe52f,
    0xe532,
    0xe530,
    0xe531,
    0xe566,
    0xe876,
    0xe151,
    0xe0be,
    0xe56d,
    0xe903,
    0xe87b,
    0xe87c,
    0xe57a,
    0xe87d,
    0xe90d,
    0xeb43,
    0xe153,
    0xe243,
    0xeb44,
    0xeb45,
    0xe7ef,
    0xe310,
    0xe3f3,
    0xe88a,
    0xeb46,
    0xe53a,
    0xe312,
    0xeb47,
    0xe3f7,
    0xe90f,
    0xe540,
    0xe556,
    0xe544,
    0xe545,
    0xe547,
    0xe54a,
    0xe553,
    0xe557,
    0xe028,
    0xe91d,
    0xeb48,
    0xe8b1,
    0xe56c,
    0xe921,
    0xe80c,
    0xe815,
    0xe8d1,
    0xe425,
    0xe333,
    0xe16b,
  ];
}
