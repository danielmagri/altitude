import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:mobx/mobx.dart';
part 'SettingsLogic.g.dart';

class SettingsLogic = _SettingsLogicBase with _$SettingsLogic;

abstract class _SettingsLogicBase with Store {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;

  @observable
  String name = "";

  @observable
  bool isLogged = false;

  @action
  Future<void> fetchData() async {
    name = personUseCase.name;
    isLogged = personUseCase.isLogged;
  }

  @action
  Future<void> changeName(String newName) async {
    if (await personUseCase.setName(newName)) {
      name = newName;
    }
  }

  @action
  Future<void> logout() async {
    await personUseCase.logout();
    isLogged = false;
  }
}
