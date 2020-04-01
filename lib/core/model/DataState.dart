import 'package:altitude/core/enums/StateType.dart';
import 'package:flutter/material.dart' show Widget;
import 'package:mobx/mobx.dart';
part 'DataState.g.dart';

typedef Widget Initial();
typedef Widget Success<T>(T data);
typedef Widget Error(dynamic error);

class DataState<T> = _DataStateBase<T> with _$DataState;

abstract class _DataStateBase<T> with Store {
  @observable
  StateType state = StateType.INITIAL;

  T _data;
  T get data => _data;
  
  @action
  void setData(T data) {
    state = StateType.SUCESS;
    _data = data;
  }

  dynamic _error;
  dynamic get error => _error;
  
  @action
  void setError(dynamic error) {
    state = StateType.ERROR;
    _error = error;
  }

  Widget handleState(Initial initial, Success<T> success, Error error) {
    switch (state) {
      case StateType.INITIAL:
        return initial();
      case StateType.ERROR:
        return error(_error);
      default:
        return success(_data);
    }
  }
}
