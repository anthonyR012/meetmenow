import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:meet_me/src/auth/domain/use_case/do_signin.dart';
import 'package:meet_me/src/auth/domain/use_case/do_signout.dart';
import 'package:meet_me/src/auth/domain/use_case/do_signup.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final DoSignIn doSignIn;
  final DoSignUp doSignUp;
  final DoSignOut doSignOut;

  AuthCubit(this.doSignIn, this.doSignOut, this.doSignUp)
      : super(AuthInitial());

  Future<void> signIn(
      {required String userName, required String password}) async {
    emit(AuthLoading());
    final result = await doSignIn.call(
        repository: Repository.firebase,
        userName: userName,
        password: password);
    result.fold((l) => emit(AuthFailure(l)), (r) => emit(AuthSuccess(r)));
  }

  Future<void> signUp(
      {required String userName, required String password}) async {
    emit(AuthLoading());
    final result = await doSignUp.call(
        repository: Repository.firebase,
        userName: userName,
        password: password);
    result.fold((l) => emit(AuthFailure(l)), (r) => emit(AuthSuccess(r)));
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await doSignOut.call(repository: Repository.firebase);
    result.fold((l) => emit(AuthFailure(l)), (r) async{
      emit(AuthLogout());
      Future.delayed(Durations.medium4);
      emit(AuthInitial());
    } );
  }
}
