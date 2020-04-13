import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/view/RainbowAnimated.dart';
import 'package:altitude/common/view/Score.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/feature/home/view/dialogs/NewLevelDialog.dart';
import 'package:altitude/feature/home/view/widget/AllHabits.dart';
import 'package:altitude/feature/home/view/widget/HomeBottomNavigation.dart';
import 'package:altitude/feature/home/view/widget/HomeDrawer.dart';
import 'package:altitude/feature/home/view/widget/SkyDragTarget.dart';
import 'package:altitude/feature/home/view/widget/TodayHabits.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController(initialPage: 1);

  HomeLogic controller = GetIt.I.get<HomeLogic>();
  bool isPageActived = true;

  @override
  initState() {
    super.initState();

    controller.fetchData();
  }

  @override
  void onPageBack(Object value) {
    controller.fetchData().then((_) {
      hasLevelUp(controller.user.data.score);
    });
    super.onPageBack(value);
  }

  @override
  void dispose() {
    pageController.dispose();
    GetIt.I.resetLazySingleton<HomeLogic>();
    super.dispose();
  }

  void showDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  void setHabitDone(id) {
    showLoading(true);
    controller.completeHabit(id).then((newScore) async {
      showLoading(false);
      vibratePhone();
      hasLevelUp(newScore);
    }).catchError((error) {
      showLoading(false);
      showToast("Ocorreu um erro");
    });
  }

  void hasLevelUp(int score) async {
    if (await controller.checkLevelUp(score)) {
      navigateSmooth(NewLevelDialog(score: score));
    }
  }

  void pageScroll(int index) {
    pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void goAllLevels() {
    var arguments = AllLevelsPageArguments(controller.user.data.score);
    navigatePush('allLevels', arguments: arguments);
  }

  void goAddHabit() {
    navigatePush('addHabit');
  }

  void goHabitDetails(int id, int color) {
    var arguments = HabitDetailsPageArguments(id, color);
    navigatePush('habitDetails', arguments: arguments);
  }

  void goFriends() {
    navigatePopAndPush('friends');
  }

  void goCompetition() {
    navigatePopAndPush('competition');
  }

  void goSettings() {
    navigatePopAndPush('settings');
  }

  void goBuyBook() {
    navigatePush('buyBook');
  }

  @override
  Widget build(context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: HomeDrawer(goFriends: goFriends, goCompetition: goCompetition, goSettings: goSettings),
        drawerScrimColor: Colors.black12,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: 75,
                  padding: const EdgeInsets.only(top: 20, left: 12, right: 8),
                  child: Row(
                    children: <Widget>[
                      IconButton(tooltip: "Menu", icon: Icon(Icons.menu), onPressed: showDrawer),
                      Spacer(),
                      IconButton(
                          icon: RainbowAnimated(child: (color) => Icon(Icons.new_releases, color: color)),
                          iconSize: 28,
                          onPressed: goBuyBook),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: goAllLevels,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 25),
                        Observer(builder: (_) {
                          return controller.user.handleState(
                            () {
                              return Skeleton.custom(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white, borderRadius: new BorderRadius.circular(15)),
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      width: 120,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.white, borderRadius: new BorderRadius.circular(15)),
                                    )
                                  ],
                                ),
                              );
                            },
                            (data) {
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(LevelControl.getLevelText(data.score)),
                                  Score(color: AppColors.colorAccent, score: data.score),
                                ],
                              );
                            },
                            (error) {
                              return SizedBox();
                            },
                          );
                        }),
                        Observer(builder: (_) {
                          return controller.user.handleState(
                            () {
                              return Skeleton(
                                width: 25,
                                height: 25,
                                margin: const EdgeInsets.only(bottom: 4, right: 8),
                              );
                            },
                            (data) {
                              return Image.asset(
                                LevelControl.getLevelImagePath(data.score),
                                height: 25,
                                width: 25,
                              );
                            },
                            (error) {
                              return SizedBox();
                            },
                          );
                        })
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: BouncingScrollPhysics(),
                    onPageChanged: controller.swipedPage,
                    children: <Widget>[
                      AllHabitsPage(goHabitDetails: goHabitDetails),
                      TodayHabits(goHabitDetails: goHabitDetails),
                    ],
                  ),
                ),
              ],
            ),
            Observer(builder: (_) {
              return SkyDragTarget(visibilty: controller.visibilty, setHabitDone: setHabitDone);
            }),
          ],
        ),
        bottomNavigationBar: HomebottomNavigation(pageScroll: pageScroll, goAddHabit: goAddHabit));
  }
}
