import 'package:altitude/data/repository/friends_repository.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFriendsUsecase extends BaseUsecase<NoParams, List<Person>> {
  final IFriendsRepository _friendsRepository;

  GetFriendsUsecase(this._friendsRepository);

  @override
  Future<List<Person>> getRawFuture(NoParams params) {
    return _friendsRepository.getFriends();
  }
}
