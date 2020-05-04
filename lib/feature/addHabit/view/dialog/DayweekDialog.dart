import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/feature/addHabit/model/DayweekSelection.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        Color,
        Colors,
        Column,
        Container,
        EdgeInsets,
        FlatButton,
        FontWeight,
        GestureDetector,
        Key,
        Navigator,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget,
        Wrap,
        WrapAlignment,
        required;

class DayweekDialog extends StatefulWidget {
  DayweekDialog({Key key, @required this.color, this.frequency}) : super(key: key);

  final Color color;
  final DayWeek frequency;

  @override
  _DayweekDialogState createState() => _DayweekDialogState();
}

class _DayweekDialogState extends State<DayweekDialog> {
  List<DayweekSelection> days = [
    DayweekSelection("Domingo"),
    DayweekSelection("Segunda-feira"),
    DayweekSelection("Terça-feira"),
    DayweekSelection("Quarta-feira"),
    DayweekSelection("Quinta-feira"),
    DayweekSelection("Sexta-feira"),
    DayweekSelection("Sábado")
  ];

  @override
  initState() {
    super.initState();

    if (widget.frequency != null) {
      days[0].state = widget.frequency.sunday == 1 ? true : false;
      days[1].state = widget.frequency.monday == 1 ? true : false;
      days[2].state = widget.frequency.tuesday == 1 ? true : false;
      days[3].state = widget.frequency.wednesday == 1 ? true : false;
      days[4].state = widget.frequency.thursday == 1 ? true : false;
      days[5].state = widget.frequency.friday == 1 ? true : false;
      days[6].state = widget.frequency.saturday == 1 ? true : false;
    }
  }

  void _validate() {
    if (days.any((element) => element.state == true)) {
      DayWeek dayWeek = DayWeek(
          monday: days[1].state ? 1 : 0,
          tuesday: days[2].state ? 1 : 0,
          wednesday: days[3].state ? 1 : 0,
          thursday: days[4].state ? 1 : 0,
          friday: days[5].state ? 1 : 0,
          saturday: days[6].state ? 1 : 0,
          sunday: days[0].state ? 1 : 0);

      Navigator.of(context).pop(dayWeek);
    } else {
      showToast("Selecione pelo menos um dia da semana");
    }
  }

  @override
  Widget build(context) {
    return BaseDialog(
      title: "Diariamente",
      body: Column(
        children: [
          const Text("Escolha quais dias da semana você irá realizar o hábito:"),
          const SizedBox(height: 16.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: days
                .map((day) => GestureDetector(
                      onTap: () {
                        setState(() {
                          day.state = !day.state;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: day.state ? widget.color : const Color.fromARGB(255, 220, 220, 220),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          day.title,
                          style: TextStyle(color: day.state ? Colors.white : Colors.black),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      action: [
        FlatButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
        FlatButton(onPressed: _validate, child: const Text("Ok", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }
}
