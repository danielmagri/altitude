import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/statistics/logic/StatisticsLogic.dart';
import 'package:altitude/feature/statistics/model/HabitStatisticData.dart';
import 'package:altitude/feature/statistics/view/widget/Indicator.dart';
import 'package:altitude/feature/statistics/view/widget/PieChartScore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class Statisticspage extends StatefulWidget {
  @override
  _StatisticspageState createState() => _StatisticspageState();
}

class _StatisticspageState extends State<Statisticspage> {
  StatisticsLogic controller = GetIt.I.get<StatisticsLogic>();

  @override
  void initState() {
    super.initState();
    controller.fetchData();
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<StatisticsLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Header(title: "ESTATÍSTICAS"),
            const SizedBox(height: 20),
            Observer(
                builder: (_) => controller.habitsData.handleState(
                    () => Skeleton.custom(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              5,
                              (index) => Container(
                                width: 90,
                                height: 20,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ),
                        ),
                    (data) => Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: data.map((data) => Indicator(data: data, onClick: controller.selectHabit)).toList(),
                        ),
                    (error) => DataError())),
            const SizedBox(height: 20),
            Container(
                width: double.maxFinite,
                height: 260,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Observer(
                  builder: (_) => controller.habitsData.handleState(
                      () => Skeleton.custom(
                              child: PieChartScore(data: [
                            HabitStatisticData(0, 25, "", 1),
                            HabitStatisticData(0, 25, "", 1),
                            HabitStatisticData(0, 25, "", 1),
                            HabitStatisticData(0, 25, "", 1),
                          ])),
                      (data) => PieChartScore(data: data.toList(), onClick: controller.selectHabit),
                      (error) => DataError()),
                )),
          ],
        ),
      ),
    );
  }
}
