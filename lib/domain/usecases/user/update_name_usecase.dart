import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNameUsecase extends BaseUsecase<UpdateNameParams, void> {
  UpdateNameUsecase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<void> getRawFuture(UpdateNameParams params) async {
    return _userRepository.updateName(params.name, params.competitionsId);
  }
}

class UpdateNameParams {
  UpdateNameParams({required this.name, required this.competitionsId});

  final String name;
  final List<String?> competitionsId;
}
