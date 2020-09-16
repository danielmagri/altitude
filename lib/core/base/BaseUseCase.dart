import 'package:altitude/core/model/Result.dart';

abstract class BaseUseCase {
  Future<Result<T>> safeCall<T>(Future<Result<T>> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return Result.error(e);
    }
  }
}
