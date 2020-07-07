import 'package:altitude/common/view/Header.dart';
import 'package:altitude/feature/home/logic/StatisticsLogic.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as math;

class Statisticspage extends StatefulWidget {
  @override
  _StatisticspageState createState() => _StatisticspageState();
}

class _StatisticspageState extends State<Statisticspage> {
  StatisticsLogic controller = GetIt.I.get<StatisticsLogic>();

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<StatisticsLogic>();
    super.dispose();
  }

  List<FlSpot> setSpots() {
    int currentKilometer = 0;
    int index = -1;
    return controller.getKilometersHistoric().map((data) {
      currentKilometer += data.kilometersEarned;
      index++;
      return FlSpot(index.toDouble(), currentKilometer.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Header(title: "ESTATÍSTICAS"),
            // const SizedBox(height: 20),
            const SizedBox(height: 100),
            Text("Em breve novidades...", style: TextStyle(fontSize: 20),),
            // Container(
            //     width: double.maxFinite,
            //     margin: const EdgeInsets.symmetric(horizontal: 8),
            //     child: PieChart(
            //       PieChartData(
            //           pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            //             // setState(() {
            //             //   if (pieTouchResponse.touchInput is FlLongPressEnd ||
            //             //       pieTouchResponse.touchInput is FlPanEnd) {
            //             //     touchedIndex = -1;
            //             //   } else {
            //             //     touchedIndex = pieTouchResponse.touchedSectionIndex;
            //             //   }
            //             // });
            //           }),
            //           borderData: FlBorderData(
            //             show: false,
            //           ),
            //           sectionsSpace: 0,
            //           centerSpaceRadius: 0,
            //           sections: showingSections()),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final double fontSize = 25;//isTouched ? 25 : 16;
      final double radius = 50;//isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}