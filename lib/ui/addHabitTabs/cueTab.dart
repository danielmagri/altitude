import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/utils/Validator.dart';

class CueTab extends StatefulWidget {
  CueTab({Key key, this.controller, this.onTap}) : super(key: key);

  final TextEditingController controller;
  final Function onTap;

  @override
  _CueTabState createState() => new _CueTabState();
}

class _CueTabState extends State<CueTab> {
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
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(0.0, 1.0),
            child: Text("Texto explicando sobre a deixa"),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(-0.6, 0.6),
            child: Text(
              "Qual será sua deixa?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: widget.controller,
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
          child: Text("Lista das sugestões"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                widget.onTap(false);
              },
              child: const Text("VOLTAR"),
            ),
            RaisedButton(
              onPressed: validate,
              child: const Text("CRIAR"),
            ),
          ],
        ),
      ],
    );
  }
}
