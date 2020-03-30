import 'package:altitude/core/enums/StateType.dart';
import 'package:flutter/material.dart' show Widget;

typedef Widget Initial();
typedef Widget Success<T>(T data);
typedef Widget Error(dynamic error);

class DataState<T> {
  StateType state = StateType.INITIAL;

  T _data;
  T get data => _data;
  set data(T data) {
    state = StateType.SUCESS;
    _data = data;
  }

  dynamic _error;
  dynamic get error => _error;
  set error(dynamic error) {
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
