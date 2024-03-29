import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart'
    show
        Animation,
        AnimationController,
        BuildContext,
        Color,
        Column,
        FontWeight,
        IntTween,
        Key,
        SingleTickerProviderStateMixin,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget;
import 'package:intl/intl.dart';

class Score extends StatefulWidget {
  const Score({required this.score, Key? key, this.color}) : super(key: key);

  final Color? color;
  final int? score;

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  int? lastScore = 0;
  final formatNumber = NumberFormat.decimalPattern('pt_BR');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.addListener(() => setState(() {}));

    if (widget.score == 0) {
      _animation = IntTween(begin: lastScore, end: widget.score).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      );
    }

    runAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(Score oldWidget) {
    runAnimation();
    super.didUpdateWidget(oldWidget);
  }

  void runAnimation() {
    if (widget.score != lastScore) {
      _animation = IntTween(begin: lastScore, end: widget.score).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      );

      _controller.reset();
      _controller.forward().orCancel.whenComplete(() {
        lastScore = widget.score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 40),
        AutoSizeText(
          formatNumber.format(_animation.value),
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            color: widget.color,
            height: 0.2,
          ),
          maxLines: 1,
        ),
        const Text(
          'QUILÔMETROS',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
