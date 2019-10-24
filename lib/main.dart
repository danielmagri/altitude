import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/services/FireMenssaging.dart';
import 'package:habit/ui/competition/competitionPage.dart';
import 'package:habit/ui/friends/friendsPage.dart';
import 'dart:ui';
import 'package:habit/ui/widgets/HabitCardItem.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/ui/addHabit/addHabitPage.dart';
import 'package:habit/ui/settingsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/ui/tutorialPage.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/services/SharedPref.dart';
import 'package:habit/utils/Color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/controllers/LevelControl.dart';
import 'package:habit/ui/dialogs/newLevelDialog.dart';
import 'package:habit/ui/allLevelsPage.dart';
import 'package:habit/services/FireAnalytics.dart';

void main() async {
  bool showTutorial = false;
  if (await SharedPref().getName() == null) showTutorial = true;

  await AppColors.getColorMix();

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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        accentColor: Color.fromARGB(255, 34, 34, 34),
        primaryColor: Colors.white,
        brightness: Brightness.light,
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

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controllerScore;
  AnimationController _controllerDragTarget;

  PageController _pageController = new PageController(initialPage: 1);
  int pageIndex = 1;

  int score = 0;
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color.fromARGB(255, 250, 250, 250),
        systemNavigationBarColor: Color.fromARGB(255, 250, 250, 250),
        systemNavigationBarIconBrightness: Brightness.dark));

    WidgetsBinding.instance.addObserver(this);
    FireMessaging().configure();

    _controllerScore = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _controllerDragTarget = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void didChangeDependencies() {
    SharedPref().getScore().then((score) {
      this.score = 0;
      updateScore(score);
    });

    HabitsControl().getAllHabitsColor().then((colors) {
      if (colors.length != 0) {
        if (AppColors.updateColorMix(colors)) {
          setState(() {});
        }
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controllerScore.dispose();
    _controllerDragTarget.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color.fromARGB(255, 250, 250, 250),
          systemNavigationBarColor: Color.fromARGB(255, 250, 250, 250),
          systemNavigationBarIconBrightness: Brightness.dark));
    }
    super.didChangeAppLifecycleState(state);
  }

  void updateScore(int earnedScore) async {
    setState(() {
      score += earnedScore;
    });
    int newLevel = LevelControl.getLevel(score);
    if (newLevel > await SharedPref().getLevel()) {
      FireAnalytics().sendNextLevel(score);
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

    if (newLevel != await SharedPref().getLevel()) {
      SharedPref().setLevel(newLevel);
    }

    if (previousScore != score) {
      _controllerScore.reset();
      _controllerScore.forward().orCancel.whenComplete(() {
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

    HabitsControl().setHabitDoneAndScore(today, id).then((earnedScore) {
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

  void _rateApp() async {
    //const APP_STORE_URL =
    //    'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
    const PLAY_STORE_URL =
        'https://play.google.com/store/apps/details?id=com.magrizo.habit';
    if (await canLaunch(PLAY_STORE_URL)) {
      await launch(PLAY_STORE_URL);
    } else {
      throw 'Could not launch $PLAY_STORE_URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(color: AppColors.colorHabitMix),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: UserControl().getEmail(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data != "") {
                        return Text(
                          "${snapshot.data}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: UserControl().getPhotoUrl(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != "") {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              snapshot.data,
                            ),
                          );
                        } else {
                          return Icon(
                            Icons.person,
                            size: 32,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 14),
                  FutureBuilder(
                    future: UserControl().getName(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "Olá, ${snapshot.data}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text(
                          "Bem-vindo...",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${LevelControl.getLevelText(score)}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Amigos',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(
                Icons.people,
                color: Colors.black,
              ),
              trailing: FutureBuilder(
                future: UserControl().getPendingFriendsStatus(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return Container(
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.colorHabitMix),
                      );
                    }
                  }
                  return SizedBox();
                },
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FriendsPage();
                }));
              },
            ),
            ListTile(
              title: Text(
                'Competição',
                style: TextStyle(fontSize: 16),
              ),
              leading: Image.asset(
                "assets/ic_award.png",
                width: 25,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return CompetitionPage();
                }));
              },
            ),
            ListTile(
              title: Text(
                'Configurações',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SettingsPage();
                }));
              },
            ),
            ListTile(
              title: Text(
                'Avalie o app',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(
                Icons.star,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                _rateApp();
              },
            ),
          ]),
        ),
      ),
      drawerScrimColor: Colors.black12,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: 75,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 12, left: 12),
                child: IconButton(
                  tooltip: "Menu",
                  icon: Icon(
                    Icons.menu,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
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
                        width: 25,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 3,
                          ),
                          Text(LevelControl.getLevelText(score)),
                          ScoreWidget(
                            color: AppColors.colorHabitMix,
                            animation:
                                IntTween(begin: previousScore, end: score)
                                    .animate(CurvedAnimation(
                                        parent: _controllerScore,
                                        curve: Curves.fastOutSlowIn)),
                          ),
                        ],
                      ),
                      Image.asset(
                        LevelControl.getLevelImagePath(score),
                        height: 25,
                        width: 25,
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
          margin: EdgeInsets.only(top: 40),
          child: Text(
            "HÁBITOS DE HOJE",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: HabitsControl().getHabitsToday(),
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
          margin: EdgeInsets.only(top: 40),
          child: Text(
            "TODOS OS HÁBITOS",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: HabitsControl().getAllHabits(),
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
    if (await HabitsControl().getAllHabitCount() < 9) {
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
          color: AppColors.colorHabitMix,
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
                  color: AppColors.colorHabitMix,
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
          height: 200,
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
                      "assets/cloud1.png",
                      fit: BoxFit.contain,
                      height: 60,
                    ),
                  ),
                  Align(
                    alignment: Alignment(1.2, 0 + offsetCloud.value),
                    child: Image.asset(
                      "assets/cloud2.png",
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
