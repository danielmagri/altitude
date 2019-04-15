import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
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

class _AddHabitPageState extends State<AddHabitPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final rewardController = TextEditingController();
  final habitController = TextEditingController();
  final cueController = TextEditingController();
  int selection = 0;

  dynamic frequency;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
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

  void frequencySettingTap(bool next, dynamic frequency) {
    this.frequency = frequency;
    if (next) {
      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void cueSettingTap(bool next) {
    if (next) {
      Habit habit = new Habit(
          category: 1, cue: cueController.text, habit: habitController.text, reward: rewardController.text, score: 0);

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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 127, 114),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            CategoryTab(
              onTap: categorySelected,
            ),
            RewardTab(
              controller: rewardController,
              onTap: rewardSettingTap,
            ),
            HabitTab(
              controller: habitController,
              onTap: habitSettingTap,
            ),
            FrequencyTab(
              onTap: frequencySettingTap,
            ),
            CueTab(
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
