import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signOut({required Repository datasource});
  Future<Either<Failure, UserModel>> signIn({
    required Repository datasource,
    required String userName,
    required String password,
  });
  Future<Either<Failure, UserModel>> signUp({
    required Repository datasource,
    required String userName,
    required String password,
  });
}
