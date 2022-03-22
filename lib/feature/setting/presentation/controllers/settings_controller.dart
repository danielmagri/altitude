import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'settings_controller.g.dart';

@LazySingleton()
class SettingsController = _SettingsControllerBase with _$SettingsController;

abstract class _SettingsControllerBase with Store {
  final PersonUseCase? _personUseCase;
  final HabitUseCase? _habitUseCase;
  final CompetitionUseCase? _competitionUseCase;
  final SharedPref? _sharedPref;

  _SettingsControllerBase(this._personUseCase, this._habitUseCase, this._competitionUseCase, this._sharedPref);

  @observable
  String? name = "";

  @observable
  ThemeType? theme = ThemeType.SYSTEM;

  @observable
  bool isLogged = false;

  @action
  Future<void> fetchData() async {
    name = _personUseCase!.name;
    isLogged = _personUseCase!.isLogged;
    theme = getThemeType(_sharedPref!.theme);
  }

  @action
  Future<void> changeName(String newName) async {
    List<String?> competitionsId =
        (await _competitionUseCase!.getCompetitions(fromServer: true)).absoluteResult().map((e) => e.id).toList();
    (await _personUseCase!.updateName(newName, competitionsId)).absoluteResult();
    name = newName;
  }

  @action
  void changeTheme(BuildContext context, ThemeType? value) {
    _sharedPref!.theme = value.themeString;
    theme = value;
    AppTheme.changeTheme(context, value.toThemeMode);
  }

  @action
  Future<void> logout() async {
    await _personUseCase!.logout();
    isLogged = false;
  }

  Future recalculateScore() async {
    return (await _habitUseCase!.recalculateScore()).absoluteResult();
  }
}
