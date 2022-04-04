import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/view/dialog/base_dialog.dart';
import 'package:altitude/common/view/generic/toast.dart';
import 'package:altitude/presentation/habits/models/dayweek_selection.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        Color,
        Colors,
        Column,
        Container,
        EdgeInsets,
        TextButton,
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
        WrapAlignment;

class DayweekDialog extends StatefulWidget {
  const DayweekDialog({required this.color, Key? key, this.frequency})
      : super(key: key);

  final Color color;
  final DayWeek? frequency;

  @override
  _DayweekDialogState createState() => _DayweekDialogState();
}

class _DayweekDialogState extends State<DayweekDialog> {
  List<DayweekSelection> days = [
    DayweekSelection('Domingo'),
    DayweekSelection('Segunda-feira'),
    DayweekSelection('Terça-feira'),
    DayweekSelection('Quarta-feira'),
    DayweekSelection('Quinta-feira'),
    DayweekSelection('Sexta-feira'),
    DayweekSelection('Sábado')
  ];

  @override
  void initState() {
    super.initState();

    if (widget.frequency != null) {
      days[0].state = widget.frequency!.sunday! ? true : false;
      days[1].state = widget.frequency!.monday! ? true : false;
      days[2].state = widget.frequency!.tuesday! ? true : false;
      days[3].state = widget.frequency!.wednesday! ? true : false;
      days[4].state = widget.frequency!.thursday! ? true : false;
      days[5].state = widget.frequency!.friday! ? true : false;
      days[6].state = widget.frequency!.saturday! ? true : false;
    }
  }

  void _validate() {
    if (days.any((element) => element.state == true)) {
      DayWeek dayWeek = DayWeek(
        monday: days[1].state,
        tuesday: days[2].state,
        wednesday: days[3].state,
        thursday: days[4].state,
        friday: days[5].state,
        saturday: days[6].state,
        sunday: days[0].state,
      );

      Navigator.of(context).pop(dayWeek);
    } else {
      showToast('Selecione pelo menos um dia da semana');
    }
  }

  @override
  Widget build(context) {
    return BaseDialog(
      title: 'Diariamente',
      body: Column(
        children: [
          const Text(
            'Escolha quais dias da semana você irá realizar o hábito:',
          ),
          const SizedBox(height: 16.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: days
                .map(
                  (day) => GestureDetector(
                    onTap: () {
                      setState(() {
                        day.state = !day.state;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: day.state
                            ? widget.color
                            : const Color.fromARGB(255, 220, 220, 220),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        day.title,
                        style: TextStyle(
                          color: day.state ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      action: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _validate,
          child: const Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
