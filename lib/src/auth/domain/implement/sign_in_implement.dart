
import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/data/datasource/sign_in_datasource.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:meet_me/src/auth/domain/repository/sign_in_repository.dart';


class SignInImplement extends SignInRepository {
  final SingInFirebaseDatasource _signInFirebaseDatasource;

  SignInImplement(this._signInFirebaseDatasource);

  @override
  Future<Either<Failure, UserModel>> signIn(
      {String? userName,
      String? password,
      required Repository datasource}) async {
    try {
      UserModel? user;
     if (datasource == Repository.firebase) {
        user = await _signInFirebaseDatasource.signIn();
      }
      if (user == null) {
        throw UnimplementedError();
      }
      return Right(user);
    } catch (e, stackTrace) {      
      assert(e is! Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut(
      {required Repository datasource}) async {
    try {
      bool value = false;
      if (datasource == Repository.firebase) {
        value = await _signInFirebaseDatasource.signOut();
      } 
      return Right(value);
    } catch (e, stackTrace) {
      assert(e is! Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }


}
