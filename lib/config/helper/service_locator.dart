import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meet_me/config/constants.dart';
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
import 'package:meet_me/src/call/bloc/call_cubit.dart';
import 'package:meet_me/src/call/data/datasource/call_datasource.dart';
import 'package:meet_me/src/call/data/implement_datasource/call_agora_datasource.dart';
import 'package:meet_me/src/call/domain/implement/call_implement.dart';
import 'package:meet_me/src/call/domain/repository/call_repository.dart';
import 'package:meet_me/src/call/domain/use_case/do_init_engine.dart';
import 'package:meet_me/src/call/domain/use_case/do_join_channel.dart';
import 'package:meet_me/src/call/domain/use_case/do_leave_channel.dart';
import 'package:meet_me/src/call/domain/use_case/do_mute_video.dart';

void injectDependencies() async {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  final stateNetwork = NetworkState(Connectivity());
  stateNetwork.watchConnectionState();
  getIt.registerLazySingleton(() => stateNetwork);
  getIt.registerLazySingleton(() => FailureManage());
  await dotenv.load(fileName: ".env");
  getIt.registerLazySingleton<DotEnv>(() => dotenv);

  injectAuthDatasource();
  injectCallDatasource();
}

void injectAuthDatasource() {
  _registerOrUnregister<AuthFirebaseDatasource>(
      () => SignInFirebaseDatasourceImplement(getIt(), getIt(), getIt()));
  _registerOrUnregister<AuthRepository>(() => AuthImplement(getIt()));
  //USES CASES
  _registerOrUnregister<DoSignIn>(() => DoSignIn(getIt()));
  _registerOrUnregister<DoSignUp>(() => DoSignUp(getIt()));
  _registerOrUnregister<DoSignOut>(() => DoSignOut(getIt()));
  _registerOrUnregister<AuthCubit>(() => AuthCubit(getIt(), getIt(), getIt()));
}

void injectCallDatasource() {
  _registerOrUnregister<CallAgoraDatasource>(
      () => CallAgoraDatasourceImplement(getIt()));
  _registerOrUnregister<CallRepository>(() => CallImplement(getIt()));
  //USES CASES
  final dot = getIt<DotEnv>();
  final appId = dot.env[keyAppId] ?? "";
  final token = dot.env[keyTokenAgora] ?? "";
  final channelId = dot.env[keyChannelName] ?? "";

  _registerOrUnregister<DoInitEngine>(() => DoInitEngine(getIt(), appId));
  _registerOrUnregister<DoJoinChannel>(
      () => DoJoinChannel(getIt(), channelId, token));
  _registerOrUnregister<DoLeaveChannel>(() => DoLeaveChannel(getIt()));
  _registerOrUnregister<DoMuteVideo>(() => DoMuteVideo(getIt()));
  _registerOrUnregister<CallCubit>(
      () => CallCubit(getIt(), getIt(), getIt(), getIt()));
}

void _registerOrUnregister<T extends Object>(T Function() instanceBuilder) {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
    return;
  }
  getIt.registerLazySingleton<T>(instanceBuilder);
}
