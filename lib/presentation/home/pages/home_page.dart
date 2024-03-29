import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/data_error.dart';
import 'package:altitude/common/view/generic/skeleton.dart';
import 'package:altitude/common/view/score.dart';
import 'package:altitude/presentation/home/controllers/home_controller.dart';
import 'package:altitude/presentation/home/dialogs/new_level_dialog.dart';
import 'package:altitude/presentation/home/widgets/habits_panel.dart';
import 'package:altitude/presentation/home/widgets/home_bottom_navigation.dart';
import 'package:altitude/presentation/home/widgets/home_drawer.dart';
import 'package:altitude/presentation/home/widgets/sky_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseStateWithController<HomePage, HomeController>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    fetchData();
    WidgetsBinding.instance!.addObserver(this);
  }

  void fetchData() {
    controller.getUser();
    controller.getHabits();
    controller.fetchPendingStatus();
  }

  @override
  void onPageBack(Object? value) {
    controller.getUser().then((_) {
      hasLevelUp(controller.user.data!.score);
    });

    controller.getHabits();
    controller.fetchPendingStatus();
    super.onPageBack(value);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      controller.fetchPendingStatus();
      controller.updateSystemStyle();
    }
  }

  void showDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void setHabitDone(String id) {
    showLoading(true);
    controller.completeHabit(id).then((newScore) async {
      showLoading(false);
      vibratePhone();
      hasLevelUp(newScore!);
    }).catchError(handleError);
  }

  Future<void> hasLevelUp(int score) async {
    if (await controller.checkLevelUp(score)) {
      navigateSmooth(NewLevelDialog(score: score));
    }
  }

  void goAllLevels() {
    var arguments = AllLevelsPageArguments(controller.user.data?.score ?? 0);
    navigatePush('allLevels', arguments: arguments);
  }

  void goAddHabit() {
    navigatePush('addHabit');
  }

  void goHabitDetails(String id, int color) {
    var arguments = HabitDetailsPageArguments(id, color);
    navigatePush('habitDetails', arguments: arguments);
  }

  void goFriends() {
    navigatePopAndPush('friends');
  }

  void goStatistics() {
    navigatePush('statistics');
  }

  void goCompetition(bool pop) {
    if (pop) {
      navigatePopAndPush('competition');
    } else {
      navigatePush('competition');
    }
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
      drawer: HomeDrawer(
        controller: controller,
        goFriends: goFriends,
        goCompetition: goCompetition,
        goLearn: goLearn,
        goSettings: goSettings,
      ),
      drawerScrimColor: Colors.black12,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 24, left: 12, right: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: showDrawer,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: goAllLevels,
                child: Container(
                  color: AppTheme.of(context).materialTheme.backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Observer(
                    builder: (_) {
                      return controller.user.handleState(
                        loading: () {
                          return Skeleton.custom(
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 120,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        success: (data) {
                          return Column(
                            children: [
                              Text(data.levelText),
                              const SizedBox(height: 4),
                              Score(score: data.score),
                            ],
                          );
                        },
                        error: (error) {
                          return const DataError();
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: HabitsPanel(
                  controller: controller,
                  goHabitDetails: goHabitDetails,
                ),
              ),
            ],
          ),
          Observer(
            builder: (_) => SkyDragTarget(
              visibilty: controller.visibilty,
              setHabitDone: setHabitDone,
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomebottomNavigation(
        controller: controller,
        goAddHabit: goAddHabit,
        goStatistics: goStatistics,
        goCompetition: goCompetition,
      ),
    );
  }
}
