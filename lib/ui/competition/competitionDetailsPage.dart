import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit/objects/Competition.dart';
import 'package:habit/ui/widgets/generic/Rocket.dart';

class CompetitionDetailsPage extends StatelessWidget {
  CompetitionDetailsPage({Key key, @required this.data}) : super(key: key);

  final Competition data;

  double getMaxHeight(BuildContext context) {
    double height = 650;

    // Soma com o maior score dos competidores

    if (height < MediaQuery.of(context).size.height) {
      return MediaQuery.of(context).size.height - 110;
    } else {
      return height;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 118, 213, 216),
      body: Column(
        children: <Widget>[
          Container(
            height: 106,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: BackButton(),
                ),
                Expanded(
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Metrics(height: getMaxHeight(context)),
                    Expanded(
                      child: SizedBox(
                        height: 400,
                        child: Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Positioned(
                              top: 70,
                              bottom: 0,
                              width: 25,
                              child: Image.asset("assets/smoke.png",
                                  repeat: ImageRepeat.repeatY),
                            ),
                            Rocket(
                              size: Size(100, 100),
                              color: Colors.red,
                              state: RocketState.ON_FIRE,
                              fireForce: 2,
                            ),
                            Transform.rotate(
                              angle: -1.57,
                              child: FractionalTranslation(
                                translation: Offset(0.75, 0),
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Você",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Metrics extends StatelessWidget {
  Metrics({Key key, @required this.height}) : super(key: key);

  final double height;

  List<Widget> _metricList() {
    List<Widget> widgets = List();
    var km = (height / 10) - 6;

    widgets.insert(0, _metricWidget("0", 60));

    var h = 5;
    while (h <= km) {
      if (h <= 100) {
        widgets.insert(0, _metricWidget(h.toString(), 50));
      } else if (h <= 240) {
        widgets.insert(0, _metricWidget(h.toString(), 100));
      } else {
        widgets.insert(0, _metricWidget(h.toString(), 200));
      }

      if (h < 100) {
        h += 5;
      } else if (h < 240) {
        h += 10;
      } else {
        h += 20;
      }
    }

    return widgets;
  }

  Widget _metricWidget(String value, double height) {
    return Container(
      height: height,
      alignment: Alignment.topCenter,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 50,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _metricList(),
      ),
    );
  }
}
