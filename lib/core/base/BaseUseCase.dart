import 'package:altitude/core/model/failure.dart';
import 'package:altitude/core/model/result.dart';

@deprecated
abstract class BaseUseCase {
  Future<Result<T>> safeCall<T>(Future<T> Function() call) async {
    try {
      return Result.success(await call());
    } catch (e) {
      return Result.error(Failure.genericFailure(e));
    }
  }
}
