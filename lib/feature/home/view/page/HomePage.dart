import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/view/Score.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/feature/home/view/dialogs/NewLevelDialog.dart';
import 'package:altitude/feature/home/view/widget/HabitsPanel.dart';
import 'package:altitude/feature/home/view/widget/HomeBottomNavigation.dart';
import 'package:altitude/feature/home/view/widget/HomeDrawer.dart';
import 'package:altitude/feature/home/view/widget/SkyDragTarget.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomeLogic controller = GetIt.I.get<HomeLogic>();
  bool isPageActived = true;

  @override
  initState() {
    super.initState();
    controller.getUser();
    controller.getHabits();
    controller.fetchPendingStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onPageBack(Object value) {
    controller.getUser().then((_) {
      hasLevelUp(controller.user.data.score);
    });

    controller.getHabits();
    controller.fetchPendingStatus();
    super.onPageBack(value);
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<HomeLogic>();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      controller.fetchPendingStatus();
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color.fromARGB(100, 250, 250, 250),
          systemNavigationBarColor: Color.fromARGB(255, 250, 250, 250),
          systemNavigationBarIconBrightness: Brightness.dark));
    }
  }

  void showDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  void setHabitDone(String id) {
    showLoading(true);
    controller.completeHabit(id).then((newScore) async {
      showLoading(false);
      vibratePhone();
      hasLevelUp(newScore);
    }).catchError(handleError);
  }

  void hasLevelUp(int score) async {
    if (await controller.checkLevelUp(score)) {
      navigateSmooth(NewLevelDialog(score: score));
    }
  }

  void goAllLevels() {
    var arguments = AllLevelsPageArguments(controller.user.data.score);
    navigatePush('allLevels', arguments: arguments);
  }

  void goAddHabit() {
    navigatePush('addHabit');
  }

  void goHabitDetails(String id, int oldId, int color) {
    var arguments = HabitDetailsPageArguments(id, oldId, color);
    navigatePush('habitDetails', arguments: arguments);
  }

  void goFriends() {
    navigatePopAndPush('friends');
  }

  void goStatistics() {
    navigatePush('statistics');
  }

  void goCompetition(bool pop) {
    if (pop)
      navigatePopAndPush('competition');
    else
      navigatePush('competition');
  }

  void goLearn() {
    navigatePopAndPush('learn');
  }

  void goSettings() {
    navigatePopAndPush('settings');
  }

  @override
  Widget build(context) {
    return Scaffold(
        key: scaffoldKey,
        drawer:
            HomeDrawer(goFriends: goFriends, goCompetition: goCompetition, goLearn: goLearn, goSettings: goSettings),
        drawerScrimColor: Colors.black12,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(top: 24, left: 12, right: 8),
                  child: Row(
                    children: <Widget>[
                      Observer(
                          builder: (_) => IconButtonStatus(
                              icon: const Icon(Icons.menu),
                              onPressed: showDrawer,
                              status: controller.pendingLearnStatus)),
                      const Spacer(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: goAllLevels,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Observer(builder: (_) {
                      return controller.user.handleState(
                        () {
                          return Skeleton.custom(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 100,
                                    height: 20,
                                    decoration:
                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
                                const SizedBox(height: 4),
                                Container(
                                    width: 120,
                                    height: 70,
                                    decoration:
                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)))
                              ],
                            ),
                          );
                        },
                        (data) {
                          return Column(children: <Widget>[
                            Text(data.levelText),
                            const SizedBox(height: 4),
                            Score(color: AppColors.colorAccent, score: data.score),
                          ]);
                        },
                        (error) {
                          return const DataError();
                        },
                      );
                    }),
                  ),
                ),
                // Container(
                //   alignment: Alignment.centerRight,
                //   padding: const EdgeInsets.only(right: 12, top: 24),
                //   child: Observer(
                //     builder: (_) => PopupMenuButton<HabitFiltersType>(
                //       initialValue: controller.filterSelected,
                //       onSelected: controller.selectFilter,
                //       itemBuilder: (_) => HabitFiltersType.values
                //           .map((type) => PopupMenuItem(value: type, child: Text(type.title)))
                //           .toList(),
                //       child: Row(mainAxisSize: MainAxisSize.min, children: [
                //         Text(controller.filterSelected.title, style: TextStyle(color: AppColors.popupMenuButtonHome)),
                //         Icon(Icons.arrow_drop_down, color: AppColors.popupMenuButtonHome),
                //       ]),
                //     ),
                //   ),
                // ),
                Expanded(child: HabitsPanel(goHabitDetails: goHabitDetails)),
              ],
            ),
            Observer(builder: (_) => SkyDragTarget(visibilty: controller.visibilty, setHabitDone: setHabitDone)),
          ],
        ),
        bottomNavigationBar:
            HomebottomNavigation(goAddHabit: goAddHabit, goStatistics: goStatistics, goCompetition: goCompetition));
  }
}
