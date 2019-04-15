import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:habit/objects/Frequency.dart';


class FrequencyTab extends StatefulWidget {
  FrequencyTab({Key key, this.onTap}) : super(key: key);

  final Function onTap;

  @override
  _FrequencyTabState createState() => new _FrequencyTabState();
}

class _FrequencyTabState extends State<FrequencyTab> {
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

  int _currentValue = 1;
  int _currentValue2 = 3;
  int _currentValue3 = 7;

  void validateData() {
    if (expanded == 0) {
      FreqDayWeek dayWeek = new FreqDayWeek(
          monday: _filters.contains(_days[0]) ? 1 : 0,
          tuesday: _filters.contains(_days[1]) ? 1 : 0,
          wednesday: _filters.contains(_days[2]) ? 1 : 0,
          thursday: _filters.contains(_days[3]) ? 1 : 0,
          friday: _filters.contains(_days[4]) ? 1 : 0,
          saturday: _filters.contains(_days[5]) ? 1 : 0,
          sunday: _filters.contains(_days[6]) ? 1 : 0);

      widget.onTap(true, dayWeek);
    } else if (expanded == 1) {
      FreqWeekly weekly = new FreqWeekly(daysTime: _currentValue);

      widget.onTap(true, weekly);
    } else if (expanded == 2) {
      FreqRepeating repeating = new FreqRepeating(daysTime: _currentValue2, daysCicle: _currentValue3);

      widget.onTap(true, repeating);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
          child: new ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              if (!isExpanded) {
                expandList[expanded] = false;
                expanded = index;
              }

              setState(() {
                expandList[index] = !isExpanded;
              });
            },
            children: <ExpansionPanel>[
              new ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: const Text("Dias da semana"),
                    subtitle: const Text("Segunda, Terça, Quarta ..."),
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
                    title: const Text("Semanalmente"),
                    subtitle: const Text("X dias na semana"),
                  );
                },
                isExpanded: expandList[1],
                body: new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new NumberPicker.integer(
                        initialValue: _currentValue,
                        minValue: 1,
                        maxValue: 7,
                        listViewWidth: 50.0,
                        onChanged: (newValue) => setState(() => _currentValue = newValue),
                      ),
                      Text("dias por semana")
                    ],
                  ),
                ),
              ),
              new ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: const Text("Recorrente"),
                    subtitle: const Text("X vezes em Y dias"),
                  );
                },
                isExpanded: expandList[2],
                body: new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new NumberPicker.integer(
                        initialValue: _currentValue2,
                        minValue: 1,
                        maxValue: 15,
                        listViewWidth: 50.0,
                        onChanged: (newValue) => setState(() => _currentValue2 = newValue),
                      ),
                      Text("vezes em"),
                      new NumberPicker.integer(
                        initialValue: _currentValue3,
                        minValue: 1,
                        maxValue: 15,
                        listViewWidth: 50.0,
                        onChanged: (newValue) => setState(() => _currentValue3 = newValue),
                      ),
                      Text("dias")
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              onPressed: validateData,
              child: const Text("AVANÇAR"),
            ),
          ],
        ),
      ],
    );
  }
}