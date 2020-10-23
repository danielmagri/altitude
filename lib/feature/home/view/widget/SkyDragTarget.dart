import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        Animation,
        AnimationController,
        BoxDecoration,
        BoxFit,
        Color,
        Colors,
        Container,
        CurvedAnimation,
        Curves,
        DragTarget,
        FontWeight,
        FractionalTranslation,
        Image,
        Interval,
        Key,
        LinearGradient,
        Offset,
        Opacity,
        SingleTickerProviderStateMixin,
        Stack,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Theme,
        Tween,
        Widget;

class SkyDragTarget extends StatefulWidget {
  SkyDragTarget({Key key, this.visibilty, this.setHabitDone}) : super(key: key);

  final bool visibilty;
  final Function(String id) setHabitDone;

  @override
  _SkyDragTargetState createState() => _SkyDragTargetState();
}

class _SkyDragTargetState extends State<SkyDragTarget> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacity;
  Animation<double> _offsetSky;
  Animation<double> _offsetCloud;
  Animation<double> _opacityText;

  bool hover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controller.addListener(() => setState(() {}));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.8, curve: Curves.easeInOutSine),
    ));

    _offsetSky = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: Curves.easeOutSine),
    ));

    _offsetCloud = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutSine),
    ));

    _opacityText = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.easeInOutCubic),
    ));

    runAnimation();
  }

  @override
  void didUpdateWidget(SkyDragTarget oldWidget) {
    runAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void runAnimation() {
    if (widget.visibilty) {
      _controller.forward().orCancel;
    } else {
      _controller.reverse().orCancel;
    }
  }

  @override
  Widget build(context) {
    return FractionalTranslation(
      translation: Offset(0, _offsetSky.value),
      child: Opacity(
        opacity: _opacity.value,
        child: Container(
          height: 205,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1],
                  colors: [AppColors.sky, Theme.of(context).canvasColor])),
          child: DragTarget<String>(
            builder: (context, List<String> candidateData, rejectedData) {
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-1.1, -0.9 + _offsetCloud.value),
                    child: Image.asset("assets/cloud1.png", fit: BoxFit.contain, height: 60),
                  ),
                  Align(
                    alignment: Alignment(1.2, 0 + _offsetCloud.value),
                    child: Image.asset("assets/cloud2.png", fit: BoxFit.contain, height: 45),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.6),
                    child: Opacity(
                      opacity: _opacityText.value,
                      child: Text("ARRASTE AQUI PARA COMPLETAR",
                          style: TextStyle(
                              fontSize: 18,
                              color: hover ? Color.fromARGB(255, 78, 173, 176) : Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            },
            onWillAccept: (data) {
              hover = true;
              return true;
            },
            onAccept: (data) {
              hover = false;
              widget.setHabitDone(data);
            },
            onLeave: (data) {
              hover = false;
            },
          ),
        ),
      ),
    );
  }
}
