import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/ui/widgets/generic/DotsIndicator.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/main.dart';
import 'package:habit/controllers/DataPreferences.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/ui/widgets/generic/Rocket.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage({Key key, this.showNameTab = true}) : super(key: key);

  final bool showNameTab;

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _controller = new PageController();
  final _nameTextController = TextEditingController();

  int pageIndex = 0;

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void _nextTap() async {
    if (pageIndex == 4) {
      String result = Validate.nameTextValidate(_nameTextController.text);

      if (result == null) {
        await DataPreferences().setName(_nameTextController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return MainPage();
        }));
      } else {
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } else if (pageIndex == 3 && !widget.showNameTab) {
      Navigator.pop(context);
    } else {
      pageIndex++;
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  List<Widget> _pageList() {
    List<Widget> widgets = [Initial(), CreateHabit(), CompleteHabit(), Score()];
    if (widget.showNameTab) {
      widgets.add(
        Container(
          color: HabitColors.colors[5],
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 64),
                child: Text(
                  "Como podemos te chamar?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Flexible(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    margin: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                      boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                    ),
                    child: TextField(
                      controller: _nameTextController,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      onEditingComplete: _nextTap,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration.collapsed(hintText: "Seu nome"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            onPageChanged: (index) => pageIndex = index,
            children: _pageList(),
          ),
          new Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: new Container(
              height: 60,
              child: Stack(
                children: <Widget>[
                  new Center(
                    child: new DotsIndicator(
                      controller: _controller,
                      itemCount: widget.showNameTab ? 5 : 4,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    height: 60,
                    child: FlatButton(
                      child: Text(
                        "Avançar",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onPressed: _nextTap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabitColors.colors[0],
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 24),
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "HÁBITOS",
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                height: 250,
                width: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                child: SizedBox(
                  width: 200,
                  height: 190,
                  child: Transform.rotate(
                    angle: 0.8,
                    child: Rocket(
                      size: const Size(200, 190),
                      color: HabitColors.colors[0],
                      state: RocketState.ON_FIRE,
                      fireForce: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Deseja mudar sua vida? Comece mudando seus hábitos!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}

class CreateHabit extends StatefulWidget {
  @override
  _CreateHabitState createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this, lowerBound: 0, upperBound: 5);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabitColors.colors[1],
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 24),
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "CRIAR UM HÁBITO",
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage('assets/createHabit.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                ),
                Positioned(
                  bottom: -25 + _controller.value,
                  right: 5 + _controller.value,
                  child: Transform.rotate(
                    angle: -1,
                    child: Image.asset(
                      "assets/finger.png",
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Crie um novo hábito clicando no botão +",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}

class CompleteHabit extends StatefulWidget {
  @override
  _CompleteHabitState createState() => _CompleteHabitState();
}

class _CompleteHabitState extends State<CompleteHabit> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> positionYAnimation;
  Animation<double> positionXAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);

    _controller.addListener(() {
      setState(() {});
    });

    positionYAnimation = Tween<double>(
      begin: 0,
      end: 140,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    positionXAnimation = Tween<double>(
      begin: 0,
      end: 30,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabitColors.colors[3],
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 24),
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "COMPLETAR O HÁBITO",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage('assets/completeHabit.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                ),
                Positioned(
                  bottom: 25 + positionYAnimation.value,
                  right: 43 + positionXAnimation.value,
                  child: Rocket(
                    size: const Size(80, 70),
                    color: HabitColors.colors[3],
                    state: RocketState.ON_FIRE,
                    fireForce: 1,
                  ),
                ),
                Positioned(
                  bottom: -25 + positionYAnimation.value,
                  right: -30 + positionXAnimation.value,
                  child: Transform.rotate(
                    angle: -1,
                    child: Image.asset(
                      "assets/finger.png",
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  "Para completar o hábito basta arrastar o foguete até o céu!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}

class Score extends StatefulWidget {
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> scoreAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 4000), vsync: this);

    _controller.addListener(() {
      setState(() {});
    });

    scoreAnimation = Tween<double>(
      begin: 0,
      end: 122,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabitColors.colors[4],
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 24),
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "EVOLUÇÃO DO HÁBITO",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage('assets/score.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                ),
                Positioned(
                  top: 80,
                  right: 0,
                  left: 0,
                  child: Text(
                    scoreAnimation.value.toInt().toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, height: 0.2, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  "A cada vez que você completar um hábito o seu foguete elevará de altitude, o espaço é o limite!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
