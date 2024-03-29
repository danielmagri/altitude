import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/icon_button_status.dart';
import 'package:altitude/common/view/generic/toast.dart';
import 'package:altitude/presentation/home/controllers/home_controller.dart';
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
        Icons,
        Image,
        InkWell,
        Key,
        MainAxisAlignment,
        Row,
        StatelessWidget,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';

class HomebottomNavigation extends StatelessWidget {
  const HomebottomNavigation({
    required this.controller,
    required this.goAddHabit,
    required this.goStatistics,
    required this.goCompetition,
    Key? key,
  }) : super(key: key);

  final Function goAddHabit;
  final Function goStatistics;
  final Function(bool) goCompetition;
  final HomeController controller;

  Future<void> _addHabitTap() async {
    if (!await controller.canAddHabit()) {
      goAddHabit();
    } else {
      showToast('Você atingiu o limite de 9 hábitos');
    }
  }

  @override
  Widget build(context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 8, right: 24, left: 24),
        decoration: BoxDecoration(
          color: AppTheme.of(context).materialTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButtonStatus(
              status: false,
              backgroundColor:
                  AppTheme.of(context).materialTheme.colorScheme.secondary,
              icon: const Icon(Icons.show_chart, color: Colors.white, size: 28),
              onPressed: () => goStatistics(),
            ),
            InkWell(
              onTap: _addHabitTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.add,
                  color:
                      AppTheme.of(context).materialTheme.colorScheme.secondary,
                  size: 28,
                ),
              ),
            ),
            Observer(
              builder: (_) => IconButtonStatus(
                status: controller.pendingCompetitionStatus,
                backgroundColor:
                    AppTheme.of(context).materialTheme.colorScheme.secondary,
                icon: Image.asset(
                  'assets/ic_award.png',
                  width: 28,
                  color: Colors.white,
                ),
                onPressed: () => goCompetition(false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
