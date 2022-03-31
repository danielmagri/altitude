import 'package:altitude/common/enums/score_type.dart';
import 'package:altitude/common/model/Frequency.dart';

abstract class IScoreService {
  static const int DAY_DONE_POINT = 2;
  static const int CYCLE_DONE_POINT = 1;

  /// Calcula os pontos a ser adicionado ou retirado
  /// frequency: frequência do hábito
  /// week: os dias da semana feito
  /// date: o dia a ser adicionado ou removido
  int calculateScore(
    ScoreType type,
    Frequency frequency,
    List<DateTime?> week,
    DateTime date,
  );

  /// Calcula toda a pontuação
  int scoreEarnedTotal(
    Frequency frequency,
    List<DateTime?> daysDone,
  );
}
