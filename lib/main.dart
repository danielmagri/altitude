import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:habit/ui/widgets/HabitListItem.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/ui/addHabitPage.dart';
import 'package:habit/ui/settingsPage.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/tutorialPage.dart';
import 'package:habit/controllers/DataPreferences.dart';

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
        accentColor: Color.fromARGB(255, 24, 24, 24),
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

  List<Habit> habitsForToday;
  List<DayDone> habitsDone;
  Person person = new Person(name: "");
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    DataPreferences().getName().then((name) {
      setState(() {
        person.name = name;
      });
    });

    DataPreferences().getScore().then((score) {
      setState(() {
        person.score = score;
      });
      animateScore();
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

  void animateScore() {
    if (previousScore != person.score) {
      _controllerScore.reset();
      _controllerScore.forward().orCancel.then((e) {
        previousScore = person.score;
      }).catchError((error) {
        print(error.toString());
        previousScore = person.score;
      });
    }
  }

  void setHabitDone(id) {
    setState(() {
      habitsDone.add(new DayDone(done: 1, habitId: id));
    });
    int cycle = habitsForToday.firstWhere((habit) => habit.id == id, orElse: () => null).cycle;

    DataControl().setHabitDoneAndScore(id, cycle).then((earnedScore) {
      setState(() {
        person.score += earnedScore;
      });
      animateScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          HeaderWidget(
            name: person.name,
            score: person.score,
            previousScore: previousScore,
            controllerScore: _controllerScore,
          ),
          Container(
            height: 1,
            color: Colors.grey,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          Container(
            margin: EdgeInsets.only(top: 12.0),
            child: Text(
              "HÁBITOS DE HOJE",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                _doneIconBackgroundWidget(),
                LayoutBuilder(builder: _habitsForTodayBuild),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }

  Widget _doneIconBackgroundWidget() {
    if (habitsForToday != null && habitsDone != null && habitsForToday.length == habitsDone.length) {
      return Center(
        child: Icon(
          Icons.done,
          size: 350,
          color: Colors.grey.withOpacity(0.1),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _habitsForTodayBuild(BuildContext context, BoxConstraints constrant) {
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
        Widget habitWidget = HabitListItem(
            habit: habit, done: done == null ? false : true, setHabitDone: setHabitDone, width: constrant.maxWidth);

        widgets.add(habitWidget);
      }
    }

    return Center(
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: widgets,
      ),
    );
  }

  Widget _bottomNavigationBarWidget() {
    return BottomAppBar(
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 7, color: Colors.black.withOpacity(0.5))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: IconButton(
                tooltip: "Todos os hábitos",
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {

                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AddHabitPage();
                }));
              },
              tooltip: 'Adicionar',
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 32,
              ),
              backgroundColor: Colors.white,
            ),
            Expanded(
              child: IconButton(
                tooltip: "Configurações",
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return SettingsPage();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
      color: Colors.transparent,
      elevation: 0.0,
    );
  }
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, this.name, this.score, this.previousScore, this.controllerScore}) : super(key: key);

  final String name;
  final int score;
  final int previousScore;
  final controllerScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment(0.0, 0.5),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 65,
          ),
          ScoreWidget(
            animation: IntTween(begin: previousScore, end: score)
                .animate(CurvedAnimation(parent: controllerScore, curve: Curves.fastOutSlowIn)),
          )
        ],
      ),
    );
  }
}
