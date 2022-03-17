import 'package:flutter/material.dart' show SizedBox, Widget;
import 'package:mobx/mobx.dart';
import 'result.dart';
import 'failure.dart';

part 'data_state.g.dart';

typedef Initial = Widget Function();
typedef Success<T> = Widget Function(T? data);
typedef SuccessLoadable<T> = Widget Function(T? data, bool loading);
typedef Error = Widget Function(Failure? error);

typedef LoadingCallback = void Function(bool loading);
typedef SuccessCallback<T> = void Function(T? data);
typedef ErrorCallback = void Function(Failure? error);

/*
  O estado INITIAL é o estado de início, como um loading/shimmer/skeleton para carregar os dados
  O estado SUCCESS é para quando der sucesso na chamada
  O estado ERROR é para quando der erro na chamada
  E O estado RELOADING é indicado para quando queremos fazer algum recarregamento e continuar tendo acesso aos dados anteriores,
    como exibir um loading no final da lista ou algo do tipo
*/

enum StateType { INITIAL, SUCCESS, RELOADING, ERROR }

class DataState<T> = _DataStateBase<T> with _$DataState;

abstract class _DataStateBase<T> with Store {
  _DataStateBase({StateType state = StateType.INITIAL}) : _state = state;

  @observable
  StateType _state;

  StateType get state => _state;

  T? _data;
  T? get data => _data;

  Failure? _error;
  Failure? get error => _error;

  @action
  void setInitialState() {
    _state = StateType.INITIAL;
  }

  @action
  void setLoadingState() {
    _state = StateType.RELOADING;
  }

  @action
  void setSuccessState(T? data) {
    _state = StateType.SUCCESS;
    _data = data;
  }

  @action
  void setErrorState(Failure? error) {
    _state = StateType.ERROR;
    _error = error;
  }

  Widget handleState(Initial initial, Success<T> success, [Error? error]) {
    switch (_state) {
      case StateType.INITIAL:
        return initial();
      case StateType.ERROR:
        if (error == null) {
          return const SizedBox();
        } else {
          return error(_error);
        }
      default:
        return success(_data);
    }
  }

  Widget handleStateReloadable(
      Initial initial, SuccessLoadable<T> successLoadable,
      [Error? error]) {
    switch (_state) {
      case StateType.INITIAL:
        return initial();
      case StateType.ERROR:
        if (error == null) {
          return const SizedBox();
        } else {
          return error(_error);
        }
      default:
        return successLoadable(_data, _state == StateType.RELOADING);
    }
  }

  ReactionDisposer handleReactionState(
      {LoadingCallback? loading,
      SuccessCallback<T>? success,
      ErrorCallback? error}) {
    return reaction((_) => _state, (_) {
      switch (_state) {
        case StateType.RELOADING:
          if (loading != null) loading(true);
          break;
        case StateType.ERROR:
          if (loading != null) loading(false);
          if (error != null) error(_error);
          break;
        case StateType.SUCCESS:
          if (loading != null) loading(false);
          if (success != null) success(_data);
          break;
        case StateType.INITIAL:
          break;
      }
    });
  }
}

extension FutureExtension<T> on Future<Result<T>> {
  Future<R> resultComplete<R>(
      R Function(T? data) success, R Function(Failure error) error) async {
    var res = await this;
    if (res.isSuccess) {
      return success((res as SuccessResult<T>).value);
    } else {
      return error((res as FailureResult).e);
    }
  }

  Future resultCompleteState<T>(DataState<T> dataState) async {
    var res = await this;
    if (res.isSuccess) {
      dataState.setSuccessState((res as SuccessResult<T>).value);
    } else {
      dataState.setErrorState((res as FailureResult).e);
    }
  }
}
