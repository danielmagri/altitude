import 'package:altitude/common/constant/Constants.dart'
    show MAX_HABIT_COMPETITIONS;
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/focus_fixer.dart';
import 'package:altitude/core/handler/AdsHandler.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/model/BackDataItem.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/competition/logic/CreateCompetitionLogic.dart';
import 'package:flutter/material.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CreateCompetitionPage extends StatefulWidget {
  CreateCompetitionPage(this.arguments);

  final CreateCompetitionPageArguments? arguments;

  @override
  _CreateCompetitionPageState createState() => _CreateCompetitionPageState();
}

class _CreateCompetitionPageState
    extends BaseStateWithLogic<CreateCompetitionPage, CreateCompetitionLogic> {
  final TextEditingController textEditingController = TextEditingController();

  InterstitialAd? myInterstitial;

  @override
  void initState() {
    InterstitialAd.load(
      adUnitId: AdsHandler.edithabitOnSaveIntersticialAdUnitId,
      request: AdsHandler.adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this.myInterstitial = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
    controller.habits = widget.arguments!.habits;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    myInterstitial!.dispose();
    super.dispose();
  }

  @override
  void onPageBack(Object? value) {
    if (value is Habit) {
      controller.addHabit(value);
    }
    super.onPageBack(value);
  }

  void createCompetition() async {
    var competitionNameValidate =
        ValidationHandler.competitionNameValidate(textEditingController.text);
    if (competitionNameValidate != null) {
      showToast(competitionNameValidate);
    } else if (controller.selectedHabit == null) {
      showToast("Escolha um hábito para competir.");
    } else if (controller.selectedFriends.length == 0) {
      showToast("Escolha pelo menos um amigo.");
    } else if (await controller.checkHabitCompetitionLimit()) {
      showToast(
          "O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
    } else {
      showLoading(true);
      controller
          .createCompetition(textEditingController.text)
          .then((res) async {
        showLoading(false);
        myInterstitial?.show();
        navigatePop(result: BackDataItem.added(res));
      }).catchError(handleError);
    }
  }

  void goAddHabit() {
    navigatePush('addHabit', arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return FocusFixer(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Header(title: "CRIAR COMPETIÇÃO"),
              const SizedBox(height: 32),
              const Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: const Text("Nome da competição",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
                child: TextField(
                  controller: textEditingController,
                  style: const TextStyle(fontSize: 18.0),
                  decoration: const InputDecoration(
                      hintText: "Competição de ...",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 42),
                child: const Text("Escolha um hábito para competir",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 12),
                child: Observer(builder: (_) {
                  return DropdownButton<Habit>(
                    value: controller.selectedHabit,
                    isExpanded: true,
                    hint: const Text("Escolher um hábito"),
                    items: controller.habits.map((habit) {
                      return DropdownMenuItem(
                        value: habit,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Rocket(
                                size: const Size(30, 30),
                                isExtend: true,
                                color: AppColors.habitsColor[habit.colorCode!]),
                            const SizedBox(width: 10),
                            Text(habit.habit!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: controller.selectHabit,
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.only(right: 16, left: 16),
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppTheme.of(context).materialTheme.accentColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 0)),
                      overlayColor: MaterialStateProperty.all(Colors.white24),
                      elevation: MaterialStateProperty.all(0)),
                  child: const Text("ou crie um novo",
                      style: TextStyle(color: Colors.white)),
                  onPressed: goAddHabit,
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 42),
                child: const Text("Convidar amigos",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16, left: 16, top: 12),
                alignment: Alignment.topCenter,
                child: Observer(builder: (_) {
                  return Wrap(
                    runSpacing: 6,
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: widget.arguments!.friends
                        .map((friend) => ChoiceChip(
                              label: Text(friend.name!),
                              selected:
                                  controller.selectedFriends.contains(friend),
                              selectedColor: AppTheme.of(context).chipSelected,
                              onSelected: (selected) =>
                                  controller.selectFriend(selected, friend),
                            ))
                        .toList(),
                  );
                }),
              ),
              Container(
                margin: const EdgeInsets.only(top: 38, bottom: 28),
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          AppTheme.of(context).materialTheme.accentColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 16)),
                      overlayColor: MaterialStateProperty.all(Colors.white24),
                      elevation: MaterialStateProperty.all(2)),
                  onPressed: createCompetition,
                  child: const Text("CRIAR",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
