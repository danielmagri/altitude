import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:habit/ui/widgets/HabitCardItem.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/ui/addHabitPage.dart';
import 'package:habit/ui/settingsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/tutorialPage.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/controllers/DataPreferences.dart';
import 'package:vibration/vibration.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/controllers/LevelControl.dart';
import 'package:habit/ui/dialogs/newLevelDialog.dart';
import 'package:habit/ui/allLevelsPage.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));

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

  PageController _pageController = new PageController(initialPage: 1);
  int pageIndex = 1;

  int score = 0;
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    _controllerScore = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _controllerDragTarget = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void didChangeDependencies() {
    DataPreferences().getScore().then((score) {
      this.score = 0;
      updateScore(score);
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    _controllerDragTarget.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void updateScore(int earnedScore) async {
    setState(() {
      score += earnedScore;
    });
    int newLevel = LevelControl.getLevel(score);
    if (newLevel > await DataPreferences().getLevel()) {
      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              new FadeTransition(
                  opacity: new CurvedAnimation(
                      parent: animation, curve: Curves.easeOut),
                  child: child),
          pageBuilder: (BuildContext context, _, __) {
            return NewLevelDialog(
              score: score,
            );
          }));
    }

    if (newLevel != await DataPreferences().getLevel()) {
      DataPreferences().setLevel(newLevel);
    }

    if (previousScore != score) {
      _controllerScore.reset();
      _controllerScore.forward().whenComplete(() {
        previousScore = score;
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
    Loading.showLoading(context);
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    DataControl().setHabitDoneAndScore(today, id).then((earnedScore) {
      Loading.closeLoading(context);
      Vibration.hasVibrator().then((resp) {
        if (resp != null && resp == true) {
          Vibration.vibrate(duration: 100);
        }
      });

      updateScore(earnedScore);
    });
  }

  void pageScroll(int index) {
    setState(() {
      pageIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _AppBar(),
              Text(LevelControl.getLevelText(score)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AllLevelsPage(
                      score: score,
                    );
                  }));
                },
                child: Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      ScoreWidget(
                        animation: IntTween(begin: previousScore, end: score)
                            .animate(CurvedAnimation(
                                parent: _controllerScore,
                                curve: Curves.fastOutSlowIn)),
                      ),
                      Image.asset(
                        LevelControl.getLevelImagePath(score),
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  children: <Widget>[
                    _AllHabitsPage(
                      showDragTarget: showDragTarget,
                    ),
                    _TodayHabitsPage(
                      showDragTarget: showDragTarget,
                    ),
                  ],
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
      bottomNavigationBar:
          _BottomNavigationBar(index: pageIndex, onTap: pageScroll),
    );
  }
}

class _TodayHabitsPage extends StatelessWidget {
  _TodayHabitsPage({Key key, @required this.showDragTarget}) : super(key: key);

  final Function showDragTarget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 36),
          child: Text(
            "HÁBITOS DE HOJE",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: DataControl().getHabitsToday(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Habit> habits = snapshot.data[0];
                  List<DayDone> dones = snapshot.data[1];
                  if (habits.isEmpty) {
                    return Center(
                      child: Text(
                        "Não tem hábitos para serem feitos hoje",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black.withOpacity(0.2)),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: habits.map((habit) {
                          DayDone done = dones.firstWhere(
                              (dayDone) => dayDone.habitId == habit.id,
                              orElse: () => null);
                          return HabitCardItem(
                            habit: habit,
                            showDragTarget: showDragTarget,
                            done: done == null ? false : true,
                          );
                        }).toList(),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class _AllHabitsPage extends StatelessWidget {
  _AllHabitsPage({Key key, @required this.showDragTarget}) : super(key: key);

  final Function showDragTarget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 36),
          child: Text(
            "TODOS OS HÁBITOS",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: DataControl().getAllHabits(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Habit> habits = snapshot.data[0];
                  List<DayDone> dones = snapshot.data[1];
                  if (habits.isEmpty) {
                    return Text(
                      "Crie um novo hábito pelo botão \"+\" na tela principal.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: habits.map((habit) {
                          DayDone done = dones.firstWhere(
                              (dayDone) => dayDone.habitId == habit.id,
                              orElse: () => null);
                          return HabitCardItem(
                            habit: habit,
                            showDragTarget: showDragTarget,
                            done: done == null ? false : true,
                          );
                        }).toList(),
                      ),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  _BottomNavigationBar({Key key, this.index, @required this.onTap})
      : super(key: key);

  final int index;
  final Function(int index) onTap;

  void _addHabitTap(BuildContext context) async {
    if (await DataControl().getAllHabitCount() < 9) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return AddHabitPage();
      }));
    } else {
      showToast("Você atingiu o limite de 9 hábitos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 8, right: 12, left: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 7, color: Colors.black.withOpacity(0.5))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: index == 0 ? 1 : 0,
                  child: Container(
                    height: 4,
                    width: 25,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                IconButton(
                  tooltip: "Todos os hábitos",
                  icon: Icon(
                    Icons.apps,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => onTap(0),
                ),
              ],
            ),
            InkWell(
              onTap: () => _addHabitTap(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: index == 1 ? 1 : 0,
                  child: Container(
                    height: 4,
                    width: 25,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                IconButton(
                  tooltip: "Configurações",
                  icon: Icon(
                    Icons.today,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => onTap(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 75,
      margin: const EdgeInsets.only(top: 12, left: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FutureBuilder(
            future: DataPreferences().getName(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return RichText(
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
                      text: snapshot.data,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ]),
                );
              } else {
                return Text(
                  "Bem-vindo...",
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                );
              }
            },
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
    );
  }
}

// ignore: must_be_immutable
class _DragTargetDoneHabit extends StatelessWidget {
  _DragTargetDoneHabit(
      {Key key, @required this.controller, @required this.setHabitDone})
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
                  stops: [
                0.7,
                1
              ],
                  colors: [
                Color.fromARGB(255, 118, 213, 216),
                Theme.of(context).canvasColor
              ])),
          child: DragTarget<int>(
            builder: (context, List<int> candidateData, rejectedData) {
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
                            color: hover
                                ? Color.fromARGB(255, 78, 173, 176)
                                : Colors.white,
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
