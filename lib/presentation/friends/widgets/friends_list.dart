import 'package:altitude/common/view/generic/data_error.dart';
import 'package:altitude/common/view/generic/skeleton.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/presentation/friends/controllers/friends_controller.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BouncingScrollPhysics,
        BoxDecoration,
        Center,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Divider,
        EdgeInsets,
        Expanded,
        FontWeight,
        InkWell,
        Key,
        ListView,
        Padding,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextOverflow,
        TextStyle,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class FriendsList extends StatelessWidget {
  FriendsList({required this.removeFriend, Key? key})
      : controller = GetIt.I.get<FriendsController>(),
        super(key: key);

  final FriendsController controller;
  final Function(Person person) removeFriend;

  @override
  Widget build(context) {
    return Observer(
      builder: (_) {
        return controller.friends.handleState(
          loading: () {
            return Skeleton.custom(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (_, __) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 90,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 70,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          success: (data) {
            if (data.isEmpty) {
              return Center(
                child: Text(
                  'Adicione seus amigos clicando no botão "+" abaixo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (_, index) => const Divider(),
                padding: const EdgeInsets.only(bottom: 80),
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (_, index) {
                  Person person = data[index];
                  return InkWell(
                    onLongPress: () => removeFriend(person),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              person.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                person.levelText,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${person.score} Km',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          error: (error) {
            return const DataError();
          },
        );
      },
    );
  }
}
