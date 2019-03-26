import 'package:flutter/material.dart';

class HeaderBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.addOval(new Rect.fromCircle(center: new Offset(size.width / 2, size.height / 2), radius: 80.0));
    path.close();

    paint.color = Color.fromARGB(255, 51, 51, 51);
    canvas.drawShadow(path, Colors.grey[900], 1.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          foregroundPainter: HeaderBackground(),
          child: Container(color: Color.fromARGB(255, 221, 221, 221)),
        ),
        Center(
          child: Container(
            width: 90.0,
            height: 90.0,
            child: Icon(Icons.fitness_center, size: 50.0,),
            margin: EdgeInsets.only(top: 25.0),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 0.94),
          child: Text(
            "Academia",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment(0.0, -0.55),
          child: Text(
            "100%",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key}) : super(key: key);

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: HeaderWidget()),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "5987",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
//                Card(
//                  elevation: 3.0,
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Stack(
//                      children: <Widget>[
//                        Text("Dias concluidos: 567"),
//                      ],
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
