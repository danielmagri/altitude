import 'package:altitude/core/model/failure.dart';
import 'package:altitude/core/model/result.dart';
import 'package:meta/meta.dart' show protected;

abstract class BaseUsecase<Params, Response> {
  @protected
  Future<Response> getRawFuture(Params params);

  Future<Result<Response>> call(Params params) async {
    try {
      return Result.success(await getRawFuture(params));
    } on Failure catch (e) {
      return Result.error(e);
    } catch (error) {
      return Result.error(GenericFailure(error));
    }
  }
}
