import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Person.dart';
import 'dart:async';
import 'package:habit/controllers/DataControl.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
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

  void cueSettingTap(bool next) {
    if (next) {
      Habit habit = new Habit(
          category: 1,
          cue: cueController.text,
          habit: habitController.text,
          reward: rewardController.text,
          score: 0);

      DataControl().addHabit(habit).then((result) {
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