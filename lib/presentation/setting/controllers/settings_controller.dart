import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/common/model/result.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/domain/usecases/auth/logout_usecase.dart';
import 'package:altitude/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/domain/usecases/user/is_logged_usecase.dart';
import 'package:altitude/domain/usecases/user/recalculate_score_usecasse.dart';
import 'package:altitude/domain/usecases/user/update_name_usecase.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'settings_controller.g.dart';

@lazySingleton
class SettingsController = _SettingsControllerBase with _$SettingsController;

abstract class _SettingsControllerBase with Store {
  _SettingsControllerBase(
    this._sharedPref,
    this._getCompetitionsUsecase,
    this._updateNameUsecase,
    this._logoutUsecase,
    this._recalculateScoreUsecase,
    this._isLoggedUsecase,
    this._getUserDataUsecase,
  );

  final GetCompetitionsUsecase _getCompetitionsUsecase;
  final UpdateNameUsecase _updateNameUsecase;
  final LogoutUsecase _logoutUsecase;
  final RecalculateScoreUsecase _recalculateScoreUsecase;
  final IsLoggedUsecase _isLoggedUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final SharedPref _sharedPref;

  @observable
  String? name = '';

  @observable
  ThemeType? theme = ThemeType.system;

  @observable
  bool isLogged = false;

  @action
  Future<void> fetchData() async {
    name = (await _getUserDataUsecase
            .call(false)
            .resultComplete((data) => data, (error) => null))
        ?.name;
    isLogged = await _isLoggedUsecase
        .call(NoParams())
        .resultComplete((data) => data, (error) => false);
    theme = getThemeType(_sharedPref.theme);
  }

  @action
  Future<void> changeName(String newName) async {
    List<String?> competitionsId = (await _getCompetitionsUsecase
            .call(true)
            .resultComplete((data) => data, (error) => throw error))
        .map((e) => e.id)
        .toList();
    await _updateNameUsecase
        .call(UpdateNameParams(name: newName, competitionsId: competitionsId))
        .resultComplete((data) => data, (error) => throw error);
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
    await _logoutUsecase.call(NoParams());
    isLogged = false;
  }

  Future recalculateScore() async {
    return _recalculateScoreUsecase
        .call(NoParams())
        .resultComplete((data) => data, (error) => throw error);
  }
}
