import 'package:flutter/material.dart';
import 'package:altitude/controllers/LevelControl.dart';

class AllLevelsPage extends StatefulWidget {
  AllLevelsPage({Key key, this.score}) : super(key: key);

  final int score;

  @override
  _AllLevelsPageState createState() => _AllLevelsPageState();
}

class _AllLevelsPageState extends State<AllLevelsPage> {
  List<Widget> _setLevelsWidget() {
    List<Widget> widgets = new List();
    widgets.add(
      Container(
        margin: EdgeInsets.only(top: 40, bottom: 16),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 50,
              child: BackButton(),
            ),
            Spacer(),
            Text(
              "NÍVEIS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );

    for (int i = 0; i < 10; i++) {
      widgets.add(
        Opacity(
          opacity: LevelControl.getLevel(widget.score) >= i ? 1 : 0.3,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 90,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    LevelControl.getLevelImagePathByCode(i),
                    height: 60,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        LevelControl.getLevelTextByCode(i),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${LevelControl.getMaxScore(i)} Km',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: _setLevelsWidget(),
        ),
      ),
    );
  }
}
