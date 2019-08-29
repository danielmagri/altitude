import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habit/utils/Suggestions.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class EditCueDialog extends StatefulWidget {
  EditCueDialog({Key key, @required this.closeBottomSheet}) : super(key: key);

  final Function closeBottomSheet;

  @override
  _EditCueDialogState createState() => new _EditCueDialogState();
}

class _EditCueDialogState extends State<EditCueDialog> {
  KeyboardVisibilityNotification _keyboardVisibilityNotification =
      new KeyboardVisibilityNotification();
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _controller = new TextEditingController();

  List _suggestion;
  bool showAll = false;

  @override
  initState() {
    super.initState();

    if (DataHabitDetail().habit.cue != null) {
      _controller.text = DataHabitDetail().habit.cue;
    }

    _suggestion = getSuggestion();

    _controller.addListener(_onTextChanged);

    _keyboardVisibilityNotification.addNewListener(
      onChange: (bool visible) {
        if (visible) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      },
    );

    // Ao clicar em "Saiba mais"
    _tapGestureRecognizer.onTap = () {
      setState(() {
        showAll = true;
      });
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _tapGestureRecognizer.dispose();
    _keyboardVisibilityNotification.dispose();
    super.dispose();
  }

  List getSuggestion() {
    List result = new List();
    String cue = _controller.text.toLowerCase();

    for (String text in Suggestions.getCues()) {
      if (text.toLowerCase().contains(cue) && text.toLowerCase() != cue) {
        result.add(text);
      }
    }

    return result;
  }

  void _onTextChanged() {
    setState(() {
      _suggestion = getSuggestion();
    });
  }

  void _onTextDone() {
    _validateAndSave();
  }

  void _validateAndSave() async {
    String result = Validate.cueTextValidate(_controller.text);

    if (result == null) {
      await DataControl().updateCue(DataHabitDetail().habit.id,
          DataHabitDetail().habit.habit, _controller.text);
      DataHabitDetail().habit.cue = _controller.text;
      widget.closeBottomSheet();
    } else {
      showToast(result);
    }
  }

  void _remove() async {
    await DataControl().updateCue(
        DataHabitDetail().habit.id, DataHabitDetail().habit.habit, null);
    DataHabitDetail().habit.cue = null;
    widget.closeBottomSheet();
  }

  List<TextSpan> _texts() {
    if (showAll) {
      return [
        TextSpan(
          text:
              "Todo hábito precisa de um \"gatilho\" para que ele se inicie. Mas o que seria esse gatilho?",
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text:
              "\n  O gatilho é uma ação que estímula seu cérebro a realizar o hábito.",
          style: TextStyle(color: Colors.black, fontSize: 17.0, height: 1.2),
        ),
        TextSpan(
          text:
              " Por exemplo ao deixar sua roupa de corrida do lado da cama pode ser uma boa forma de iniciar seu hábito de correr de manhã.",
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text:
              "\n\n  Qual seria um gatilho (ação) a ser tomado para que você realize seu hábito? Escreva ela para nós e te lembraremos de faze-la todas as vezes!",
          style: TextStyle(color: Colors.black, fontSize: 17.0),
        ),
      ];
    } else {
      return [
        TextSpan(
          text:
              "Todo hábito precisa de um \"gatilho\" para que ele se inicie. Mas o que seria esse gatilho? ",
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text: "Continuar lendo...",
          recognizer: _tapGestureRecognizer,
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              decoration: TextDecoration.underline),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            height: 30,
            child: Text(
              "Gatilho",
              style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                  color: DataHabitDetail().getColor()),
            ),
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              children: _texts(),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height * 0.8) - 140,
            width: double.maxFinite,
            child: Column(
              children: <Widget>[
                Spacer(),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.go,
                  onEditingComplete: _onTextDone,
                  minLines: 1,
                  maxLines: 2,
                  style: TextStyle(fontSize: 19),
                  cursorColor: DataHabitDetail().getColor(),
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: DataHabitDetail().getColor())),
                      hintText: "Escreva aqui seu gatilho",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                ),
                _suggestion.length != 0
                    ? Container(
                        height: 0.25,
                        width: double.maxFinite,
                        margin: EdgeInsets.only(right: 30, left: 30, top: 4),
                      )
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: _suggestion.length != 0
                      ? EdgeInsets.only(top: 12, bottom: 8)
                      : EdgeInsets.all(0),
                  itemCount: _suggestion.length < 3 ? _suggestion.length : 3,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      onTap: () {
                        String text = _suggestion[position];

                        _controller.value = new TextEditingValue(text: text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _suggestion[position],
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                    );
                  },
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    DataHabitDetail().habit.cue != null
                        ? FlatButton(
                            onPressed: _remove,
                            child: Text(
                              "Remover",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          )
                        : SizedBox(),
                    FlatButton(
                      onPressed: _validateAndSave,
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: DataHabitDetail().getColor()),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
