import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/dialog/TutorialDialog.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/statistics/logic/StatisticsLogic.dart';
import 'package:altitude/feature/statistics/model/HabitStatisticData.dart';
import 'package:altitude/feature/statistics/view/widget/FrequencyChart.dart';
import 'package:altitude/feature/statistics/view/widget/HistoricChart.dart';
import 'package:altitude/feature/statistics/view/widget/Indicator.dart';
import 'package:altitude/feature/statistics/view/widget/PieChartScore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:altitude/core/extensions/NavigatorExtension.dart';

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

  void showPercentageTutorial() {
    Navigator.of(context).smooth(TutorialDialog(
      hero: "helpPercentage",
      texts: const [
        TextSpan(text: "  Vamos começar escolhendo qual será o hábito que deseja construir no seu cotidiano."),
        TextSpan(text: "\n\n  O segredo para conseguir construir um hábito é "),
        TextSpan(text: "criar um ritual e sempre fazer a mesma coisa.", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ));
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
                            runSpacing: 15,
                            spacing: 15,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 24),
              child: Row(
                children: [
                  const HeaderSection(title: "Porcetagem"),
                  IconButton(
                      iconSize: 22,
                      icon: const Hero(tag: "helpPercentage", child: Icon(Icons.help_outline)),
                      onPressed: showPercentageTutorial)
                ],
              ),
            ),
            Container(
                width: double.maxFinite,
                height: 200,
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
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 24),
              child: Row(
                children: [
                  const HeaderSection(title: "Histórico"),
                  IconButton(
                      iconSize: 22,
                      icon: const Hero(tag: "helpHistoric", child: Icon(Icons.help_outline)),
                      onPressed: showPercentageTutorial)
                ],
              ),
            ),
            Observer(
              builder: (_) => controller.historicData.handleState(
                  () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Skeleton(width: double.maxFinite, height: HISTORIC_CHART_HEIGHT),
                      ),
                  (data) => HistoricChart(list: data),
                  (error) => DataError()),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 24),
              child: Row(
                children: [
                  const HeaderSection(title: "Frequência"),
                  IconButton(
                      iconSize: 22,
                      icon: const Hero(tag: "helpFrequency", child: Icon(Icons.help_outline)),
                      onPressed: showPercentageTutorial)
                ],
              ),
            ),
            Observer(
              builder: (_) => controller.frequencyData.handleState(
                  () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Skeleton(width: double.maxFinite, height: FREQUENCY_CHART_HEIGHT),
                      ),
                  (data) => FrequencyChart(list: data),
                  (error) => DataError()),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key key, this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20));
  }
}
