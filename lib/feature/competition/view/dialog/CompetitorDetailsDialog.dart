import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter/material.dart'
    show
        Column,
        Expanded,
        FontWeight,
        Key,
        Navigator,
        Row,
        Size,
        StatelessWidget,
        Text,
        TextButton,
        TextStyle,
        Transform,
        Widget,
        required;

class CompetitorDetailsDialog extends StatelessWidget {
  const CompetitorDetailsDialog({Key key, @required this.competitor}) : super(key: key);

  final Competitor competitor;

  @override
  Widget build(context) {
    return BaseDialog(
      title: competitor.name,
      body: Row(
        children: <Widget>[
          Expanded(
            child: Transform.rotate(
                angle: 0.52,
                child: Rocket(
                    size: const Size(200, 200),
                    color: AppColors.habitsColor[competitor.color],
                    state: RocketState.ON_FIRE,
                    fireForce: 1)),
          ),
          Expanded(
            child: Column(children: [
              Text(
                competitor.score.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              const Text("Km", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
            ]),
          )
        ],
      ),
      action: <Widget>[
        TextButton(child: const Text('Fechar'), onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
