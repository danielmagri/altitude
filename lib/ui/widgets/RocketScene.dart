import 'package:flutter/material.dart';
import 'dart:math';

class RocketPainter extends CustomPainter {
  RocketPainter(this.color, this.fireSize);

  final Color color;
  final double fireSize;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    num degToRad(num deg) => deg * (pi / 180.0);

    path.moveTo(size.width * 0.49, size.height * 0.05);
    path.quadraticBezierTo(size.width * 0.44, size.height * 0.1, size.width * 0.41, size.height * 0.2);
    path.lineTo(size.width * 0.59, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.56, size.height * 0.1, size.width * 0.51, size.height * 0.05);
    path.close();

    paint.color = color;
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 0.41, size.height * 0.4);
    path.lineTo(size.width * 0.28, size.height * 0.5);
    path.lineTo(size.width * 0.26, size.height * 0.58);
    path.quadraticBezierTo(size.width * 0.31, size.height * 0.54, size.width * 0.41, size.height * 0.53);
    path.close();

    paint.color = color;
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 0.59, size.height * 0.4);
    path.lineTo(size.width * 0.72, size.height * 0.5);
    path.lineTo(size.width * 0.74, size.height * 0.58);
    path.quadraticBezierTo(size.width * 0.67, size.height * 0.54, size.width * 0.59, size.height * 0.53);
    path.close();

    paint.color = color;
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 0.41, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.38, size.height * 0.4, size.width * 0.41, size.height * 0.6);
    path.lineTo(size.width * 0.59, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.62, size.height * 0.4, size.width * 0.59, size.height * 0.2);
    path.close();

    paint.color = Colors.black;
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, paint);

    paint.color = color;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), size.width * 0.06, paint);

    path = Path();
    path.arcTo(
        Rect.fromLTWH(size.width * (0.45 - (fireSize / 20.0)), size.height * 0.6,
            size.width * (0.1 + (fireSize / 10.0)), size.height * (0.2 + (fireSize / 20.0))),
        degToRad(30),
        degToRad(-240),
        true);
    path.lineTo(size.width * 0.5, size.height * (0.85 + (fireSize / 10.0)));
    paint.color = Colors.orange;
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, paint);

    path = Path();
    path.arcTo(
        Rect.fromLTWH(size.width * (0.475 - (fireSize / 40.0)), size.height * 0.6,
            size.width * (0.05 + (fireSize / 20.0)), size.height * (0.1 + (fireSize / 20.0))),
        degToRad(30),
        degToRad(-240),
        true);
    path.lineTo(size.width * 0.5, size.height * (0.75 + (fireSize / 20.0)));
    paint.color = Colors.deepOrange;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class RocketScene extends StatelessWidget {
  RocketScene({Key key, @required this.color, this.force = 0})
      : duration = 2000 - (961 * force).toInt(),
        super(key: key);

  final Color color;
  final double force;
  final int duration;

  Widget build(BuildContext context) {
    return CustomPaint(
      child: Sky(
        duration: duration,
      ),
      foregroundPainter: RocketPainter(color, force),
    );
  }
}

class Sky extends StatefulWidget {
  Sky({
    @required this.duration,
  });

  final int duration;

  @override
  _SkyState createState() => _SkyState();
}

class _SkyState extends State<Sky> with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;
  AnimationController _controller4;

  Random rnd = new Random();

  static const int range = 40;
  List<double> positionsX = [0, 0, 0, 0];
  List<bool> update = [true, true, true, true];

  @override
  void initState() {
    super.initState();

    positionsX[0] = rnd.nextInt(range).toDouble();
    positionsX[1] = rnd.nextInt(range).toDouble();
    positionsX[2] = rnd.nextInt(range).toDouble();
    positionsX[3] = rnd.nextInt(range).toDouble();

    _controller1 = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    _controller2 = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    _controller3 = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    _controller4 = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);

    _controller1.addListener(() {
      if (_controller1.value > 0.94 && update[0]) {
        update[0] = false;
        positionsX[0] = rnd.nextInt(range).toDouble();
        setState(() {});
      } else if (_controller1.value < 0.06 && !update[0]) {
        update[0] = true;
      }
    });
    _controller2.addListener(() {
      if (_controller2.value > 0.94 && update[1]) {
        update[1] = false;
        positionsX[1] = rnd.nextInt(range).toDouble();
        setState(() {});
      } else if (_controller2.value < 0.06 && !update[1]) {
        update[1] = true;
      }
    });
    _controller3.addListener(() {
      if (_controller3.value > 0.94 && update[2]) {
        update[2] = false;
        positionsX[2] = rnd.nextInt(range).toDouble();
        setState(() {});
      } else if (_controller3.value < 0.06 && !update[2]) {
        update[2] = true;
      }
    });
    _controller4.addListener(() {
      if (_controller4.value > 0.94 && update[3]) {
        update[3] = false;
        positionsX[3] = rnd.nextInt(range).toDouble();
        setState(() {});
      } else if (_controller4.value < 0.06 && !update[3]) {
        update[3] = true;
      }
    });

    _controller1.value = 1 / 4;
    _controller1.repeat();
    _controller2.value = 2 / 4;
    _controller2.repeat();
    _controller3.value = 3 / 4;
    _controller3.repeat();
    _controller4.value = 4 / 4;
    _controller4.repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Sky oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller1.duration = Duration(milliseconds: widget.duration);
      _controller2.duration = Duration(milliseconds: widget.duration);
      _controller3.duration = Duration(milliseconds: widget.duration);
      _controller4.duration = Duration(milliseconds: widget.duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        Cloud(
          animation: _controller1,
          positionX: positionsX[0],
          imagePath: "assets/c1.png",
        ),
        Cloud(
          animation: _controller2,
          positionX: positionsX[1],
          imagePath: "assets/c2.png",
          fromRight: true,
        ),
        Cloud(
          animation: _controller3,
          positionX: positionsX[2],
          imagePath: "assets/c2.png",
        ),
        Cloud(
          animation: _controller4,
          positionX: positionsX[3],
          imagePath: "assets/c1.png",
          fromRight: true,
        ),
      ],
    );
  }
}

class Cloud extends AnimatedWidget {
  Cloud(
      {Key key,
      @required this.positionX,
      @required this.imagePath,
      this.fromRight = false,
      Animation<double> animation})
      : super(key: key, listenable: animation);

  final double positionX;
  final String imagePath;
  final bool fromRight;

  double _setOpacity(double value) {
    if (value > 0.8) {
      double res = (47 - (50 * value)) / 7;
      return res > 0 ? res : 0;
    } else if (value < 0.2) {
      return 5.0 * value;
    } else {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Positioned(
      top: -30 + (170 * animation.value),
      left: !fromRight ? positionX : 0,
      right: fromRight ? positionX : 0,
      height: 20,
      child: Opacity(
        opacity: _setOpacity(animation.value),
        child: Image.asset(
          imagePath,
          alignment: !fromRight ? Alignment.centerLeft : Alignment.centerRight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
