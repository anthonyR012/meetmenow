import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:meet_me/src/auth/domain/repository/auth_repository.dart';

class DoSignUp {
  final AuthRepository authRepository;

  DoSignUp(this.authRepository);

  Future<Either<Failure, UserModel>> call(
      {required Repository repository,
      required String userName,
      required String password}) async {
    return authRepository.signUp(
        datasource: repository, userName: userName, password: password);
  }
}
