import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Progress.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/addHabitTabs/categoryTab.dart';
import 'package:habit/ui/addHabitTabs/rewardTab.dart';
import 'package:habit/ui/addHabitTabs/cueTab.dart';
import 'package:habit/ui/addHabitTabs/habitTab.dart';
import 'package:habit/ui/addHabitTabs/frequencyTab.dart';
import 'package:habit/utils/Color.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class AddHabitPage extends StatefulWidget {
  AddHabitPage({Key key}) : super(key: key);

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> with TickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController = PageController();
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  AnimationController _backgroundController;
  Animation _backgroundAnimation;

  final Color _startColor = Colors.white;
  final rewardController = TextEditingController();
  final habitController = TextEditingController();
  final cueController = TextEditingController();

  CategoryEnum category;
  dynamic frequency;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _backgroundController.dispose();
    rewardController.dispose();
    habitController.dispose();
    cueController.dispose();
    super.dispose();
  }

  void categoryTabTap(CategoryEnum selection) {
    category = selection;
    Color color;

    color = CategoryColors.getPrimaryColor(category);

    _backgroundAnimation = ColorTween(begin: _startColor, end: color)
        .animate(CurvedAnimation(parent: _backgroundController, curve: Curves.linear));

    _backgroundController.forward();
    _nextTab(1);
  }

  void rewardTabTap(bool next) {
    if (next) {
      _nextPage(1);
    } else {
      _nextTab(-1);
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
          category: category,
          icon: 1,
          cue: cueController.text,
          habit: habitController.text,
          reward: rewardController.text,
          progress: Progress(type: ProgressEnum.DAY, progress: 10, goal: 12));

      DataControl().addHabit(habit, frequency).then((result) {
        Navigator.pop(context);
      });

      _nextPage(1);
    } else {
      _nextPage(-1);
    }
  }

  void _nextTab(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex == 0) {
      _backgroundController.reverse();
    }
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  void _nextPage(int delta) {
    if (delta == 1)
      _pageController.nextPage(duration: Duration(milliseconds: 2000), curve: Curves.elasticOut);
    else if (delta == -1)
      _pageController.previousPage(duration: Duration(milliseconds: 2000), curve: Curves.elasticOut);
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    if (_tabController.index == 0) {
      return true;
    } else if (_pageController.page >= 0.8) {
      _nextPage(-1);
      return false;
    } else if (_tabController.index == 1) {
      _nextTab(-1);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return MaterialApp(
            theme: Theme.of(context).copyWith(
                textTheme: TextTheme(body1: TextStyle(color: Colors.white)),
                buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary)),
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
                  PageView(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    children: <Widget>[
                      RewardTab(
                        category: category,
                        controller: rewardController,
                        keyboard: _keyboardVisibility,
                        onTap: rewardTabTap,
                      ),
                      HabitTab(
                        category: category,
                        controller: habitController,
                        keyboard: _keyboardVisibility,
                        onTap: habitTabTap,
                      ),
                      FrequencyTab(
                        category: category,
                        onTap: frequencyTabTap,
                      ),
                      CueTab(
                        category: category,
                        controller: cueController,
                        keyboard: _keyboardVisibility,
                        onTap: cueTabTap,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
