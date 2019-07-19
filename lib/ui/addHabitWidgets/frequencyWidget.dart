import 'package:flutter/material.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/ui/widgets/Toast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:habit/datas/dataHabitCreation.dart';

class FrequencyWidget extends StatefulWidget {
  FrequencyWidget({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  _FrequencyWidgetState createState() => new _FrequencyWidgetState();
}

class _FrequencyWidgetState extends State<FrequencyWidget> {
  int chosen = -1;

  @override
  initState() {
    super.initState();

    if (DataHabitCreation().frequency != null) {
      switch (DataHabitCreation().frequency.runtimeType) {
        case FreqDayWeek:
          chosen = 0;
          break;
        case FreqWeekly:
          chosen = 1;
          break;
      }
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
            margin: const EdgeInsets.only(left: 16, bottom: 6),
            child: Text(
              "Qual a frequência do hábito?",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
          Column(
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DailyDialog(
                          color: widget.color,
                        ),
                  ).then((result) {
                    if (result != null) {
                      setState(() {
                        chosen = 0;
                      });
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    color: chosen != 0 ? HabitColors.disableHabitCreation : widget.color,
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Diariamente",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Ex. Segunda, Quarta e Sexta",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              InkWell(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => WeeklyDialog(
                          color: widget.color,
                        ),
                  ).then((result) {
                    if (result != null) {
                      setState(() {
                        chosen = 1;
                      });
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    color: chosen != 1 ? HabitColors.disableHabitCreation : widget.color,
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Semanalmente",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Ex. 3 vezes por semana",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyDialog extends StatefulWidget {
  DailyDialog({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  _DailyDialogState createState() => new _DailyDialogState();
}

class _DailyDialogState extends State<DailyDialog> {
  List<bool> days = [false, false, false, false, false, false, false];

  @override
  initState() {
    super.initState();

    if (DataHabitCreation().frequency != null && DataHabitCreation().frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek dayWeek = DataHabitCreation().frequency;

      days = [
        dayWeek.sunday == 1 ? true : false,
        dayWeek.monday == 1 ? true : false,
        dayWeek.tuesday == 1 ? true : false,
        dayWeek.wednesday == 1 ? true : false,
        dayWeek.thursday == 1 ? true : false,
        dayWeek.friday == 1 ? true : false,
        dayWeek.saturday == 1 ? true : false,
      ];
    }
  }

  void _validate() {
    if (days.contains(true)) {
      FreqDayWeek dayWeek = new FreqDayWeek(
          monday: days[1] ? 1 : 0,
          tuesday: days[2] ? 1 : 0,
          wednesday: days[3] ? 1 : 0,
          thursday: days[4] ? 1 : 0,
          friday: days[5] ? 1 : 0,
          saturday: days[6] ? 1 : 0,
          sunday: days[0] ? 1 : 0);

      DataHabitCreation().frequency = dayWeek;
      Navigator.of(context).pop(true);
    } else {
      showToast("Selecione pelo menos um dia da semana");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5.0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              "Diariamente",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text("Escolha quais dias da semana você irá realizar o hábito:"),
            SizedBox(height: 16.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      days[1] = !days[1];
                    });
                  },
                  child: DayWidget(
                    text: "Segunda-feira",
                    status: days[1],
                    color: widget.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      days[2] = !days[2];
                    });
                  },
                  child: DayWidget(
                    text: "Terça-feira",
                    status: days[2],
                    color: widget.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      days[3] = !days[3];
                    });
                  },
                  child: DayWidget(
                    text: "Quarta-feira",
                    status: days[3],
                    color: widget.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      days[4] = !days[4];
                    });
                  },
                  child: DayWidget(
                    text: "Quinta-feira",
                    status: days[4],
                    color: widget.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      days[5] = !days[5];
                    });
                  },
                  child: DayWidget(
                    text: "Sexta-feira",
                    status: days[5],
                    color: widget.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      days[6] = !days[6];
                    });
                  },
                  child: DayWidget(
                    text: "Sábado",
                    status: days[6],
                    color: widget.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      days[0] = !days[0];
                    });
                  },
                  child: DayWidget(
                    text: "Domingo",
                    status: days[0],
                    color: widget.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancelar"),
                    ),
                    FlatButton(
                      onPressed: _validate,
                      child: Text(
                        "Ok",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class DayWidget extends StatelessWidget {
  final String text;
  final bool status;
  final Color color;

  DayWidget({
    @required this.text,
    @required this.status,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: status ? color : Color.fromARGB(255, 220, 220, 220),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: status ? Colors.white : Colors.black),
      ),
    );
  }
}

class WeeklyDialog extends StatefulWidget {
  WeeklyDialog({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  _WeeklyDialogState createState() => new _WeeklyDialogState();
}

class _WeeklyDialogState extends State<WeeklyDialog> {
  int _currentValue;

  @override
  initState() {
    super.initState();

    if (DataHabitCreation().frequency != null && DataHabitCreation().frequency.runtimeType == FreqWeekly) {
      FreqWeekly weekly = DataHabitCreation().frequency;
      _currentValue = weekly.daysTime;
    } else {
      _currentValue = 3;
    }
  }

  void _validate() {
    DataHabitCreation().frequency = new FreqWeekly(daysTime: _currentValue);

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5.0,
      backgroundColor: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: widget.color),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Semanalmente",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text("Escolha quantos vezes por semana você irá realizar o hábito:"),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new NumberPicker.integer(
                    initialValue: _currentValue,
                    minValue: 1,
                    maxValue: 7,
                    listViewWidth: 45.0,
                    onChanged: (newValue) => setState(() => _currentValue = newValue),
                  ),
                  Text(
                    "vezes por semana.",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancelar"),
                      ),
                      FlatButton(
                        onPressed: _validate,
                        child: Text(
                          "Ok",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}