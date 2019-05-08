import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:habit/ui/widgets/HabitCard.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/ui/widgets/ClipShadowPath.dart';
import 'package:habit/ui/addHabitPage.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:vibration/vibration.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitos',
      theme: ThemeData(fontFamily: 'Montserrat'),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class HeaderBackgroundClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, this.name, this.score, this.previousScore, this.controller})
      : animation = IntTween(begin: previousScore, end: score)
            .animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
        super(key: key);

  final AnimationController controller;
  final String name;
  final int score;
  final int previousScore;
  final Animation<int> animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipShadowPath(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/praia.jpg'), fit: BoxFit.cover),
            ),
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.4)),
              ),
            ),
          ),
          clipper: HeaderBackgroundClip(),
          shadow: Shadow(blurRadius: 5, color: Colors.black.withOpacity(0.5)),
        ),
        Container(
          alignment: Alignment(-0.92, 0.95),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " " + name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
              ),
              ScoreWidget(
                animation: animation,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(0.85, 0.85),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddHabitPage();
              }));
            },
            tooltip: 'Adicionar',
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class DragComplete extends AnimatedWidget {
  DragComplete({Key key, @required this.onAccept, Animation<double> animation})
      : super(key: key, listenable: animation);

  bool hover = false;
  final Function onAccept;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Positioned(
      left: 40,
      right: 40,
      bottom: animation.value,
      child: Container(
        height: 90,
        color: Color.fromARGB(255, 221, 221, 221),
        child: DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            return Center(
                child: Text(
              "Concluído",
              style: TextStyle(color: hover ? Colors.green : Colors.white, fontSize: 22.0),
            ));
          },
          onWillAccept: (data) {
            hover = true;
            return true;
          },
          onAccept: (data) {
            hover = false;
            onAccept(data);
          },
          onLeave: (data) {
            hover = false;
          },
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  PanelController _panelController = new PanelController();
  AnimationController _controllerDragComplete;
  AnimationController _controllerScore;
  Animation _animationDragComplete;

  List<Habit> habitsForToday = [];
  List<Habit> habits = [];
  Person person;
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    person = new Person(name: "", score: 0);

    _controllerDragComplete = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _animationDragComplete = Tween(begin: -100.0, end: 10.0)
        .animate(CurvedAnimation(parent: _controllerDragComplete, curve: Curves.elasticOut));
  }

  @override
  void didChangeDependencies() {
    DataControl().getPerson().then((person) {
      setState(() {
        this.person = person;
      });
      animateScore();
    });

    DataControl().getAllHabits().then((habits) {
      this.habits = habits;
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllerDragComplete.dispose();
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

  void onAccept(id) {
    _controllerDragComplete.reverse();

    int cycle = habitsForToday.firstWhere((habit) => habit.id == id, orElse: () => null).cycle;

    DataControl().setHabitDoneAndScore(id, cycle).then((earnedScore) {
      for (int i = 0; i < habitsForToday.length; i++) {
        if (habitsForToday[i].id == id) {
          Vibration.vibrate();
          setState(() {
            habitsForToday.removeAt(i);
            person.score += earnedScore;
          });
          animateScore();
        }
      }
    });
  }

  Widget habitsForTodayBuild(BuildContext context, AsyncSnapshot snapshot) {
    List<Widget> widgets = new List();

    if (!snapshot.hasData) {
      widgets.add(Center(child: CircularProgressIndicator()));
    } else {
      habitsForToday = snapshot.data;
      if (habitsForToday.length == 0) {
        widgets.add(Center(child: Text("Já foram feitos todos os hábitos de hoje :)")));
      } else {
        for (Habit habit in habitsForToday) {
          Widget habitWidget = HabitWidget(habit: habit);

          widgets.add(
            Draggable(
              data: habit.id,
              child: habitWidget,
              feedback: Material(type: MaterialType.transparency, child: habitWidget),
              childWhenDragging: Container(height: 90.0, width: 110.0),
              onDragStarted: () {
                _controllerDragComplete.forward();
              },
              onDraggableCanceled: (velocity, offset) {
                _controllerDragComplete.reverse();
              },
            ),
          );
        }
      }
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 0.0,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        backdropEnabled: true,
        panel: Center(
          child: _bottomSheet(),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: HeaderWidget(
                  name: person.name,
                  score: person.score,
                  previousScore: previousScore,
                  controller: _controllerScore,
                )),
            Expanded(
              flex: 2,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Hábitos de hoje",
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, height: 1.3),
                      ),
                      Expanded(
                        child: Center(
                            child: FutureBuilder(future: DataControl().getHabitsToday(), builder: habitsForTodayBuild)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: RaisedButton(
                          child: Text("TODOS OS HÁBITOS"),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          elevation: 5.0,
                          padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
                          onPressed: () => _panelController.open(),
                        ),
                      ),
                    ],
                  ),
                  DragComplete(onAccept: onAccept, animation: _animationDragComplete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    List<Widget> widgets = new List();

    if (habits.length == 0) {
      widgets.add(Center(child: Text("Já foram feitos todos os hábitos de hoje :)")));
    } else {
      for (Habit habit in habits) {
        widgets.add(HabitWidget(habit: habit));
      }
    }

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: 35.0,
            height: 8.0,
            margin: EdgeInsets.only(top: 8.0),
            decoration: new BoxDecoration(color: Colors.black12, borderRadius: new BorderRadius.circular(10.0)),
          ),
          Text(
            "Todos os hábitos",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, height: 1.9),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: double.maxFinite,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: widgets,
            ),
          )
        ],
      ),
    );
  }
}
