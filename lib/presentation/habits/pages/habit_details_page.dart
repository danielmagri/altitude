import 'dart:async' show Timer;

import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/constant/ads_utils.dart';
import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/enums/done_page_type.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/skeleton.dart';
import 'package:altitude/common/view/generic/tutorial_presentation.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:altitude/presentation/habits/controllers/habit_details_controller.dart';
import 'package:altitude/presentation/habits/dialogs/edit_alarm_dialog.dart';
import 'package:altitude/presentation/habits/dialogs/edit_cue_dialog.dart';
import 'package:altitude/presentation/habits/widgets/calendar_widget.dart';
import 'package:altitude/presentation/habits/widgets/cool_data_widget.dart';
import 'package:altitude/presentation/habits/widgets/cue_widget.dart';
import 'package:altitude/presentation/habits/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HabitDetailsPage extends StatefulWidget {
  const HabitDetailsPage(this.arguments, {Key? key}) : super(key: key);

  final HabitDetailsPageArguments? arguments;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState
    extends BaseStateWithController<HabitDetailsPage, HabitDetailsController> {
  final ScrollController scrollController = ScrollController();

  final BannerAd banner = BannerAd(
    adUnitId: AdsUtils.habitDetailsBannerAdUnitId,
    size: AdSize.largeBanner,
    request: AdsUtils.adRequest,
    listener: AdsUtils.adBannerListener,
  );

  @override
  void initState() {
    super.initState();
    banner.load();

    controller.fetchData(widget.arguments!.id, widget.arguments!.color);

    showInitialTutorial();
  }

  Future<void> showInitialTutorial() async {
    if (!serviceLocator.get<SharedPref>().rocketTutorial) {
      Timer.run(() async {
        await Future.delayed(const Duration(milliseconds: 600));
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        await navigateSmooth(
          const TutorialPresentation(
            focusAlignment: Alignment(-0.55, -0.6),
            focusRadius: 0.42,
            textAlignment: Alignment(0, 0.5),
            text: [
              TextSpan(
                text: 'Esse é seu hábito em forma de foguete..',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextSpan(
                text:
                    '\nQuanto mais você completar seu hábito mais potente ele fica e mais longe vai!',
              ),
              TextSpan(
                text:
                    '\n\nSiga a frequência certinho para ir ainda mais longe!',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
            hasNext: true,
          ),
        );
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        await navigateSmooth(
          const TutorialPresentation(
            focusAlignment: Alignment(0.0, -0.35),
            focusRadius: 0.45,
            textAlignment: Alignment(0, 0.51),
            text: [
              TextSpan(
                text:
                    'No calendário você tem o controle de todos os dias feitos!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextSpan(
                text:
                    '\n\nAo manter pressionado um dia você consegue marcar como feito ou desmarcar.',
              ),
            ],
          ),
        );
      });
      serviceLocator.get<SharedPref>().rocketTutorial = true;
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
      if (donePageType == DonePageType.calendar &&
          add &&
          serviceLocator.get<SharedPref>().alarmTutorial < 2 &&
          controller.reminders.data?.hasAnyDay() == true) {
        await Future.delayed(const Duration(milliseconds: 600));
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        navigateSmooth(
          const TutorialPresentation(
            focusAlignment: Alignment(0.65, -0.85),
            focusRadius: 0.15,
            textAlignment: Alignment(0, 0),
            text: [
              TextSpan(
                text: 'Esqueceu de marcar como feito o hábito?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextSpan(
                text:
                    '\n\nQue tal colocar um alarme, assim você será sempre lembrado a hora que desejar!',
              ),
            ],
          ),
        );
        serviceLocator.get<SharedPref>().addAlarmTutorial();
      }
    }).catchError(handleError);
  }

  void openReminderBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => const EditAlarmDialog(),
    );
  }

  void openCueBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => const EditCueDialog(),
    );
  }

  Future<void> goEditHabitPage() async {
    var arguments = EditHabitPageArguments(
      controller.habit.data!,
      await controller.hasCompetition(),
    );
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
                      loading: () => const Skeleton(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(bottom: 4, right: 8),
                      ),
                      success: (data) => IconButton(
                        icon: Icon(
                          data != null && data.hasAnyDay()
                              ? Icons.alarm_on
                              : Icons.add_alarm,
                          size: 25,
                          color: controller.habitColor,
                        ),
                        onPressed: openReminderBottomSheet,
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) => controller.habit.handleState(
                      loading: () => const Skeleton(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(bottom: 4, right: 8),
                      ),
                      success: (data) => IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 25,
                          color: controller.habitColor,
                        ),
                        onPressed: goEditHabitPage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HeaderWidget(),
            Container(
              margin: const EdgeInsets.only(
                top: 36,
                bottom: 4,
                left: 32,
                right: 32,
              ),
              width: double.maxFinite,
              height: 50,
              child: Observer(
                builder: (_) =>
                    controller.isHabitDone.handleStateLoadableWithData(
                  loading: (data) => data == null
                      ? const Skeleton(
                          width: double.maxFinite,
                          height: 50,
                        )
                      : _completeButton(data, true),
                  success: (data) => _completeButton(data, false),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Observer(
                builder: (_) => controller.frequency.handleState(
                  loading: () => const Skeleton(width: 200, height: 20),
                  success: (data) => Text(
                    data!.frequencyText(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
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

  Widget _completeButton(bool data, bool loading) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          data
              ? controller.habitColor
              : AppTheme.of(context).materialTheme.cardColor,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15),
        ),
        overlayColor:
            MaterialStateProperty.all(controller.habitColor.withOpacity(0.2)),
        elevation: MaterialStateProperty.all(2),
      ),
      onPressed: () {
        if (!data) {
          completeHabit(true, DateTime.now().onlyDate, DonePageType.detail);
        }
      },
      child: loading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  data ? Colors.white : controller.habitColor,
                ),
              ),
            )
          : Text(
              data ? 'HÁBITO COMPLETO!' : 'COMPLETAR HÁBITO HOJE',
              style: TextStyle(
                fontSize: 16,
                color: data ? Colors.white : controller.habitColor,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
