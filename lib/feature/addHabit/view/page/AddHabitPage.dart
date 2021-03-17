import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/addHabit/logic/AddHabitLogic.dart';
import 'package:altitude/feature/addHabit/view/widget/HabitText.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectAlarm.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectColor.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectFrequency.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AddHabitPage extends StatefulWidget {
  AddHabitPage({Key key, this.backTo = false}) : super(key: key);

  final bool backTo;

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends BaseState<AddHabitPage> {
  final AddHabitLogic controller = GetIt.I.get<AddHabitLogic>();

  final habitTextController = TextEditingController();

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<AddHabitLogic>();
    habitTextController.dispose();
    super.dispose();
  }

  void _createHabitTap() {
    if (ValidationHandler.habitTextValidate(habitTextController.text) != null) {
      showToast("O hábito precisa ser preenchido.");
    } else if (controller.frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      Habit habit = Habit(
          habit: habitTextController.text,
          colorCode: controller.color,
          frequency: controller.frequency,
          initialDate: DateTime.now().today);

      showLoading(true);

      controller.createHabit(habit).then((response) {
        response.result((data) {
          showLoading(false);
          if (widget.backTo) {
            navigatePop(result: data);
          } else {
            showToast("O hábito foi criado com sucesso!");
            HabitDetailsPageArguments arguments = HabitDetailsPageArguments(data.id, data.colorCode);
            navigatePushReplacement("habitDetails", arguments: arguments);
          }
        }, handleError);
      }).catchError(handleError);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Header(title: "NOVO HÁBITO"),
            const SizedBox(height: 20),
            Observer(
                builder: (_) => SelectColor(currentColor: controller.color, onSelectColor: controller.selectColor)),
            const SizedBox(height: 20),
            Observer(builder: (_) => HabitText(color: controller.habitColor, controller: habitTextController)),
            const SizedBox(height: 32),
            Observer(
                builder: (_) => SelectFrequency(
                    color: controller.habitColor,
                    currentFrequency: controller.frequency,
                    selectFrequency: controller.selectFrequency)),
            const SizedBox(height: 42),
            Observer(builder: (_) => SelectAlarm()),
            const SizedBox(height: 42),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 40),
              child: Observer(
                builder: (_) => ElevatedButton(
                  onPressed: _createHabitTap,
                  child: const Text("CRIAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(controller.habitColor),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0)),
                      overlayColor: MaterialStateProperty.all(Colors.white24),
                      elevation: MaterialStateProperty.all(2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
