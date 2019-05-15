import 'package:flutter/material.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FrequencyTab extends StatefulWidget {
  FrequencyTab({Key key, this.category, this.onTap}) : super(key: key);

  final CategoryEnum category;
  final Function onTap;

  @override
  _FrequencyTabState createState() => new _FrequencyTabState();
}

class _FrequencyTabState extends State<FrequencyTab> {
  final weeklyController = TextEditingController();
  final repeating1Controller = TextEditingController();
  final repeating2Controller = TextEditingController();

  List<bool> expandList = [true, false, false];
  int expanded = 0;

  final List<String> _days = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sábado",
    "Domingo"
  ];
  List<String> _filters = <String>[];

  @override
  void dispose() {
    weeklyController.dispose();
    repeating1Controller.dispose();
    repeating2Controller.dispose();
    super.dispose();
  }

  void validateData() {
    if (expanded == 0) {
      bool hasOne = false;
      for (int i = 0; i < 7; i++) {
        if (_filters.contains(_days[i])) {
          hasOne = true;
          break;
        }
      }

      if (!hasOne) {
        Fluttertoast.showToast(
            msg: "Selecione pelo menos um dia da semana",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        FreqDayWeek dayWeek = new FreqDayWeek(
            monday: _filters.contains(_days[0]) ? 1 : 0,
            tuesday: _filters.contains(_days[1]) ? 1 : 0,
            wednesday: _filters.contains(_days[2]) ? 1 : 0,
            thursday: _filters.contains(_days[3]) ? 1 : 0,
            friday: _filters.contains(_days[4]) ? 1 : 0,
            saturday: _filters.contains(_days[5]) ? 1 : 0,
            sunday: _filters.contains(_days[6]) ? 1 : 0);

        widget.onTap(true, dayWeek);
      }
    } else if (expanded == 1) {
      int number = int.tryParse(weeklyController.text);

      if (number == null) {
        Fluttertoast.showToast(
            msg: "Preencha a quantidade de dias na semana que deseja fazer",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (number < 1 || number > 7) {
        Fluttertoast.showToast(
            msg: "Preencha a quantidade de dias entre 1 e 7",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        FreqWeekly weekly = new FreqWeekly(daysTime: number);

        widget.onTap(true, weekly);
      }
    } else if (expanded == 2) {
      int number1 = int.tryParse(repeating1Controller.text);
      int number2 = int.tryParse(repeating2Controller.text);

      if (number1 == null || number2 == null) {
        Fluttertoast.showToast(
            msg: "Preencha a quantidade de dias que deseja fazer",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (number1 > number2) {
        Fluttertoast.showToast(
            msg: "O número de repetições deve ser menor que o do ciclo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (number1 < 1 || number1 > 30 || number2 < 1 || number2 > 30) {
        Fluttertoast.showToast(
            msg: "Os valores precisam ser maiores que 0 e menores que 30",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        FreqRepeating repeating = new FreqRepeating(daysTime: number1, daysCycle: number2);

        widget.onTap(true, repeating);
      }
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

  Iterable<Widget> get dayWeekWidgets sync* {
    for (String day in _days) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          label: Text(day),
          selected: _filters.contains(day),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(day);
              } else {
                _filters.removeWhere((String name) {
                  return name == day;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
            child: new ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                if (!isExpanded) {
                  if (expanded != -1) expandList[expanded] = false;
                  expanded = index;
                } else {
                  if (expanded != -1) expandList[expanded] = false;
                  expanded = -1;
                }

                setState(() {
                  expandList[index] = !isExpanded;
                });
              },
              children: <ExpansionPanel>[
                new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: const Text(
                        "Dias da semana",
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: const Text(
                        "Segunda, Terça, Quarta ...",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  isExpanded: expandList[0],
                  body: new Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: dayWeekWidgets.toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: const Text(
                        "Semanalmente",
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: const Text(
                        "X dias na semana",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  isExpanded: expandList[1],
                  body: new Container(
                    height: 70.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30,
                          child: TextField(
                            controller: weeklyController,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textInputAction: TextInputAction.go,
                            onEditingComplete: validateData,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "dias por semana",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: const Text(
                        "Recorrente",
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: const Text(
                        "X vezes em Y dias",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  isExpanded: expandList[2],
                  body: new Container(
                    height: 70.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30,
                          child: TextField(
                            controller: repeating1Controller,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          " vezes em ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Container(
                          width: 30,
                          child: TextField(
                            controller: repeating2Controller,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            textInputAction: TextInputAction.go,
                            onEditingComplete: validateData,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "dias",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
