import 'package:flutter/material.dart';
import 'package:habit/utils/Util.dart';
import 'dart:math';

enum RocketState { ON_FIRE, STOPPED }

class _RocketPainter extends CustomPainter {
  _RocketPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    Color lightenedColor = Util.setWhitening(color, -50);

    path.moveTo(size.width * 0.49, 0);
    path.quadraticBezierTo(size.width * 0.44, size.height * 0.1, size.width * 0.41, size.height * 0.2);
    path.lineTo(size.width * 0.59, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.56, size.height * 0.1, size.width * 0.51, 0);
    path.close();

    paint.color = lightenedColor;
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 0.38, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.8, size.width * 0.26, size.height);
    path.quadraticBezierTo(size.width * 0.32, size.height * 0.85, size.width * 0.4, size.height * 0.88);
    path.close();

    paint.color = lightenedColor;
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 0.62, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.74, size.height * 0.8, size.width * 0.73, size.height);
    path.quadraticBezierTo(size.width * 0.67, size.height * 0.85, size.width * 0.59, size.height * 0.88);
    path.close();

    paint.color = lightenedColor;
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width * 0.41, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.34, size.height * 0.5, size.width * 0.42, size.height);
    path.lineTo(size.width * 0.58, size.height);
    path.quadraticBezierTo(size.width * 0.66, size.height * 0.5, size.width * 0.59, size.height * 0.2);
    path.close();

    paint.color = Util.setWhitening(color, 10);
    canvas.drawPath(path, paint);

    paint.color = lightenedColor;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.45), size.width * 0.05, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _FirePainter extends CustomPainter {
  _FirePainter(this.fireSize);

  final double fireSize;
  double degToRad(double deg) => deg * (pi / 180.0);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.arcTo(
        Rect.fromLTWH(size.width * (0.45 - (fireSize / 20.0)), 0, size.width * (0.1 + (fireSize / 10.0)),
            size.height * (0.5 + (fireSize / 20.0))),
        degToRad(30),
        degToRad(-240),
        true);
    path.lineTo(size.width * 0.5, size.height * (0.7 + (fireSize * 0.3)));
    paint.color = Colors.deepOrange;
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, paint);

    path = Path();
    path.arcTo(
        Rect.fromLTWH(size.width * (0.475 - (fireSize / 40.0)), 0, size.width * (0.05 + (fireSize / 20.0)),
            size.height * (0.4 + (fireSize / 20.0))),
        degToRad(30),
        degToRad(-240),
        true);
    path.lineTo(size.width * 0.5, size.height * (0.45 + (fireSize * 0.3)));
    paint.color = Colors.orange;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// Widget do foguete
/// isExtend se estiver em true desenha o foguete em completo no tamanho entregue
class Rocket extends StatelessWidget {
  Rocket(
      {Key key,
      @required this.size,
      @required this.color,
      this.state = RocketState.STOPPED,
      this.isExtend = false,
      this.fireForce = 0})
      : super(key: key);

  final RocketState state;
  final Size size;
  final Color color;
  final bool isExtend;
  final double fireForce;

  List<Widget> _listPainters() {
    List<Widget> widgets = new List();

    if (isExtend && state != RocketState.ON_FIRE) {
      widgets.add(CustomPaint(
        size: size,
        foregroundPainter: _RocketPainter(color),
      ));
    } else {
      widgets.add(CustomPaint(
        size: Size(size.width, size.height * 0.6),
        foregroundPainter: _RocketPainter(color),
      ));

      if (state == RocketState.ON_FIRE) {
        widgets.add(CustomPaint(
          size: Size(size.width, size.height * 0.4),
          foregroundPainter: _FirePainter(fireForce),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _listPainters());
  }
}
