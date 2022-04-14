import 'package:altitude/core/model/Result.dart';

abstract class BaseUseCase {
  Future<Result<T>> safeCall<T>(Future<T> Function() call) async {
    try {
      return Result.success(await call());
    } catch (e) {
      return Result.error(e);
    }
  }
}
