import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:flutter/material.dart'
    show
        Color,
        Colors,
        Column,
        Container,
        EdgeInsets,
        FontWeight,
        Key,
        MainAxisAlignment,
        Navigator,
        Row,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextStyle,
        Theme,
        Widget;
import 'package:numberpicker/numberpicker.dart';

class WeeklyDialog extends StatefulWidget {
  WeeklyDialog({Key key, this.color, this.frequency}) : super(key: key);

  final Color color;
  final Weekly frequency;

  @override
  _WeeklyDialogState createState() => new _WeeklyDialogState();
}

class _WeeklyDialogState extends State<WeeklyDialog> {
  int _currentValue;

  @override
  initState() {
    super.initState();

    if (widget.frequency != null) {
      _currentValue = widget.frequency.daysTime;
    } else {
      _currentValue = 3;
    }
  }

  void _validate() {
    Navigator.of(context).pop(Weekly(daysTime: _currentValue));
  }

  @override
  Widget build(context) {
    return BaseDialog(
      title: "Semanalmente",
      body: Theme(
        data: Theme.of(context).copyWith(accentColor: widget.color),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Escolha quantos vezes por semana você irá realizar o hábito:"),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NumberPicker.integer(
                    initialValue: _currentValue,
                    minValue: 1,
                    maxValue: 7,
                    listViewWidth: 45,
                    onChanged: (newValue) => setState(() => _currentValue = newValue),
                  ),
                  const Text("vezes por semana.", style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ],
          ),
        ),
      ),
      action: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar", style: TextStyle(color: Colors.black))),
        TextButton(
            onPressed: _validate,
            child: const Text("Ok", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      ],
    );
  }
}
