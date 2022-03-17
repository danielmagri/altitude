import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
        Animatable,
        AnimationController,
        BuildContext,
        Color,
        ColorTween,
        Key,
        SingleTickerProviderStateMixin,
        State,
        StatefulWidget,
        TweenSequence,
        TweenSequenceItem,
        Widget;

class RainbowAnimated extends StatefulWidget {
  const RainbowAnimated({Key? key, this.child}) : super(key: key);

  final Widget Function(Color? color)? child;

  @override
  _RainbowAnimatedState createState() => _RainbowAnimatedState();
}

class _RainbowAnimatedState extends State<RainbowAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Animatable<Color?> background = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: AppColors.habitsColor[0], end: AppColors.habitsColor[1]),
    ),
    TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.habitsColor[1], end: AppColors.habitsColor[2])),
    TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.habitsColor[2], end: AppColors.habitsColor[3])),
    TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.habitsColor[3], end: AppColors.habitsColor[4])),
    TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.habitsColor[4], end: AppColors.habitsColor[5])),
    TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.habitsColor[5], end: AppColors.habitsColor[6])),
    TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: AppColors.habitsColor[6], end: AppColors.habitsColor[0])),
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
    return widget.child!(background.evaluate(AlwaysStoppedAnimation(_controller.value)));
  }
}
