import 'package:finance_tracking_app/core/utils/app_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators.email', () {
    test('returns error when email is empty', () {
      final result = AppValidators.email('');

      expect(result, 'Please enter your email');
    });

    test('returns error when email format is invalid', () {
      final result = AppValidators.email('invalid-email');

      expect(result, 'Email format is invalid');
    });

    test('returns null when email is valid', () {
      final result = AppValidators.email('test@example.com');

      expect(result, isNull);
    });
  });

  group('AppValidators.password', () {
    test('returns error when password is empty', () {
      final result = AppValidators.password('');

      expect(result, 'Please enter your password');
    });

    test('returns error when password shorter than 8 chars', () {
      final result = AppValidators.password('abc123');

      expect(result, 'Password must be at least 8 characters');
    });

    test('returns error when password has no letter', () {
      final result = AppValidators.password('12345678');

      expect(result, 'Password must include letter');
    });

    test('returns error when password has no number', () {
      final result = AppValidators.password('abcdefgh');

      expect(result, 'Password must include number');
    });

    test('returns null when password strong enough', () {
      final result = AppValidators.password('abc12345');

      expect(result, isNull);
    });
  });

  group('AppValidators.confirmPassword', () {
    test('returns error when confirm is empty', () {
      final result = AppValidators.confirmPassword('', 'abc12345');

      expect(result, 'Please confirm your password');
    });

    test('returns error when passwords do not match', () {
      final result =
          AppValidators.confirmPassword('abc12345', 'abc123456');

      expect(result, 'Password does not match');
    });

    test('returns null when passwords match', () {
      final result =
          AppValidators.confirmPassword('abc12345', 'abc12345');

      expect(result, isNull);
    });
  });
}
