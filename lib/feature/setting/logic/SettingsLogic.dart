import 'package:altitude/common/controllers/UserControl.dart';
import 'package:mobx/mobx.dart';
part 'SettingsLogic.g.dart';

class SettingsLogic = _SettingsLogicBase with _$SettingsLogic;

abstract class _SettingsLogicBase with Store {
  @observable
  String name = "";

  @observable
  bool isLogged = false;

  @action
  Future<void> fetchData() async {
    name = UserControl().getName();
    isLogged = UserControl().isLogged();
  }

  @action
  Future<void> changeName(String newName) async {
    if (await UserControl().setName(newName)) {
      name = newName;
    }
  }

  @action
  Future<void> logout() async {
    await UserControl().logout();
    isLogged = false;
  }
}
