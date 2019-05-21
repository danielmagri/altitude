import 'package:flutter/material.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

class FrequencyTab extends StatefulWidget {
  FrequencyTab({Key key, this.category, this.onTap}) : super(key: key);

  final CategoryEnum category;
  final Function onTap;

  @override
  _FrequencyTabState createState() => new _FrequencyTabState();
}

class _FrequencyTabState extends State<FrequencyTab> {
  int chosen = -1;

  List<bool> days;
  int weeklyInt;
  int repeatingInt1;
  int repeatingInt2;

  @override
  initState() {
    super.initState();

    initValues();
  }

  void initValues() {
    days = [false, false, false, false, false, false, false];
    weeklyInt = 3;
    repeatingInt1 = 5;
    repeatingInt2 = 15;
  }

  void validateData() {
    if (chosen == 0) {
      FreqDayWeek dayWeek = new FreqDayWeek(
          monday: days[1] ? 1 : 0,
          tuesday: days[2] ? 1 : 0,
          wednesday: days[3] ? 1 : 0,
          thursday: days[4] ? 1 : 0,
          friday: days[5] ? 1 : 0,
          saturday: days[6] ? 1 : 0,
          sunday: days[0] ? 1 : 0);

      widget.onTap(true, dayWeek);
    } else if (chosen == 1) {
      FreqWeekly weekly = new FreqWeekly(daysTime: weeklyInt);

      widget.onTap(true, weekly);
    } else if (chosen == 2) {
      FreqRepeating repeating = new FreqRepeating(daysTime: repeatingInt1, daysCycle: repeatingInt2);

      widget.onTap(true, repeating);
    } else {
      Fluttertoast.showToast(
          msg: "Por favor, escolha alguma das opções",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 60.0, left: 8.0),
          child: Text(
            "Qual a frequência do hábito?",
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment(0.0, 1.0),
            margin: EdgeInsets.only(bottom: 12.0),
            child: Text(
              "Escolha uma opção:",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment(0.0, -1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      color: CategoryColors.getSecundaryColor(widget.category),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => DailyDialog(
                                  days: days,
                                  category: widget.category,
                                ),
                          ).then((result) {
                            if (result != null) {
                              initValues();
                              setState(() {
                                chosen = 0;
                                days = result;
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              border: chosen == 0
                                  ? Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid)
                                  : null,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: BoxContent(
                            title: "Diariamente",
                            example: "Ex. Segunda, Quarta e Sexta",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      color: CategoryColors.getSecundaryColor(widget.category),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => WeeklyDialog(
                                  weeklyInt: weeklyInt,
                                  category: widget.category,
                                ),
                          ).then((result) {
                            if (result != null) {
                              initValues();
                              setState(() {
                                chosen = 1;
                                weeklyInt = result;
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              border: chosen == 1
                                  ? Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid)
                                  : null,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: BoxContent(
                            title: "Semanalmente",
                            example: "Ex. 3 vezes por semana",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      color: CategoryColors.getSecundaryColor(widget.category),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => RepeatingDialog(
                                  repeatingInt1: repeatingInt1,
                                  repeatingInt2: repeatingInt2,
                                  category: widget.category,
                                ),
                          ).then((result) {
                            if (result != null) {
                              initValues();
                              setState(() {
                                chosen = 2;
                                repeatingInt1 = result[0];
                                repeatingInt2 = result[1];
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              border: chosen == 2
                                  ? Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid)
                                  : null,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: BoxContent(
                            title: "Intervalo",
                            example: "Ex. 5 vezes a cada 15 dias",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                onPressed: validateData,
                child: const Text("AVANÇAR"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BoxContent extends StatelessWidget {
  final String title;
  final String example;

  BoxContent({
    @required this.title,
    @required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              example,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }
}

class DailyDialog extends StatefulWidget {
  DailyDialog({Key key, this.days, this.category}) : super(key: key);

  final List<bool> days;
  final CategoryEnum category;

  @override
  _DailyDialogState createState() => new _DailyDialogState();
}

class _DailyDialogState extends State<DailyDialog> {
  List<bool> days;

  @override
  initState() {
    super.initState();

    days = widget.days;
  }

  void _validate() {
    if (days.contains(true)) {
      Navigator.of(context).pop(days);
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
  final CategoryEnum category;

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
        color: status ? CategoryColors.getSecundaryColor(category) : Color.fromARGB(255, 220, 220, 220),
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
  WeeklyDialog({Key key, this.weeklyInt, this.category}) : super(key: key);

  final int weeklyInt;
  final CategoryEnum category;

  @override
  _WeeklyDialogState createState() => new _WeeklyDialogState();
}

class _WeeklyDialogState extends State<WeeklyDialog> {
  int _currentValue;

  @override
  initState() {
    super.initState();

    _currentValue = widget.weeklyInt;
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
        data: Theme.of(context).copyWith(accentColor: CategoryColors.getSecundaryColor(widget.category)),
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
                        onPressed: () => Navigator.of(context).pop(_currentValue),
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

class RepeatingDialog extends StatefulWidget {
  RepeatingDialog({Key key, this.repeatingInt1, this.repeatingInt2, this.category}) : super(key: key);

  final int repeatingInt1;
  final int repeatingInt2;
  final CategoryEnum category;

  @override
  _RepeatingDialogState createState() => new _RepeatingDialogState();
}

class _RepeatingDialogState extends State<RepeatingDialog> {
  int _currentValue1;
  int _currentValue2;

  @override
  initState() {
    super.initState();

    _currentValue1 = widget.repeatingInt1;
    _currentValue2 = widget.repeatingInt2;
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
      Navigator.of(context).pop({0: _currentValue1, 1: _currentValue2});
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
        data: Theme.of(context).copyWith(accentColor: CategoryColors.getSecundaryColor(widget.category)),
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
