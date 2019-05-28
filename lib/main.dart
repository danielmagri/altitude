import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:habit/ui/widgets/HabitCard.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/ui/addHabitPage.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
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
        Container(
          alignment: Alignment(-1.0, 1.0),
          margin: EdgeInsets.only(left: 15.0, bottom: 25.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " " + name,
                style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w300),
              ),
              ScoreWidget(
                animation: animation,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(0.85, 0.9),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: Color.fromARGB(255, 210, 236, 207),
        ),
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
          setState(() {
            habitsForToday.removeAt(i);
            person.score += earnedScore;
          });
          animateScore();
          break;
        }
      }
    });
  }

  Future<bool> _onBackPressed() async {
    if (_panelController.isPanelOpen()) {
      _panelController.close();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            minHeight: 60.0,
            controller: _panelController,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            backdropEnabled: true,
            panel: FutureBuilder(future: DataControl().getAllHabits(), builder: _bottomSheetBuild),
            body: Stack(
              children: <Widget>[
                Container(
                  height: 205.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/category/fisico.png'), fit: BoxFit.cover),
                  ),
                  child: new BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: new Container(
                      decoration: new BoxDecoration(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 180.0),
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.5))],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Hábitos de hoje",
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Expanded(
                          child: Center(
                              child:
                                  FutureBuilder(future: DataControl().getHabitsToday(), builder: _habitsForTodayBuild)),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200.0,
                  width: double.maxFinite,
                  child: HeaderWidget(
                    name: person.name,
                    score: person.score,
                    previousScore: previousScore,
                    controller: _controllerScore,
                  ),
                ),
              ],
            ),
          ),
          DragComplete(onAccept: onAccept, animation: _animationDragComplete),
        ],
      )),
    );
  }

  Widget _habitsForTodayBuild(BuildContext context, AsyncSnapshot snapshot) {
    List<Widget> widgets = new List();

    if (!snapshot.hasData) {
      widgets.add(Center(child: CircularProgressIndicator()));
    } else {
      habitsForToday = snapshot.data;
      if (habitsForToday.length == 0) {
        widgets.add(Center(child: Text("Já foram feitos todos os hábitos de hoje :)")));
      } else {
        for (Habit habit in habitsForToday) {
          Widget habitWidget = HabitWidget(
            habit: habit,
            fromAllHabits: false,
          );

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
      spacing: 4.0,
      runSpacing: 4.0,
      children: widgets,
    );
  }

  Widget _bottomSheetBuild(BuildContext context, AsyncSnapshot snapshot) {
    List<Widget> widgets = new List();

    if (!snapshot.hasData) {
      widgets.add(Center(child: CircularProgressIndicator()));
    } else {
      if (snapshot.data.length == 0) {
        widgets.add(Center(child: Text("Já foram feitos todos os hábitos de hoje :)")));
      } else {
        for (Habit habit in snapshot.data) {
          widgets.add(HabitWidget(
            habit: habit,
            fromAllHabits: true,
          ));
        }
      }
    }

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_panelController.isPanelOpen()) {
                _panelController.close();
              } else {
                _panelController.open();
              }
            },
            child: Container(
              height: 60.0,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 220, 220, 220),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 35.0,
                    height: 8.0,
                    margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: new BoxDecoration(color: Colors.black12, borderRadius: new BorderRadius.circular(10.0)),
                  ),
                  Text(
                    "Todos os hábitos",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: double.maxFinite,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 4.0,
              runSpacing: 4.0,
              children: widgets,
            ),
          )
        ],
      ),
    );
  }
}
