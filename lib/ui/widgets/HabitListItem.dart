import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/utils/Color.dart';

class HabitListItem extends StatelessWidget {
  HabitListItem({Key key, this.habit, this.done, this.setHabitDone, this.width}) : super(key: key);

  final Habit habit;
  final bool done;
  final Function setHabitDone;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: width,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: 15,
            bottom: 0,
            right: 60,
            child: Text(
              done ? "Feito!" : "",
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: done ? width - 55 : 40,
            child: Dismissible(
              key: Key(habit.id.toString()),
              confirmDismiss: (direction) async {
                if (!done && direction == DismissDirection.startToEnd) setHabitDone(habit.id);
                Future.value(false);
              },
              direction: done ? DismissDirection.endToStart : DismissDirection.startToEnd,
              child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                width: width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  color: HabitColors.colors[habit.color],
                  boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  onTap: () async {
                    Habit data = await DataControl().getHabit(habit.id);
                    dynamic frequency = await DataControl().getFrequency(habit.id);
                    Map<DateTime, List> daysDone = await DataControl().getDaysDone(habit.id);

                    if (data != null && data.id != null && frequency != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return HabitDetailsPage(
                          habit: data,
                          frequency: frequency,
                          markedDays: daysDone,
                          fromAllHabits: false,
                        );
                      }));
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 55.0,
                        height: 50.0,
                        child: Hero(
                          tag: habit.id,
                          transitionOnUserGestures: true,
                          child: Icon(
                            IconData(habit.icon, fontFamily: 'MaterialIcons'),
                            size: 32.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        habit.habit,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideMenu extends StatefulWidget {
  final Widget child;

  SlideMenu({this.child});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        new Tween<double>(begin: 0, end: 100).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        print(data.primaryDelta);
        setState(() {
          _controller.value = data.primaryDelta / 100;
        });
      },
      onHorizontalDragEnd: (data) {
//        if (_controller.value >= .5 || data.primaryVelocity > 1500)
//          _controller.animateTo(1.0); //close menu on fast swipe in the right direction
//        else if (data.primaryVelocity < -1500) // fully open if dragged a lot to left or on fast swipe to left
//          _controller.animateTo(0.0);
//        else // close if none of above
//          _controller.animateTo(.0);
      },
      child: Container(
        margin: EdgeInsets.only(left: animation.value),
        child: widget.child,
      ),
    );
  }
}
