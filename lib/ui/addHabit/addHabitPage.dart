import 'package:flutter/material.dart';
import 'package:habit/model/Habit.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/ui/addHabit/addHabitWidgets/colorWidget.dart';
import 'package:habit/ui/addHabit/addHabitWidgets/habitWidget.dart';
import 'package:habit/ui/addHabit/addHabitWidgets/frequencyWidget.dart';
import 'package:habit/ui/addHabit/addHabitWidgets/alarmWidget.dart';
import 'package:habit/utils/Color.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/datas/dataHabitCreation.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/utils/Util.dart';

class AddHabitPage extends StatefulWidget {
  AddHabitPage({Key key, this.backTo = false}) : super(key: key);

  final bool backTo;

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();

  final habitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    DataHabitCreation().emptyData();
  }

  @override
  void dispose() {
    habitController.dispose();
    super.dispose();
  }

  void changeColor(int index) {
    setState(() {
      DataHabitCreation().indexColor = index;
    });
  }

  void _createHabitTap() {
    if (Validate.habitTextValidate(habitController.text) != null) {
      showToast("O hábito precisa ser preenchido.");
    } else if (DataHabitCreation().frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      Habit habit = new Habit(
        color: DataHabitCreation().indexColor,
        habit: habitController.text,
      );

      Loading.showLoading(context);

      HabitsControl()
          .addHabit(habit, DataHabitCreation().frequency,
              DataHabitCreation().reminders)
          .then((result) {
        Loading.closeLoading(context);
        if (widget.backTo) {
          Navigator.pop(context, result);
        } else {
          Util.goDetailsPage(context, habit.id, pushReplacement: true);
          showToast("O hábito foi criado com sucesso!");
        }
      }).catchError((error) {
        Loading.closeLoading(context);
      });
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
                  SizedBox(
                    width: 50,
                    child: BackButton(),
                  ),
                  Spacer(),
                  Text(
                    "NOVO HÁBITO",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 30),
            ),
            ColorWidget(
              currentColor: DataHabitCreation().indexColor,
              changeColor: changeColor,
            ),
            SizedBox(
              height: 20,
            ),
            HabitWidget(
              color: AppColors.habitsColor[DataHabitCreation().indexColor],
              controller: habitController,
              keyboard: _keyboardVisibility,
            ),
            FrequencyWidget(
              color: AppColors.habitsColor[DataHabitCreation().indexColor],
            ),
            AlarmWidget(
              color: AppColors.habitsColor[DataHabitCreation().indexColor],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 28),
              child: RaisedButton(
                color: AppColors.habitsColor[DataHabitCreation().indexColor],
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 16.0),
                elevation: 5.0,
                onPressed: _createHabitTap,
                child: const Text(
                  "CRIAR",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
