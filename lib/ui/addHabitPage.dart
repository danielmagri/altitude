import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/addHabitTabs/categoryTab.dart';
import 'package:habit/ui/addHabitTabs/rewardTab.dart';
import 'package:habit/ui/addHabitTabs/cueTab.dart';
import 'package:habit/ui/addHabitTabs/habitTab.dart';
import 'package:habit/ui/addHabitTabs/frequencyTab.dart';

class AddHabitPage extends StatefulWidget {
  AddHabitPage({Key key}) : super(key: key);

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> with TickerProviderStateMixin {
  TabController _tabController;
  AnimationController _backgroundController;
  Animation _backgroundAnimation;

  final Color _startColor = Colors.white;
  final rewardController = TextEditingController();
  final habitController = TextEditingController();
  final cueController = TextEditingController();

  Category category;
  dynamic frequency;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _backgroundController.dispose();
    rewardController.dispose();
    habitController.dispose();
    cueController.dispose();
    super.dispose();
  }

  void categoryTabTap(Category selection) {
    category = selection;
    Color color;

    switch (category) {
      case Category.FISICO:
        color = Colors.red;
        break;
      case Category.MENTAL:
        color = Colors.green;
        break;
      case Category.LOCURA:
        color = Colors.blue;
        break;
      case Category.DOIDERA:
        color = Colors.yellow;
        break;
    }

    _backgroundAnimation = ColorTween(begin: _startColor, end: color)
        .animate(CurvedAnimation(parent: _backgroundController, curve: Curves.linear));

    _backgroundController.forward();
    _nextPage(1);
  }

  void rewardTabTap(bool next) {
    if (next) {
      _nextPage(1);
    } else {
      _backgroundController.reverse();
      _nextPage(-1);
    }
  }

  void habitTabTap(bool next) {
    if (next) {
      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void frequencyTabTap(bool next, dynamic frequency) {
    this.frequency = frequency;
    if (next) {
      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void cueTabTap(bool next) {
    if (next) {
      Habit habit = new Habit(
          category: category, cue: cueController.text, habit: habitController.text, reward: rewardController.text, score: 0);

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
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: _backgroundAnimation == null ? _startColor : _backgroundAnimation.value,
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                CategoryTab(
                  onCategoryTap: categoryTabTap,
                ),
                RewardTab(
                  controller: rewardController,
                  onTap: rewardTabTap,
                ),
                HabitTab(
                  controller: habitController,
                  onTap: habitTabTap,
                ),
                FrequencyTab(
                  onTap: frequencyTabTap,
                ),
                CueTab(
                  controller: cueController,
                  onTap: cueTabTap,
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
      },
    );
  }
}
