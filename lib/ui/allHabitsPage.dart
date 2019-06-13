import 'package:flutter/material.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/ui/widgets/HabitCardItem.dart';

class AlHabitsPage extends StatefulWidget {
  AlHabitsPage({Key key}) : super(key: key);

  @override
  _AlHabitsPageState createState() => _AlHabitsPageState();
}

class _AlHabitsPageState extends State<AlHabitsPage> {
  List<Habit> habits;

  @override
  void didChangeDependencies() {
    DataControl().getAllHabits().then((data) {
      setState(() {
        habits = data;
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: BackButton(),
                  ),
                  Spacer(),
                  Text(
                    "TODOS OS HÁBITOS",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
              margin: const EdgeInsets.only(right: 40, left: 40, top: 25, bottom: 40),
            ),
            _habitsForTodayBuild(context),
          ],
        ),
      ),
    );
  }

  Widget _habitsForTodayBuild(BuildContext context) {
    List<Widget> widgets = new List();

    if (habits == null) {
      widgets.add(CircularProgressIndicator());
    } else if (habits.length == 0) {
      widgets.add(
        Center(
          child: Text(
            "Crie um novo hábito pelo botão \"+\" na tela principal.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
          ),
        ),
      );
    } else {
      for (Habit habit in habits) {
        Widget habitWidget = HabitCardItem(habit: habit);

        widgets.add(habitWidget);
      }
    }

    return Wrap(
      spacing: 6,
      runSpacing: 12,
      children: widgets,
    );
  }
}
