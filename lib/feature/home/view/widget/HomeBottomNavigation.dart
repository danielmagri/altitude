import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomebottomNavigation extends StatelessWidget {
  HomebottomNavigation({Key key, @required this.pageScroll, @required this.goAddHabit}) : super(key: key);

  final Function(int) pageScroll;
  final Function goAddHabit;
  final HomeLogic controller = GetIt.I.get<HomeLogic>();

  void _addHabitTap() async {
    if (await controller.canAddHabit()) {
      goAddHabit();
    } else {
      showToast("Você atingiu o limite de 9 hábitos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 8, right: 12, left: 12),
        decoration: BoxDecoration(
          color: AppColors.colorAccent,
          borderRadius: BorderRadius.circular(40),
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 7, color: Colors.black.withOpacity(0.5))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Observer(builder: (_) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: controller.pageIndex == 0 ? 1 : 0,
                    child: Container(
                      height: 4,
                      width: 25,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    ),
                  );
                }),
                IconButton(
                  tooltip: "Todos os hábitos",
                  icon: Icon(
                    Icons.apps,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    pageScroll(0);
                    controller.swipedPage(0);
                  },
                ),
              ],
            ),
            InkWell(
              onTap: _addHabitTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.add,
                  color: AppColors.colorAccent,
                  size: 28,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Observer(builder: (_) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: controller.pageIndex == 1 ? 1 : 0,
                    child: Container(
                      height: 4,
                      width: 25,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    ),
                  );
                }),
                IconButton(
                  tooltip: "Configurações",
                  icon: Icon(
                    Icons.today,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    pageScroll(1);
                    controller.swipedPage(1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
