import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/constant/level_utils.dart';
import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:flutter/material.dart';

class AllLevelsPage extends StatefulWidget {
  const AllLevelsPage(this.arguments, {Key? key}) : super(key: key);

  final AllLevelsPageArguments? arguments;

  @override
  _AllLevelsPageState createState() => _AllLevelsPageState();
}

class _AllLevelsPageState extends BaseState<AllLevelsPage> {
  List<Widget> _setLevelsWidget() {
    List<Widget> widgets = [];
    widgets.add(
      Container(
        margin: const EdgeInsets.only(top: 20, bottom: 16),
        child: Row(
          children: const <Widget>[
            SizedBox(
              width: 50,
              child: BackButton(),
            ),
            Spacer(),
            Text(
              'NÍVEIS',
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
          opacity: LevelUtils.getLevel(widget.arguments!.score) >= i ? 1 : 0.3,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 90,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    LevelUtils.getLevelImagePathByCode(i),
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
                        LevelUtils.getLevelTextByCode(i),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${LevelUtils.getMaxScore(i)} Km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: _setLevelsWidget(),
          ),
        ),
      ),
    );
  }
}
