import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

// TODO: sửa path UserModel cho đúng project bạn
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUserModel extends Mock implements UserModel {}

void main() {
  late MockAuthRepository repo;
  late Login usecase;

  const email = 'test@example.com';
  const password = '12345678';

  setUp(() {
    repo = MockAuthRepository();
    usecase = Login(repo);
  });

  test('Login calls repository.login correctly and returns user', () async {
    final user = MockUserModel();
    when(() => user.email).thenReturn(email);

    when(() => repo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => user);

    final result = await usecase(email: email, password: password);

    expect(result, isA<UserModel>());
    expect(result.email, email);

    verify(() => repo.login(email: email, password: password)).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('Login rethrows AuthException', () async {
    when(() => repo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const AuthException('Invalid credentials'));

    expect(
      () => usecase(email: email, password: password),
      throwsA(isA<AuthException>()),
    );

    verify(() => repo.login(email: email, password: password)).called(1);
  });

  test('Login rethrows NetworkException', () async {
    when(() => repo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const NetworkException('No internet'));

    expect(
      () => usecase(email: email, password: password),
      throwsA(isA<NetworkException>()),
    );

    verify(() => repo.login(email: email, password: password)).called(1);
  });
}
