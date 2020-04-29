import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BottomAppBar,
        BoxDecoration,
        BoxShape,
        Colors,
        Container,
        EdgeInsets,
        Icon,
        IconButton,
        Icons,
        Image,
        InkWell,
        Key,
        MainAxisAlignment,
        MainAxisSize,
        Row,
        StatelessWidget,
        Widget,
        required;
import 'package:get_it/get_it.dart';

class HomebottomNavigation extends StatelessWidget {
  HomebottomNavigation({Key key, @required this.goAddHabit, @required this.goFriends, @required this.goCompetition})
      : super(key: key);

  final Function goAddHabit;
  final Function(bool) goFriends;
  final Function(bool) goCompetition;
  final HomeLogic controller = GetIt.I.get<HomeLogic>();

  void _addHabitTap() async {
    if (await controller.canAddHabit()) {
      goAddHabit();
    } else {
      showToast("Você atingiu o limite de 9 hábitos");
    }
  }

  @override
  Widget build(context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 8, right: 16, left: 16),
        decoration: BoxDecoration(color: AppColors.colorAccent, borderRadius: BorderRadius.circular(22)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: "Amigos",
              icon: const Icon(Icons.people, color: Colors.white, size: 28),
              onPressed: () => goFriends(false),
            ),
            InkWell(
              onTap: _addHabitTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.add, color: AppColors.colorAccent, size: 28),
              ),
            ),
            IconButton(
              tooltip: "Competição",
              icon: Image.asset("assets/ic_award.png", width: 28, color: Colors.white),
              onPressed: () => goCompetition(false),
            ),
          ],
        ),
      ),
    );
  }
}
