import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/repository/auth_repository.dart';


class DoSignOut {
  final AuthRepository authRepository;

  DoSignOut(this.authRepository);

  Future<Either<Failure, bool>> call({required Repository repository}) async {

    return await authRepository.signOut(datasource: Repository.firebase);
  }
}

