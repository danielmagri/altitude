import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/constant/level_utils.dart';
import 'package:flutter/material.dart';

class NewLevelDialog extends StatelessWidget {
  const NewLevelDialog({required this.score, Key? key}) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const BackgroundAnimated(),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Parabéns!',
                    style: TextStyle(
                      color: LevelUtils.getLevelColor(score),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Você subiu de nível!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 24.0),
                  Image.asset(
                    LevelUtils.getLevelImagePath(score),
                    height: 120,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    LevelUtils.getLevelText(score),
                    style: TextStyle(
                      color: LevelUtils.getLevelColor(score),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Ok',
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
  const BackgroundAnimated({Key? key}) : super(key: key);

  @override
  _BackgroundAnimatedState createState() => _BackgroundAnimatedState();
}

class _BackgroundAnimatedState extends State<BackgroundAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Animatable<Color?> background = TweenSequence<Color?>([
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
          .evaluate(AlwaysStoppedAnimation(_controller.value))!
          .withOpacity(0.75),
    );
  }
}
