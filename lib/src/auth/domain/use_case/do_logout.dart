import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/repository/sign_in_repository.dart';


class DoSignOut {
  final SignInRepository signInRepository;

  DoSignOut(this.signInRepository);

  Future<Either<Failure, bool>> call({required Repository repository}) async {

    return await signInRepository.signOut(datasource: Repository.firebase);
  }
}

