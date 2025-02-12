import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:meet_me/src/auth/domain/repository/sign_in_repository.dart';

class DoSignIn {
  final SignInRepository signInRepository;

  DoSignIn(this.signInRepository);

  Future<Either<Failure, UserModel>> call(
      {required Repository repository}) async {
    return signInRepository.signIn(datasource: repository);
  }
}
