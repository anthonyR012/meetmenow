import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/config/helper/network_state.dart';
import 'package:meet_me/main.dart';
import 'package:meet_me/src/auth/bloc/auth_cubit.dart';
import 'package:meet_me/src/auth/data/datasource/auth_datasource.dart';
import 'package:meet_me/src/auth/data/implement_datasource/auth_firebase_datasource.dart';
import 'package:meet_me/src/auth/domain/implement/auth_implement.dart';
import 'package:meet_me/src/auth/domain/repository/auth_repository.dart';
import 'package:meet_me/src/auth/domain/use_case/do_signin.dart';
import 'package:meet_me/src/auth/domain/use_case/do_signout.dart';
import 'package:meet_me/src/auth/domain/use_case/do_signup.dart';

void injectDependencies() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  final stateNetwork = NetworkState(Connectivity());
  stateNetwork.watchConnectionState();
  getIt.registerLazySingleton(() => stateNetwork);
  getIt.registerLazySingleton(() => FailureManage());
  injectAuthDatasource();
}

void injectAuthDatasource() {
  // ---------------SPLASH MODULE--------------
  // * [SPLASH]
  _registerOrUnregister<AuthFirebaseDatasource>(
      () => SignInFirebaseDatasourceImplement(getIt(), getIt(), getIt()));
  _registerOrUnregister<AuthRepository>(() => AuthImplement(getIt()));
  //USES CASES
  _registerOrUnregister<DoSignIn>(() => DoSignIn(getIt()));
  _registerOrUnregister<DoSignUp>(() => DoSignUp(getIt()));
  _registerOrUnregister<DoSignOut>(() => DoSignOut(getIt()));
  _registerOrUnregister<AuthCubit>(() => AuthCubit(getIt(), getIt(), getIt()));
}

void _registerOrUnregister<T extends Object>(T Function() instanceBuilder) {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
    return;
  }
  getIt.registerLazySingleton<T>(instanceBuilder);
}
