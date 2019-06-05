import 'package:flutter/material.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/utils/Color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:habit/datas/dataHabitCreation.dart';
import 'package:habit/objects/Reminder.dart';

class AlarmWidget extends StatefulWidget {
  AlarmWidget({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  _AlarmWidgetState createState() => new _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  int _chosen = -1;

  TimeOfDay _temporaryTime;
  List<bool> _daysSelected = [false, true, true, true, true, true, false];

  void _emptyData() {
    _chosen = -1;
    DataHabitCreation().reminders = new List();
    _temporaryTime = null;
    _daysSelected = [false, true, true, true, true, true, false];
  }

  double _containerHeight(int index) {
    if (_chosen == -1) {
      return 60;
    } else if (_chosen == 0) {
      if (index == 0) {
        return 115;
      } else {
        return 0;
      }
    } else if (_chosen == 1) {
      if (index == 1) {
        return 170;
      } else {
        return 0;
      }
    }
    return 0;
  }

  Widget _everyDayContent() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  padding: EdgeInsets.all(0),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _emptyData();
                    });
                  }),
              Text(
                "Lembrar todos os dias",
                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            child: InkWell(
              onTap: () {
                showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                          data: ThemeData.light().copyWith(
                            accentColor: widget.color,
                            primaryColor: widget.color,
                          ),
                          child: child);
                    }).then((time) {
                  setState(() {
                    _temporaryTime = time;
                    _validateEachDay();
                  });
                });
              },
              child: Text(
                _temporaryTime == null
                    ? "--:-- hrs"
                    : _temporaryTime.hour.toString().padLeft(2, '0') +
                        ":" +
                        _temporaryTime.minute.toString().padLeft(2, '0') +
                        " hrs",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eachDayContent() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  padding: EdgeInsets.all(0),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _emptyData();
                    });
                  }),
              Text(
                "Apenas em dias específicos",
                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            child: InkWell(
              onTap: () {
                showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                          data: ThemeData.light().copyWith(
                            accentColor: widget.color,
                            primaryColor: widget.color,
                          ),
                          child: child);
                    }).then((time) {
                  setState(() {
                    _temporaryTime = time;
                    _validateEachDay();
                  });
                });
              },
              child: Text(
                _temporaryTime == null
                    ? "--:-- hrs"
                    : _temporaryTime.hour.toString().padLeft(2, '0') +
                        ":" +
                        _temporaryTime.minute.toString().padLeft(2, '0') +
                        " hrs",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _weekdayWidget(),
            ),
          ),
        ],
      ),
    );
  }

  void _validateEachDay() {
    if (_temporaryTime != null) {
      DataHabitCreation().reminders = new List();
      for (int i = 0; i < 7; i++) {
        if (_chosen == 0) {
          DataHabitCreation()
              .reminders
              .add(new Reminder(hour: _temporaryTime.hour, minute: _temporaryTime.minute, weekday: i + 1));
        } else {
          if (_daysSelected[i]) {
            DataHabitCreation()
                .reminders
                .add(new Reminder(hour: _temporaryTime.hour, minute: _temporaryTime.minute, weekday: i + 1));
          }
        }
      }
    }
  }

  List<Widget> _weekdayWidget() {
    const List<String> days = ["D", "S", "T", "Q", "Q", "S", "S"];
    List<Widget> widgets = new List();

    for (int i = 0; i < 7; i++) {
      widgets.add(
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _daysSelected[i] = !_daysSelected[i];
                _validateEachDay();
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: _daysSelected[i] ? Border(bottom: BorderSide(color: Colors.white, width: 5)) : null),
              child: Text(
                days[i],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
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
              "Quando deseja ser lembrado da deixa?",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
          Column(
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                onTap: () {
                  setState(() {
                    _chosen = 0;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: double.maxFinite,
                  height: _containerHeight(0),
                  alignment: Alignment(-1, 0),
                  padding: EdgeInsets.symmetric(horizontal: _chosen != 1 ? 16 : 0, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    color: DataHabitCreation().reminders.length == 0 ? HabitColors.disableHabitCreation : widget.color,
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                  ),
                  child: _chosen != 0
                      ? Text(
                          "Lembrar todos os dias",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : _everyDayContent(),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              InkWell(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                onTap: () {
                  setState(() {
                    _chosen = 1;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: double.maxFinite,
                  height: _containerHeight(1),
                  alignment: Alignment(-1, 0),
                  padding: EdgeInsets.symmetric(horizontal: _chosen != 1 ? 16 : 0, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    color: DataHabitCreation().reminders.length == 0 ? HabitColors.disableHabitCreation : widget.color,
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                  ),
                  child: _chosen != 1
                      ? Text(
                          "Apenas em dias específicos",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : _eachDayContent(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeDialog extends StatefulWidget {
  TimeDialog({Key key, this.category, this.hour, this.minute}) : super(key: key);

  final Color category;
  final int hour;
  final int minute;

  @override
  _TimeDialogState createState() => new _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  int _hourValue;
  int _minuteValue;

  void _validate() {
//    DataHabitCreation().hour = _hourValue;
//    DataHabitCreation().minute = _minuteValue;

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
        data: Theme.of(context).copyWith(accentColor: Colors.yellow),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Horário",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text("Escolha que horas deseja de ser avisado:"),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new NumberPicker.integer(
                    initialValue: _hourValue,
                    minValue: 0,
                    maxValue: 23,
                    listViewWidth: 45.0,
                    onChanged: (newValue) => setState(() => _hourValue = newValue),
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  new NumberPicker.integer(
                    initialValue: _minuteValue,
                    minValue: 0,
                    maxValue: 59,
                    step: 5,
                    infiniteLoop: true,
                    listViewWidth: 45.0,
                    onChanged: (newValue) => setState(() => _minuteValue = newValue),
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

class DailyDialog extends StatefulWidget {
  DailyDialog({Key key, this.category}) : super(key: key);

  final Color category;

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
      Fluttertoast.showToast(
          msg: "Selecione pelo menos um dia da semana",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color.fromARGB(255, 220, 220, 220),
          textColor: Colors.black,
          fontSize: 16.0);
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
                    category: widget.category,
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
                    category: widget.category,
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
                    category: widget.category,
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
                    category: widget.category,
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
                    category: widget.category,
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
                    category: widget.category,
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
                    category: widget.category,
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
  final Color category;

  DayWidget({
    @required this.text,
    @required this.status,
    @required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: status ? Colors.yellow : Color.fromARGB(255, 220, 220, 220),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: status ? Colors.white : Colors.black),
      ),
    );
  }
}

class RepeatingDialog extends StatefulWidget {
  RepeatingDialog({Key key, this.category}) : super(key: key);

  final Color category;

  @override
  _RepeatingDialogState createState() => new _RepeatingDialogState();
}

class _RepeatingDialogState extends State<RepeatingDialog> {
  int _currentValue1;
  int _currentValue2;

  @override
  initState() {
    super.initState();

    if (DataHabitCreation().frequency != null && DataHabitCreation().frequency.runtimeType == FreqRepeating) {
      FreqRepeating repeating = DataHabitCreation().frequency;
      _currentValue1 = repeating.daysTime;
      _currentValue2 = repeating.daysCycle;
    } else {
      _currentValue1 = 5;
      _currentValue2 = 15;
    }
  }

  void _validate() {
    if (_currentValue1 > _currentValue2) {
      Fluttertoast.showToast(
          msg: "O número de repetições deve ser menor que o do intervalo.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color.fromARGB(255, 220, 220, 220),
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      DataHabitCreation().frequency = new FreqRepeating(daysTime: _currentValue1, daysCycle: _currentValue2);
      Navigator.of(context).pop(true);
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
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.yellow),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Intervalo",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text("Escolha quantos vezes irá realizar o hábito e o intervalo de tempo para isso:"),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new NumberPicker.integer(
                    initialValue: _currentValue1,
                    minValue: 1,
                    maxValue: 30,
                    listViewWidth: 45.0,
                    onChanged: (newValue) => setState(() => _currentValue1 = newValue),
                  ),
                  Text(
                    "vezes em",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  new NumberPicker.integer(
                    initialValue: _currentValue2,
                    minValue: 1,
                    maxValue: 30,
                    listViewWidth: 45.0,
                    onChanged: (newValue) => setState(() => _currentValue2 = newValue),
                  ),
                  Text(
                    "dias.",
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
