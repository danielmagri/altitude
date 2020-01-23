import 'package:flutter/material.dart';
import 'dart:math';
import 'package:altitude/ui/widgets/generic/Rocket.dart';
import 'package:altitude/utils/Color.dart';

class SkyScene extends StatelessWidget {
  SkyScene({Key key, this.size, @required this.color, this.force = 0})
      : duration = 2000 - (900 * force).toInt(),
        super(key: key);

  final Size size;
  final Color color;
  final double force;
  final int duration;

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      overflow: Overflow.visible,
      children: <Widget>[
        Cloud(
          duration: duration,
          startPoint: 1 / 4,
          imagePath: "assets/cloud1.png",
        ),
        Cloud(
          duration: duration,
          startPoint: 2 / 4,
          imagePath: "assets/cloud2.png",
          fromRight: true,
        ),
        Cloud(
          duration: duration,
          startPoint: 3 / 4,
          imagePath: "assets/cloud2.png",
        ),
        Cloud(
          duration: duration,
          startPoint: 4 / 4,
          imagePath: "assets/cloud1.png",
          fromRight: true,
        ),
        RocketAnimated(
          size: size,
          color: color,
          force: force,
          duration: duration,
        ),
      ],
    );
  }
}

class RocketAnimated extends StatefulWidget {
  RocketAnimated(
      {Key key,
      @required this.size,
      @required this.color,
      @required this.force,
      @required this.duration})
      : super(key: key);

  final Size size;
  final Color color;
  final double force;
  final int duration;

  @override
  _RocketAnimatedState createState() => _RocketAnimatedState();
}

class _RocketAnimatedState extends State<RocketAnimated>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration - 400),
        vsync: this,
        lowerBound: 2 * pi,
        upperBound: 9 * pi);

    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didUpdateWidget(RocketAnimated oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reset();
        _controller.forward();
      },
      child: Container(
        color: Colors.transparent,
        child: Transform.rotate(
          angle: sin(_controller.value) / _controller.value,
          child: Rocket(
            size: widget.size,
            color: widget.color,
            fireForce: widget.force,
            state: RocketState.ON_FIRE,
          ),
        ),
      ),
    );
  }
}

class Cloud extends StatefulWidget {
  Cloud(
      {Key key,
      @required this.duration,
      this.startPoint = 0,
      @required this.imagePath,
      this.fromRight = false})
      : super(key: key);

  final int duration;
  final double startPoint;
  final String imagePath;
  final bool fromRight;

  @override
  _CloudState createState() => _CloudState();
}

class _CloudState extends State<Cloud> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> top;
  Animation<double> opacityTop;
  Animation<double> opacityBottom;

  Random rnd = new Random();

  static const int range = 40;
  double positionsX = 0;
  bool update = true;

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);

    _controller.addListener(() {
      if (_controller.value > 0.94 && update) {
        update = false;
        positionsX = rnd.nextInt(range).toDouble() - 5;
      } else if (_controller.value < 0.06 && !update) {
        update = true;
      }
      setState(() {});
    });

    top = Tween<double>(
      begin: -35,
      end: 140,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    opacityTop = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0,
          0.15,
          curve: Curves.linear,
        ),
      ),
    );

    opacityBottom = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.85,
          0.95,
          curve: Curves.linear,
        ),
      ),
    );

    _controller.value = widget.startPoint;
    _controller.repeat();
    super.initState();
  }

  @override
  void didUpdateWidget(Cloud oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
      _controller.repeat();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top.value,
      left: !widget.fromRight ? positionsX : 0,
      right: widget.fromRight ? positionsX : 0,
      height: 20,
      child: Opacity(
        opacity: opacityTop.value,
        child: Opacity(
          opacity: opacityBottom.value,
          child: Image.asset(
            widget.imagePath,
            alignment: !widget.fromRight
                ? Alignment.centerLeft
                : Alignment.centerRight,
            fit: BoxFit.contain,
            color: AppColors.sky,
          ),
        ),
      ),
    );
  }
}
