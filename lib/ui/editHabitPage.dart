import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage({Key key, this.habit, this.frequency}) : super(key: key);

  final Habit habit;
  final dynamic frequency;

  @override
  _EditHabitPagePageState createState() => _EditHabitPagePageState();
}

class _EditHabitPagePageState extends State<EditHabitPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
