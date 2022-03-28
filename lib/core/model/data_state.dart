import 'package:flutter/material.dart' show SizedBox, Widget;
import 'package:mobx/mobx.dart';
import 'result.dart';
import 'failure.dart';

part 'data_state.g.dart';

typedef _SuccessStateCallback<T> = Widget Function(T data);
typedef _LoadingStateCallback<T> = Widget Function(T? data);
typedef _SimpleLoadingStateCallback = Widget Function();
typedef _ErrorStateCallback = Widget Function(Failure error);

typedef _LoadingReactionCallback = void Function(bool loading);
typedef _SuccessReactionCallback<T> = void Function(T data);
typedef _ErrorReactionCallback = void Function(Failure error);

/*
  O estado INITIAL é o estado de início, como um loading/shimmer/skeleton para carregar os dados
  O estado SUCCESS é para quando der sucesso na chamada
  O estado ERROR é para quando der erro na chamada
  E O estado RELOADING é indicado para quando queremos fazer algum recarregamento e continuar tendo acesso aos dados anteriores,
    como exibir um loading no final da lista ou algo do tipo
*/

enum StateType { SUCCESS, LOADING, ERROR }

class DataState<T> = _DataStateBase<T> with _$DataState;

abstract class _DataStateBase<T> with Store {
  _DataStateBase({StateType initialState = StateType.LOADING}) : _state = initialState;

  @observable
  StateType _state;

  StateType get state => _state;

  T? _data;
  T? get data => _data;

  Failure? _error;
  Failure? get error => _error;

  @action
  void setLoadingState([bool loading = true]) {
    _state = StateType.LOADING;
  }

  @action
  void setSuccessState(T data) {
    _state = StateType.SUCCESS;
    _data = data;
  }

  @action
  void setErrorState(Failure error) {
    _state = StateType.ERROR;
    _error = error;
  }

  Widget handleState(
      {required _SimpleLoadingStateCallback loading,
      required _SuccessStateCallback<T> success,
      _ErrorStateCallback? error}) {
    switch (_state) {
      case StateType.LOADING:
        return loading();
      case StateType.ERROR:
        if (error == null) {
          return const SizedBox();
        } else {
          return error(_error!);
        }
      default:
        return success(_data!);
    }
  }

  Widget handleStateLoadableWithData(
      {required _LoadingStateCallback<T> loading,
      required _SuccessStateCallback<T> success,
      _ErrorStateCallback? error}) {
    switch (_state) {
      case StateType.LOADING:
        return loading(_data);
      case StateType.ERROR:
        if (error == null) {
          return const SizedBox();
        } else {
          return error(_error!);
        }
      default:
        return success(_data!);
    }
  }

  ReactionDisposer handleReactionState(
      {_LoadingReactionCallback? loading,
      _SuccessReactionCallback<T>? success,
      _ErrorReactionCallback? error}) {
    return reaction((_) => _state, (_) {
      switch (_state) {
        case StateType.LOADING:
          if (loading != null) loading(true);
          break;
        case StateType.ERROR:
          if (loading != null) loading(false);
          if (error != null) error(_error!);
          break;
        case StateType.SUCCESS:
          if (loading != null) loading(false);
          if (success != null) success(_data!);
          break;
      }
    });
  }
}

extension FutureExtension<T> on Future<Result<T>> {
  Future<R> resultComplete<R>(
      R Function(T data) success, R Function(Failure error) error) async {
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
