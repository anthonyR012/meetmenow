import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/data/datasource/auth_datasource.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:meet_me/src/auth/domain/repository/auth_repository.dart';

class AuthImplement extends AuthRepository {
  final AuthFirebaseDatasource _authFirebaseDatasource;

  AuthImplement(this._authFirebaseDatasource);

  @override
  Future<Either<Failure, UserModel>> signIn(
      {required String userName,
      required String password,
      required Repository datasource}) async {
    try {
      UserModel? user ;
      if (datasource == Repository.firebase) {
        user = await _authFirebaseDatasource.signIn(
            password: password, userName: userName);
      }
      return Right(user!);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut(
      {required Repository datasource}) async {
    try {
      bool value = false;
      if (datasource == Repository.firebase) {
        value = await _authFirebaseDatasource.signOut();
      }
      return Right(value);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp(
      {required Repository datasource,
      required String userName,
      required String password}) async {
    try {
      UserModel? user;
      if (datasource == Repository.firebase) {
        user = await _authFirebaseDatasource.signUp(
            password: password, userName: userName);
      }
      if (user == null) {
        throw UnimplementedError();
      }
      return Right(user);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
