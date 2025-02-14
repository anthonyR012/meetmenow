// Mock Dependencies
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/data/datasource/auth_datasource.dart';
import 'package:meet_me/src/auth/domain/implement/auth_implement.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthFirebaseDatasource extends Mock
    implements AuthFirebaseDatasource {}

void main() {
  late AuthImplement authRepository;
  late MockAuthFirebaseDatasource mockAuthFirebaseDatasource;

  setUp(() {
    mockAuthFirebaseDatasource = MockAuthFirebaseDatasource();
    authRepository = AuthImplement(mockAuthFirebaseDatasource);
  });

  group('signIn', () {
    test('should return UserModel when signIn is successful', () async {
      final user = UserModel(
          id: '123',
          name: 'test_user',
          email: 'test_user',
          profilePic: 'test_user',
          isOnline: true);
      when(() => mockAuthFirebaseDatasource.signIn(
          userName: any(named: 'userName'),
          password: any(named: 'password'))).thenAnswer((_) async => user);

      final result = await authRepository.signIn(
        userName: 'test_user',
        password: 'password123',
        datasource: Repository.firebase,
      );

      expect(result, Right(user));
    });

    test('should return Failure when signIn fails', () async {
      when(() => mockAuthFirebaseDatasource.signIn(
              userName: any(named: 'userName'),
              password: any(named: 'password')))
          .thenThrow(UnknownFailure('Login failed'));

      final result = await authRepository.signIn(
        userName: 'test_user',
        password: 'password123',
        datasource: Repository.firebase,
      );

      expect(result.fold((l) => l, (r) => r) , UnknownFailure('Login failed'));
    });
  });

  group('signOut', () {
    test('should return true when signOut is successful', () async {
      when(() => mockAuthFirebaseDatasource.signOut())
          .thenAnswer((_) async => true);

      final result = await authRepository.signOut(
        datasource: Repository.firebase,
      );

      expect(result, const Right(true));
    });

    test('should return Failure when signOut fails', () async {
      when(() => mockAuthFirebaseDatasource.signOut())
          .thenThrow(UnknownFailure('Sign out failed'));

      final result = await authRepository.signOut(
        datasource: Repository.firebase,
      );

      expect(result, Left(UnknownFailure('Sign out failed')));
    });
  });

  group('signUp', () {
    test('should return UserModel when signUp is successful', () async {
      final user = UserModel(
          id: '123',
          name: 'test_user',
          email: 'test_user',
          profilePic: 'test_user',
          isOnline: true);
      when(() => mockAuthFirebaseDatasource.signUp(
          userName: any(named: 'userName'),
          password: any(named: 'password'))).thenAnswer((_) async => user);

      final result = await authRepository.signUp(
        userName: 'new_user',
        password: 'password123',
        datasource: Repository.firebase,
      );

      expect(result, Right(user));
    });

    test('should return Failure when signUp fails', () async {
      when(() => mockAuthFirebaseDatasource.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password')))
          .thenThrow(UnknownFailure('Sign up failed'));

      final result = await authRepository.signUp(
        userName: 'new_user',
        password: 'password123',
        datasource: Repository.firebase,
      );

      expect(result, Left(UnknownFailure('Sign up failed')));
    });
  });
}
