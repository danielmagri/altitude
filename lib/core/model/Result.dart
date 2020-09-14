typedef R Success<R, T>(T data);
typedef R Error<R>(dynamic error);

class Result<T> {
  Result._();

  factory Result.success(T data) = RSuccess<T>;
  factory Result.error(dynamic error) = RError;

  bool get isSuccess => this is RSuccess<T>;
  bool get isError => this is RError<T>;

  R result<R>(Success<R, T> success, Error<R> error) {
    if (isSuccess) {
      return success((this as RSuccess).data);
    } else {
      return error((this as RError).error);
    }
  }

  R absoluteResult<R>() {
    if (isSuccess) {
      return (this as RSuccess).data;
    } else {
      throw (this as RError).error;
    }
  }
}

class RSuccess<T> extends Result<T> {
  RSuccess(this.data) : super._();

  final T data;
}

class RError<T> extends Result<T> {
  RError(this.error) : super._();

  final dynamic error;
}
