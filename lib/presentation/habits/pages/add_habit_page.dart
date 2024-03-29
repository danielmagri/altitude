import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/inputs/validations/validation_handler.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/view/header.dart';
import 'package:altitude/presentation/habits/controllers/add_habit_controller.dart';
import 'package:altitude/presentation/habits/widgets/habit_text.dart';
import 'package:altitude/presentation/habits/widgets/select_alarm.dart';
import 'package:altitude/presentation/habits/widgets/select_color.dart';
import 'package:altitude/presentation/habits/widgets/select_frequency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({Key? key, this.backTo = false}) : super(key: key);

  final bool backTo;

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState
    extends BaseStateWithController<AddHabitPage, AddHabitController> {
  final habitTextController = TextEditingController();

  @override
  void dispose() {
    habitTextController.dispose();
    super.dispose();
  }

  void _createHabitTap() {
    if (ValidationHandler.habitTextValidate(habitTextController.text) != null) {
      showToast('O hábito precisa ser preenchido.');
    } else if (controller.frequency == null) {
      showToast('Escolha qual será a frequência.');
    } else {
      showLoading(true);

      controller
          .createHabit(
        habitTextController.text,
        controller.color,
        controller.frequency!,
        DateTime.now().onlyDate,
      )
          .then((response) {
        response.result(
          (data) {
            showLoading(false);
            if (widget.backTo) {
              navigatePop(result: data);
            } else {
              showToast('O hábito foi criado com sucesso!');
              HabitDetailsPageArguments arguments =
                  HabitDetailsPageArguments(data.id, data.colorCode);
              navigatePushReplacement('habitDetails', arguments: arguments);
            }
          },
          handleError,
        );
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
            const Header(title: 'NOVO HÁBITO'),
            const SizedBox(height: 20),
            Observer(
              builder: (_) => SelectColor(
                currentColor: controller.color,
                onSelectColor: controller.selectColor,
              ),
            ),
            const SizedBox(height: 20),
            Observer(
              builder: (_) => HabitText(
                color: controller.habitColor,
                controller: habitTextController,
              ),
            ),
            const SizedBox(height: 32),
            Observer(
              builder: (_) => SelectFrequency(
                color: controller.habitColor,
                currentFrequency: controller.frequency,
                selectFrequency: controller.selectFrequency,
              ),
            ),
            const SizedBox(height: 42),
            Observer(builder: (_) => const SelectAlarm()),
            const SizedBox(height: 42),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 40),
              child: Observer(
                builder: (_) => ElevatedButton(
                  onPressed: _createHabitTap,
                  child: const Text(
                    'CRIAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(controller.habitColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 16.0,
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.white24),
                    elevation: MaterialStateProperty.all(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
