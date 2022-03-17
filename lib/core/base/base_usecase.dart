import 'package:altitude/core/model/failure.dart';
import 'package:altitude/core/model/result.dart';
import 'package:meta/meta.dart' show protected;

abstract class BaseUsecase<Params extends Object, Response> {
  @protected
  Future<Response> getRawFuture(Params params);

  Future<Result<Response>> call([Params? params]) async {
    try {
      if (Params != NoParams && params == null) {
        throw NoParamsFailure();
      } else {
        final value =
            Params == NoParams ? NoParams() as Params : params as Params;
        return Result.success(await getRawFuture(value));
      }
    } on Failure catch (e) {
      return Result.error(e);
    } catch (error) {
      return Result.error(GenericFailure(error));
    }
  }
}

class NoParams {}
