import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:habit/ui/editHabitPage.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/objects/Progress.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/ui/widgets/DoneDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget(
      {Key key,
      this.habit,
      this.frequency,
      this.fromAllHabits,
      this.score,
      this.previousScore,
      this.done,
      this.setDoneHabit,
      this.controller})
      : animation = IntTween(begin: previousScore, end: score)
            .animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
        super(key: key);

  final AnimationController controller;
  final Habit habit;
  final bool fromAllHabits;
  final dynamic frequency;
  final int score;
  final int previousScore;
  final bool done;
  final Function setDoneHabit;
  final Animation<int> animation;

  void _doneIconTap() {
    if (done) {
      Fluttertoast.showToast(
          msg: "Você já completou esse hábito hoje",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: CategoryColors.getPrimaryColor(habit.category),
          textColor: Colors.white,
          fontSize: 16.0);
    }else{
      setDoneHabit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 70.0,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Align(alignment: Alignment(-1.0, 1.0), child: BackButton(color: Colors.white)),
            ),
            IconButton(icon: Icon(Icons.check, color: Colors.white), onPressed: _doneIconTap),
            IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return EditHabitPage(
                      habit: habit,
                      frequency: frequency,
                    );
                  }));
                }),
          ]),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 90.0,
                height: 90.0,
                margin: EdgeInsets.only(left: 15.0),
                alignment: Alignment(0.0, 0.0),
                child: Hero(
                  tag: fromAllHabits ? habit.id + 1000 : habit.id,
                  transitionOnUserGestures: true,
                  child: Icon(
                    IconData(habit.icon, fontFamily: 'MaterialIcons'),
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: CategoryColors.getPrimaryColor(habit.category),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: habit.habit.length < 20 ? 10.0 : 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        habit.habit,
                        softWrap: true,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w300, height: 0.8),
                      ),
                      ScoreWidget(
                        animation: animation,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class RewardWidget extends StatelessWidget {
  RewardWidget({Key key, this.category, this.reward, this.progress}) : super(key: key);

  final CategoryEnum category;
  final String reward;
  final Progress progress;

  String _progressTypeText() {
    switch (progress.type) {
      case ProgressEnum.INFINITY:
        return "Infinito";
        break;
      case ProgressEnum.NUMBER:
        return "Número";
        break;
      case ProgressEnum.DAY:
        return "Dias";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Meta", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4)),
            Text("Meta: " + reward, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            Text("Tipo: " + _progressTypeText(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            progress.type != ProgressEnum.INFINITY
                ? Text("Progresso: " + progress.progress.toString() + " de " + progress.goal.toString(),
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2))
                : Container(),
            progress.type != ProgressEnum.INFINITY
                ? LinearProgressIndicator(
                    value: progress.progress / progress.goal,
                    valueColor: AlwaysStoppedAnimation<Color>(CategoryColors.getSecundaryColor(category)),
                    backgroundColor: CategoryColors.getPrimaryColor(category).withOpacity(0.5),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class CueWidget extends StatelessWidget {
  CueWidget({Key key, this.cue}) : super(key: key);

  final String cue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Deixa", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4)),
            Text("Deixa: " + cue, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key key, this.initialDate, this.daysDone, this.cycles}) : super(key: key);

  final DateTime initialDate;
  final int daysDone;
  final int cycles;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Informações Legais", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4)),
            Text(
                "Começou em " +
                    initialDate.day.toString().padLeft(2, '0') +
                    "/" +
                    initialDate.month.toString().padLeft(2, '0') +
                    "/" +
                    initialDate.year.toString(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            Text("Dias cumpridos: " + daysDone.toString(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            Text("Ciclos feitos: " + cycles.toString(),
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key, @required this.markedDays}) : super(key: key);

  final Map<DateTime, List> markedDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Dias feito", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4)),
            TableCalendar(
              events: markedDays,
              formatAnimation: FormatAnimation.slide,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableGestures: AvailableGestures.horizontalSwipe,
              forcedCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                selectedColor: Colors.deepOrange[400],
                todayColor: Colors.deepOrange[200],
                markersPositionBottom: 15,
                markersMaxAmount: 1,
                markersColor: Colors.brown[700],
              ),
              builders: CalendarBuilders(markersBuilder: (context, date, event, list) {
                return <Widget>[
                  Container(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment(0.0, 0.0),
                      margin: EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ))
                ];
              }),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.deepOrange[400],
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key, this.habit, this.frequency, this.markedDays, this.fromAllHabits}) : super(key: key);

  final Habit habit;
  final dynamic frequency;
  final Map<DateTime, List> markedDays;
  final bool fromAllHabits;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> with TickerProviderStateMixin {
  AnimationController _controllerScore;

  TextEditingController numberController = TextEditingController();

  Progress progress;
  int score;
  int previousScore = 0;
  Map<DateTime, List> markedDays;

  @override
  initState() {
    super.initState();

    progress = widget.habit.progress;
    score = widget.habit.score;
    markedDays = widget.markedDays;

    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    animateScore();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    super.dispose();
  }

  void animateScore() {
    if (previousScore != score) {
      _controllerScore.reset();
      _controllerScore.forward().then((e) {
        previousScore = score;
      });
    }
  }

  bool hasDoneToday() {
    DateTime now = DateTime.now();
    if (widget.markedDays.containsKey(DateTime(now.year, now.month, now.day))) {
      return true;
    } else {
      return false;
    }
  }

  void setDoneHabit() {
    DataControl().setHabitDoneAndScore(widget.habit.id, widget.habit.cycle).then((earnedScore) {
      if (widget.habit.progress.type == ProgressEnum.NUMBER)
        numberController.text = widget.habit.progress.progress.toString();
      showDialog(
        context: context,
        builder: (BuildContext context) => DoneDialog(
          progress: widget.habit.progress,
          controller: numberController,
        ),
      ).then((result) {
        if (result != null) {
          progress.progress = result;
          DataControl().setHabitProgress(widget.habit.id, result);
        } else if (widget.habit.progress.type == ProgressEnum.DAY) {
          DataControl().setHabitProgress(widget.habit.id, widget.habit.progress.progress + 1);
          progress.progress++;
        }
        setState(() {
          score += earnedScore;
          markedDays.putIfAbsent(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), () => ['']);
        });
        animateScore();
      });
    });
  }

  String frequencyText() {
    if (widget.frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = widget.frequency;
      return (freq.monday == 1 ? "Segunda, " : "") +
          (freq.tuesday == 1 ? "Terça, " : "") +
          (freq.wednesday == 1 ? "Quarta, " : "") +
          (freq.thursday == 1 ? "Quinta, " : "") +
          (freq.friday == 1 ? "Sexta, " : "") +
          (freq.saturday == 1 ? "Sábado, " : "") +
          (freq.sunday == 1 ? "Domingo, " : "");
    } else if (widget.frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = widget.frequency;
      return freq.daysTime.toString() + " vezes por semana";
    } else if (widget.frequency.runtimeType == FreqRepeating) {
      FreqRepeating freq = widget.frequency;
      return freq.daysTime.toString() + " vezes em " + freq.daysCycle.toString() + " dias";
    }
  }

  AssetImage _getBackgroundImage() {
    switch (widget.habit.category) {
      case CategoryEnum.PHYSICAL:
        return AssetImage('assets/category/fisico.png');
        break;
      case CategoryEnum.MENTAL:
        return AssetImage('assets/category/mental.png');
        break;
      case CategoryEnum.SOCIAL:
        return AssetImage('assets/category/social.png');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 205.0,
            decoration: BoxDecoration(
              image: DecorationImage(image: _getBackgroundImage(), fit: BoxFit.cover),
            ),
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.05)),
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
              child: ListView(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Text(
                    frequencyText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, color: Colors.black54),
                  ),
                  RewardWidget(
                    category: widget.habit.category,
                    reward: widget.habit.reward,
                    progress: progress,
                  ),
                  Divider(),
                  CueWidget(
                    cue: widget.habit.cue,
                  ),
                  Divider(),
                  CoolDataWidget(
                    initialDate: widget.habit.initialDate != null ? widget.habit.initialDate : DateTime.now(),
                    daysDone: widget.habit.daysDone,
                    cycles: widget.habit.cycle,
                  ),
                  Divider(),
                  CalendarWidget(
                    markedDays: markedDays,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 200.0,
            width: double.maxFinite,
            child: HeaderWidget(
              habit: widget.habit,
              frequency: widget.frequency,
              fromAllHabits: widget.fromAllHabits,
              score: score,
              previousScore: previousScore,
              done: hasDoneToday(),
              setDoneHabit: setDoneHabit,
              controller: _controllerScore,
            ),
          ),
        ],
      ),
    );
  }
}
