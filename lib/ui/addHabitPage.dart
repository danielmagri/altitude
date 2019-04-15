import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:numberpicker/numberpicker.dart';

class CategorySelection extends StatelessWidget {
  CategorySelection({Key key, this.onTap}) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0.0, -0.7),
          child: Text("Escolha uma categoria:"),
        ),
        Align(
          alignment: Alignment(0.0, 0.5),
          child: GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: 2,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  onTap(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Align(
                              alignment: Alignment(-0.7, -0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Nome",
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              ))),
                      Expanded(
                          child: Align(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Descrição",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(2);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Align(
                              alignment: Alignment(-0.7, -0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Nome",
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              ))),
                      Expanded(
                          child: Align(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Descrição",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(3);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Align(
                              alignment: Alignment(-0.7, -0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Nome",
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              ))),
                      Expanded(
                          child: Align(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Descrição",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(4);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Align(
                              alignment: Alignment(-0.7, -0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Nome",
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              ))),
                      Expanded(
                          child: Align(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Descrição",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RewardSetting extends StatelessWidget {
  RewardSetting({Key key, this.controller, this.onTap}) : super(key: key);

  final TextEditingController controller;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(0.0, 1.0),
            child: Text("Texto explicando sobre a meta"),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(-0.6, 0.6),
            child: Text(
              "Qual é sua meta?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: TextField(
            controller: controller,
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
                onTap(false);
              },
              child: const Text("VOLTAR"),
            ),
            RaisedButton(
              onPressed: () {
                onTap(true);
              },
              child: const Text("AVANÇAR"),
            ),
          ],
        ),
      ],
    );
  }
}

class HabitSetting extends StatelessWidget {
  HabitSetting({Key key, this.controller, this.onTap}) : super(key: key);

  final TextEditingController controller;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(0.0, 1.0),
            child: Text("Texto explicando sobre o hábito"),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(-0.6, 0.6),
            child: Text(
              "Qual será seu hábito?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: controller,
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
                onTap(false);
              },
              child: const Text("VOLTAR"),
            ),
            RaisedButton(
              onPressed: () {
                onTap(true);
              },
              child: const Text("AVANÇAR"),
            ),
          ],
        ),
      ],
    );
  }
}

class FrequencySetting extends StatefulWidget {
  FrequencySetting({Key key, this.onTap}) : super(key: key);

  final Function onTap;

  @override
  _FrequencySettingState createState() => new _FrequencySettingState();
}

class _FrequencySettingState extends State<FrequencySetting> {
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

class CueSetting extends StatelessWidget {
  CueSetting({Key key, this.controller, this.onTap}) : super(key: key);

  final TextEditingController controller;
  final Function onTap;

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
            controller: controller,
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
                onTap(false);
              },
              child: const Text("VOLTAR"),
            ),
            RaisedButton(
              onPressed: () {
                onTap(true);
              },
              child: const Text("CRIAR"),
            ),
          ],
        ),
      ],
    );
  }
}

class AddHabitPage extends StatefulWidget {
  AddHabitPage({Key key}) : super(key: key);

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final rewardController = TextEditingController();
  final habitController = TextEditingController();
  final cueController = TextEditingController();
  int selection = 0;

  dynamic frequency;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void categorySelected(int selection) {
    this.selection = selection;
    _nextPage(1);
  }

  void rewardSettingTap(bool next) {
    if (next) {
      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void habitSettingTap(bool next) {
    if (next) {
      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void frequencySettingTap(bool next, dynamic frequency) {
    this.frequency = frequency;
    if (next) {
      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void cueSettingTap(bool next) {
    if (next) {
      Habit habit = new Habit(
          category: 1, cue: cueController.text, habit: habitController.text, reward: rewardController.text, score: 0);

      DataControl().addHabit(habit, frequency).then((result) {
        Navigator.pop(context);
      });

      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 127, 114),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            CategorySelection(
              onTap: categorySelected,
            ),
            RewardSetting(
              controller: rewardController,
              onTap: rewardSettingTap,
            ),
            HabitSetting(
              controller: habitController,
              onTap: habitSettingTap,
            ),
            FrequencySetting(
              onTap: frequencySettingTap,
            ),
            CueSetting(
              controller: cueController,
              onTap: cueSettingTap,
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 52.0,
          alignment: Alignment.center,
          child: TabPageSelector(
            controller: _tabController,
            selectedColor: Color.fromARGB(255, 221, 221, 221),
          ),
        ),
      ),
    );
  }
}
