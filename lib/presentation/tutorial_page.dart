import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/view/generic/dots_indicator.dart';
import 'package:altitude/common/view/generic/rocket.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends BaseState<TutorialPage> {
  final _controller = PageController();

  int pageIndex = 0;

  List<Widget> pagesWidget = [
    const Initial(),
    const CreateHabit(),
    const CompleteHabit(),
    const Score()
  ];

  @override
  void initState() {
    super.initState();

    serviceLocator.get<SharedPref>().habitTutorial = true;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    resetSystemStyle();
    super.dispose();
  }

  Future<void> _nextTap() async {
    if (pageIndex == 3) {
      int version = int.parse((await PackageInfo.fromPlatform()).buildNumber);
      serviceLocator.get<SharedPref>().version = version;
      if (GetIt.I.get<IFireAuth>().isLogged()) {
        navigatePushReplacement('/');
      } else {
        navigatePushReplacement('login');
      }
    } else {
      pageIndex++;
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            onPageChanged: (index) => pageIndex = index,
            children: pagesWidget,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 60,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: DotsIndicator(
                      controller: _controller,
                      itemCount: pagesWidget.length,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    height: 60,
                    child: TextButton(
                      child: const Text(
                        'Avançar',
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
  const Initial({Key? key}) : super(key: key);

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
            child: const Text(
              'Bem-vindo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 250, 250),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                      )
                    ],
                  ),
                  child: SizedBox(
                    width: 200,
                    height: 190,
                    child: Transform.rotate(
                      angle: 0.8,
                      child: Rocket(
                        size: const Size(200, 190),
                        color: AppColors.habitsColor[3],
                        state: RocketState.onFire,
                        fireForce: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Deseja mudar sua vida? Comece mudando seus hábitos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}

class CreateHabit extends StatefulWidget {
  const CreateHabit({Key? key}) : super(key: key);

  @override
  _CreateHabitState createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
      upperBound: 0.03,
    );
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
            child: const Text(
              'CRIAR UM HÁBITO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/createHabit.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Align(
                      alignment: Alignment(
                        1.15 + _controller.value,
                        1.55 + _controller.value,
                      ),
                      child: Image.asset(
                        'assets/finger.png',
                        fit: BoxFit.contain,
                        width: constraint.biggest.width * 0.55,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment(0, 0.5),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Crie um novo hábito clicando no botão +',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}

class CompleteHabit extends StatefulWidget {
  const CompleteHabit({Key? key}) : super(key: key);

  @override
  _CompleteHabitState createState() => _CompleteHabitState();
}

class _CompleteHabitState extends State<CompleteHabit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> positionYRocketAnimation;
  late Animation<double> positionXRocketAnimation;
  late Animation<double> positionYFingerAnimation;
  late Animation<double> positionXFingerAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });

    positionYRocketAnimation = Tween<double>(
      begin: 1,
      end: -0.65,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
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
        curve: const Interval(
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
        curve: const Interval(
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
        curve: const Interval(
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
            child: const Text(
              'COMPLETAR O HÁBITO',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/completeHabit.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    const sizeRocket = 0.29;
                    return Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(
                            positionXRocketAnimation.value,
                            positionYRocketAnimation.value,
                          ),
                          child: SizedBox(
                            height: constraint.biggest.width * sizeRocket,
                            width: (constraint.biggest.width * sizeRocket) + 10,
                            child: Rocket(
                              size: Size(
                                (constraint.biggest.width * sizeRocket) + 10,
                                constraint.biggest.width * sizeRocket,
                              ),
                              color: AppColors.habitsColor[3],
                              state: RocketState.onFire,
                              fireForce: 1,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(
                            positionXFingerAnimation.value,
                            positionYFingerAnimation.value,
                          ),
                          child: Image.asset(
                            'assets/finger.png',
                            fit: BoxFit.contain,
                            width: constraint.biggest.width * 0.55,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment(0, 0.5),
              child: Padding(
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  'Para completar o hábito basta arrastar o foguete até o céu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}

class Score extends StatefulWidget {
  const Score({Key? key}) : super(key: key);

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scoreAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });

    scoreAnimation = Tween<double>(
      begin: 0,
      end: 122,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
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
            child: const Text(
              'EVOLUÇÃO DO HÁBITO',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/score.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                ),
                child: Align(
                  alignment: const Alignment(0, -0.41),
                  child: Text(
                    scoreAnimation.value.toInt().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 47,
                      fontWeight: FontWeight.bold,
                      height: 0.2,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment(0, 0.5),
              child: Padding(
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  'A cada vez que você completar um hábito o seu foguete subirá de altitude, o espaço é o limite!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
