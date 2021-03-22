import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'SettingsLogic.g.dart';

@LazySingleton()
class SettingsLogic = _SettingsLogicBase with _$SettingsLogic;

abstract class _SettingsLogicBase with Store {
  final PersonUseCase _personUseCase;
  final HabitUseCase _habitUseCase;
  final CompetitionUseCase _competitionUseCase;

  _SettingsLogicBase(this._personUseCase, this._habitUseCase, this._competitionUseCase);

  @observable
  String name = "";

  @observable
  bool isLogged = false;

  @action
  Future<void> fetchData() async {
    name = _personUseCase.name;
    isLogged = _personUseCase.isLogged;
  }

  @action
  Future<void> changeName(String newName) async {
    List<String> competitionsId =
        (await _competitionUseCase.getCompetitions(fromServer: true)).absoluteResult().map((e) => e.id).toList();
    (await _personUseCase.updateName(newName, competitionsId)).absoluteResult();
    name = newName;
  }

  @action
  Future<void> logout() async {
    await _personUseCase.logout();
    isLogged = false;
  }

  Future recalculateScore() async {
    return (await _habitUseCase.recalculateScore()).absoluteResult();
  }
}
