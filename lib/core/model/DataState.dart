import 'package:altitude/core/enums/StateType.dart';
import 'package:flutter/material.dart' show SizedBox, Widget;
import 'package:mobx/mobx.dart';
part 'DataState.g.dart';

typedef Widget Initial();
typedef Widget Success<T>(T data);
typedef Widget SuccessLoadable<T>(T data, bool loading);
typedef Widget Error(dynamic error);

class DataState<T> = _DataStateBase<T> with _$DataState;

abstract class _DataStateBase<T> with Store {
  @observable
  StateType _state = StateType.INITIAL;

  StateType get state => _state;

  @observable
  bool _loading = false;

  T _data;
  T get data => _data;

  dynamic _error;
  dynamic get error => _error;

  @action
  void setInitial() {
    _state = StateType.INITIAL;
    _loading = false;
  }

  @action
  void setLoading([bool loading = true]) {
    _loading = loading;
  }

  @action
  void setData(T data) {
    _state = StateType.SUCESS;
    _loading = false;
    _data = data;
  }

  @action
  void setError(dynamic error) {
    _state = StateType.ERROR;
    _loading = false;
    _error = error;
  }

  Widget handleState(Initial initial, Success<T> success, [Error error]) {
    switch (_state) {
      case StateType.INITIAL:
        return initial();
      case StateType.ERROR:
        if (error == null) const SizedBox();
        return error(_error);
      default:
        return success(_data);
    }
  }

  Widget handleStateLoadable(Initial initial, SuccessLoadable<T> successLoadable, [Error error]) {
    switch (_state) {
      case StateType.INITIAL:
        return initial();
      case StateType.ERROR:
        if (error == null) const SizedBox();
        return error(_error);
      default:
        return successLoadable(_data, _loading);
    }
  }
}
