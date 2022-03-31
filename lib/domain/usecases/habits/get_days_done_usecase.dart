import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetDaysDoneUsecase extends BaseUsecase<GetDaysDoneParams, List<DayDone>> {
  final IFireDatabase _fireDatabase;

  GetDaysDoneUsecase(this._fireDatabase);

  @override
  Future<List<DayDone>> getRawFuture(GetDaysDoneParams params) async {
    return _fireDatabase.getDaysDone(params.id, params.start, params.end);
  }
}

class GetDaysDoneParams {
  final String? id;
  final DateTime? start;
  final DateTime end;

  GetDaysDoneParams({this.id, this.start, required this.end});
}
