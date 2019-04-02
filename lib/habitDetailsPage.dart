import 'package:flutter/material.dart';

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
            "Academia",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.75),
          child: Text(
            "1000",
            style: TextStyle(fontSize: 55.0, fontWeight: FontWeight.bold),
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
