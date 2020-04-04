import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/datas/dataHabitCreation.dart';
import 'package:altitude/feature/editHabit/logic/EditHabitLogic.dart';
import 'package:flutter/material.dart';
import 'package:altitude/feature/addHabit/widgets/colorWidget.dart';
import 'package:altitude/feature/addHabit/widgets/habitWidget.dart';
import 'package:altitude/feature/addHabit/widgets/frequencyWidget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage(this.arguments);

  final EditHabitPageArguments arguments;

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends BaseState<EditHabitPage> {
  final keyboardVisibility = KeyboardVisibilityNotification();
  final habitTextController = TextEditingController();

  final EditHabitLogic controller = GetIt.I.get<EditHabitLogic>();

  @override
  void initState() {
    super.initState();

    controller.setData(widget.arguments.habit, widget.arguments.frequency, widget.arguments.reminders);

    controller.color = widget.arguments.habit.color;
    habitTextController.text = widget.arguments.habit.habit;
    DataHabitCreation().frequency = widget.arguments.frequency;
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<EditHabitLogic>();
    super.dispose();
  }

  void updateHabit() {
    String habitValidation = ValidationHandler.habitTextValidate(habitTextController.text);
    if (habitValidation != null) {
      showToast(habitValidation);
    } else if (DataHabitCreation().frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      showLoading(true);
      controller.updateHabit(habitTextController.text).then((_) {
        showLoading(false);
        Navigator.pop(context);
      }).catchError(handleError);
      showToast("O hábito foi editado!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 50, child: BackButton()),
                  const Spacer(),
                  const Text("EDITAR HÁBITO", style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      // onPressed: () => bloc.removeHabit(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Observer(builder: (_) {
              return ColorWidget(currentColor: controller.color, changeColor: controller.switchColor);
            }),
            const SizedBox(height: 20),
            Observer(builder: (_) {
              return HabitWidget(
                  color: controller.habitColor, controller: habitTextController, keyboard: keyboardVisibility);
            }),
            Observer(builder: (_) {
              return FrequencyWidget(color: controller.habitColor);
            }),
            Observer(builder: (_) {
              return Container(
                margin: const EdgeInsets.only(top: 20, bottom: 28),
                child: RaisedButton(
                  color: controller.habitColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                  elevation: 5.0,
                  onPressed: updateHabit,
                  child: const Text("SALVAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
