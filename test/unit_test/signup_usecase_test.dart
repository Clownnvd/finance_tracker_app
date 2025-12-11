import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late Signup usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = Signup(mockRepository);
  });

  final user = UserModel(
    id: 'user-1',
    email: 'test@example.com',
    fullName: 'Test User',
  );

  test('calls repository.signup correctly', () async {
    when(
      () => mockRepository.signup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => user);

    final result = await usecase(
      email: 'test@example.com',
      password: 'Password123',
      fullName: 'Test User',
    );

    expect(result, user);

    verify(
      () => mockRepository.signup(
        email: 'test@example.com',
        password: 'Password123',
        fullName: 'Test User',
      ),
    ).called(1);
  });

  test('throws ValidationException for invalid email', () {
    expect(
      () => usecase(
        email: 'invalid',
        password: 'Password123',
        fullName: 'Test User',
      ),
      throwsA(isA<ValidationException>()),
    );

    verifyNever(
      () => mockRepository.signup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    );
  });

  test('propagates AuthException from repository', () async {
    when(
      () => mockRepository.signup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenThrow(const AuthException('Email exists'));

    expect(
      () => usecase(
        email: 'test@example.com',
        password: 'Password123',
        fullName: 'Test User',
      ),
      throwsA(isA<AuthException>()),
    );
  });
}
