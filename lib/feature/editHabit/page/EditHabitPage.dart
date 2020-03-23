import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/feature/editHabit/bloc/EditHabitBloc.dart';
import 'package:flutter/material.dart';
import 'package:altitude/feature/addHabit/widgets/colorWidget.dart';
import 'package:altitude/feature/addHabit/widgets/habitWidget.dart';
import 'package:altitude/feature/addHabit/widgets/frequencyWidget.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage(this.habit, this.frequency, this.reminders);

  final Habit habit;
  final Frequency frequency;
  final List<Reminder> reminders;

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  EditHabitBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = EditHabitBloc(widget.habit, widget.frequency, widget.reminders);
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
                    "EDITAR HÁBITO",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => bloc.removeHabit(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<int>(
              initialData: bloc.color,
              stream: bloc.colorWidgetStream,
              builder: (context, snapshot) {
                return ColorWidget(
                  currentColor: snapshot.data,
                  changeColor: bloc.switchColor,
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<Color>(
              initialData: bloc.habitColor,
              stream: bloc.colorStream,
              builder: (context, snapshot) {
                return HabitWidget(
                  color: snapshot.data,
                  controller: bloc.habitTextController,
                  keyboard: bloc.keyboardVisibility,
                );
              },
            ),
            StreamBuilder<Color>(
              initialData: bloc.habitColor,
              stream: bloc.colorStream,
              builder: (context, snapshot) {
                return FrequencyWidget(
                  color: snapshot.data,
                );
              },
            ),
            StreamBuilder<Color>(
              initialData: bloc.habitColor,
              stream: bloc.colorStream,
              builder: (context, snapshot) {
                return Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 28),
                  child: RaisedButton(
                    color: snapshot.data,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                    elevation: 5.0,
                    onPressed: () => bloc.updateHabit(context),
                    child: const Text(
                      "SALVAR",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
