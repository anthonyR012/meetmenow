import 'package:meet_me/src/auth/domain/model/user_model.dart';

abstract class AuthDatasource {}

mixin SignInMixin {
  Future<UserModel> signIn({required String userName, required String password});
}

mixin SignUpMixin {
  Future<UserModel> signUp({required String userName, required String password});
}

mixin SignoutMixin {
  Future<bool> signOut();
}


abstract class AuthFirebaseDatasource
    implements AuthDatasource, SignInMixin, SignoutMixin , SignUpMixin {}
