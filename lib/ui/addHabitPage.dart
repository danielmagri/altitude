import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/addHabitWidgets/colorWidget.dart';
import 'package:habit/ui/addHabitWidgets/cueWidget.dart';
import 'package:habit/ui/addHabitWidgets/habitWidget.dart';
import 'package:habit/ui/addHabitWidgets/frequencyWidget.dart';
import 'package:habit/ui/addHabitWidgets/alarmWidget.dart';
import 'package:habit/utils/Color.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:habit/datas/dataHabitCreation.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/ui/widgets/Toast.dart';

class AddHabitPage extends StatefulWidget {
  AddHabitPage({Key key}) : super(key: key);

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();

  final habitController = TextEditingController();
  final cueController = TextEditingController();

  List<bool> validation = [false, false, false, false];

  @override
  void initState() {
    super.initState();

    DataHabitCreation().emptyData();
  }

  @override
  void dispose() {
    habitController.dispose();
    cueController.dispose();
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
    } else if (Validate.cueTextValidate(cueController.text) != null) {
      showToast("A deixa precisa ser preenchido.");
    } else if (DataHabitCreation().frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      Habit habit = new Habit(
        color: DataHabitCreation().indexColor,
        icon: DataHabitCreation().icon,
        cue: cueController.text,
        habit: habitController.text,
      );

      DataControl().addHabit(habit, DataHabitCreation().frequency, DataHabitCreation().reminders).then((result) {
        Navigator.pop(context);
        showToast("O hábito foi criado com sucesso!");
      });
    }
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: MaterialApp(
        theme: Theme.of(context).copyWith(
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 60.0),
                  child: Text(
                    "NOVO HÁBITO",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                ),
                ColorWidget(
                  currentColor: DataHabitCreation().indexColor,
                  changeColor: changeColor,
                ),
                SizedBox(
                  height: 20,
                ),
                HabitWidget(
                  color: HabitColors.colors[DataHabitCreation().indexColor],
                  controller: habitController,
                  keyboard: _keyboardVisibility,
                ),
                FrequencyWidget(
                  color: HabitColors.colors[DataHabitCreation().indexColor],
                ),
                CueWidget(
                  color: HabitColors.colors[DataHabitCreation().indexColor],
                  controller: cueController,
                  keyboard: _keyboardVisibility,
                ),
                AlarmWidget(
                  color: HabitColors.colors[DataHabitCreation().indexColor],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 28),
                  child: RaisedButton(
                    color: HabitColors.colors[DataHabitCreation().indexColor],
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                    elevation: 5.0,
                    onPressed: _createHabitTap,
                    child: const Text(
                      "CRIAR",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
