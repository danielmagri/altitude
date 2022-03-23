import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/domain/usecases/user/is_logged_usecase.dart';
import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/feature/setting/domain/usecases/logout_usecase.dart';
import 'package:altitude/feature/setting/domain/usecases/recalculate_score_usecasse.dart';
import 'package:altitude/feature/setting/domain/usecases/update_name_usecase.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'settings_controller.g.dart';

@LazySingleton()
class SettingsController = _SettingsControllerBase with _$SettingsController;

abstract class _SettingsControllerBase with Store {
  final GetCompetitionsUsecase _getCompetitionsUsecase;
  final UpdateNameUsecase _updateNameUsecase;
  final LogoutUsecase _logoutUsecase;
  final RecalculateScoreUsecase _recalculateScoreUsecase;
  final IsLoggedUsecase _isLoggedUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final SharedPref _sharedPref;

  _SettingsControllerBase(
      this._sharedPref,
      this._getCompetitionsUsecase,
      this._updateNameUsecase,
      this._logoutUsecase,
      this._recalculateScoreUsecase,
      this._isLoggedUsecase,
      this._getUserDataUsecase);

  @observable
  String? name = "";

  @observable
  ThemeType? theme = ThemeType.SYSTEM;

  @observable
  bool isLogged = false;

  @action
  Future<void> fetchData() async {
    name = (await _getUserDataUsecase
            .call(false)
            .resultComplete((data) => data, (error) => null))
        ?.name;
    isLogged = await _isLoggedUsecase
        .call()
        .resultComplete((data) => data ?? false, (error) => false);
    theme = getThemeType(_sharedPref.theme);
  }

  @action
  Future<void> changeName(String newName) async {
    List<String?> competitionsId = (await _getCompetitionsUsecase.call(true))
        .absoluteResult()
        .map((e) => e.id)
        .toList();
    (await _updateNameUsecase.call(
            UpdateNameParams(name: newName, competitionsId: competitionsId)))
        .absoluteResult();
    name = newName;
  }

  @action
  void changeTheme(BuildContext context, ThemeType? value) {
    _sharedPref.theme = value.themeString;
    theme = value;
    AppTheme.changeTheme(context, value.toThemeMode);
  }

  @action
  Future<void> logout() async {
    await _logoutUsecase.call();
    isLogged = false;
  }

  Future recalculateScore() async {
    return (await _recalculateScoreUsecase.call()).absoluteResult();
  }
}