import 'package:altitude/common/view/generic/DotsIndicator.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/feature/home/view/page/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:altitude/common/services/SharedPref.dart';
import 'package:altitude/utils/Color.dart';
import 'package:package_info/package_info.dart';

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
  initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void _nextTap() async {
    if (pageIndex == 4) {
      String result = ValidationHandler.nameTextValidate(_nameTextController.text);

      if (result == null) {
        await SharedPref().setName(_nameTextController.text);
        int version = int.parse((await PackageInfo.fromPlatform()).buildNumber);
        SharedPref().setVersion(version);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) {
                  return HomePage();
                },
                settings: RouteSettings(name: "Main Page")));
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
          color: AppColors.habitsColor[5],
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
      color: AppColors.habitsColor[0],
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 24),
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "Bem-vindo",
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
                      color: AppColors.habitsColor[3],
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
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this, lowerBound: 0, upperBound: 0.03);
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
      color: AppColors.habitsColor[1],
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
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage('assets/createHabit.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Align(
                    alignment: Alignment(1.15 + _controller.value, 1.55 + _controller.value),
                    child: Image.asset(
                      "assets/finger.png",
                      fit: BoxFit.contain,
                      width: constraint.biggest.width * 0.55,
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment(0, 0.5),
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
  Animation<double> positionYRocketAnimation;
  Animation<double> positionXRocketAnimation;
  Animation<double> positionYFingerAnimation;
  Animation<double> positionXFingerAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 3500), vsync: this);

    _controller.addListener(() {
      setState(() {});
    });

    positionYRocketAnimation = Tween<double>(
      begin: 1,
      end: -0.65,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.142,
          0.833,
          curve: Curves.ease,
        ),
      ),
    );
    positionXRocketAnimation = Tween<double>(
      begin: 0.4,
      end: 0.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.142,
          0.833,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
    positionYFingerAnimation = Tween<double>(
      begin: 1.7,
      end: -0.25,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.142,
          0.833,
          curve: Curves.ease,
        ),
      ),
    );
    positionXFingerAnimation = Tween<double>(
      begin: 1.8,
      end: 1.35,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.142,
          0.833,
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
      color: AppColors.habitsColor[3],
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
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage('assets/completeHabit.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                child: LayoutBuilder(builder: (context, constraint) {
                  final sizeRocket = 0.29;
                  return Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment(positionXRocketAnimation.value, positionYRocketAnimation.value),
                        child: SizedBox(
                          height: constraint.biggest.width * sizeRocket,
                          width: (constraint.biggest.width * sizeRocket) + 10,
                          child: Rocket(
                            size: Size(
                                (constraint.biggest.width * sizeRocket) + 10, constraint.biggest.width * sizeRocket),
                            color: AppColors.habitsColor[3],
                            state: RocketState.ON_FIRE,
                            fireForce: 1,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(positionXFingerAnimation.value, positionYFingerAnimation.value),
                        child: Image.asset(
                          "assets/finger.png",
                          fit: BoxFit.contain,
                          width: constraint.biggest.width * 0.55,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment(0, 0.5),
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
      color: AppColors.habitsColor[4],
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
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage('assets/score.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))]),
                child: Align(
                  alignment: Alignment(0, -0.41),
                  child: Text(
                    scoreAnimation.value.toInt().toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 47, fontWeight: FontWeight.bold, height: 0.2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment(0, 0.5),
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  "A cada vez que você completar um hábito o seu foguete subirá de altitude, o espaço é o limite!",
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
