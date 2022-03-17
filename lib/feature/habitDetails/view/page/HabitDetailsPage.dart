import 'dart:async' show Timer;
import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/common/view/generic/TutorialPresentation.dart';
import 'package:altitude/core/base/base_state.dart';
import 'package:altitude/core/handler/AdsHandler.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/feature/habitDetails/view/dialogs/EditAlarmDialog.dart';
import 'package:altitude/feature/habitDetails/view/dialogs/EditCueDialog.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/feature/habitDetails/view/widgets/calendarWidget.dart';
import 'package:altitude/feature/habitDetails/view/widgets/coolDataWidget.dart';
import 'package:altitude/feature/habitDetails/view/widgets/cueWidget.dart';
import 'package:altitude/feature/habitDetails/view/widgets/headerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage(this.arguments);

  final HabitDetailsPageArguments? arguments;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends BaseStateWithLogic<HabitDetailsPage, HabitDetailsLogic> {
  final ScrollController scrollController = ScrollController();

  final BannerAd banner = BannerAd(
      adUnitId: AdsHandler.habitDetailsBannerAdUnitId,
      size: AdSize.largeBanner,
      request: AdsHandler.adRequest,
      listener: AdsHandler.adBannerListener);

  @override
  void initState() {
    super.initState();
    banner.load();

    controller.fetchData(widget.arguments!.id, widget.arguments!.color);

    showInitialTutorial();
  }

  void showInitialTutorial() async {
    if (!SharedPref.instance.rocketTutorial) {
      Timer.run(() async {
        await Future.delayed(Duration(milliseconds: 600));
        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        await navigateSmooth(
          TutorialPresentation(
              focusAlignment: Alignment(-0.55, -0.6),
              focusRadius: 0.42,
              textAlignment: Alignment(0, 0.5),
              text: const [
                TextSpan(
                    text: "Esse é seu hábito em forma de foguete..",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                TextSpan(text: "\nQuanto mais você completar seu hábito mais potente ele fica e mais longe vai!"),
                TextSpan(
                    text: "\n\nSiga a frequência certinho para ir ainda mais longe!",
                    style: TextStyle(fontWeight: FontWeight.w300)),
              ],
              hasNext: true),
        );
        await scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        await navigateSmooth(
          TutorialPresentation(
            focusAlignment: Alignment(0.0, -0.35),
            focusRadius: 0.45,
            textAlignment: Alignment(0, 0.51),
            text: const [
              TextSpan(
                  text: "No calendário você tem o controle de todos os dias feitos!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: "\n\nAo manter pressionado um dia você consegue marcar como feito ou desmarcar."),
            ],
          ),
        );
      });
      SharedPref.instance.rocketTutorial = true;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    banner.dispose();
    super.dispose();
  }

  @override
  void onPageBack(Object? value) {
    if (value is bool && !value) {
      navigatePop();
    } else {
      setState(() {});
      super.onPageBack(value);
    }
  }

  void completeHabit(bool add, DateTime date, DonePageType donePageType) {
    controller.setDoneHabit(add, date, donePageType).then((_) async {
      vibratePhone();
      if (donePageType == DonePageType.Calendar &&
          add &&
          SharedPref.instance.alarmTutorial < 2 &&
          controller.reminders.data?.hasAnyDay() == true) {
        await Future.delayed(Duration(milliseconds: 600));
        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        navigateSmooth(
          TutorialPresentation(
            focusAlignment: Alignment(0.65, -0.85),
            focusRadius: 0.15,
            textAlignment: Alignment(0, 0),
            text: [
              TextSpan(
                  text: "Esqueceu de marcar como feito o hábito?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: "\n\nQue tal colocar um alarme, assim você será sempre lembrado a hora que desejar!"),
            ],
          ),
        );
        SharedPref.instance.addAlarmTutorial();
      }
    }).catchError(handleError);
  }

  void openReminderBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        isScrollControlled: true,
        builder: (_) => EditAlarmDialog());
  }

  void openCueBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        isScrollControlled: true,
        builder: (_) => EditCueDialog());
  }

  void goEditHabitPage() async {
    var arguments = EditHabitPageArguments(controller.habit.data, await controller.hasCompetition());
    navigatePush('editHabit', arguments: arguments);
  }

  void competition(int index) {
    GetIt.I.get<IFireAnalytics>().sendGoCompetition(index.toString());
    navigatePush('competition');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 75,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BackButton(color: controller.habitColor),
                  const Spacer(),
                  Observer(
                    builder: (_) => controller.reminders.handleState(
                      () => const Skeleton(width: 40, height: 40, margin: const EdgeInsets.only(bottom: 4, right: 8)),
                      (data) => IconButton(
                          icon: Icon(data != null && data.hasAnyDay() ? Icons.alarm_on : Icons.add_alarm,
                              size: 25, color: controller.habitColor),
                          onPressed: openReminderBottomSheet),
                      (error) => const SizedBox(),
                    ),
                  ),
                  Observer(
                    builder: (_) => controller.habit.handleState(
                      () => const Skeleton(width: 40, height: 40, margin: const EdgeInsets.only(bottom: 4, right: 8)),
                      (data) => IconButton(
                        icon: Icon(Icons.edit, size: 25, color: controller.habitColor),
                        onPressed: goEditHabitPage,
                      ),
                      (error) => const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            HeaderWidget(),
            Container(
              margin: const EdgeInsets.only(top: 36, bottom: 4, left: 32, right: 32),
              width: double.maxFinite,
              height: 50,
              child: Observer(
                builder: (_) => controller.isHabitDone.handleStateLoadable(
                  () => const Skeleton(width: double.maxFinite, height: 50),
                  (data, loading) => ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            data! ? controller.habitColor : AppTheme.of(context).materialTheme.cardColor),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
                        overlayColor: MaterialStateProperty.all(controller.habitColor.withOpacity(0.2)),
                        elevation: MaterialStateProperty.all(2)),
                    onPressed: () {
                      if (!data) completeHabit(true, DateTime.now().today, DonePageType.Detail);
                    },
                    child: loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(data ? Colors.white : controller.habitColor)))
                        : Text(data ? "HÁBITO COMPLETO!" : "COMPLETAR HÁBITO HOJE",
                            style: TextStyle(
                                fontSize: 16,
                                color: data ? Colors.white : controller.habitColor,
                                fontWeight: FontWeight.bold)),
                  ),
                  (error) => const SizedBox(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Observer(
                builder: (_) => controller.frequency.handleState(
                  () => const Skeleton(width: 200, height: 20),
                  (data) => Text(data!.frequencyText(),
                      textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300)),
                  (error) => const SizedBox(),
                ),
              ),
            ),
            CueWidget(openBottomSheet: openCueBottomSheet),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: banner),
              width: banner.size.width.toDouble(),
              height: banner.size.height.toDouble(),
            ),
            const SizedBox(height: 16),
            CalendarWidget(completeHabit: completeHabit),
            const SizedBox(height: 16),
            CoolDataWidget(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
