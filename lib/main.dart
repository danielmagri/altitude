import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class HeaderBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.7);
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
        Container(color: Color.fromARGB(255, 221, 221, 221)),
        CustomPaint(
          painter: HeaderBackground(),
          child: Container(),
        ),
        Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage("https://i.imgur.com/BoN9kdC.png"),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 0.94),
          child: Text(
            "Nome da Silva",
            style: TextStyle(fontSize: 20.0,color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class ActivityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      child: Column(
        children: <Widget>[
          Container(
            width: 70.0,
            height: 70.0,
            color: Colors.red,
            child: Icon(Icons.accessibility),
          ),
          Text("Academia"),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                    "Atividades de hoje",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Center(child: ActivityWidget())),
                OutlineButton(child: Text("Todas as metas"), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        tooltip: 'Adicionar',
//        child: Icon(Icons.add),
//      ),
    );
  }
}
