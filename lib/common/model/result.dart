import '../../common/model/failure.dart';

typedef Success<R, T> = R Function(T data);
typedef Error<R> = R Function(dynamic error);

class Result<T> {
  Result._();

  factory Result.success(T data) = SuccessResult<T>;
  factory Result.error(Failure error) = FailureResult;

  bool get isSuccess => this is SuccessResult<T>;
  bool get isError => this is FailureResult<T>;

  T? get data => this is SuccessResult ? (this as SuccessResult).value : null;
  Failure? get error =>
      this is FailureResult ? (this as FailureResult).e : null;

  R result<R>(Success<R, T> success, Error<R> error) {
    if (isSuccess) {
      return success((this as SuccessResult).data);
    } else {
      return error((this as FailureResult).error);
    }
  }
}

class SuccessResult<T> extends Result<T> {
  SuccessResult(this.value) : super._();

  final T value;
}

class FailureResult<T> extends Result<T> {
  FailureResult(this.e) : super._();

  final Failure e;
}
