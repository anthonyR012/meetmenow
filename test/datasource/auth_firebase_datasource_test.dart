// Mock Dependencies
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/domain/implement/auth_implement.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late AuthImplement authRepository;
  late MockAuthFirebaseDatasource mockAuthFirebaseDatasource;

  setUp(() {
    mockAuthFirebaseDatasource = MockAuthFirebaseDatasource();
    authRepository = AuthImplement(mockAuthFirebaseDatasource);
  });

  group('signIn', () {
    test('should return UserModel when signIn is successful', () async {
      
      String username = "test_user";
      String password = "password123";
      final user = UserModel(
          id: '123',
          name: 'test_user',
          email: 'test_user',
          profilePic: 'test_user',
          isOnline: true);
      
      when(mockAuthFirebaseDatasource.signIn(
        userName: username,
        password: password,
      )).thenAnswer((_) async => user);

      final result = await authRepository.signIn(
        userName: username,
        password: password,
        datasource: Repository.firebase,
      );

      expect(result, Right(user));
    });

    test('should return Failure when signIn fails', () async {
      final exception = UnknownFailure('Login failed');
       String username = "test_user";
      String password = "password123";
      when(mockAuthFirebaseDatasource.signIn(
        userName: username,
        password: password,
      )).thenThrow(exception);

      final result = await authRepository.signIn(
        userName: username,
        password: password,
        datasource: Repository.firebase,
      );

      expect(result.fold((l) => l, (r) => r), exception);
    });
  });

  group('signOut', () {
    test('should return true when signOut is successful', () async {
      when(mockAuthFirebaseDatasource.signOut()).thenAnswer((_) async => true);

      final result = await authRepository.signOut(
        datasource: Repository.firebase,
      );

      expect(result, const Right(true));
    });

    test('should return Failure when signOut fails', () async {
      final exception = UnknownFailure('Sign out failed');
      
      when(mockAuthFirebaseDatasource.signOut()).thenThrow(exception);

      final result = await authRepository.signOut(
        datasource: Repository.firebase,
      );

      expect(result, Left(exception));
    });
  });

  group('signUp', () {
    test('should return UserModel when signUp is successful', () async {
      String username = "test_user";
      String password = "password123";
      final user = UserModel(
          id: '123',
          name: 'test_user',
          email: 'test_user',
          profilePic: 'test_user',
          isOnline: true);
      
      when(mockAuthFirebaseDatasource.signUp(
        userName:username,
        password: password,
      )).thenAnswer((_) async => user);

      final result = await authRepository.signUp(
        userName: username,
        password: password,
        datasource: Repository.firebase,
      );

      expect(result, Right(user));
    });

    test('should return Failure when signUp fails', () async {
      final exception = UnknownFailure('Sign up failed');
      String username = "test_user";
      String password = "password123";
      when(mockAuthFirebaseDatasource.signUp(
        userName: username,
        password: password,
      )).thenThrow(exception);

      final result = await authRepository.signUp(
        userName: username,
        password: password,
        datasource: Repository.firebase,
      );

      expect(result, Left(exception));
    });
  });
}