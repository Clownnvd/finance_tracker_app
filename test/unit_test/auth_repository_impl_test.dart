import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockRemote remote;
  late AuthRepositoryImpl repo;

  setUp(() {
    remote = MockRemote();
    repo = AuthRepositoryImpl(remote);
  });

  final user = UserModel(
    id: 'user-1',
    email: 'test@example.com',
    fullName: 'Test User',
  );

  test('signup success returns UserModel', () async {
    when(
      () => remote.signup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => user);

    final result = await repo.signup(
      email: 'test@example.com',
      password: 'Password123',
      fullName: 'Test User',
    );

    expect(result, user);

    verify(
      () => remote.signup(
        email: 'test@example.com',
        password: 'Password123',
        fullName: 'Test User',
      ),
    ).called(1);
  });

  test('signup error throws AuthException', () async {
    when(
      () => remote.signup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenThrow(const AuthException('Email exists'));

    expect(
      () => repo.signup(
        email: 'test@example.com',
        password: 'Password123',
        fullName: 'Test User',
      ),
      throwsA(isA<AuthException>()),
    );
  });
}
