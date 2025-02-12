import 'package:meet_me/src/auth/domain/model/user_model.dart';

abstract class SignInDatasource {}

mixin SignInMixin {
  Future<UserModel> signIn();
}

mixin SignoutMixin {
  Future<bool> signOut();
}


abstract class SingInFirebaseDatasource
    implements SignInDatasource, SignInMixin, SignoutMixin {}
