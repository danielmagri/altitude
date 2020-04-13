import 'package:flutter/material.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/utils/Color.dart';

class NewLevelDialog extends StatelessWidget {
  final int score;

  NewLevelDialog({
    @required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackgroundAnimated(),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Parabéns!",
                    style: TextStyle(
                        color: LevelControl.getLevelColor(score),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    "Você subiu de nível!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 24.0),
                  Image.asset(
                    LevelControl.getLevelImagePath(score),
                    height: 120,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    LevelControl.getLevelText(score),
                    style: TextStyle(
                        color: LevelControl.getLevelColor(score),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
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

class BackgroundAnimated extends StatefulWidget {
  @override
  _BackgroundAnimatedState createState() => _BackgroundAnimatedState();
}

class _BackgroundAnimatedState extends State<BackgroundAnimated>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[0],
        end: AppColors.habitsColor[1],
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[1],
        end: AppColors.habitsColor[2],
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[2],
        end: AppColors.habitsColor[3],
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[3],
        end: AppColors.habitsColor[4],
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[4],
        end: AppColors.habitsColor[5],
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[5],
        end: AppColors.habitsColor[6],
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: AppColors.habitsColor[6],
        end: AppColors.habitsColor[0],
      ),
    ),
  ]);

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {});
    });
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
      color: background
          .evaluate(AlwaysStoppedAnimation(_controller.value)).withOpacity(0.75),
    );
  }
}
