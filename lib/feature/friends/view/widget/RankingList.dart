import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/friends/logic/FriendsLogic.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BouncingScrollPhysics,
        BoxDecoration,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Expanded,
        FontWeight,
        Image,
        Key,
        ListView,
        Padding,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextDecoration,
        TextOverflow,
        TextStyle,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class RankingList extends StatelessWidget {
  RankingList({Key key})
      : controller = GetIt.I.get<FriendsLogic>(),
        super(key: key);

  final FriendsLogic controller;

  Widget _positionWidget(int position) {
    if (position == 1) {
      return Image.asset("assets/first.png", height: 30);
    } else if (position == 2) {
      return Image.asset("assets/second.png", height: 30);
    } else if (position == 3) {
      return Image.asset("assets/third.png", height: 30);
    } else {
      return Text("#$position", style: TextStyle(fontSize: 20));
    }
  }

  @override
  Widget build(context) {
    return Observer(
      builder: (_) {
        return controller.ranking.handleState(() {
          return Skeleton.custom(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Container(
                      width: double.maxFinite,
                      height: 25,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    )),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 90,
                          height: 15,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 70,
                          height: 15,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }, (data) {
          return ListView.separated(
              separatorBuilder: (_, index) {
                return Container(
                    height: 1, width: double.maxFinite, decoration: const BoxDecoration(color: Colors.black12));
              },
              padding: const EdgeInsets.only(bottom: 80),
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (_, int index) {
                Person person = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      _positionWidget(index + 1),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          person.you ? "Eu" : person.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: person.you ? TextDecoration.underline : TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(person.levelText, style: TextStyle(fontSize: 16)),
                          Text("${person.score} Km", style: TextStyle(fontWeight: FontWeight.w300)),
                        ],
                      )
                    ],
                  ),
                );
              });
        }, (error) {
          return const DataError();
        });
      },
    );
  }
}
