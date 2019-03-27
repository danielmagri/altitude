import 'package:flutter/material.dart';
import 'package:habit/widgets/Habit.dart';

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
    path.addOval(new Rect.fromCircle(center: new Offset(size.width / 2, size.height / 2), radius: 75.0));
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
            width: 100.0,
            height: 100.0,
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
          alignment: Alignment(0.0, 0.85),
          child: Text(
            "Nome da Silva",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class DragComplete extends AnimatedWidget {
  DragComplete({Key key, @required this.onAccept, Animation<double> animation})
      : super(key: key, listenable: animation);

  bool hover = false;
  final Function onAccept;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Positioned(
      left: 40,
      right: 40,
      bottom: animation.value,
      child: Container(
        height: 90,
        color: Color.fromARGB(255, 221, 221, 221),
        child: DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            return Center(
                child: Text(
              "Concluído",
              style: TextStyle(color: hover ? Colors.green : Colors.white, fontSize: 22.0),
            ));
          },
          onWillAccept: (data) {
            hover = true;
            return true;
          },
          onAccept: (data) {
            hover = false;
            onAccept(data);
          },
          onLeave: (data) {
            hover = false;
          },
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  AnimationController _controllerDragComplete;
  Animation _animationDragComplete;

  List<int> habitsForToday = [1, 2, 3];

  initState() {
    super.initState();

    _controllerDragComplete = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _animationDragComplete = Tween(begin: -100.0, end: 10.0)
        .animate(CurvedAnimation(parent: _controllerDragComplete, curve: Curves.easeOutExpo));
  }

  @override
  void dispose() {
    _controllerDragComplete.dispose();
    super.dispose();
  }

  void onAccept(data) {
    _controllerDragComplete.reverse();

    for (int i = 0; i < habitsForToday.length; i++) {
      if (habitsForToday[i] == data) {
        setState(() {
          habitsForToday.removeAt(i);
        });
      }
    }
  }

  List<Widget> habitsForTodayBuild() {
    List<Widget> widgets = new List();

    for (int habit in habitsForToday) {
      widgets.add(
        Positioned(
          left: habit * 100.0,
          top: 20,
          child: Draggable(
            data: habit,
            child: HabitWidget(),
            feedback: HabitWidget(),
            childWhenDragging: Container(),
            onDragStarted: () {
              _controllerDragComplete.forward();
            },
            onDraggableCanceled: (velocity, offset) {
              _controllerDragComplete.reverse();
            },
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: HeaderWidget()),
          Expanded(
            flex: 2,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hábitos de hoje",
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: habitsForTodayBuild(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: OutlineButton(
                          child: Text("Todas os hábitos"),
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          onPressed: () {}),
                    ),
                  ],
                ),
                DragComplete(onAccept: onAccept, animation: _animationDragComplete),
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
