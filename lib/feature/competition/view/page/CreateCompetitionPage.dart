import 'package:altitude/common/constant/Constants.dart' show MAX_HABIT_COMPETITIONS;
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/model/BackDataItem.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/competition/logic/CreateCompetitionLogic.dart';
import 'package:flutter/material.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CreateCompetitionPage extends StatefulWidget {
  CreateCompetitionPage(this.arguments);

  final CreateCompetitionPageArguments arguments;

  @override
  _CreateCompetitionPageState createState() => _CreateCompetitionPageState();
}

class _CreateCompetitionPageState extends BaseState<CreateCompetitionPage> {
  CreateCompetitionLogic controller = GetIt.I.get<CreateCompetitionLogic>();

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    controller.habits = widget.arguments.habits;
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<CreateCompetitionLogic>();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void onPageBack(Object value) {
    if (value is Habit) {
      controller.addHabit(value);
    }
    super.onPageBack(value);
  }

  void createCompetition() async {
    var competitionNameValidate = ValidationHandler.competitionNameValidate(textEditingController.text);
    if (competitionNameValidate != null) {
      showToast(competitionNameValidate);
    } else if (controller.selectedHabit == null) {
      showToast("Escolha um hábito para competir.");
    } else if (controller.selectedFriends.length == 0) {
      showToast("Escolha pelo menos um amigo.");
    } else if (!(await controller.checkHabitCompetitionLimit())) {
      showToast("O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
    } else {
      showLoading(true);
      controller.createCompetition(textEditingController.text).then((res) {
        showLoading(false);
        navigatePop(result: BackDataItem.added(res));
      }).catchError(handleError);
    }
  }

  void goAddHabit() {
    navigatePush('addHabit', arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Header(title: "CRIAR COMPETIÇÃO"),
            const SizedBox(height: 32),
            const Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: const Text("Nome da competição", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
                decoration: const InputDecoration(
                    hintText: "Competição de ...",
                    hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 42),
              child: const Text("Escolha um hábito para competir",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          Rocket(size: const Size(30, 30), isExtend: true, color: AppColors.habitsColor[habit.colorCode]),
                          const SizedBox(width: 10),
                          Text(habit.habit, style: const TextStyle(color: Colors.black)),
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
              child: FlatButton(
                color: AppColors.colorAccent,
                child: const Text("ou crie um novo", style: TextStyle(color: Colors.white)),
                onPressed: goAddHabit,
              ),
            ),
            const Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 42),
              child: const Text("Convidar amigos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16, left: 16, top: 12),
              alignment: Alignment.topCenter,
              child: Observer(builder: (_) {
                return Wrap(
                  runSpacing: 6,
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  children: widget.arguments.friends.map((friend) {
                    return ChoiceChip(
                      label: Text(friend.name, style: const TextStyle(fontSize: 15)),
                      selected: controller.selectedFriends.contains(friend),
                      selectedColor: AppColors.colorAccent,
                      onSelected: (selected) => controller.selectFriend(selected, friend),
                    );
                  }).toList(),
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 38, bottom: 28),
              alignment: Alignment.topCenter,
              child: RaisedButton(
                color: AppColors.colorAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                elevation: 5.0,
                onPressed: createCompetition,
                child: const Text("CRIAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
