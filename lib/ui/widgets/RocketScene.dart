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
      : duration = 3000 - (1750 * force).toInt(),
        super(key: key);

  final Color color;
  final double force;
  final int duration;

  Widget build(BuildContext context) {
    return CustomPaint(
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: <Widget>[
          Cloud(
            duration: duration,
            imagePath: "assets/c1.png",
          ),
          Cloud(
            duration: duration,
            delay: (duration * (2 / 4)).toInt(),
            imagePath: "assets/c2.png",
            fromRight: true,
          ),
          Cloud(
            duration: duration,
            delay: (duration * (3 / 4)).toInt(),
            imagePath: "assets/c2.png",
          ),
          Cloud(
            duration: duration,
            delay: duration,
            imagePath: "assets/c1.png",
            fromRight: true,
          ),
        ],
      ),
      foregroundPainter: RocketPainter(color, force),
    );
  }
}

class Cloud extends StatefulWidget {
  Cloud({this.duration, this.delay = 0, @required this.imagePath, this.fromRight = false});

  final int duration;
  final int delay;
  final String imagePath;
  final bool fromRight;

  @override
  _CloudState createState() => _CloudState();
}

class _CloudState extends State<Cloud> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Random rnd = new Random();
  double x = 0;

  @override
  void initState() {
    super.initState();

    x = rnd.nextInt(20).toDouble();

    _controller = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        x = rnd.nextInt(30).toDouble();
        _controller.forward(from: 0.0);
      }
    });

    Future.delayed(Duration(milliseconds: widget.delay), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  void didUpdateWidget(Cloud oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
    }
  }

  double _setOpacity() {
    if (_controller.value > 0.8) {
      return 5.0 - (5*_controller.value);
    } else if (_controller.value < 0.2) {
      return 5.0 * _controller.value;
    } else {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -30 + (170 * _controller.value),
      left: !widget.fromRight ? x : 0,
      right: widget.fromRight ? x : 0,
      height: 20,
      child: Opacity(
        opacity: _setOpacity(),
        child: Image.asset(
          widget.imagePath,
          alignment: !widget.fromRight ? Alignment.centerLeft : Alignment.centerRight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
