import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:get_it/get_it.dart';

class CompetitionUseCase extends BaseUseCase {
  static CompetitionUseCase get getInstance => GetIt.I.get<CompetitionUseCase>();

  final Memory _memory = Memory.getInstance;

  bool get pendingCompetitionsStatus => SharedPref.instance.pendingCompetition;
  set pendingCompetitionsStatus(bool value) => SharedPref.instance.pendingCompetition = value;

  Future<Result<List<Competition>>> getCompetitions() => safeCall(() async {
        if (_memory.competitions.isEmpty) {
          List<Competition> list = await FireDatabase().getCompetitions();
          _memory.competitions = list;
          return Result.success(list);
        } else {
          return Result.success(_memory.competitions);
        }
      });

  Future<Result<Competition>> createCompetition(
          String title, Habit habit, List<String> invitations, List<String> invitationsToken) =>
      safeCall(() {
        Competition competition = Competition(
          title: title,
          
        );
        // Criar json no firebase
        //Enviar notificações
        // Salvar no Memory
      });

  Future<bool> maximumNumberReached() async {
    try {
      int length = (await getCompetitions()).absoluteResult().length;

      return length >= MAX_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }

  Future<bool> maximumNumberReachedByHabit(String habitId) async {
    //TODO:
    // try {
    //   int length = (await getCompetitions()).absoluteResult().length;

    //   return length >= MAX_COMPETITIONS;
    // } catch (e) {
    return Future.value(true);
    // }
  }
}
