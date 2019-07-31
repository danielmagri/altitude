import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:habit/ui/widgets/HabitCardItem.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/ui/addHabitPage.dart';
import 'package:habit/ui/settingsPage.dart';
import 'package:habit/ui/allHabitsPage.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/tutorialPage.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/controllers/DataPreferences.dart';
import 'package:vibration/vibration.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color.fromARGB(255, 24, 24, 24)));

  bool showTutorial = false;
  if (await DataPreferences().getName() == null) showTutorial = true;

  runApp(MyApp(
    showTutorial: showTutorial,
  ));
}

class MyApp extends StatelessWidget {
  final bool showTutorial;

  MyApp({
    @required this.showTutorial,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        accentColor: Color.fromARGB(255, 34, 34, 34),
      ),
      debugShowCheckedModeBanner: false,
      home: showTutorial ? TutorialPage() : MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  AnimationController _controllerScore;
  AnimationController _controllerDragTarget;

  List<Habit> habitsForToday;
  List<DayDone> habitsDone;
  Person person = new Person(name: "");
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _controllerDragTarget = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void didChangeDependencies() {
    DataPreferences().getName().then((name) {
      if (name != null) {
        setState(() {
          person.name = name;
        });
      }
    });

    DataPreferences().getScore().then((score) {
      setState(() {
        person.score = score;
      });
      updateScore();
    });

    DataControl().getHabitsToday().then((data) {
      setState(() {
        habitsForToday = data[0];
        habitsDone = data[1];
      });
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    super.dispose();
  }

  void updateScore() {
    if (previousScore != person.score) {
      _controllerScore.reset();
      _controllerScore.forward().whenComplete(() {
        previousScore = person.score;
      });
    }
  }

  void showDragTarget(bool show) {
    if (show) {
      _controllerDragTarget.forward();
    } else {
      _controllerDragTarget.reverse();
    }
  }

  void setHabitDone(id) {
    setState(() {
      habitsDone.add(new DayDone(habitId: id));
    });

    Loading.showLoading(context);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    DataControl().setHabitDoneAndScore(today, id).then((earnedScore) {
      Loading.closeLoading(context);
      Vibration.hasVibrator().then((resp) {
        if (resp != null && resp == true) {
          Vibration.vibrate(duration: 100);
        }
      });

      setState(() {
        person.score += earnedScore;
      });
      updateScore();
    });
  }

  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: 75,
                margin: const EdgeInsets.only(top: 12, left: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "Olá, ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        TextSpan(
                          text: person.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ]),
                    ),
                    Spacer(),
                    IconButton(
                      tooltip: "Configurações",
                      icon: Icon(
                        Icons.settings,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return SettingsPage();
                        }));
                      },
                    ),
                  ],
                ),
              ),
              ScoreWidget(
                animation: IntTween(begin: previousScore, end: person.score)
                    .animate(CurvedAnimation(parent: _controllerScore, curve: Curves.fastOutSlowIn)),
              ),
              Container(
                margin: EdgeInsets.only(top: 36),
                child: Text(
                  "HÁBITOS DE HOJE",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: Center(
                  child: _habitsForTodayBuild(),
                ),
              ),
            ],
          ),
          _DragTargetDoneHabit(
            controller: _controllerDragTarget,
            setHabitDone: setHabitDone,
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }

  Widget _habitsForTodayBuild() {
    List<Widget> widgets = new List();

    if (habitsForToday == null) {
      widgets.add(Center(child: CircularProgressIndicator()));
    } else if (habitsForToday.length == 0) {
      widgets.add(
        Center(
          child: Text(
            "Não tem hábitos para serem feitos hoje",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
          ),
        ),
      );
    } else {
      for (Habit habit in habitsForToday) {
        DayDone done = habitsDone.firstWhere((dayDone) => dayDone.habitId == habit.id, orElse: () => null);
        Widget habitWidget = HabitCardItem(
          habit: habit,
          showDragTarget: showDragTarget,
          done: done == null ? false : true,
        );

        widgets.add(habitWidget);
      }
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: widgets,
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 8, right: 12, left: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 7, color: Colors.black.withOpacity(0.5))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: "Todos os hábitos",
              icon: Icon(
                Icons.apps,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AlHabitsPage();
                }));
              },
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AddHabitPage();
                }));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            IconButton(
              tooltip: "Configurações",
              icon: Icon(
                Icons.today,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _DragTargetDoneHabit extends StatelessWidget {
  _DragTargetDoneHabit({Key key, @required this.controller, @required this.setHabitDone})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.8,
              curve: Curves.easeInOutSine,
            ),
          ),
        ),
        offsetSky = Tween<double>(
          begin: -1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.6,
              curve: Curves.easeOutSine,
            ),
          ),
        ),
        offsetCloud = Tween<double>(
          begin: -1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              1.0,
              curve: Curves.easeOutSine,
            ),
          ),
        ),
        opacityText = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.5,
              1.0,
              curve: Curves.easeInOutCubic,
            ),
          ),
        ),
        super(key: key);

  final Function(int id) setHabitDone;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> offsetSky;
  final Animation<double> offsetCloud;
  final Animation<double> opacityText;

  bool hover = false;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return FractionalTranslation(
      translation: Offset(0, offsetSky.value),
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          height: 175,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1],
                  colors: [Color.fromARGB(255, 118, 213, 216), Theme.of(context).canvasColor])),
          child: DragTarget<int>(
            builder: (context, List<int> candidateData, rejectedData) {
              print(candidateData);
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-1.1, -0.9 + offsetCloud.value),
                    child: Image.asset(
                      "assets/c1white.png",
                      fit: BoxFit.contain,
                      height: 60,
                    ),
                  ),
                  Align(
                    alignment: Alignment(1.2, 0 + offsetCloud.value),
                    child: Image.asset(
                      "assets/c2white.png",
                      fit: BoxFit.contain,
                      height: 45,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.6),
                    child: Opacity(
                      opacity: opacityText.value,
                      child: Text(
                        "ARRASTE AQUI PARA COMPLETAR",
                        style: TextStyle(
                            fontSize: 18,
                            color: hover ? Color.fromARGB(255, 78, 173, 176) : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            },
            onWillAccept: (data) {
              hover = true;
              return true;
            },
            onAccept: (data) {
              hover = false;
              setHabitDone(data);
            },
            onLeave: (data) {
              hover = false;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
