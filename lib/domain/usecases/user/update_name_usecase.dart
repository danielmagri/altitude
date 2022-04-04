import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNameUsecase extends BaseUsecase<UpdateNameParams, void> {
  final IUserRepository _userRepository;

  UpdateNameUsecase(this._userRepository);

  @override
  Future<void> getRawFuture(UpdateNameParams params) async {
    return _userRepository.updateName(params.name, params.competitionsId);
  }
}

class UpdateNameParams {
  final String name;
  final List<String?> competitionsId;

  UpdateNameParams({required this.name, required this.competitionsId});
}
