import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:habit/ui/editHabitPage.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/widgets/Toast.dart';
import 'package:vibration/vibration.dart';
import 'package:habit/ui/widgets/Loading.dart';
import 'package:habit/ui/detailHabitWidget/cueWidget.dart';
import 'package:habit/ui/detailHabitWidget/coolDataWidget.dart';
import 'package:habit/ui/detailHabitWidget/calendarWidget.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/ui/dialogs/editCueDialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:habit/ui/widgets/RocketScene.dart';

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key}) : super(key: key);

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> with TickerProviderStateMixin {
  PanelController _panelController = new PanelController();
  AnimationController _controllerScore;

  DataHabitDetail data = DataHabitDetail();

  int _panelIndex = -1;
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    animateScore();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    super.dispose();
  }

  void animateScore() {
    if (previousScore != data.habit.score) {
      _controllerScore.reset();
      _controllerScore.forward().then((e) {
        previousScore = data.habit.score;
      });
    }
  }

  bool hasDoneToday() {
    DateTime now = DateTime.now();
    if (data.daysDone.containsKey(DateTime(now.year, now.month, now.day))) {
      return true;
    } else {
      return false;
    }
  }

  void setDoneHabit() {
    if (hasDoneToday()) {
      showToast("Você já completou esse hábito hoje!");
    } else {
      Loading.showLoading(context);

      DataControl().setHabitDoneAndScore(data.habit.id, data.habit.cycle).then((earnedScore) {
        Loading.closeLoading(context);
        Vibration.hasVibrator().then((resp) {
          if (resp != null && resp == true) {
            Vibration.vibrate(duration: 100);
          }
        });

        DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        bool before;
        if (data.daysDone.length - 1 >= 0 && data.daysDone.containsKey(now.subtract(Duration(days: 1)))) {
          data.daysDone[now.subtract(Duration(days: 1))] = [data.daysDone[now.subtract(Duration(days: 1))][0], true];
          before = true;
        } else {
          before = false;
        }

        setState(() {
          data.habit.score += earnedScore;
          data.daysDone.putIfAbsent(now, () => [before, false]);
          data.habit.daysDone++;
        });
        animateScore();
      });
    }
  }

  Future<bool> onBackPress() async {
    if (_panelController.isPanelOpen()) {
      closeBottomSheet();
      return false;
    }

    return true;
  }

  void openBottomSheet(int index) {
    if (index == 0) {
      setState(() {
        _panelIndex = 0;
      });
      _panelController.open();
    } else {
      setState(() {
        _panelIndex = -1;
      });
    }
  }

  void closeBottomSheet() {
    setState(() {});
    _panelController.close();
  }

  Widget _bottomSheetBuilder() {
    if (_panelIndex == 0) {
      return EditCueDialog(
        closeBottomSheet: closeBottomSheet,
      );
    } else {
      return SizedBox();
    }
  }

  String frequencyText() {
    if (data.frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = data.frequency;
      String text = "";
      bool hasOne = false;

      if (freq.monday == 1) {
        text += "Segunda";
        hasOne = true;
      }
      if (freq.tuesday == 1) {
        if (hasOne) text += ", ";
        text += "Terça";
        hasOne = true;
      }
      if (freq.wednesday == 1) {
        if (hasOne) text += ", ";
        text += "Quarta";
        hasOne = true;
      }
      if (freq.thursday == 1) {
        if (hasOne) text += ", ";
        text += "Quinta";
        hasOne = true;
      }
      if (freq.friday == 1) {
        if (hasOne) text += ", ";
        text += "Sexta";
        hasOne = true;
      }
      if (freq.saturday == 1) {
        if (hasOne) text += ", ";
        text += "Sábado";
        hasOne = true;
      }
      if (freq.sunday == 1) {
        if (hasOne) text += ", ";
        text += "Domingo";
      }
      return text;
    } else if (data.frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = data.frequency;
      return freq.daysTime.toString() + " vezes por semana";
    } else if (data.frequency.runtimeType == FreqRepeating) {
      FreqRepeating freq = data.frequency;
      return freq.daysTime.toString() + " vezes em " + freq.daysCycle.toString() + " dias";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: SlidingUpPanel(
          controller: _panelController,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          backdropEnabled: true,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: 0,
          panel: _bottomSheetBuilder(),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70.0,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    BackButton(color: data.getColor()),
                    Spacer(),
                    IconButton(icon: Icon(Icons.check, size: 34, color: data.getColor()), onPressed: setDoneHabit),
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                        icon: Icon(Icons.edit, size: 30, color: data.getColor()),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return EditHabitPage();
                          }));
                        }),
                  ]),
                ),
                HeaderWidget(
                  previousScore: previousScore,
                  controllerScore: _controllerScore,
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                Text(
                  frequencyText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black54),
                ),
                CueWidget(
                  openBottomSheet: openBottomSheet,
                ),
                CalendarWidget(),
                CoolDataWidget(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, this.previousScore, this.controllerScore}) : super(key: key);

  final int previousScore;
  final controllerScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: RocketScene(
              color: DataHabitDetail().getColor(),
              force: 1,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  DataHabitDetail().habit.habit,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 19),
                ),
                ScoreWidget(
                  color: DataHabitDetail().getColor(),
                  animation: IntTween(begin: previousScore, end: DataHabitDetail().habit.score)
                      .animate(CurvedAnimation(parent: controllerScore, curve: Curves.fastOutSlowIn)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
