import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserDataUsecase extends BaseUsecase<bool, Person> {
  GetUserDataUsecase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<Person> getRawFuture(bool params) async {
    return _userRepository.getUserData(params);
  }
}
