import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/utils/app_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators.email', () {
    test('returns error when email is empty', () {
      final result = AppValidators.email('');

      expect(result, AppStrings.emailRequired);
    });

    test('returns error when email format is invalid', () {
      final result = AppValidators.email('invalid-email');

      expect(result, AppStrings.invalidEmailFormat);
    });

    test('returns null when email is valid', () {
      final result = AppValidators.email('test@example.com');

      expect(result, isNull);
    });
  });

  group('AppValidators.password', () {
    test('returns error when password is empty', () {
      final result = AppValidators.password('');

      expect(result, AppStrings.passwordRequired);
    });

    test('returns error when password shorter than 8 chars', () {
      final result = AppValidators.password('Abc123!');

      expect(result, AppStrings.passwordMinLength8);
    });

    test('returns error when password has no uppercase', () {
      final result = AppValidators.password('abcd1234!');

      expect(result, AppStrings.passwordNeedUppercase);
    });

    test('returns error when password has no lowercase', () {
      final result = AppValidators.password('ABCD1234!');

      expect(result, AppStrings.passwordNeedLowercase);
    });

    test('returns error when password has no number', () {
      final result = AppValidators.password('Abcdefgh!');

      expect(result, AppStrings.passwordNeedNumber);
    });

    test('returns error when password has no special char', () {
      final result = AppValidators.password('Abcd1234');

      expect(result, AppStrings.passwordNeedSpecialChar);
    });

    test('returns null when password strong enough', () {
      // Password with uppercase, lowercase, number, and special char
      final result = AppValidators.password('Abcd1234!');

      expect(result, isNull);
    });
  });

  group('AppValidators.confirmPassword', () {
    test('returns error when confirm is empty', () {
      final result = AppValidators.confirmPassword('', 'Abcd1234!');

      expect(result, AppStrings.confirmPasswordRequired);
    });

    test('returns error when passwords do not match', () {
      final result = AppValidators.confirmPassword('Abcd1234!', 'Abcd12345!');

      expect(result, AppStrings.passwordNotMatch);
    });

    test('returns null when passwords match', () {
      final result = AppValidators.confirmPassword('Abcd1234!', 'Abcd1234!');

      expect(result, isNull);
    });
  });
}
