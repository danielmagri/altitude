import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';

class HeaderBackgroundClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 40);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, this.name, this.score}) : super(key: key);

  final String name;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 221, 221),
            ),
          ),
          clipper: HeaderBackgroundClip(),
        ),
        Align(
          alignment: Alignment(-0.9, 0.5),
          child: Container(
            width: 100.0,
            height: 100.0,
            alignment: Alignment(0.0, 0.0),
            child: Text(
              "100%",
              style: TextStyle(fontSize: 20.0),
            ),
            decoration: new BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 250, 127, 114)),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.0),
          child: Text(
            name,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.75),
          child: Text(
            score.toString(),
            style: TextStyle(fontSize: 55.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key, this.habit}) : super(key: key);

  final Habit habit;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: HeaderWidget(name: widget.habit.habit, score: widget.habit.score,)),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Container(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: <Widget>[
                          Text("Dias concluidos: 567"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
