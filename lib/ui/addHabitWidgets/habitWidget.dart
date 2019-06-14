import 'package:flutter/material.dart';
import 'package:habit/ui/widgets/Toast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/ui/widgets/TutorialDialog.dart';
import 'package:habit/datas/dataHabitCreation.dart';

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
  double _iconHelpOpacity = 0.0;

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

//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      if (prefs.getBool("habitTutorial") == null) {
//        await showTutorial();
//        prefs.setBool("habitTutorial", true);
//      }
//    });

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
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,
                Widget child) =>
            new FadeTransition(opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
        pageBuilder: (BuildContext context, _, __) {
          return TutorialDialog(
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
          );
        }));
  }

  List getSuggestions() {
    List result = new List();
    List data = Suggestions.getHabits();
    String habit = widget.controller.text.toLowerCase();

    for (int i = 0; i < data.length; i++) {
      if (data[i][1].toLowerCase().contains(habit) && data[i][1].toLowerCase() != habit) {
        result.add(data[i]);
      }
    }

    return result;
  }

  void _onTextChanged() {
    String habit = widget.controller.text.toLowerCase();

    if (habit.length == 1 && _iconHelpOpacity != 1) {
      setState(() {
        _iconHelpOpacity = 1;
      });
    }

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
              color: validated ? widget.color : HabitColors.disableHabitCreation,
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.go,
                      onEditingComplete: _onTextDone,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _iconHelpOpacity = 0.0;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => IconsDialog(),
                            ).then((result) {
                              if (result != null && result != -1) {
                                setState(() {
                                  DataHabitCreation().icon = result;
                                });
                              }
                            });
                          },
                          child: Icon(
                            IconData(DataHabitCreation().icon, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Escreva seu hábito aqui",
                        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                      ),
                    ),
                    Positioned(
                      top: -29,
                      left: 16,
                      child: AnimatedOpacity(
                        opacity: _iconHelpOpacity,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            "Clique no ícone para alterá-lo",
                            style: TextStyle(color: Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0))),
                        ),
                      ),
                    )
                  ],
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
                        String text = suggestion[position][1];
                        int icon = suggestion[position][0];

                        widget.controller.value = new TextEditingValue(text: text);

                        setState(() {
                          DataHabitCreation().icon = icon;
                          _iconHelpOpacity = 0.0;
                        });

                        _validate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Icon(
                              IconData(suggestion[position][0], fontFamily: 'MaterialIcons'),
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              suggestion[position][1],
                              style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w300),
                            ),
                          ],
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

class IconsDialog extends StatelessWidget {
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
                return IconButton(
                  icon: Icon(IconData(icons[index], fontFamily: 'MaterialIcons'), size: 64),
                  onPressed: () {
                    Navigator.of(context).pop(icons[index]);
                  },
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
    0xeb4a,
  ];
}
