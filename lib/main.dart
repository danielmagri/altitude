import 'package:flutter/material.dart';
import 'package:habit/widgets/Habit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitos',
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'Roboto'),
      home: MainPage(),
    );
  }
}

class HeaderBackgroundClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 60);
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
          alignment: Alignment(-0.9, 0.2),
          child: Text(
            "Nome da Silva",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
          ),
        ),
        Align(
          alignment: Alignment(-0.9, 0.95),
          child: Text(
            "1395",
            style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment(0.85, 0.65),
          child: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Adicionar',
            backgroundColor: Color.fromARGB(255, 250, 127, 114),
            child: Icon(Icons.add,color: Colors.black,),
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

  List<int> habitsForToday = [1, 2, 3, 4, 5];

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

  List<Widget> habitsForTodayWidget(BoxConstraints constraints) {
    List<Widget> widgets = new List();

    const int width = 100;
    const int height = 100;
    final int maxHabitsWidth = constraints.maxWidth ~/ width;
    final int numberLines = (habitsForToday.length / maxHabitsWidth).round();

    int currentLine = 0; //Qual linha está relativa ao centro
    int currentHabitsLine = 0; //Quantos hábitos tem na linha atual
    int totalHabitAdded = 0;
    int alternatorHabitPosition = 0; //Alterna a posição relativa ao centro
    bool widthCentralized = false;

    for (int habit in habitsForToday) {
      if (currentHabitsLine == maxHabitsWidth) {
        currentHabitsLine = 0;
        currentLine = currentLine >= 0 ? -currentLine - 1 : currentLine * (-1);
        alternatorHabitPosition = 0;
        widthCentralized = ((habitsForToday.length - totalHabitAdded) % 2) == 0 ? true : false;
      }

      currentHabitsLine++;
      totalHabitAdded++;

      double left = 0;
      double top = 0;

      if ((numberLines % 2) == 0) {
        top = (constraints.maxHeight / 2.0);
        top += currentLine * height;
      } else {
        top = (constraints.maxHeight / 2.0) - height / 2.0;
        top += currentLine * height;
      }

      if (widthCentralized) {
        left = (constraints.maxWidth / 2.0) + alternatorHabitPosition * width;
        alternatorHabitPosition =
            alternatorHabitPosition >= 0 ? -alternatorHabitPosition - 1 : alternatorHabitPosition * (-1);
      } else {
        left = (constraints.maxWidth / 2.0) - width / 2.0;
        left += alternatorHabitPosition * width;
        alternatorHabitPosition =
            alternatorHabitPosition >= 0 ? -alternatorHabitPosition - 1 : alternatorHabitPosition * (-1);
      }

      widgets.add(
        Positioned(
          left: left,
          top: top,
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
                    Text(
                      "Hábitos de hoje",
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) => Stack(
                              fit: StackFit.expand,
                              children: habitsForTodayWidget(constraints),
                            ),
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
    );
  }
}
