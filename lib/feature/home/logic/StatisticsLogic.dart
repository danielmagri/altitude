import 'dart:math';

import 'package:altitude/feature/home/model/KilometerStatisticData.dart';
import 'package:mobx/mobx.dart';
part 'StatisticsLogic.g.dart';

class StatisticsLogic = _StatisticsLogicBase with _$StatisticsLogic;

abstract class _StatisticsLogicBase with Store {
  List<KilometerStatisticData> getKilometersHistoric() {
    List<KilometerStatisticData> list = [];
    //   KilometerStatisticData(4, 3, 9, 5, 2020),
    //   KilometerStatisticData(2, 10, 16, 5, 2020),
    //   KilometerStatisticData(1, 17, 23, 5, 2020),
    //   KilometerStatisticData(5, 24, 30, 5, 2020),
    //   KilometerStatisticData(3, 31, 6, 5, 2020),
    //   KilometerStatisticData(3, 7, 13, 6, 2020),
    //   KilometerStatisticData(0, 14, 20, 6, 2020),
    //   KilometerStatisticData(1, 21, 27, 6, 2020),
    //   KilometerStatisticData(7, 28, 4, 6, 2020),
    // ];

    for (var i=1;i<52;i++) {
      list.add(KilometerStatisticData(Random().nextInt(15), DateTime(2020, 1, 1).add(Duration(days: i))));
    }

    return list;
  }
}
