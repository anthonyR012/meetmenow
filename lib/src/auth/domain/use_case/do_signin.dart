import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:meet_me/src/auth/domain/repository/auth_repository.dart';

class DoSignIn {
  final AuthRepository authRepository;

  DoSignIn(this.authRepository);

  Future<Either<Failure, UserModel>> call(
      {required Repository repository,
      required String userName,
      required String password}) async {
    if (userName.isEmpty || password.isEmpty) {
      return Left(EmptyFailure("Empty username or password"));
    }
    return authRepository.signIn(
        datasource: repository, userName: userName, password: password);
  }
}
