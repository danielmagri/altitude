import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/widgets/HabitCard.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: <Widget>[
            Text(
              "Todos os hábitos",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    itemCount: habits.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 90.0),
                    itemBuilder: (BuildContext context, int index) {
                      return HabitWidget(
                        habit: habits[index],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
