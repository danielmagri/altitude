import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/widgets/HabitCard.dart';

class AllHabitsPage extends StatefulWidget {
  AllHabitsPage({Key key}) : super(key: key);

  @override
  _AllHabitsPageState createState() => _AllHabitsPageState();
}

class _AllHabitsPageState extends State<AllHabitsPage> with SingleTickerProviderStateMixin {
  List<Habit> habits;

  bool _loading = true;

  @override
  void didChangeDependencies() {
    getData();

    super.didChangeDependencies();
  }

  void getData() async {
    habits = await DataControl().getAllHabits();

    setState(() {
      _loading = false;
    });
  }

  List<Widget> habitsWidget() {
    List<Widget> widgets = new List();

    if (_loading) {
      widgets.add(Center(child: CircularProgressIndicator()));
    } else if (habits.length == 0) {
      widgets.add(Center(child: Text("Já foram feitos todos os hábitos de hoje :)")));
    } else {
      for (Habit habit in habits) {
        widgets.add(HabitWidget(habit: habit));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "Todos os hábitos",
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, height: 1.2),
            ),
            Container(
              margin: EdgeInsets.only(top: 32.0),
              width: double.maxFinite,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: habitsWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
