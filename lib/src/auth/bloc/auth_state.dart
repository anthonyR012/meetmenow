part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final Failure failure;
  const AuthFailure(this.failure);
}

final class AuthLogout extends AuthState {}